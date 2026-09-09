Set-StrictMode -Version 2.0

function Get-MKRepositoryRoot {
    param([string]$StartPath = ".")
    $resolved = (Resolve-Path -LiteralPath $StartPath -ErrorAction Stop).Path
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $root = & git -C $resolved rev-parse --show-toplevel 2>$null
        if ($LASTEXITCODE -eq 0 -and $root) { return ($root | Select-Object -First 1).Trim() }
    }
    return $resolved
}

function Get-MKMetadata {
    param([Parameter(Mandatory=$true)][string]$RepositoryRoot)
    $path = Join-Path $RepositoryRoot "mk.json"
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return $null }
    try { return (Get-Content -LiteralPath $path -Raw -Encoding UTF8 | ConvertFrom-Json) }
    catch { return $null }
}

function Get-MKImplementationRoot {
    param([Parameter(Mandatory=$true)][string]$RepositoryRoot)
    $metadata = Get-MKMetadata -RepositoryRoot $RepositoryRoot
    if ($metadata -and $metadata.implementation -and $metadata.implementation.root) { return [string]$metadata.implementation.root }
    return "implementation"
}

function Test-MKCommand {
    param([Parameter(Mandatory=$true)][string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function New-MKResult {
    param(
        [Parameter(Mandatory=$true)][ValidateSet("PASS","INFO","WARN","MANUAL","FAIL")][string]$Status,
        [Parameter(Mandatory=$true)][string]$Check,
        [Parameter(Mandatory=$true)][string]$Message
    )
    return [pscustomobject]@{ Status = $Status; Check = $Check; Message = $Message }
}

function Show-MKResults {
    param([Parameter(Mandatory=$true)][object[]]$Results,[string]$Title = "MK Project Check")
    Write-Host ""
    Write-Host "=== $Title ===" -ForegroundColor Cyan
    foreach ($item in $Results) {
        $color = "Gray"
        switch ($item.Status) {
            "PASS" { $color = "Green" }; "INFO" { $color = "Cyan" }; "WARN" { $color = "Yellow" }
            "MANUAL" { $color = "Magenta" }; "FAIL" { $color = "Red" }
        }
        Write-Host ("[{0,-6}] {1}: {2}" -f $item.Status, $item.Check, $item.Message) -ForegroundColor $color
    }
    Write-Host ""
}

function Write-MKMarkdownReport {
    param([Parameter(Mandatory=$true)][object[]]$Results,[Parameter(Mandatory=$true)][string]$Path,[string]$Title = "MK Project Report")
    $directory = Split-Path -Parent $Path
    if ($directory -and -not (Test-Path -LiteralPath $directory)) { New-Item -ItemType Directory -Path $directory -Force | Out-Null }
    $lines = @("# $Title", "", "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')", "", "| Status | Check | Message |", "| --- | --- | --- |")
    foreach ($item in $Results) {
        $message = ([string]$item.Message).Replace("|", "\|").Replace("`r", " ").Replace("`n", " ")
        $check = ([string]$item.Check).Replace("|", "\|")
        $lines += "| $($item.Status) | $check | $message |"
    }
    Set-Content -LiteralPath $Path -Value ($lines -join "`n") -Encoding UTF8
}

function Get-MKPythonCommand {
    foreach ($candidate in @("python3", "python", "py")) { if (Test-MKCommand -Name $candidate) { return $candidate } }
    return $null
}

function Invoke-MKRepositoryValidator {
    param([Parameter(Mandatory=$true)][string]$RepositoryRoot)
    $validator = Join-Path $RepositoryRoot ".mk/scripts/validate_repository.py"
    if (-not (Test-Path -LiteralPath $validator -PathType Leaf)) { return New-MKResult -Status "FAIL" -Check "Repository validator" -Message ".mk/scripts/validate_repository.py is missing." }
    $python = Get-MKPythonCommand
    if (-not $python) { return New-MKResult -Status "MANUAL" -Check "Repository validator" -Message "Python was not found; run the validator in CI or install Python 3." }
    Push-Location $RepositoryRoot
    try {
        & $python $validator
        if ($LASTEXITCODE -eq 0) { return New-MKResult -Status "PASS" -Check "Repository validator" -Message "Repository contract validation passed." }
        return New-MKResult -Status "FAIL" -Check "Repository validator" -Message "Repository contract validation failed with exit code $LASTEXITCODE."
    } finally { Pop-Location }
}

function Get-MKGitChangedPaths {
    param([Parameter(Mandatory=$true)][string]$RepositoryRoot)
    if (-not (Test-MKCommand -Name "git")) { return @() }
    $inside = & git -C $RepositoryRoot rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -ne 0 -or $inside -ne "true") { return @() }
    $lines = & git -C $RepositoryRoot status --porcelain=v1 2>$null
    $result = @()
    foreach ($line in $lines) {
        if (-not $line -or $line.Length -lt 4) { continue }
        $path = $line.Substring(3).Trim()
        if ($path -match " -> ") { $path = ($path -split " -> ")[-1] }
        $result += $path.Replace("\", "/")
    }
    return $result
}

function Get-MKGraphStatus {
    param([Parameter(Mandatory=$true)][string]$RepositoryRoot)
    $results = @(); $impl = Get-MKImplementationRoot -RepositoryRoot $RepositoryRoot; $graph = Join-Path $RepositoryRoot "graphify-out/graph.json"
    if (Test-MKCommand -Name "graphify") { $results += New-MKResult -Status "PASS" -Check "Graphify CLI" -Message "graphify is available." }
    else { $results += New-MKResult -Status "MANUAL" -Check "Graphify CLI" -Message "Graphify is not on PATH. Recommended install: uv tool install `"graphifyy[mcp]`"." }
    if (Test-Path -LiteralPath $graph -PathType Leaf) {
        $results += New-MKResult -Status "PASS" -Check "Graphify graph" -Message "graphify-out/graph.json exists."
        $changed = Get-MKGitChangedPaths -RepositoryRoot $RepositoryRoot
        $implChanged = @($changed | Where-Object { $_ -eq $impl -or $_.StartsWith("$impl/") })
        if ($implChanged.Count -gt 0) { $results += New-MKResult -Status "WARN" -Check "Graph freshness" -Message "$($implChanged.Count) uncommitted path(s) under $impl/ may make the graph stale." }
        else { $results += New-MKResult -Status "INFO" -Check "Graph freshness" -Message "No uncommitted implementation changes detected; graph_stats remains the reachability check." }
    } else { $results += New-MKResult -Status "MANUAL" -Check "Graphify graph" -Message "Build the graph against $impl/ before creating MCP config." }
    return $results
}

function Test-MKMcpFiles {
    param([Parameter(Mandatory=$true)][string]$RepositoryRoot)
    $results = @()
    foreach ($item in @(@{Name="Claude MCP";Path=".mcp.json"},@{Name="Cursor MCP";Path=".cursor/mcp.json"},@{Name="Codex MCP";Path=".codex/config.toml"})) {
        $full = Join-Path $RepositoryRoot $item.Path
        if (Test-Path -LiteralPath $full -PathType Leaf) {
            $text = Get-Content -LiteralPath $full -Raw -Encoding UTF8
            if ($text -match "graphify") { $results += New-MKResult -Status "PASS" -Check $item.Name -Message "$($item.Path) contains Graphify configuration." }
            else { $results += New-MKResult -Status "MANUAL" -Check $item.Name -Message "$($item.Path) exists but Graphify was not detected." }
        } else { $results += New-MKResult -Status "MANUAL" -Check $item.Name -Message "$($item.Path) is not configured. Run Configure-MKGraphify.ps1 after the graph exists." }
    }
    return $results
}

function Get-MKValidationCommands {
    param([Parameter(Mandatory=$true)][string]$RepositoryRoot)
    $metadata = Get-MKMetadata -RepositoryRoot $RepositoryRoot
    if (-not $metadata -or -not $metadata.implementation -or -not $metadata.implementation.validation) { return @() }
    $commands = $metadata.implementation.validation.commands
    if (-not $commands) { return @() }
    return @($commands | ForEach-Object { [string]$_ })
}

function Invoke-MKConfiguredValidation {
    param([Parameter(Mandatory=$true)][string]$RepositoryRoot)
    $commands = Get-MKValidationCommands -RepositoryRoot $RepositoryRoot; $results = @()
    if ($commands.Count -eq 0) { $results += New-MKResult -Status "MANUAL" -Check "Implementation validation" -Message "No implementation.validation.commands are defined in mk.json."; return $results }
    Push-Location $RepositoryRoot
    try {
        foreach ($command in $commands) {
            Write-Host "Running: $command" -ForegroundColor DarkCyan
            & ([scriptblock]::Create($command))
            if ($LASTEXITCODE -ne 0) { $results += New-MKResult -Status "FAIL" -Check "Implementation validation" -Message "Command failed ($LASTEXITCODE): $command" }
            else { $results += New-MKResult -Status "PASS" -Check "Implementation validation" -Message "Passed: $command" }
        }
    } finally { Pop-Location }
    return $results
}

Export-ModuleMember -Function *-MK*
