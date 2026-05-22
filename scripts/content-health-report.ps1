param(
    [string]$Root = ".",
    [string]$OutputPath = "content-health-report.md",
    [int]$ShortPageWords = 300,
    [int]$LongPageWords = 10000,
    [int]$Top = 20
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$rootPath = (Resolve-Path -LiteralPath $Root).Path

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

function Escape-MarkdownCell {
    param([string]$Value)

    if ($null -eq $Value) {
        return ""
    }

    return $Value.Replace("|", "\|").Replace("`r", " ").Replace("`n", " ")
}

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
        Get-ChildItem -LiteralPath $BasePath -Recurse -File -Filter "*.md"
    )
}

function Measure-ContentUnits {
    param([string]$Text)

    $latinWords = [regex]::Matches($Text, "[A-Za-z0-9]+(?:[-_./][A-Za-z0-9]+)*").Count
    $cjkChars = [regex]::Matches($Text, "[\u3400-\u9FFF]").Count

    return $latinWords + $cjkChars
}

$markdownFiles = Get-MarkdownFileItems -BasePath $rootPath |
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
        $_.FullName -notmatch "\\.workbuddy\\" -and
        $_.Name -ne "content-health-report.md"
    }

$intentionalShortPagePatterns = @(
    "^docs/ebook-cover\.md$",
    "^docs/copyright\.md$",
    "^LICENSE\.md$",
    "^CONTRIBUTING\.md$",
    "^agents/index\.md$"
)

function Test-IntentionalShortPage {
    param([string]$Path)

    foreach ($pattern in $intentionalShortPagePatterns) {
        if ($Path -match $pattern) {
            return $true
        }
    }

    return $false
}

$pages = New-Object System.Collections.Generic.List[object]
$chapterIssues = New-Object System.Collections.Generic.List[object]
$dynamicReviewPages = New-Object System.Collections.Generic.List[object]

foreach ($file in $markdownFiles) {
    $relative = Get-RelativePathCompat -BasePath $rootPath -TargetPath $file.FullName
    $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $file.FullName
    $lines = @($text -split "`r?`n")
    $words = Measure-ContentUnits -Text $text
    $headings = [regex]::Matches($text, "(?m)^#{1,6}\s+\S+").Count
    $links = [regex]::Matches($text, "\[[^\]]+\]\([^)]+\)").Count
    $checkboxes = [regex]::Matches($text, "(?m)^\s*-\s+\[[ xX]\]").Count
    $hasH1 = $text -match "(?m)^#\s+\S+"
    $hasMermaid = $text -match '```mermaid'
    $dynamicHits = [regex]::Matches($text, "截至|OpenClaw|Hermes|HiMeS|MCP|A2A|前沿|季度复核|模型选型").Count

    $pages.Add([pscustomobject]@{
        Path = $relative
        Lines = $lines.Count
        Words = $words
        Headings = $headings
        Links = $links
        Checkboxes = $checkboxes
        HasH1 = $hasH1
        HasMermaid = $hasMermaid
        DynamicHits = $dynamicHits
    })

    if ($relative -match "^docs/chapters/\d{2}-.+\.md$") {
        $missing = @()
        if ($text -notmatch "(?m)^## 本章导读") {
            $missing += "本章导读"
        }
        if ($text -notmatch "(?m)^## 本章收尾") {
            $missing += "本章收尾"
        }
        if ($text -notmatch "(?m)^## 章节导航") {
            $missing += "章节导航"
        }

        if ($missing.Count -gt 0) {
            $chapterIssues.Add([pscustomobject]@{
                Path = $relative
                Missing = ($missing -join ", ")
            })
        }
    }

    if ($dynamicHits -gt 0) {
        $dynamicReviewPages.Add([pscustomobject]@{
            Path = $relative
            Hits = $dynamicHits
            Words = $words
        })
    }
}

$shortPages = $pages |
    Where-Object { $_.Words -lt $ShortPageWords -and (-not (Test-IntentionalShortPage -Path $_.Path)) } |
    Sort-Object Words, Path |
    Select-Object -First $Top

$intentionalShortPages = $pages |
    Where-Object { $_.Words -lt $ShortPageWords -and (Test-IntentionalShortPage -Path $_.Path) } |
    Sort-Object Words, Path |
    Select-Object -First $Top

$longPages = $pages |
    Where-Object { $_.Words -gt $LongPageWords } |
    Sort-Object Words -Descending |
    Select-Object -First $Top

$missingH1 = $pages |
    Where-Object { -not $_.HasH1 } |
    Sort-Object Path |
    Select-Object -First $Top

$dynamicReviewPages = $dynamicReviewPages |
    Sort-Object -Property @{ Expression = "Hits"; Descending = $true }, Path |
    Select-Object -First $Top

$chapterNumbers = @(
    $pages | ForEach-Object {
        if ($_.Path -match "^docs/chapters/(\d{2})-.+\.md$") {
            [int]$Matches[1]
        }
    }
) | Sort-Object -Unique

if ($chapterNumbers.Count -gt 0) {
    $chapterRangeText = "第 $($chapterNumbers[0])-$($chapterNumbers[-1]) 章"
}
else {
    $chapterRangeText = "主体章节"
}

$totalWords = ($pages | Measure-Object -Property Words -Sum).Sum
$totalLines = ($pages | Measure-Object -Property Lines -Sum).Sum
$generatedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"

