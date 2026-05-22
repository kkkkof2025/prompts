param(
    [string]$Root = ".",
    [switch]$CheckPlaceholders
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$rootPath = (Resolve-Path -LiteralPath $Root).Path
$errors = New-Object System.Collections.Generic.List[string]
$placeholderHits = New-Object System.Collections.Generic.List[string]

function Get-MarkdownFileItems {
    param([string]$BasePath)

    if (Get-Command git -ErrorAction SilentlyContinue) {
        $inside = & git -C $BasePath rev-parse --is-inside-work-tree 2>$null
        if ($LASTEXITCODE -eq 0 -and $inside -eq "true") {
            $tracked = @(& git -C $BasePath ls-files "*.md")
            if ($LASTEXITCODE -eq 0 -and $tracked.Count -gt 0) {
                return @(
                    $tracked |
                        ForEach-Object { Get-Item -LiteralPath (Join-Path $BasePath $_) }
                )
            }
        }
    }

    return @(
        Get-ChildItem -LiteralPath $BasePath -Recurse -File -Filter "*.md" |
            Where-Object {
                $_.FullName -notmatch "\\_site\\" -and
                $_.FullName -notmatch "\\node_modules\\" -and
                $_.FullName -notmatch "\\vendor\\bundle\\"
            }
    )
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

$markdownFiles = Get-MarkdownFileItems -BasePath $rootPath

foreach ($file in $markdownFiles) {
    $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
    $dir = $file.DirectoryName

    $linkMatches = [regex]::Matches($text, '\[[^\]]+\]\(([^)]+)\)')
    foreach ($match in $linkMatches) {
        $target = $match.Groups[1].Value.Trim()

        if ([string]::IsNullOrWhiteSpace($target)) {
            continue
        }

        if ($target -match '^(https?:|mailto:|#)') {
            continue
        }

        if ($target -match '^<(.+)>$') {
            $target = $Matches[1]
        }

        $pathOnly = ($target -split '#')[0]
        if ([string]::IsNullOrWhiteSpace($pathOnly)) {
            continue
        }

        $pathOnly = [System.Uri]::UnescapeDataString($pathOnly)
        $resolved = Resolve-Path -LiteralPath (Join-Path $dir $pathOnly) -ErrorAction SilentlyContinue

        if (-not $resolved) {
            $relativeFile = Get-RelativePathCompat -BasePath $rootPath -TargetPath $file.FullName
            $errors.Add("$relativeFile -> $target")
        }
    }

    if ($CheckPlaceholders) {
        $lines = Get-Content -Encoding UTF8 -LiteralPath $file.FullName
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match 'TODO|FIXME|待补|lorem|xxx|TBD') {
                $relativeFile = Get-RelativePathCompat -BasePath $rootPath -TargetPath $file.FullName
                $lineNo = $i + 1
                $placeholderHits.Add("${relativeFile}:${lineNo}: $($lines[$i])")
            }
        }
    }
}

if ($errors.Count -gt 0) {
    Write-Host "Broken local Markdown links:"
    $errors | ForEach-Object { Write-Host "  $_" }
}
else {
    Write-Host "All local Markdown links resolved."
}

if ($CheckPlaceholders) {
    if ($placeholderHits.Count -gt 0) {
        Write-Host "Placeholder-like text found:"
        $placeholderHits | ForEach-Object { Write-Host "  $_" }
    }
    else {
        Write-Host "No placeholder markers found."
    }
}

if ($errors.Count -gt 0 -or ($CheckPlaceholders -and $placeholderHits.Count -gt 0)) {
    exit 1
}
