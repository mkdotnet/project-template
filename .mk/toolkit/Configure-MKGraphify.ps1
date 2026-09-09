[CmdletBinding()]
param([string]$ProjectRoot = ".",[switch]$InstallIfMissing,[switch]$SkipSkillRegistration)

$module = Join-Path $PSScriptRoot "MK.Common.psm1"
Import-Module $module -Force
$root = Get-MKRepositoryRoot -StartPath $ProjectRoot
$results = @()
$impl = Get-MKImplementationRoot -RepositoryRoot $root
$graphRelative = "graphify-out/graph.json"
$graphPath = Join-Path $root $graphRelative

if (-not (Test-MKCommand -Name "graphify")) {
    if ($InstallIfMissing -and (Test-MKCommand -Name "uv")) {
        Write-Host "Installing Graphify with MCP support..." -ForegroundColor DarkCyan
        & uv tool install "graphifyy[mcp]"
        if ($LASTEXITCODE -ne 0) { $results += New-MKResult -Status "FAIL" -Check "Graphify install" -Message "uv tool install failed." }
    }
}
if (-not (Test-MKCommand -Name "graphify")) {
    $results += New-MKResult -Status "MANUAL" -Check "Graphify install" -Message "Install with: uv tool install `"graphifyy[mcp]`"; ensure graphify is on PATH; rerun this script."
    Show-MKResults -Results $results -Title "MK Graphify Setup"; exit 0
}
$results += New-MKResult -Status "PASS" -Check "Graphify CLI" -Message "graphify is available."

if (-not $SkipSkillRegistration) {
    Push-Location $root
    try {
        foreach ($platform in @("claude", "cursor", "codex")) {
            & graphify $platform install --project
            if ($LASTEXITCODE -eq 0) { $results += New-MKResult -Status "PASS" -Check "Graphify skill" -Message "Project-scoped $platform integration installed/refreshed." }
            else { $results += New-MKResult -Status "WARN" -Check "Graphify skill" -Message "$platform project install returned exit code $LASTEXITCODE; review Graphify output." }
        }
    } finally { Pop-Location }
}

if (-not (Test-Path -LiteralPath $graphPath -PathType Leaf)) {
    $results += New-MKResult -Status "MANUAL" -Check "Graph build" -Message "No graph exists yet. Build Graphify against $impl/ using the active assistant integration, then rerun this script to create MCP configs."
    Show-MKResults -Results $results -Title "MK Graphify Setup"; exit 0
}

function Ensure-JsonMcp([string]$Path) {
    $full = Join-Path $root $Path; $directory = Split-Path -Parent $full
    if ($directory -and -not (Test-Path -LiteralPath $directory)) { New-Item -ItemType Directory -Path $directory -Force | Out-Null }
    $data = $null
    if (Test-Path -LiteralPath $full -PathType Leaf) {
        try { $data = Get-Content -LiteralPath $full -Raw -Encoding UTF8 | ConvertFrom-Json }
        catch { $script:results += New-MKResult -Status "MANUAL" -Check "MCP config" -Message "$Path is not valid JSON; merge Graphify manually."; return }
    }
    if (-not $data) { $data = New-Object psobject }
    if (-not ($data.PSObject.Properties.Name -contains "mcpServers")) { Add-Member -InputObject $data -MemberType NoteProperty -Name "mcpServers" -Value (New-Object psobject) }
    if ($data.mcpServers.PSObject.Properties.Name -contains "graphify") { $script:results += New-MKResult -Status "INFO" -Check "MCP config" -Message "$Path already has a Graphify server; existing settings were preserved."; return }
    $server = [pscustomobject]@{ command = "graphify-mcp"; args = @($graphRelative) }
    Add-Member -InputObject $data.mcpServers -MemberType NoteProperty -Name "graphify" -Value $server
    Set-Content -LiteralPath $full -Value ($data | ConvertTo-Json -Depth 20) -Encoding UTF8
    $script:results += New-MKResult -Status "PASS" -Check "MCP config" -Message "Added Graphify to $Path."
}

Ensure-JsonMcp -Path ".mcp.json"
Ensure-JsonMcp -Path ".cursor/mcp.json"
$codex = Join-Path $root ".codex/config.toml"
if (-not (Test-Path -LiteralPath (Split-Path -Parent $codex))) { New-Item -ItemType Directory -Path (Split-Path -Parent $codex) -Force | Out-Null }
if (Test-Path -LiteralPath $codex -PathType Leaf) {
    $text = Get-Content -LiteralPath $codex -Raw -Encoding UTF8
    if ($text -match "(?m)^\s*\[mcp_servers\.graphify\]\s*$") { $results += New-MKResult -Status "INFO" -Check "Codex MCP" -Message ".codex/config.toml already defines mcp_servers.graphify; existing settings were preserved." }
    else { Add-Content -LiteralPath $codex -Value "`n[mcp_servers.graphify]`ncommand = `"graphify-mcp`"`nargs = [`"$graphRelative`"]`nrequired = true`n" -Encoding UTF8; $results += New-MKResult -Status "PASS" -Check "Codex MCP" -Message "Added project-scoped Graphify MCP config." }
} else {
    Set-Content -LiteralPath $codex -Value "[mcp_servers.graphify]`ncommand = `"graphify-mcp`"`nargs = [`"$graphRelative`"]`nrequired = true`n" -Encoding UTF8
    $results += New-MKResult -Status "PASS" -Check "Codex MCP" -Message "Created .codex/config.toml with Graphify MCP config."
}
$results += New-MKResult -Status "MANUAL" -Check "Reachability" -Message "Restart/reload each assistant as needed. For structural work, confirm Graphify is listed and call graph_stats."
Show-MKResults -Results $results -Title "MK Graphify Setup"
if (@($results | Where-Object { $_.Status -eq "FAIL" }).Count -gt 0) { exit 1 }
exit 0
