param(
    [Parameter(Mandatory = $true)]
    [string]$InputPath,

    [string]$OutputPath = ""
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

if (-not (Test-Path -LiteralPath $InputPath)) {
    throw "Input file not found: $InputPath"
}

function Read-DateTimeOffset {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    return [datetimeoffset]::Parse($Value)
}

function Get-SpanDurationSeconds {
    param($Span)

    $started = Read-DateTimeOffset -Value ([string]$Span.started_at)
    $ended = Read-DateTimeOffset -Value ([string]$Span.ended_at)

    if ($null -eq $started -or $null -eq $ended) {
        return 0
    }

    return [int][math]::Max(0, [math]::Round(($ended - $started).TotalSeconds))
}

function Get-CostValue {
    param(
        $Span,
        [string]$Name
    )

    if ($null -eq $Span.cost) {
        return 0
    }

    $property = $Span.cost.PSObject.Properties[$Name]
    if ($null -eq $property -or $null -eq $property.Value) {
        return 0
    }

    return [int]$property.Value
}

function Add-UniqueString {
    param(
        [System.Collections.Generic.List[string]]$List,
        [string]$Value
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return
    }

    if (-not $List.Contains($Value)) {
        [void]$List.Add($Value)
    }
}

function Add-LinkValues {
    param(
        [System.Collections.Generic.List[string]]$List,
        $Links
    )

    if ($null -eq $Links) {
        return
    }

    foreach ($property in $Links.PSObject.Properties) {
        Add-UniqueString -List $List -Value ([string]$property.Value)
    }
}

$spans = New-Object System.Collections.Generic.List[object]
$lineNumber = 0

foreach ($line in Get-Content -LiteralPath $InputPath) {
    $lineNumber++
    if ([string]::IsNullOrWhiteSpace($line)) {
        continue
    }

    try {
        $span = $line | ConvertFrom-Json -DateKind String
    }
    catch {
        throw "Invalid JSON at line $lineNumber in $InputPath. $($_.Exception.Message)"
    }

    foreach ($required in @("trace_id", "span_id", "task_id", "workflow", "name", "kind", "actor", "status", "started_at", "ended_at")) {
        if (-not $span.PSObject.Properties[$required] -or [string]::IsNullOrWhiteSpace([string]$span.$required)) {
            throw "Span at line $lineNumber is missing required field '$required'."
        }
    }

    $spans.Add($span)
}

$spans = @($spans | Sort-Object started_at, trace_id, span_id)

$traceSummaries = New-Object System.Collections.Generic.List[object]
$failureQueue = New-Object System.Collections.Generic.List[object]
$longestSpans = New-Object System.Collections.Generic.List[object]
$actorCost = @{}

foreach ($span in $spans) {
    $duration = Get-SpanDurationSeconds -Span $span
    $tokensInput = Get-CostValue -Span $span -Name "tokens_input"
    $tokensOutput = Get-CostValue -Span $span -Name "tokens_output"
    $toolCalls = Get-CostValue -Span $span -Name "tool_calls"

    if (-not $actorCost.ContainsKey($span.actor)) {
        $actorCost[$span.actor] = [ordered]@{
            actor = [string]$span.actor
            span_count = 0
            error_count = 0
            warning_count = 0
            tokens_input = 0
            tokens_output = 0
            tool_calls = 0
            span_seconds = 0
        }
    }

    $actorCost[$span.actor].span_count = [int]$actorCost[$span.actor].span_count + 1
    $actorCost[$span.actor].tokens_input = [int]$actorCost[$span.actor].tokens_input + $tokensInput
    $actorCost[$span.actor].tokens_output = [int]$actorCost[$span.actor].tokens_output + $tokensOutput
    $actorCost[$span.actor].tool_calls = [int]$actorCost[$span.actor].tool_calls + $toolCalls
    $actorCost[$span.actor].span_seconds = [int]$actorCost[$span.actor].span_seconds + $duration

    if ($span.status -eq "error") {
        $actorCost[$span.actor].error_count = [int]$actorCost[$span.actor].error_count + 1
    }

    if ($span.status -eq "warn") {
        $actorCost[$span.actor].warning_count = [int]$actorCost[$span.actor].warning_count + 1
    }

    if ($span.status -in @("error", "warn")) {
        $failureQueue.Add([pscustomobject][ordered]@{
            trace_id = [string]$span.trace_id
            span_id = [string]$span.span_id
            task_id = [string]$span.task_id
            workflow = [string]$span.workflow
            name = [string]$span.name
            kind = [string]$span.kind
            actor = [string]$span.actor
            status = [string]$span.status
            duration_seconds = $duration
            started_at = [string]$span.started_at
            ended_at = [string]$span.ended_at
        })
    }

    $longestSpans.Add([pscustomobject][ordered]@{
        trace_id = [string]$span.trace_id
        span_id = [string]$span.span_id
        task_id = [string]$span.task_id
        name = [string]$span.name
        actor = [string]$span.actor
        status = [string]$span.status
        duration_seconds = $duration
    })
}

$traceGroups = $spans | Group-Object trace_id
foreach ($group in $traceGroups) {
    $traceSpans = @($group.Group | Sort-Object started_at, span_id)
    $startedValues = @($traceSpans | ForEach-Object { Read-DateTimeOffset -Value ([string]$_.started_at) } | Where-Object { $null -ne $_ })
    $endedValues = @($traceSpans | ForEach-Object { Read-DateTimeOffset -Value ([string]$_.ended_at) } | Where-Object { $null -ne $_ })

    $startedAt = if ($startedValues.Count -gt 0) { ($startedValues | Sort-Object | Select-Object -First 1).ToString("o") } else { $null }
    $endedAt = if ($endedValues.Count -gt 0) { ($endedValues | Sort-Object | Select-Object -Last 1).ToString("o") } else { $null }
    $criticalPathSeconds = 0
    if ($startedValues.Count -gt 0 -and $endedValues.Count -gt 0) {
        $criticalPathSeconds = [int][math]::Max(0, [math]::Round((($endedValues | Sort-Object | Select-Object -Last 1) - ($startedValues | Sort-Object | Select-Object -First 1)).TotalSeconds))
    }

    $errorCount = @($traceSpans | Where-Object { $_.status -eq "error" }).Count
    $warningCount = @($traceSpans | Where-Object { $_.status -eq "warn" }).Count
    $traceStatus = if ($errorCount -gt 0) { "error" } elseif ($warningCount -gt 0) { "warn" } else { "ok" }
    $evidenceRefs = New-Object System.Collections.Generic.List[string]

    foreach ($span in $traceSpans) {
        Add-LinkValues -List $evidenceRefs -Links $span.links
    }

    $traceSummaries.Add([pscustomobject][ordered]@{
        trace_id = [string]$group.Name
        task_id = [string]$traceSpans[0].task_id
        workflow = [string]$traceSpans[0].workflow
        status = $traceStatus
        started_at = $startedAt
        ended_at = $endedAt
        critical_path_seconds = $criticalPathSeconds
        span_count = $traceSpans.Count
        error_count = $errorCount
        warning_count = $warningCount
        model_spans = @($traceSpans | Where-Object { $_.kind -eq "model" }).Count
        tool_spans = @($traceSpans | Where-Object { $_.kind -eq "tool" }).Count
        human_spans = @($traceSpans | Where-Object { $_.kind -eq "human" }).Count
        tokens_input = [int](($traceSpans | ForEach-Object { Get-CostValue -Span $_ -Name "tokens_input" } | Measure-Object -Sum).Sum)
        tokens_output = [int](($traceSpans | ForEach-Object { Get-CostValue -Span $_ -Name "tokens_output" } | Measure-Object -Sum).Sum)
        tool_calls = [int](($traceSpans | ForEach-Object { Get-CostValue -Span $_ -Name "tool_calls" } | Measure-Object -Sum).Sum)
        span_seconds = [int](($traceSpans | ForEach-Object { Get-SpanDurationSeconds -Span $_ } | Measure-Object -Sum).Sum)
        evidence_refs = @($evidenceRefs)
    })
}

$result = [ordered]@{
    input_path = $InputPath
    projection_checkpoint = [ordered]@{
        projection_name = "agent_trace_dashboard"
        processed_spans = $spans.Count
        processed_traces = $traceGroups.Count
        generated_at = [datetimeoffset]::Now.ToString("o")
    }
    trace_summaries = @($traceSummaries | Sort-Object trace_id)
    actor_cost = @(
        $actorCost.GetEnumerator() |
            ForEach-Object { [pscustomobject]$_.Value } |
            Sort-Object actor
    )
    failure_queue = @($failureQueue | Sort-Object started_at, trace_id, span_id)
    longest_spans = @($longestSpans | Sort-Object -Property duration_seconds -Descending | Select-Object -First 5)
}

$json = $result | ConvertTo-Json -Depth 12

if ($OutputPath) {
    $parent = Split-Path -Parent $OutputPath
    if ($parent) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
    try {
        Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8
    }
    catch {
        throw "Failed to write output to '$OutputPath'. If you are running in a restricted sandbox, omit -OutputPath and use console output instead. $($_.Exception.Message)"
    }
    Write-Host "Wrote trace dashboard to $OutputPath"
}
else {
    $json
}
