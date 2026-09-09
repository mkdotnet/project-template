[CmdletBinding()]
param(
    [string]$ProjectRoot = ".",
    [string]$TemplateRepository = "https://github.com/mkdotnet/project-template.git",
    [string]$TemplateRef = "main",
    [string]$ImplementationRoot = "implementation",
    [switch]$FullSetup,
    [switch]$AllowDirty
)

Set-StrictMode -Version 2.0
$ErrorActionPreference = "Stop"
$script:Shell = (Get-Process -Id $PID).Path
$script:Checkout = $null
$script:Results = @()

function Note([string]$Status,[string]$Text) {
    $script:Results += "[$Status] $Text"
    $color = switch ($Status) { "PASS" {"Green"}; "WARN" {"Yellow"}; "MANUAL" {"Magenta"}; "FAIL" {"Red"}; default {"Cyan"} }
    Write-Host "[$Status] $Text" -ForegroundColor $color
}

function RepoRoot([string]$Path) {
    $resolved = (Resolve-Path -LiteralPath $Path).Path
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $top = & git -C $resolved rev-parse --show-toplevel 2>$null
        if ($LASTEXITCODE -eq 0 -and $top) { return ($top | Select-Object -First 1).Trim() }
    }
    return $resolved
}

function GitDirty([string]$Root) {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { return $false }
    $inside = & git -C $Root rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -ne 0 -or $inside -ne "true") { return $false }
    return [bool](& git -C $Root status --porcelain 2>$null)
}

