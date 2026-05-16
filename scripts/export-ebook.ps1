param(
    [string]$OutputDir = "dist",
    [string]$Format = "html"
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$supportedFormats = @("html", "epub", "docx")
if ($supportedFormats -notcontains $Format) {
    throw "Unsupported format '$Format'. Supported formats: $($supportedFormats -join ', ')"
}

if (-not (Get-Command pandoc -ErrorAction SilentlyContinue)) {
    Write-Host "Pandoc is not installed or not on PATH."
    Write-Host "Install Pandoc first: https://pandoc.org/installing.html"
    exit 1
}

New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

$files = @(
    "docs/ebook-cover.md",
    "docs/copyright.md",
    "docs/index.md",
    "docs/topic-index.md",
    "docs/learning-progress.md",
    "docs/chapters/00-learning-map.md",
    "docs/chapters/01-dialogue-basics.md",
    "docs/chapters/02-ai-basics.md",
    "docs/chapters/03-prompt-basics.md",
    "docs/chapters/04-prompt-workflows.md",
    "docs/chapters/05-evaluation.md",
    "docs/chapters/06-tools-rag.md",
    "docs/chapters/07-skills.md",
    "docs/chapters/08-agents.md",
    "docs/chapters/09-memory.md",
    "docs/chapters/10-openclaw.md",
    "docs/chapters/11-hermes-himes-open-models.md",
    "docs/chapters/12-frontier-landscape.md",
    "docs/chapters/13-safety-governance.md",
    "docs/chapters/14-practice-plan.md",
    "docs/case-studies.md",
    "docs/cases/index.md",
    "docs/cases/rag-skill-agent-memory.md",
    "docs/cases/teaching-rag-skill-agent-memory.md",
    "docs/cases/codebase-rag-skill-agent-memory.md",
    "docs/cases/continuous-case-exercises.md",
    "docs/cases/continuous-case-classroom-run.md",
    "docs/cases/continuous-case-team-pilot.md",
    "docs/cases/continuous-case-samples.md",
    "docs/cases/continuous-case-slide-brief.md",
    "docs/cases/student.md",
    "docs/cases/teacher.md",
    "docs/cases/operations.md",
    "docs/cases/product.md",
    "docs/cases/engineering.md",
    "docs/cases/management.md",
    "docs/learning-paths.md",
    "docs/facilitation-guide.md",
    "docs/teaching-kit.md",
    "docs/team-ai-adoption-roadmap.md",
    "docs/workshop-safety-model-selection.md",
    "docs/workshop-industry-cases.md",
    "docs/pilot-tracking-30days.md",
    "docs/classroom-worksheets.md",
    "docs/teaching-examples.md",
    "docs/feedback-validation-kit.md",
    "docs/diagrams.md",
    "docs/chapter-review-questions.md",
    "docs/chapter-validation-map.md",
    "docs/quick-reference.md",
    "docs/common-pitfalls.md",
    "docs/prompt-debugging-guide.md",
    "docs/task-decision-guide.md",
    "docs/safety-case-updates.md",
    "docs/safety-incident-retrospectives.md",
    "docs/model-landscape-china-global.md",
    "docs/model-selection-cases.md",
    "docs/technology-evolution-cases.md",
    "docs/workflow-recipes.md",
    "docs/team-adoption-playbook.md",
    "docs/team-adoption-cases.md",
    "docs/assessment-rubric.md",
    "docs/appendix-glossary.md",
    "docs/glossary-links.md",
    "docs/appendix-exercise-answers.md",
    "docs/appendix-checklists.md",
    "docs/appendix-resources.md",
    "docs/frontier-review-playbook.md",
    "docs/frontier-review-log.md",
    "docs/term-style-guide.md",
    "docs/automation-content-workflow.md",
    "docs/ebook-guide.md",
    "docs/release-checklist-1.0.md"
)

$missing = $files | Where-Object { -not (Test-Path -LiteralPath $_) }
if ($missing.Count -gt 0) {
    Write-Host "Missing source files:"
    $missing | ForEach-Object { Write-Host "  $_" }
    exit 1
}

$extension = switch ($Format) {
    "html" { "html" }
    "epub" { "epub" }
    "docx" { "docx" }
}

$output = Join-Path $OutputDir "ai-learning-methods-book.$extension"

$cssFile = "docs/ebook-style.css"

$args = @(
    "--from", "gfm",
    "--metadata", "title=AI 学习方法全景书",
    "--metadata", "lang=zh-CN",
    "--metadata", "date=2026-05-13",
    "--toc",
    "--standalone",
    "--output", $output
)

if (Test-Path -LiteralPath $cssFile) {
    $args += @("--css", $cssFile)
}

$args += $files

Write-Host "Exporting $Format to $output"
& pandoc @args

if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host "Done."
