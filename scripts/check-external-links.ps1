param(
    [string]$Root = ".",
    [int]$TimeoutSeconds = 15,
    [switch]$Strict
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

if ($PSVersionTable.PSEdition -eq "Desktop") {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
}

$rootPath = (Resolve-Path -LiteralPath $Root).Path
$headers = @{
    "User-Agent" = "ai-learning-methods-book-link-check/1.0"
}

function Get-RelativePathCompat {
    param(
        [string]$BasePath,
        [string]$TargetPath
    )

    $baseFullPath = [System.IO.Path]::GetFullPath($BasePath)
    if (-not $baseFullPath.EndsWith([System.IO.Path]::DirectorySeparatorChar)) {
        $baseFullPath += [System.IO.Path]::DirectorySeparatorChar
    }

    $targetFullPath = [System.IO.Path]::GetFullPath($TargetPath)
    $baseUri = [System.Uri]$baseFullPath
    $targetUri = [System.Uri]$targetFullPath
    $relativeUri = $baseUri.MakeRelativeUri($targetUri)

    return [System.Uri]::UnescapeDataString($relativeUri.ToString()).Replace("/", [System.IO.Path]::DirectorySeparatorChar)
}

$markdownFiles = Get-ChildItem -LiteralPath $rootPath -Recurse -File -Filter "*.md" |
    Where-Object {
        $_.FullName -notmatch "\\_site\\" -and
        $_.FullName -notmatch "\\node_modules\\" -and
        $_.FullName -notmatch "\\vendor\\bundle\\" -and
        $_.FullName -notmatch "\\dist\\"
    }

$links = @{}

foreach ($file in $markdownFiles) {
    $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
    $relativeFile = Get-RelativePathCompat -BasePath $rootPath -TargetPath $file.FullName
    $linkMatches = [regex]::Matches($text, '\[[^\]]+\]\(([^)]+)\)')

    foreach ($match in $linkMatches) {
        $target = $match.Groups[1].Value.Trim()

        if ($target -match '^<(.+)>$') {
            $target = $Matches[1]
        }

        if ($target -notmatch '^https?://') {
            continue
        }

        $uriBuilder = [System.UriBuilder]$target
        $uriBuilder.Fragment = ""
        $url = $uriBuilder.Uri.AbsoluteUri

        if (-not $links.ContainsKey($url)) {
            $links[$url] = New-Object System.Collections.Generic.List[string]
        }

        $links[$url].Add($relativeFile)
    }
}

function Invoke-LinkCheck {
    param(
        [string]$Url,
        [string]$Method
    )

    try {
        $response = Invoke-WebRequest -Uri $Url -Method $Method -Headers $headers -TimeoutSec $TimeoutSeconds -MaximumRedirection 5 -UseBasicParsing
        return @{
            Status = [int]$response.StatusCode
            Message = $response.StatusDescription
            NetworkError = $false
        }
    }
    catch {
        $status = 0
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            $status = [int]$_.Exception.Response.StatusCode
        }

        return @{
            Status = $status
            Message = $_.Exception.Message
            NetworkError = ($status -eq 0)
        }
    }
}

$softStatuses = @(401, 403, 429)
$broken = New-Object System.Collections.Generic.List[string]
$softFailures = New-Object System.Collections.Generic.List[string]

foreach ($url in ($links.Keys | Sort-Object)) {
    $result = Invoke-LinkCheck -Url $url -Method "Head"

    if ($result.Status -in @(405, 501) -or $result.NetworkError) {
        $result = Invoke-LinkCheck -Url $url -Method "Get"
    }

    $sources = (($links[$url] | Sort-Object -Unique) -join ", ")

    if ($result.Status -ge 200 -and $result.Status -lt 400) {
        continue
    }

    if (-not $Strict -and $softStatuses -contains $result.Status) {
        $softFailures.Add("$url -> HTTP $($result.Status), referenced by $sources")
        continue
    }

    if ($result.Status -eq 0) {
        $broken.Add("$url -> $($result.Message), referenced by $sources")
    }
    else {
        $broken.Add("$url -> HTTP $($result.Status), referenced by $sources")
    }
}

Write-Host "Checked $($links.Count) external links."

if ($softFailures.Count -gt 0) {
    Write-Host "External links blocked or rate-limited by remote site:"
    $softFailures | ForEach-Object { Write-Host "  $_" }
}

if ($broken.Count -gt 0) {
    Write-Host "Broken external links:"
    $broken | ForEach-Object { Write-Host "  $_" }
    exit 1
}

Write-Host "No broken external links found."
