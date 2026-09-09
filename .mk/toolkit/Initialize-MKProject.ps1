[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [string]$ProjectRoot = ".",
    [string]$ImplementationRoot = "implementation",
    [string]$TemplateRepository = "https://github.com/mkdotnet/project-template.git",
    [string]$TemplateRef = "main",
    [string]$ProjectName,
    [string]$RepositoryUrl,
    [switch]$AllowDirty,
    [switch]$InstallGraphify,
    [switch]$ConfigureGraphify
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"
$results = @()

function Add-Result([string]$Status, [string]$Check, [string]$Message) {
    $script:results += [pscustomobject]@{ Status = $Status; Check = $Check; Message = $Message }
}

function Show-Results {
    Write-Host ""
    Write-Host "=== MK Project Retrofit ===" -ForegroundColor Cyan
    foreach ($item in $script:results) {
        $color = "Gray"
        switch ($item.Status) {
            "PASS" { $color = "Green" }; "INFO" { $color = "Cyan" }; "WARN" { $color = "Yellow" }
            "MANUAL" { $color = "Magenta" }; "FAIL" { $color = "Red" }
        }
        Write-Host ("[{0,-6}] {1}: {2}" -f $item.Status, $item.Check, $item.Message) -ForegroundColor $color
    }
    Write-Host ""
}

function Write-Report([string]$Root) {
    $dir = Join-Path $Root ".mk/reports"
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    $path = Join-Path $dir ("retrofit-{0}.md" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
    $lines = @("# MK Project Retrofit Report", "", "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')", "", "| Status | Check | Message |", "| --- | --- | --- |")
    foreach ($item in $script:results) {
        $m = ([string]$item.Message).Replace("|", "\|").Replace("`r", " ").Replace("`n", " ")
        $c = ([string]$item.Check).Replace("|", "\|")
        $lines += "| $($item.Status) | $c | $m |"
    }
    Set-Content -LiteralPath $path -Value ($lines -join "`n") -Encoding UTF8
    return $path
}

function Ensure-Parent([string]$Path) {
    $parent = Split-Path -Parent $Path
    if ($parent -and -not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
}

function Copy-IfMissing([string]$SourceRoot, [string]$TargetRoot, [string]$Relative) {
    $src = Join-Path $SourceRoot $Relative; $dst = Join-Path $TargetRoot $Relative
    if (-not (Test-Path -LiteralPath $src -PathType Leaf)) { Add-Result "WARN" "Template file" "$Relative was not found in the template checkout."; return }
    if (Test-Path -LiteralPath $dst -PathType Leaf) {
        $a = (Get-FileHash -Algorithm SHA256 -LiteralPath $src).Hash; $b = (Get-FileHash -Algorithm SHA256 -LiteralPath $dst).Hash
        if ($a -eq $b) { Add-Result "PASS" "Preserved" "$Relative already matches the template." }
        else { Add-Result "MANUAL" "Merge required" "$Relative already exists and differs; it was not overwritten." }
        return
    }
    Ensure-Parent $dst; Copy-Item -LiteralPath $src -Destination $dst; Add-Result "PASS" "Created" $Relative
}

$target = (Resolve-Path -LiteralPath $ProjectRoot).Path
if (-not $ProjectName) { $ProjectName = Split-Path -Leaf $target }
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "git is required to retrieve the template and inspect repository state." }

$inside = & git -C $target rev-parse --is-inside-work-tree 2>$null
if ($LASTEXITCODE -eq 0 -and $inside -eq "true") {
    if (-not $RepositoryUrl) {
        $remote = & git -C $target remote get-url origin 2>$null
        if ($LASTEXITCODE -eq 0 -and $remote) { $RepositoryUrl = ($remote | Select-Object -First 1).Trim() }
    }
    $dirty = & git -C $target status --porcelain 2>$null
    if ($dirty -and -not $AllowDirty) { throw "The working tree is not clean. Commit/stash existing work or rerun with -AllowDirty after reviewing the risk." }
    if ($dirty) { Add-Result "WARN" "Working tree" "Existing changes are present; unrelated work must be preserved." }
    else { Add-Result "PASS" "Working tree" "Clean before retrofit." }
} else { Add-Result "MANUAL" "Git repository" "The target is not currently a Git working tree. Initialize Git before relying on CI/history workflows." }

$temp = Join-Path ([System.IO.Path]::GetTempPath()) ("mk-template-" + [Guid]::NewGuid().ToString("N"))
try {
    & git clone --quiet --depth 1 $TemplateRepository $temp
    if ($LASTEXITCODE -ne 0) { throw "Unable to clone $TemplateRepository" }
    if ($TemplateRef -ne "main") {
        & git -C $temp fetch --quiet origin $TemplateRef --depth 1
        if ($LASTEXITCODE -ne 0) { throw "Unable to fetch template ref $TemplateRef" }
        & git -C $temp checkout --quiet FETCH_HEAD
        if ($LASTEXITCODE -ne 0) { throw "Unable to checkout template ref $TemplateRef" }
    }
    Add-Result "PASS" "Template source" "$TemplateRepository ($TemplateRef) retrieved."

    $implPath = Join-Path $target $ImplementationRoot
    if (-not (Test-Path -LiteralPath $implPath -PathType Container)) {
        New-Item -ItemType Directory -Path $implPath -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $implPath ".gitkeep") -Value "" -Encoding ASCII
        Add-Result "MANUAL" "Implementation boundary" "$ImplementationRoot/ was created empty. Move the complete product implementation here before treating retrofit as complete."
    } else {
        $children = @(Get-ChildItem -LiteralPath $implPath -Force -ErrorAction SilentlyContinue)
        if ($children.Count -eq 0) { Add-Result "MANUAL" "Implementation boundary" "$ImplementationRoot/ exists but is empty." }
        else { Add-Result "PASS" "Implementation boundary" "$ImplementationRoot/ exists and contains project content." }
    }

    $toolTarget = Join-Path $target ".mk/scripts"
    if (-not (Test-Path -LiteralPath $toolTarget)) { New-Item -ItemType Directory -Path $toolTarget -Force | Out-Null }
    foreach ($toolFile in @(Get-ChildItem -LiteralPath $PSScriptRoot -File | Where-Object { $_.Extension -in @(".ps1", ".psm1", ".py") })) {
        $destination = Join-Path $toolTarget $toolFile.Name
        if ($toolFile.FullName -ne $destination) { Copy-Item -LiteralPath $toolFile.FullName -Destination $destination -Force }
    }
    Add-Result "PASS" "Updated managed tooling" ".mk/scripts synchronized from the toolkit package."

    if (-not (Test-Path -LiteralPath (Join-Path $toolTarget "validate_repository.py") -PathType Leaf)) {
        $validatorCandidates = @((Join-Path $temp ".mk/scripts/validate_repository.py"),(Join-Path $temp ".github/scripts/validate_repository.py"))
        $validatorSource = $validatorCandidates | Where-Object { Test-Path -LiteralPath $_ -PathType Leaf } | Select-Object -First 1
        if ($validatorSource) {
            Copy-Item -LiteralPath $validatorSource -Destination (Join-Path $toolTarget "validate_repository.py") -Force
            Add-Result "PASS" "Updated managed tooling" "validate_repository.py imported from the upstream template."
        } else { Add-Result "FAIL" "Repository validator" "The upstream template did not contain validate_repository.py at a known path." }
    }

    $workflowPayload = Join-Path $PSScriptRoot "repository-validation.yml"
    if (Test-Path -LiteralPath $workflowPayload -PathType Leaf) {
        $workflowTarget = Join-Path $target ".github/workflows/repository-validation.yml"
        if (-not (Test-Path -LiteralPath $workflowTarget -PathType Leaf)) {
            Ensure-Parent $workflowTarget; Copy-Item -LiteralPath $workflowPayload -Destination $workflowTarget
            Add-Result "PASS" "Created" ".github/workflows/repository-validation.yml"
        } else { Add-Result "MANUAL" "Merge required" ".github/workflows/repository-validation.yml already exists; compare it with the toolkit workflow before replacing." }
    } else { Copy-IfMissing $temp $target ".github/workflows/repository-validation.yml" }

    Copy-IfMissing $temp $target ".github/PULL_REQUEST_TEMPLATE.md"
    Copy-IfMissing $temp $target "AGENTS.md"; Copy-IfMissing $temp $target "CLAUDE.md"
    Copy-IfMissing $temp $target ".editorconfig"; Copy-IfMissing $temp $target ".gitattributes"

    foreach ($relative in @(
        "docs/ai/bootstrap.md","docs/ai/collaboration.md","docs/ai/review-checklist.md",
        "docs/standards/coding.md","docs/standards/documentation.md","docs/tooling/code-intelligence.md","docs/tooling/mcp-setup.md",
        "docs/tooling/lifecycle-scripts.md","docs/guides/developer/README.md","docs/guides/user/README.md","docs/modules/README.md",
        "docs/reference/templates/adr.md","docs/reference/templates/rfc.md","docs/reference/adoption-guide.md"
    )) { Copy-IfMissing $temp $target $relative }

    $templateIgnore = Join-Path $temp ".gitignore"; $targetIgnore = Join-Path $target ".gitignore"; $existing = @()
    if (Test-Path -LiteralPath $targetIgnore) { $existing = @(Get-Content -LiteralPath $targetIgnore) }
    $incoming = @(Get-Content -LiteralPath $templateIgnore); $missingLines = @($incoming | Where-Object { $_ -and ($_ -notin $existing) })
    if ($missingLines.Count -gt 0) {
        if (-not (Test-Path -LiteralPath $targetIgnore)) { Set-Content -LiteralPath $targetIgnore -Value "" -Encoding UTF8 }
        Add-Content -LiteralPath $targetIgnore -Value "`n# MK project-template baseline"
        foreach ($line in $missingLines) { Add-Content -LiteralPath $targetIgnore -Value $line }
        Add-Content -LiteralPath $targetIgnore -Value ".mk/reports/"
        Add-Result "PASS" "Git ignore" "Merged missing template ignore rules without replacing existing project rules."
    } elseif (-not ($existing -contains ".mk/reports/")) {
        Add-Content -LiteralPath $targetIgnore -Value "`n.mk/reports/"; Add-Result "PASS" "Git ignore" "Added .mk/reports/."
    }

    $templateMeta = Get-Content -LiteralPath (Join-Path $temp "mk.json") -Raw -Encoding UTF8 | ConvertFrom-Json
    $metaPath = Join-Path $target "mk.json"
    if (Test-Path -LiteralPath $metaPath -PathType Leaf) {
        try { $meta = Get-Content -LiteralPath $metaPath -Raw -Encoding UTF8 | ConvertFrom-Json }
        catch { throw "Existing mk.json is invalid JSON; fix it manually before retrofit." }
    } else { $meta = $templateMeta }

    if (-not ($meta.PSObject.Properties.Name -contains "implementation")) { Add-Member -InputObject $meta -MemberType NoteProperty -Name implementation -Value (New-Object psobject) }
    if (-not ($meta.implementation.PSObject.Properties.Name -contains "root")) { Add-Member -InputObject $meta.implementation -MemberType NoteProperty -Name root -Value $ImplementationRoot } else { $meta.implementation.root = $ImplementationRoot }
    if (-not ($meta.implementation.PSObject.Properties.Name -contains "topology")) { Add-Member -InputObject $meta.implementation -MemberType NoteProperty -Name topology -Value "project-defined" }
    $meta.schemaVersion = $templateMeta.schemaVersion; $meta.templateVersion = $templateMeta.templateVersion
    if ($meta.name -eq "MKDotNet Project Template" -or -not $meta.name) { $meta.name = $ProjectName }
    if ($RepositoryUrl) { $meta.repository = $RepositoryUrl }
    if ($meta.codeIntelligence) { $meta.codeIntelligence.analysisRoot = $ImplementationRoot }
    if ($meta.validation) { $meta.validation.script = ".mk/scripts/validate_repository.py" }
    Set-Content -LiteralPath $metaPath -Value ($meta | ConvertTo-Json -Depth 30) -Encoding UTF8
    Add-Result "PASS" "MK metadata" "mk.json aligned to template $($templateMeta.templateVersion) and implementation root $ImplementationRoot/."

    $skeletons = @{}
    $skeletons["README.md"] = "# $ProjectName`n`n<!-- MK-MANUAL: replace with verified project purpose and usage entry points. -->`n`n- [Project vision](docs/project/vision.md)`n- [Architecture](docs/architecture/overview.md)`n- [Project status](docs/project/status.md)`n- [AI bootstrap](docs/ai/bootstrap.md)`n`nProduct implementation lives under `$ImplementationRoot/`; its internal topology is project-owned.`n"
    $skeletons["docs/project/vision.md"] = "# Project Vision`n`n<!-- MK-MANUAL: complete from verified project requirements. -->`n`n## Mission`n`nDescribe why $ProjectName exists.`n`n## Scope`n`nDescribe goals, non-goals, constraints, and boundaries.`n"
    $skeletons["docs/project/roadmap.md"] = "# Project Roadmap`n`n<!-- MK-MANUAL: replace with verified milestone-level delivery order. -->`n`n## Current Milestones`n`n- Planned: define the next verified milestone.`n"
    $skeletons["docs/project/status.md"] = "# Project Status`n`n<!-- MK-MANUAL: replace with verified current state. -->`n`nLast updated: $(Get-Date -Format 'yyyy-MM-dd')`n`n| Area | State | Notes |`n| --- | --- | --- |`n| Existing implementation | In Progress | Verify actual state after retrofit. |`n"
    $skeletons["docs/project/capabilities.md"] = "# Project Capabilities`n`n<!-- MK-MANUAL: list meaningful verified capabilities. -->`n`n| Capability | State | Notes |`n| --- | --- | --- |`n| Project-specific capabilities | Planned | Replace this placeholder. |`n"
    $skeletons["docs/architecture/overview.md"] = "# Architecture Overview`n`n<!-- MK-MANUAL: document verified boundaries, dependencies, flows, trade-offs, and limitations. -->`n`n## Repository Boundary`n`nRepository governance lives outside `$ImplementationRoot/`.`n`n`$ImplementationRoot/` contains the complete project/framework-owned product workspace.`n"

    foreach ($relative in $skeletons.Keys) {
        $full = Join-Path $target $relative
        if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { Ensure-Parent $full; Set-Content -LiteralPath $full -Value $skeletons[$relative] -Encoding UTF8; Add-Result "MANUAL" "Project document" "$relative was created as a skeleton and must be completed." }
        else { Add-Result "INFO" "Project document" "$relative already exists and was preserved." }
    }

    if (-not (Test-Path -LiteralPath (Join-Path $target "LICENSE") -PathType Leaf)) { Add-Result "MANUAL" "License" "No LICENSE exists. Select the correct license deliberately." }
    else { Add-Result "MANUAL" "License" "Review the existing LICENSE/copyright; retrofit does not replace it." }

    if ($ConfigureGraphify) {
        $configureScript = Join-Path $target ".mk/scripts/Configure-MKGraphify.ps1"; $args = @("-ProjectRoot", $target)
        if ($InstallGraphify) { $args += "-InstallIfMissing" }
        & $configureScript @args
        if ($LASTEXITCODE -ne 0) { Add-Result "WARN" "Graphify" "Configure-MKGraphify.ps1 returned exit code $LASTEXITCODE." }
        else { Add-Result "INFO" "Graphify" "Graphify setup was invoked; review its output." }
    } else { Add-Result "MANUAL" "Graphify" "Run .mk/scripts/Configure-MKGraphify.ps1. Build the graph against $ImplementationRoot/ if requested." }

    Add-Result "MANUAL" "Implementation validation" "Add implementation.validation.commands to mk.json when you want framework-specific build/test checks."
    Add-Result "MANUAL" "GitHub Actions" "After push, verify the Repository validation workflow is enabled and passes."
    Add-Result "MANUAL" "Security/compliance" "Create docs/security/ only if verified project requirements justify it."
    $report = Write-Report $target; Add-Result "INFO" "Retrofit report" $report; Show-Results
    if (@($results | Where-Object { $_.Status -eq "FAIL" }).Count -gt 0) { exit 1 }
}
finally { if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force -ErrorAction SilentlyContinue } }
