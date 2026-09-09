[CmdletBinding()]
param([string]$ProjectRoot = ".",[switch]$SkipImplementationValidation,[switch]$RequireClean,[switch]$WriteReport)

$module = Join-Path $PSScriptRoot "MK.Common.psm1"
Import-Module $module -Force
$root = Get-MKRepositoryRoot -StartPath $ProjectRoot
$results = @()
$results += New-MKResult -Status "INFO" -Check "Repository" -Message $root
$results += Invoke-MKRepositoryValidator -RepositoryRoot $root
if (-not $SkipImplementationValidation) { $results += Invoke-MKConfiguredValidation -RepositoryRoot $root }

if (Test-MKCommand -Name "git") {
    & git -C $root diff --check
    if ($LASTEXITCODE -eq 0) { $results += New-MKResult -Status "PASS" -Check "git diff --check" -Message "No whitespace-error markers were reported." }
    else { $results += New-MKResult -Status "FAIL" -Check "git diff --check" -Message "Whitespace/conflict-marker style problems were reported." }

    $changed = Get-MKGitChangedPaths -RepositoryRoot $root; $impl = Get-MKImplementationRoot -RepositoryRoot $root
    $implChanged = @($changed | Where-Object { $_ -eq $impl -or $_.StartsWith("$impl/") })
    $stateChanged = @($changed | Where-Object { $_ -eq "docs/project/status.md" -or $_ -eq "docs/project/capabilities.md" })
    if ($implChanged.Count -gt 0 -and $stateChanged.Count -eq 0) { $results += New-MKResult -Status "MANUAL" -Check "Project state" -Message "Implementation changed, but status/capabilities did not. Confirm the change is non-material before completion." }
    if ($implChanged.Count -gt 0) { $results += New-MKResult -Status "MANUAL" -Check "Graphify refresh" -Message "Implementation changed. Refresh Graphify before relying on the graph or handing off structural work." }
    if ($changed.Count -eq 0) { $results += New-MKResult -Status "PASS" -Check "Working tree" -Message "Working tree is clean." }
    elseif ($RequireClean) { $results += New-MKResult -Status "FAIL" -Check "Working tree" -Message "$($changed.Count) changed/untracked path(s) remain and -RequireClean was specified." }
    else { $results += New-MKResult -Status "INFO" -Check "Working tree" -Message "$($changed.Count) changed/untracked path(s) remain; review before commit/push." }
}

foreach ($path in @("README.md","docs/project/vision.md","docs/project/roadmap.md","docs/project/status.md","docs/project/capabilities.md","docs/architecture/overview.md")) {
    $full = Join-Path $root $path
    if (Test-Path -LiteralPath $full -PathType Leaf) {
        $text = Get-Content -LiteralPath $full -Raw -Encoding UTF8
        if ($text -match "MK-MANUAL") { $results += New-MKResult -Status "MANUAL" -Check "Project context" -Message "$path still contains MK-MANUAL markers." }
    }
}

Show-MKResults -Results $results -Title "MK Work Completion"
if ($WriteReport) {
    $report = Join-Path (Join-Path $root ".mk/reports") ("complete-{0}.md" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
    Write-MKMarkdownReport -Results $results -Path $report -Title "MK Work Completion"; Write-Host "Report: $report" -ForegroundColor DarkGray
}
if (@($results | Where-Object { $_.Status -eq "FAIL" }).Count -gt 0) { exit 1 }
exit 0
