[CmdletBinding()]
param([string]$ProjectRoot = ".",[string]$TemplateRepository = "https://github.com/mkdotnet/project-template.git",[string]$TemplateRef = "main",[switch]$ApplyTooling,[switch]$WriteReport)

$module = Join-Path $PSScriptRoot "MK.Common.psm1"
Import-Module $module -Force
$root = Get-MKRepositoryRoot -StartPath $ProjectRoot
$results = @()
if (-not (Test-MKCommand -Name "git")) { $results += New-MKResult -Status "FAIL" -Check "Git" -Message "git is required to retrieve the upstream template."; Show-MKResults -Results $results -Title "MK Template Sync"; exit 1 }

$temp = Join-Path ([System.IO.Path]::GetTempPath()) ("mk-sync-" + [Guid]::NewGuid().ToString("N"))
try {
    & git clone --quiet --depth 1 $TemplateRepository $temp
    if ($LASTEXITCODE -ne 0) { throw "Unable to clone $TemplateRepository" }
    if ($TemplateRef -ne "main") {
        & git -C $temp fetch --quiet origin $TemplateRef --depth 1
        if ($LASTEXITCODE -ne 0) { throw "Unable to fetch $TemplateRef" }
        & git -C $temp checkout --quiet FETCH_HEAD
        if ($LASTEXITCODE -ne 0) { throw "Unable to checkout $TemplateRef" }
    }

    $localMeta = Get-MKMetadata -RepositoryRoot $root; $upstreamMeta = Get-MKMetadata -RepositoryRoot $temp
    if ($localMeta -and $upstreamMeta) { $results += New-MKResult -Status "INFO" -Check "Template version" -Message "Local: $($localMeta.templateVersion); upstream: $($upstreamMeta.templateVersion)." }

    $src = Join-Path $temp ".mk/toolkit"; $dst = Join-Path $root ".mk/scripts"
    if (Test-Path -LiteralPath $src -PathType Container) {
        $different = $false
        foreach ($sourceFile in @(Get-ChildItem -LiteralPath $src -File -Recurse)) {
            if ($sourceFile.Name -eq "README.md") { continue }
            $sub = $sourceFile.FullName.Substring($src.Length).TrimStart('\','/'); $targetFile = Join-Path $dst $sub
            if (-not (Test-Path -LiteralPath $targetFile -PathType Leaf) -or (Get-FileHash -LiteralPath $sourceFile.FullName -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $targetFile -Algorithm SHA256).Hash) { $different = $true; break }
        }
        if ($different) {
            if ($ApplyTooling) {
                New-Item -ItemType Directory -Path $dst -Force | Out-Null
                foreach ($sourceFile in @(Get-ChildItem -LiteralPath $src -File)) { if ($sourceFile.Name -ne "README.md") { Copy-Item -LiteralPath $sourceFile.FullName -Destination (Join-Path $dst $sourceFile.Name) -Force } }
                $results += New-MKResult -Status "PASS" -Check "Managed tooling" -Message ".mk/scripts updated from upstream toolkit."
            } else { $results += New-MKResult -Status "MANUAL" -Check "Managed tooling" -Message "Toolkit differs from upstream; rerun with -ApplyTooling after reviewing the changelog." }
        } else { $results += New-MKResult -Status "PASS" -Check "Managed tooling" -Message ".mk/scripts is current." }
    }

    $validatorSource = Join-Path $temp ".github/scripts/validate_repository.py"; $validatorTarget = Join-Path $root ".mk/scripts/validate_repository.py"
    if (Test-Path -LiteralPath $validatorSource -PathType Leaf) {
        $different = -not (Test-Path -LiteralPath $validatorTarget -PathType Leaf)
        if (-not $different) { $different = (Get-FileHash -LiteralPath $validatorSource -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $validatorTarget -Algorithm SHA256).Hash }
        if ($different) {
            if ($ApplyTooling) { New-Item -ItemType Directory -Path (Split-Path -Parent $validatorTarget) -Force | Out-Null; Copy-Item -LiteralPath $validatorSource -Destination $validatorTarget -Force; $results += New-MKResult -Status "PASS" -Check "Managed tooling" -Message "validate_repository.py updated from upstream." }
            else { $results += New-MKResult -Status "MANUAL" -Check "Managed tooling" -Message "validate_repository.py differs from upstream." }
        }
    }

    $workflowSource = Join-Path $temp ".mk/toolkit/repository-validation.yml"; $workflowTarget = Join-Path $root ".github/workflows/repository-validation.yml"
    if (Test-Path -LiteralPath $workflowSource -PathType Leaf) {
        $different = -not (Test-Path -LiteralPath $workflowTarget -PathType Leaf)
        if (-not $different) { $different = (Get-FileHash -LiteralPath $workflowSource -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $workflowTarget -Algorithm SHA256).Hash }
        if ($different) {
            if ($ApplyTooling) { New-Item -ItemType Directory -Path (Split-Path -Parent $workflowTarget) -Force | Out-Null; Copy-Item -LiteralPath $workflowSource -Destination $workflowTarget -Force; $results += New-MKResult -Status "PASS" -Check "Managed tooling" -Message "Repository-validation workflow updated." }
            else { $results += New-MKResult -Status "MANUAL" -Check "Managed tooling" -Message "Repository-validation workflow differs from upstream." }
        }
    }

    foreach ($relative in @("AGENTS.md","CLAUDE.md","docs/ai/bootstrap.md","docs/ai/collaboration.md","docs/ai/review-checklist.md","docs/standards/coding.md","docs/standards/documentation.md","docs/tooling/code-intelligence.md","docs/tooling/mcp-setup.md","docs/tooling/lifecycle-scripts.md","docs/reference/adoption-guide.md")) {
        $source = Join-Path $temp $relative; $target = Join-Path $root $relative
        if (-not (Test-Path -LiteralPath $source -PathType Leaf)) { continue }
        if (-not (Test-Path -LiteralPath $target -PathType Leaf)) { $results += New-MKResult -Status "MANUAL" -Check "Template guidance" -Message "$relative is missing locally; review and adopt it deliberately." }
        elseif ((Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash -ne (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash) { $results += New-MKResult -Status "MANUAL" -Check "Template guidance" -Message "$relative differs from upstream. Do not overwrite project customization blindly." }
    }

    $results += New-MKResult -Status "MANUAL" -Check "Template version" -Message "Update mk.json templateVersion only after selected upstream changes have been reviewed and applied."
    Show-MKResults -Results $results -Title "MK Template Sync"
    if ($WriteReport) { $report = Join-Path $root (".mk/reports/template-sync-{0}.md" -f (Get-Date -Format "yyyyMMdd-HHmmss")); Write-MKMarkdownReport -Results $results -Path $report -Title "MK Template Sync"; Write-Host "Report: $report" -ForegroundColor DarkGray }
}
finally { if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue } }
if (@($results | Where-Object { $_.Status -eq "FAIL" }).Count -gt 0) { exit 1 }
exit 0