$report = New-Object System.Collections.Generic.List[string]
$report.Add("# 内容健康报告")
$report.Add("")
$report.Add("生成时间：$generatedAt")
$report.Add("")
$report.Add("## 总览")
$report.Add("")
$report.Add("| 指标 | 数值 |")
$report.Add("| --- | --- |")
$report.Add("| Markdown 文件 | $($pages.Count) |")
$report.Add("| 总行数 | $totalLines |")
$report.Add("| 总内容量 | $totalWords |")
$report.Add("| 过短页面阈值 | $ShortPageWords 内容单位 |")
$report.Add("| 过长页面阈值 | $LongPageWords 内容单位 |")
$report.Add("")
$report.Add("内容单位按 CJK 字符 + 英文/数字词估算，用于避免中文页面被空白分词严重低估。")
$report.Add("")
$report.Add("## 可能需要扩写的短页面")
$report.Add("")
if ($shortPages.Count -eq 0) {
    $report.Add("未发现低于阈值的短页面。")
}
else {
    $report.Add("| 文件 | 内容量 | 行数 |")
    $report.Add("| --- | ---: | ---: |")
    foreach ($page in $shortPages) {
        $report.Add("| $(Escape-MarkdownCell $page.Path) | $($page.Words) | $($page.Lines) |")
    }
}

$report.Add("")
$report.Add("## 刻意保持简短的系统页面")
$report.Add("")
if ($intentionalShortPages.Count -eq 0) {
    $report.Add("未发现命中刻意短页规则的页面。")
}
else {
    $report.Add("这些页面通常是封面、版权或许可证，不作为正文扩写候选。")
    $report.Add("")
    $report.Add("| 文件 | 内容量 | 行数 |")
    $report.Add("| --- | ---: | ---: |")
    foreach ($page in $intentionalShortPages) {
        $report.Add("| $(Escape-MarkdownCell $page.Path) | $($page.Words) | $($page.Lines) |")
    }
}

$report.Add("")
$report.Add("## 可能需要拆分或增加导航的长页面")
$report.Add("")
if ($longPages.Count -eq 0) {
    $report.Add("未发现超过阈值的长页面。")
}
else {
    $report.Add("| 文件 | 内容量 | 标题数 | 链接数 |")
    $report.Add("| --- | ---: | ---: | ---: |")
    foreach ($page in $longPages) {
        $report.Add("| $(Escape-MarkdownCell $page.Path) | $($page.Words) | $($page.Headings) | $($page.Links) |")
    }
}

$report.Add("")
$report.Add("## 缺少一级标题的页面")
$report.Add("")
if ($missingH1.Count -eq 0) {
    $report.Add("未发现缺少一级标题的页面。")
}
else {
    $report.Add("| 文件 | 内容量 | 标题数 |")
    $report.Add("| --- | ---: | ---: |")
    foreach ($page in $missingH1) {
        $report.Add("| $(Escape-MarkdownCell $page.Path) | $($page.Words) | $($page.Headings) |")
    }
}

$report.Add("")
$report.Add("## 章节结构检查")
$report.Add("")
if ($chapterIssues.Count -eq 0) {
    $report.Add("${chapterRangeText}均包含本章导读、本章收尾和章节导航。")
}
else {
    $report.Add("| 文件 | 缺少内容 |")
    $report.Add("| --- | --- |")
    foreach ($issue in $chapterIssues) {
        $report.Add("| $(Escape-MarkdownCell $issue.Path) | $(Escape-MarkdownCell $issue.Missing) |")
    }
}

$report.Add("")
$report.Add("## 动态事实复核候选")
$report.Add("")
if ($dynamicReviewPages.Count -eq 0) {
    $report.Add("未发现明显动态事实复核候选。")
}
else {
    $report.Add("这些页面包含前沿技术、协议、模型或复核相关关键词。报告只提示候选，不代表内容一定过时。")
    $report.Add("")
    $report.Add("| 文件 | 命中次数 | 内容量 |")
    $report.Add("| --- | ---: | ---: |")
    foreach ($page in $dynamicReviewPages) {
        $report.Add("| $(Escape-MarkdownCell $page.Path) | $($page.Hits) | $($page.Words) |")
    }
}

$report.Add("")
$report.Add("## 建议动作")
$report.Add("")
$report.Add("- 短页面：优先判断是否需要补案例、练习、常见误解或章节入口说明。")
$report.Add("- 长页面：优先判断是否需要增加索引、拆分子页或在开头增加阅读路径。")
$report.Add("- 动态事实：按前沿资料季度复核执行手册核验官方来源，再决定是否更新正文。")
$report.Add("- 自动化边界：本报告只负责发现候选，不直接改写正文。")

if ([System.IO.Path]::IsPathRooted($OutputPath)) {
    $outputFullPath = [System.IO.Path]::GetFullPath($OutputPath)
}
else {
    $outputFullPath = [System.IO.Path]::GetFullPath((Join-Path $rootPath $OutputPath))
}
$outputDir = Split-Path -Parent $outputFullPath
if (-not [string]::IsNullOrWhiteSpace($outputDir)) {
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
}

$report | Set-Content -Encoding UTF8 -LiteralPath $outputFullPath
Write-Host "Content health report written to $outputFullPath"
