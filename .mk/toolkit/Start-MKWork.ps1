[CmdletBinding()]
param([string]$ProjectRoot = ".",[switch]$WriteReport)

$module = Join-Path $PSScriptRoot "MK.Common.psm1"
Import-Module $module -Force
$root = Get-MKRepositoryRoot -StartPath $ProjectRoot
$results = @()
$results += New-MKResult -Status "INFO" -Check "Repository" -Message $root

if (Test-MKCommand -Name "git") {
    $branch = & git -C $root branch --show-current 2>$null
    if ($LASTEXITCODE -eq 0) { $results += New-MKResult -Status "INFO" -Check "Git branch" -Message (($branch | Select-Object -First 1) -as [string]) }
    $changed = Get-MKGitChangedPaths -RepositoryRoot $root
    if ($changed.Count -gt 0) { $results += New-MKResult -Status "WARN" -Check "Existing work" -Message "$($changed.Count) changed/untracked path(s) already exist. Preserve unrelated work before editing." }
    else { $results += New-MKResult -Status "PASS" -Check "Existing work" -Message "Working tree is clean." }
} else { $results += New-MKResult -Status "MANUAL" -Check "Git" -Message "git is not available on PATH." }

$metadata = Get-MKMetadata -RepositoryRoot $root
if ($metadata) { $results += New-MKResult -Status "PASS" -Check "MK metadata" -Message "Template version: $($metadata.templateVersion); implementation root: $(Get-MKImplementationRoot -RepositoryRoot $root)/." }
else { $results += New-MKResult -Status "FAIL" -Check "MK metadata" -Message "mk.json is missing or invalid." }

$results += Invoke-MKRepositoryValidator -RepositoryRoot $root
$results += Get-MKGraphStatus -RepositoryRoot $root
if (Test-Path -LiteralPath (Join-Path $root "docs/ai/bootstrap.md")) { $results += New-MKResult -Status "INFO" -Check "AI context" -Message "Start from AGENTS.md and docs/ai/bootstrap.md; expand context only for the task at hand." }
if (Test-Path -LiteralPath (Join-Path $root "graphify-out/graph.json")) { $results += New-MKResult -Status "MANUAL" -Check "MCP reachability" -Message "For structural work, confirm Graphify is visible and call graph_stats at first structural use." }

Show-MKResults -Results $results -Title "MK Work Start"
if ($WriteReport) {
    $report = Join-Path (Join-Path $root ".mk/reports") ("start-{0}.md" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
    Write-MKMarkdownReport -Results $results -Path $report -Title "MK Work Start"; Write-Host "Report: $report" -ForegroundColor DarkGray
}
if (@($results | Where-Object { $_.Status -eq "FAIL" }).Count -gt 0) { exit 1 }
exit 0