function Submodules([string]$Root) {
    if (-not (Test-Path (Join-Path $Root ".gitmodules")) -or -not (Get-Command git -ErrorAction SilentlyContinue)) { return @() }
    $result = @()
    foreach ($line in @(& git -C $Root config -f .gitmodules --get-regexp '^submodule\..*\.path$' 2>$null)) {
        if ($line -match '^\S+\s+(.+)$') { $result += $Matches[1].Trim().Replace('\','/') }
    }
    return $result
}

function MigrationPlan([string]$Root) {
    $keepDirs = @(".git",".github",".mk","docs",$ImplementationRoot,"graphify-out",".cursor",".claude",".codex",".vscode",".idea",".devcontainer")
    $keepFiles = @("README.md","AGENTS.md","CLAUDE.md","mk.json","CHANGELOG.md","LICENSE","LICENSE.md","LICENSE.txt","CONTRIBUTING.md","SECURITY.md","CODE_OF_CONDUCT.md",".gitignore",".gitattributes",".editorconfig","Initialize.ps1","Initialize-MKProject.cmd")
    $secretPatterns = @('^\.env$','^\.env\.(?!example$|sample$)','\.(pfx|p12|key|pem|kdbx)$','^\.npmrc$','^\.pypirc$','^\.netrc$')
    $subs = Submodules $Root; $move=@(); $keep=@(); $manual=@()
    foreach ($item in @(Get-ChildItem -LiteralPath $Root -Force)) {
        $n=$item.Name; $rel=$n.Replace('\','/')
        if (($item.PSIsContainer -and $keepDirs -contains $n) -or (-not $item.PSIsContainer -and $keepFiles -contains $n)) { $keep += $n; continue }
        if (-not $item.PSIsContainer -and $n.ToLowerInvariant().EndsWith('.md')) { $keep += $n; $manual += "$n — root documentation; consolidate deliberately if needed"; continue }
        if ($n -eq ".gitmodules" -or $subs -contains $rel) { $manual += "$n — Git submodule metadata/path"; continue }
        $sensitive=$false; foreach($p in $secretPatterns){ if($n -match $p){$sensitive=$true;break} }
        if ($sensitive) { $manual += "$n — likely secret/credential-bearing file"; continue }
        if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) { $manual += "$n — symlink/reparse point"; continue }
        if (Test-Path (Join-Path (Join-Path $Root $ImplementationRoot) $n)) { $manual += "$n — destination collision"; continue }
        $move += $n
    }
    return [pscustomobject]@{Move=$move;Keep=$keep;Manual=$manual}
}

function Preview([string]$Root) {
    $p=MigrationPlan $Root
    Write-Host "`nMOVE -> $ImplementationRoot/" -ForegroundColor Green
    if($p.Move.Count -eq 0){Write-Host "  (none)" -ForegroundColor DarkGray}else{foreach($x in $p.Move){Write-Host "  + $x"}}
    Write-Host "`nKEEP at repository root" -ForegroundColor Cyan
    foreach($x in $p.Keep){Write-Host "  = $x" -ForegroundColor DarkGray}
    Write-Host "`nMANUAL REVIEW" -ForegroundColor Magenta
    if($p.Manual.Count -eq 0){Write-Host "  (none)" -ForegroundColor DarkGray}else{foreach($x in $p.Manual){Write-Host "  ! $x" -ForegroundColor Magenta}}
    return $p
}

function Ask([string]$Text,[bool]$Yes=$false) {
    $a=Read-Host "$Text $(if($Yes){'[Y/n]'}else{'[y/N]'})"
    if(-not $a){return $Yes}; return ($a -match '^(y|yes)$')
}

function Move-Product([string]$Root,$Plan) {
    $impl=Join-Path $Root $ImplementationRoot
    New-Item -ItemType Directory -Path $impl -Force | Out-Null
    foreach($n in $Plan.Move){
        try { Move-Item -LiteralPath (Join-Path $Root $n) -Destination (Join-Path $impl $n); Note "PASS" "Moved $n -> $ImplementationRoot/$n" }
        catch { Note "FAIL" "Could not move $n: $($_.Exception.Message)" }
    }
    foreach($x in $Plan.Manual){Note "MANUAL" $x}
}

function CheckoutTemplate {
    if($script:Checkout -and (Test-Path $script:Checkout)){return $script:Checkout}
    if(-not (Get-Command git -ErrorAction SilentlyContinue)){throw "git is required."}
    $tmp=Join-Path ([IO.Path]::GetTempPath()) ("mk-template-"+[Guid]::NewGuid().ToString('N'))
    & git clone --quiet --depth 1 --branch $TemplateRef $TemplateRepository $tmp
    if($LASTEXITCODE -ne 0){throw "Unable to clone $TemplateRepository ($TemplateRef). Check network/Git credentials."}
    $script:Checkout=$tmp; return $tmp
}

function Install-Toolkit([string]$Root) {
    $src=Join-Path (CheckoutTemplate) ".mk/toolkit"; if(-not(Test-Path $src)){throw "Upstream .mk/toolkit is missing."}
    $dst=Join-Path $Root ".mk/scripts"; New-Item -ItemType Directory -Path $dst -Force|Out-Null
    foreach($f in @(Get-ChildItem $src -File)){if($f.Name -ne "README.md"){Copy-Item $f.FullName (Join-Path $dst $f.Name) -Force}}
    New-Item -ItemType Directory -Path (Join-Path $Root ".mk/reports") -Force|Out-Null
    Note "PASS" "Toolkit downloaded and installed to .mk/scripts/."
}

function Run-Child([string]$File,[string[]]$Args) {
    & $script:Shell -NoProfile -ExecutionPolicy Bypass -File $File @Args
    return $LASTEXITCODE
}

function Apply-Template([string]$Root) {
    if(-not(Test-Path(Join-Path $Root ".mk/scripts/Initialize-MKProject.ps1"))){Install-Toolkit $Root}
    $rc=Run-Child (Join-Path $Root ".mk/scripts/Initialize-MKProject.ps1") @("-ProjectRoot",$Root,"-ImplementationRoot",$ImplementationRoot,"-TemplateRepository",$TemplateRepository,"-TemplateRef",$TemplateRef,"-AllowDirty")
    if($rc -eq 0){Note "PASS" "MK governance/template retrofit completed."}else{Note "FAIL" "Retrofit exited with code $rc."}
}

function Graphify-Setup([string]$Root) {
    if(-not(Test-Path(Join-Path $Root ".mk/scripts/Configure-MKGraphify.ps1"))){Install-Toolkit $Root}
    $args=@("-ProjectRoot",$Root); if(Ask "Install Graphify with uv if missing?" $true){$args+="-InstallIfMissing"}
    $rc=Run-Child (Join-Path $Root ".mk/scripts/Configure-MKGraphify.ps1") $args
    if($rc -eq 0){Note "INFO" "Graphify setup finished as far as automation allows; review MANUAL output."}else{Note "FAIL" "Graphify setup exited with code $rc."}
}

function Health([string]$Root) {
    if(-not(Test-Path(Join-Path $Root ".mk/scripts/Test-MKProject.ps1"))){Install-Toolkit $Root}
    $rc=Run-Child (Join-Path $Root ".mk/scripts/Test-MKProject.ps1") @("-ProjectRoot",$Root,"-WriteReport")
    if($rc -eq 0){Note "PASS" "MK health check passed without hard failures."}else{Note "FAIL" "MK health check found hard failures."}
}

function Report([string]$Root) {
    $dir=Join-Path $Root ".mk/reports"; New-Item -ItemType Directory -Path $dir -Force|Out-Null
    $file=Join-Path $dir ("bootstrap-{0}.md" -f (Get-Date -Format 'yyyyMMdd-HHmmss'))
    $lines=@("# MK Bootstrap Report","","Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')","","Repository: `$Root`","Implementation root: `$ImplementationRoot/`","")
    foreach($r in $script:Results){$lines+="- $r"}; Set-Content $file ($lines -join "`n") -Encoding UTF8
    Write-Host "`nReport: $file" -ForegroundColor DarkGray
    Write-Host "Daily: .\.mk\scripts\Start-MKWork.ps1  |  Test-MKProject.ps1  |  Complete-MKWork.ps1" -ForegroundColor Cyan
}

function Guided([string]$Root) {
    Write-Host "`n1) Preflight / migration preview" -ForegroundColor Cyan
    if(Get-Command git -ErrorAction SilentlyContinue){Note "PASS" "git is available."}else{throw "git is required."}
    $plan=Preview $Root
    if((GitDirty $Root) -and -not $AllowDirty){Note "WARN" "Working tree has uncommitted changes.";if(-not(Ask "Continue anyway? A clean commit/stash is safer." $false)){Report $Root;return}}
    if($plan.Move.Count -gt 0 -and (Ask "Move listed product/framework items into $ImplementationRoot/?" $false)){Move-Product $Root $plan}
    elseif(-not(Test-Path(Join-Path $Root $ImplementationRoot))){New-Item -ItemType Directory -Path (Join-Path $Root $ImplementationRoot) -Force|Out-Null;Note "PASS" "Created $ImplementationRoot/."}
    Write-Host "`n2) Toolkit" -ForegroundColor Cyan; Install-Toolkit $Root
    Write-Host "`n3) MK governance/template" -ForegroundColor Cyan; Apply-Template $Root
    Write-Host "`n4) Graphify/MCP" -ForegroundColor Cyan; if(Ask "Configure Graphify/MCP now?" $true){Graphify-Setup $Root}else{Note "MANUAL" "Run .mk/scripts/Configure-MKGraphify.ps1 later."}
    Write-Host "`n5) Health" -ForegroundColor Cyan; Health $Root; Report $Root
}

$root=RepoRoot $ProjectRoot
Clear-Host
Write-Host "=== MK Project Initializer ===" -ForegroundColor Cyan
Write-Host "Repository: $root" -ForegroundColor DarkGray
Write-Host "Product boundary: $ImplementationRoot/`n" -ForegroundColor DarkGray

try {
    if($FullSetup){Guided $root;return}
    while($true){
        Write-Host "1. Preflight + migration preview"
        Write-Host "2. Move product/framework items into $ImplementationRoot/"
        Write-Host "3. Download/update MK toolkit"
        Write-Host "4. Apply/complete MK template"
        Write-Host "5. Configure Graphify + MCP"
        Write-Host "6. Run MK health check"
        Write-Host "7. Guided full setup (recommended)" -ForegroundColor Green
        Write-Host "8. Write/show bootstrap report"
        Write-Host "0. Exit"
        switch(Read-Host "Selection"){
            "1"{[void](Preview $root)}
            "2"{$p=Preview $root;if(Ask "Move listed items now?" $false){Move-Product $root $p}}
            "3"{Install-Toolkit $root}
            "4"{Apply-Template $root}
            "5"{Graphify-Setup $root}
            "6"{Health $root}
            "7"{Guided $root}
            "8"{Report $root}
            "0"{return}
            default{Write-Host "Invalid selection." -ForegroundColor Yellow}
        }
        Write-Host ""
    }
}
finally{if($script:Checkout -and(Test-Path $script:Checkout)){Remove-Item $script:Checkout -Recurse -Force -ErrorAction SilentlyContinue}}
