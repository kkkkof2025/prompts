param(
    [string]$Root = "."
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$rootPath = (Resolve-Path -LiteralPath $Root).Path
$findings = New-Object System.Collections.Generic.List[string]

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

$rules = @(
    @{
        Pattern = '\bGithub\b'
        Preferred = 'GitHub'
        Reason = 'brand spelling'
    },
    @{
        Pattern = '\bOpen AI\b'
        Preferred = 'OpenAI'
        Reason = 'brand spelling'
    },
    @{
        Pattern = '\bOpen Claw\b'
        Preferred = 'OpenClaw'
        Reason = 'project spelling'
    },
    @{
        Pattern = '\bHIMES\b'
        Preferred = 'HiMeS'
        Reason = 'research-system spelling'
    },
    @{
        Pattern = '\bHesmes\b|\bhesmes\b'
        Preferred = 'Hermes or HiMeS'
        Reason = 'ambiguous typo'
    },
    @{
        Pattern = '\bAgent2agent\b|\bA2a\b'
        Preferred = 'Agent2Agent or A2A'
        Reason = 'protocol spelling'
    },
    @{
        Pattern = '\bMcp\b'
        Preferred = 'MCP'
        Reason = 'protocol spelling'
    }
)

$markdownFiles = Get-ChildItem -LiteralPath $rootPath -Recurse -File -Filter "*.md" |
    Where-Object {
        $_.FullName -notmatch "\\_site\\" -and
        $_.FullName -notmatch "\\node_modules\\" -and
        $_.FullName -notmatch "\\vendor\\bundle\\" -and
        $_.FullName -notmatch "\\dist\\"
    }

foreach ($file in $markdownFiles) {
    $relativeFile = Get-RelativePathCompat -BasePath $rootPath -TargetPath $file.FullName
    $lines = Get-Content -Encoding UTF8 -LiteralPath $file.FullName

    for ($i = 0; $i -lt $lines.Count; $i++) {
        foreach ($rule in $rules) {
            if ($lines[$i] -cmatch $rule.Pattern) {
                $lineNo = $i + 1
                $findings.Add("${relativeFile}:${lineNo}: prefer '$($rule.Preferred)' ($($rule.Reason))")
            }
        }
    }
}

if ($findings.Count -gt 0) {
    Write-Host "Terminology consistency issues:"
    $findings | ForEach-Object { Write-Host "  $_" }
    exit 1
}

Write-Host "Terminology check passed."
