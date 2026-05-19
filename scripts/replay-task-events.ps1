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

function New-TaskState {
    param(
        [string]$TaskId,
        [string]$Title,
        [int]$Priority,
        [string]$RiskLevel
    )

    [ordered]@{
        task_id = $TaskId
        title = $Title
        status = "open"
        owner = $null
        priority = $Priority
        risk_level = $RiskLevel
        evidence_count = 0
        evidence_sources = New-Object System.Collections.Generic.List[string]
        draft_files = New-Object System.Collections.Generic.List[string]
        blockers = New-Object System.Collections.Generic.List[string]
        context_pack = $null
        approved_by = $null
        commit_hash = $null
        last_event_id = $null
        updated_at = $null
    }
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

$events = New-Object System.Collections.Generic.List[object]
$lineNumber = 0

foreach ($line in Get-Content -LiteralPath $InputPath) {
    $lineNumber++
    if ([string]::IsNullOrWhiteSpace($line)) {
        continue
    }

    try {
        $events.Add(($line | ConvertFrom-Json -DateKind String))
    }
    catch {
        throw "Invalid JSON at line $lineNumber in $InputPath. $($_.Exception.Message)"
    }
}

$events = $events | Sort-Object timestamp, event_id

$seenEventIds = @{}
$tasks = @{}
$skippedDuplicates = New-Object System.Collections.Generic.List[string]
$processedEvents = 0
$lastEventId = $null
$lastTimestamp = $null

foreach ($event in $events) {
    if (-not $event.event_id) {
        throw "Event without event_id found."
    }

    if ($seenEventIds.ContainsKey($event.event_id)) {
        $skippedDuplicates.Add($event.event_id)
        continue
    }

    $seenEventIds[$event.event_id] = $true
    $processedEvents++
    $lastEventId = $event.event_id
    $lastTimestamp = $event.timestamp

    $taskId = [string]$event.task_id
    $payload = $event.payload

    if ($event.type -eq "task_created") {
        $priority = if ($payload.priority) { [int]$payload.priority } else { 3 }
        $riskLevel = if ($payload.risk_level) { [string]$payload.risk_level } else { "medium" }
        $tasks[$taskId] = New-TaskState -TaskId $taskId -Title ([string]$payload.title) -Priority $priority -RiskLevel $riskLevel
    }

    if (-not $tasks.ContainsKey($taskId)) {
        $tasks[$taskId] = New-TaskState -TaskId $taskId -Title "(created by replay)" -Priority 3 -RiskLevel "medium"
    }

    $task = $tasks[$taskId]

    switch ($event.type) {
        "task_claimed" {
            $task.owner = [string]$event.actor
            $task.status = "claimed"
        }
        "evidence_added" {
            $task.evidence_count = [int]$task.evidence_count + 1
            if ($payload.source) {
                Add-UniqueString -List $task.evidence_sources -Value ([string]$payload.source)
            }
        }
        "context_pack_generated" {
            $task.context_pack = [string]$payload.path
        }
        "draft_written" {
            if ($payload.path) {
                Add-UniqueString -List $task.draft_files -Value ([string]$payload.path)
            }
            $task.status = "drafting"
            $task.owner = [string]$event.actor
        }
        "review_requested" {
            $task.status = "waiting_review"
        }
        "review_blocked" {
            $task.status = "blocked"
            if ($payload.reason) {
                Add-UniqueString -List $task.blockers -Value ([string]$payload.reason)
            }
        }
        "review_passed" {
            $task.status = "waiting_approval"
        }
        "approved" {
            $task.status = "approved"
            $task.approved_by = [string]$event.actor
        }
        "publish_started" {
            $task.status = "publishing"
        }
        "push_failed" {
            $task.status = "failed"
            if ($payload.reason) {
                Add-UniqueString -List $task.blockers -Value ([string]$payload.reason)
            }
        }
        "push_succeeded" {
            $task.status = "published"
            $task.commit_hash = [string]$payload.commit_hash
        }
        "published" {
            $task.status = "published"
            $task.commit_hash = [string]$payload.commit_hash
        }
        "rolled_back" {
            $task.status = "rolled_back"
            if ($payload.reason) {
                Add-UniqueString -List $task.blockers -Value ([string]$payload.reason)
            }
        }
    }

    $task.last_event_id = [string]$event.event_id
    $task.updated_at = [string]$event.timestamp
}

$tasksCurrent = @(
    $tasks.GetEnumerator() |
        ForEach-Object { [pscustomobject]$_.Value } |
        Sort-Object task_id
)

$workload = @{}
foreach ($task in $tasksCurrent) {
    if (-not $task.owner) {
        continue
    }

    if (-not $workload.ContainsKey($task.owner)) {
        $workload[$task.owner] = [ordered]@{
            agent_id = $task.owner
            active_tasks = 0
            blocked_tasks = 0
            waiting_review_tasks = 0
        }
    }

    if ($task.status -in @("claimed", "drafting", "waiting_review", "blocked", "waiting_approval", "approved", "publishing")) {
        $workload[$task.owner].active_tasks = [int]$workload[$task.owner].active_tasks + 1
    }

    if ($task.status -eq "blocked") {
        $workload[$task.owner].blocked_tasks = [int]$workload[$task.owner].blocked_tasks + 1
    }

    if ($task.status -eq "waiting_review") {
        $workload[$task.owner].waiting_review_tasks = [int]$workload[$task.owner].waiting_review_tasks + 1
    }
}

$agentWorkload = @(
    $workload.GetEnumerator() |
        ForEach-Object { [pscustomobject]$_.Value } |
        Sort-Object agent_id
)

$riskQueue = @(
    $tasksCurrent |
        Where-Object { $_.risk_level -eq "high" -or $_.status -eq "blocked" } |
        Select-Object task_id, title, status, owner, risk_level, blockers, updated_at |
        Sort-Object risk_level, updated_at
)

$result = [ordered]@{
    input_path = $InputPath
    projection_checkpoint = [ordered]@{
        projection_name = "task_read_models"
        last_event_id = $lastEventId
        updated_at = $lastTimestamp
        processed_events = $processedEvents
        skipped_duplicate_events = @($skippedDuplicates)
    }
    tasks_current = $tasksCurrent
    agent_workload = $agentWorkload
    risk_queue = $riskQueue
}

$json = $result | ConvertTo-Json -Depth 10

if ($OutputPath) {
    $parent = Split-Path -Parent $OutputPath
    if ($parent) {
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
    }
    Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8
    Write-Host "Wrote read models to $OutputPath"
}
else {
    $json
}
