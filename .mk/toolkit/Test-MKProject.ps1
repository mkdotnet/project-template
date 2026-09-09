[CmdletBinding()]
param([string]$ProjectRoot = ".",[switch]$RunImplementationValidation,[switch]$WriteReport)

$module = Join-Path $PSScriptRoot "MK.Common.psm1"
Import-Module $module -Force
$root = Get-MKRepositoryRoot -StartPath $ProjectRoot
$results = @()
$results += New-MKResult -Status "INFO" -Check "Repository" -Message $root

$required = @(
    "mk.json","AGENTS.md","CLAUDE.md","docs/ai/bootstrap.md","docs/ai/collaboration.md","docs/ai/review-checklist.md",
    "docs/project/vision.md","docs/project/roadmap.md","docs/project/status.md","docs/project/capabilities.md","docs/architecture/overview.md",
    ".github/workflows/repository-validation.yml",".mk/scripts/validate_repository.py"
)
foreach ($relative in $required) {
    if (Test-Path -LiteralPath (Join-Path $root $relative) -PathType Leaf) { $results += New-MKResult -Status "PASS" -Check "Baseline file" -Message "$relative exists." }
    else { $results += New-MKResult -Status "FAIL" -Check "Baseline file" -Message "$relative is missing." }
}

$impl = Get-MKImplementationRoot -RepositoryRoot $root
if (Test-Path -LiteralPath (Join-Path $root $impl) -PathType Container) { $results += New-MKResult -Status "PASS" -Check "Implementation boundary" -Message "$impl/ exists; its internal topology is project/framework-owned." }
else { $results += New-MKResult -Status "FAIL" -Check "Implementation boundary" -Message "$impl/ is missing." }

foreach ($path in @("README.md","docs/project/vision.md","docs/project/roadmap.md","docs/project/status.md","docs/project/capabilities.md","docs/architecture/overview.md")) {
    $full = Join-Path $root $path
    if (Test-Path -LiteralPath $full -PathType Leaf) {
        $text = Get-Content -LiteralPath $full -Raw -Encoding UTF8
        if ($text -match "MK-MANUAL") { $results += New-MKResult -Status "MANUAL" -Check "Project context" -Message "$path still contains MK-MANUAL markers." }
    }
}

$results += Invoke-MKRepositoryValidator -RepositoryRoot $root
$results += Get-MKGraphStatus -RepositoryRoot $root
$results += Test-MKMcpFiles -RepositoryRoot $root
if ($RunImplementationValidation) { $results += Invoke-MKConfiguredValidation -RepositoryRoot $root }
else {
    $commands = Get-MKValidationCommands -RepositoryRoot $root
    if ($commands.Count -gt 0) { $results += New-MKResult -Status "INFO" -Check "Implementation validation" -Message "$($commands.Count) configured command(s) are available; use -RunImplementationValidation to execute them." }
    else { $results += New-MKResult -Status "MANUAL" -Check "Implementation validation" -Message "No build/test commands are configured in mk.json; the project must define its own technology-specific checks." }
}

if (Test-MKCommand -Name "git") {
    $status = & git -C $root status --short 2>$null
    if ($LASTEXITCODE -eq 0) {
        $count = @($status).Count
        if ($count -eq 0) { $results += New-MKResult -Status "PASS" -Check "Git working tree" -Message "Working tree is clean." }
        else { $results += New-MKResult -Status "INFO" -Check "Git working tree" -Message "$count changed/untracked item(s) detected." }
    }
}

Show-MKResults -Results $results -Title "MK Project Health"
if ($WriteReport) {
    $report = Join-Path (Join-Path $root ".mk/reports") ("health-{0}.md" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
    Write-MKMarkdownReport -Results $results -Path $report -Title "MK Project Health"; Write-Host "Report: $report" -ForegroundColor DarkGray
}
if (@($results | Where-Object { $_.Status -eq "FAIL" }).Count -gt 0) { exit 1 }
exit 0
