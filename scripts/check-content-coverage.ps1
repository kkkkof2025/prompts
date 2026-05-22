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

    return [System.Uri]::UnescapeDataString($relativeUri.ToString()).Replace("\", "/")
}

function Get-MarkdownFiles {
    param([string]$BasePath)

    if (Get-Command git -ErrorAction SilentlyContinue) {
        $inside = & git -C $BasePath rev-parse --is-inside-work-tree 2>$null
        if ($LASTEXITCODE -eq 0 -and $inside -eq "true") {
            $tracked = @(& git -C $BasePath ls-files "*.md")
            if ($LASTEXITCODE -eq 0 -and $tracked.Count -gt 0) {
                return @(
                    $tracked |
                        Where-Object {
                            $_ -notmatch "^_site/" -and
                            $_ -notmatch "^node_modules/" -and
                            $_ -notmatch "^vendor/" -and
                            $_ -notmatch "^dist/" -and
                            $_ -notmatch "^site/" -and
                            $_ -notmatch "^build/" -and
                            $_ -notmatch "^tmp/" -and
                            $_ -notmatch "^temp/" -and
                            $_ -notmatch "^\.git/" -and
                            $_ -notmatch "^\.github/" -and
                            $_ -notmatch "^\.workbuddy/"
                        } |
                        ForEach-Object { $_.Replace("\", "/") }
                )
            }
        }
    }

    return @(
        Get-ChildItem -LiteralPath $BasePath -Recurse -File -Filter "*.md" |
            Where-Object {
                $_.FullName -notmatch "\\_site\\" -and
                $_.FullName -notmatch "\\node_modules\\" -and
                $_.FullName -notmatch "\\vendor\\" -and
                $_.FullName -notmatch "\\dist\\" -and
                $_.FullName -notmatch "\\site\\" -and
                $_.FullName -notmatch "\\build\\" -and
                $_.FullName -notmatch "\\tmp\\" -and
                $_.FullName -notmatch "\\temp\\" -and
                $_.FullName -notmatch "\\.git\\" -and
                $_.FullName -notmatch "\\.github\\" -and
                $_.FullName -notmatch "\\.workbuddy\\"
            } |
            ForEach-Object { Get-RelativePathCompat -BasePath $BasePath -TargetPath $_.FullName }
    )
}

function Add-MissingFindings {
    param(
        [string]$Label,
        [string[]]$Missing
    )

    foreach ($item in $Missing) {
        $findings.Add("${Label}: $item")
    }
}

$markdownFiles = Get-MarkdownFiles -BasePath $rootPath | Sort-Object -Unique

$rootMaintenanceFiles = @(
    "CONTRIBUTING.md",
    "ROADMAP.md",
    "CHANGELOG.md",
    "MEMORY.md",
    "LICENSE.md"
)

$bookFiles = @(
    $markdownFiles |
        Where-Object {
            $_ -match "^(docs|examples|agents)/" -or
            $rootMaintenanceFiles -contains $_
        }
) | Sort-Object -Unique

$navRequiredFiles = @(
    $bookFiles
    "index.md"
) | Sort-Object -Unique

$mkdocsPath = Join-Path $rootPath "mkdocs.yml"
if (-not (Test-Path -LiteralPath $mkdocsPath)) {
    throw "mkdocs.yml not found."
}

$mkdocsText = Get-Content -Raw -Encoding UTF8 -LiteralPath $mkdocsPath
$mkdocsFiles = @(
    [regex]::Matches($mkdocsText, '(?m)(?:^|\s)([A-Za-z0-9_./-]+\.md)') |
        ForEach-Object { $_.Groups[1].Value }
) | Sort-Object -Unique

$summaryPath = Join-Path $rootPath "docs/SUMMARY.md"
if (-not (Test-Path -LiteralPath $summaryPath)) {
    throw "docs/SUMMARY.md not found."
}

$summaryText = Get-Content -Raw -Encoding UTF8 -LiteralPath $summaryPath
$summaryFiles = @(
    [regex]::Matches($summaryText, '\]\(([^)]+\.md)\)') |
        ForEach-Object {
            $path = $_.Groups[1].Value

            if ($path.StartsWith("../")) {
                $path.Substring(3)
            }
            elseif ($path -match "^[A-Za-z]+:") {
                $null
            }
            else {
                "docs/$path"
            }
        } |
        Where-Object { $_ }
) | Sort-Object -Unique

$exportPath = Join-Path $rootPath "scripts/export-ebook.ps1"
if (-not (Test-Path -LiteralPath $exportPath)) {
    throw "scripts/export-ebook.ps1 not found."
}

$exportText = Get-Content -Raw -Encoding UTF8 -LiteralPath $exportPath
$exportFiles = @(
    [regex]::Matches($exportText, '"([^"]+\.md)"') |
        ForEach-Object { $_.Groups[1].Value }
) | Sort-Object -Unique

$summaryIntentionalOmissions = @("docs/SUMMARY.md")

$navMissing = @(
    Compare-Object -ReferenceObject $navRequiredFiles -DifferenceObject $mkdocsFiles |
        Where-Object SideIndicator -eq "<=" |
        Select-Object -ExpandProperty InputObject
)

$summaryMissing = @(
    Compare-Object -ReferenceObject $bookFiles -DifferenceObject $summaryFiles |
        Where-Object SideIndicator -eq "<=" |
        Select-Object -ExpandProperty InputObject |
        Where-Object { $summaryIntentionalOmissions -notcontains $_ }
)

$exportMissing = @(
    Compare-Object -ReferenceObject $bookFiles -DifferenceObject $exportFiles |
        Where-Object SideIndicator -eq "<=" |
        Select-Object -ExpandProperty InputObject
)

Add-MissingFindings -Label "MkDocs nav missing" -Missing $navMissing
Add-MissingFindings -Label "SUMMARY missing" -Missing $summaryMissing
Add-MissingFindings -Label "Ebook export missing" -Missing $exportMissing

if ($findings.Count -gt 0) {
    Write-Host "Content coverage issues:"
    $findings | ForEach-Object { Write-Host "  $_" }
    exit 1
}

Write-Host "Content coverage check passed."
Write-Host "Book files checked: $($bookFiles.Count)"
Write-Host "MkDocs nav files checked: $($navRequiredFiles.Count)"
Write-Host "MkDocs nav missing: 0"
Write-Host "SUMMARY missing excluding intentional self-link: 0"
Write-Host "Ebook export missing: 0"
