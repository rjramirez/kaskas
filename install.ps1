# kaskas — one-command installer for Windows
# Installs kaskas for Claude Desktop (MCP) + Claude Code (plugin)
#
# One-liner:
#   irm https://raw.githubusercontent.com/rjramirez/kaskas/main/install.ps1 | iex
#
# Or local:
#   powershell -ExecutionPolicy Bypass -File install.ps1

param(
    [switch]$Force,
    [switch]$Uninstall,
    [switch]$DesktopOnly,
    [switch]$CodeOnly
)

$ErrorActionPreference = "Stop"

$RepoUrl       = "https://raw.githubusercontent.com/rjramirez/kaskas/main"
$RepoId        = "rjramirez/kaskas"
$PluginName    = "kaskas"
$SkillDir      = Join-Path $env:APPDATA "Claude\kaskas"
$DesktopConfig = Join-Path $env:APPDATA "Claude\claude_desktop_config.json"
$CodeSettings  = Join-Path $env:USERPROFILE ".claude\settings.json"

# ── Uninstall ──────────────────────────────────────────────────────────────────
if ($Uninstall) {
    if (Test-Path $SkillDir) {
        Remove-Item $SkillDir -Recurse -Force
        Write-Host "Removed: $SkillDir"
    }
    if (Test-Path $DesktopConfig) {
        try {
            $cfg = Get-Content $DesktopConfig -Raw | ConvertFrom-Json
            if ($cfg.mcpServers -and $cfg.mcpServers.$PluginName) {
                $cfg.mcpServers.PSObject.Properties.Remove($PluginName)
                if (($cfg.mcpServers.PSObject.Properties | Measure-Object).Count -eq 0) {
                    $cfg.PSObject.Properties.Remove('mcpServers')
                }
                $cfg | ConvertTo-Json -Depth 20 | Set-Content $DesktopConfig -Encoding utf8
                Write-Host "Removed from claude_desktop_config.json"
            }
        } catch {}
    }
    if (Test-Path $CodeSettings) {
        try {
            $s = Get-Content $CodeSettings -Raw | ConvertFrom-Json
            if ($s.extraKnownMarketplaces -and $s.extraKnownMarketplaces.$PluginName) {
                $s.extraKnownMarketplaces.PSObject.Properties.Remove($PluginName)
                $key = "$PluginName@$PluginName"
                if ($s.enabledPlugins -and $s.enabledPlugins.$key) {
                    $s.enabledPlugins.PSObject.Properties.Remove($key)
                }
                $s | ConvertTo-Json -Depth 20 | Set-Content $CodeSettings -Encoding utf8
                Write-Host "Removed from Claude Code settings"
            }
        } catch {}
    }
    Write-Host ""
    Write-Host "Uninstalled. Restart Claude Desktop and Claude Code." -ForegroundColor Green
    exit 0
}

# ── Pre-checks ─────────────────────────────────────────────────────────────────
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host ""
    Write-Host "ERROR: Node.js not found." -ForegroundColor Red
    Write-Host "       Install from https://nodejs.org (LTS) then re-run." -ForegroundColor Red
    Write-Host ""
    exit 1
}

$NodeVer = & node --version
Write-Host "Node.js $NodeVer" -ForegroundColor DarkGray

# ── Already installed? ─────────────────────────────────────────────────────────
if (-not $Force) {
    $serverExists = Test-Path (Join-Path $SkillDir "mcp-server.js")
    $desktopWired = $false
    if (Test-Path $DesktopConfig) {
        try {
            $cfg = Get-Content $DesktopConfig -Raw | ConvertFrom-Json
            $desktopWired = $null -ne $cfg.mcpServers -and $null -ne $cfg.mcpServers.$PluginName
        } catch {}
    }
    if ($serverExists -and $desktopWired) {
        Write-Host "kaskas already installed. Re-run with -Force to overwrite."
        exit 0
    }
}

Write-Host ""
Write-Host "Installing kaskas..." -ForegroundColor Cyan

# ── Detect script source ───────────────────────────────────────────────────────
# Running locally (from cloned repo)? Use local files. Otherwise download.
$ScriptDir = if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "mcp-server.js"))) {
    $PSScriptRoot
} else {
    $null
}

function Download-File([string]$RelPath, [string]$Dest) {
    $destDir = Split-Path $Dest -Parent
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }

    if ($ScriptDir) {
        $src = Join-Path $ScriptDir $RelPath
        if (Test-Path $src) {
            Copy-Item $src $Dest -Force
            return
        }
    }
    Invoke-WebRequest -Uri "$RepoUrl/$RelPath" -OutFile $Dest -UseBasicParsing -ErrorAction Stop
}

# ── 1. Install skill files ─────────────────────────────────────────────────────
New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null

Write-Host "  Downloading files..." -ForegroundColor DarkGray

# Root
foreach ($f in @("mcp-server.js", "manifest.json", "claude.json")) {
    Download-File $f "$SkillDir\$f"
}

# Commands (all 15)
$cmds = @(
    "due.md","embed.md","export.md","forecast.md","insights.md",
    "llm.md","memory.md","ocr.md","offers.md","pdf.md",
    "promos.md","remind.md","review.md","safe.md","subscriptions.md"
)
foreach ($f in $cmds) { Download-File "commands/$f" "$SkillDir\commands\$f" }

# References
$refs = @(
    "embedding-config.md","forecast-config.md","llm-config.md",
    "merchant-categories.md","ph-cards.md","recurring-patterns.md","utilization-rules.md"
)
foreach ($f in $refs) { Download-File "references/$f" "$SkillDir\references\$f" }

# Templates
foreach ($f in @("obligations.md","summary.md")) {
    Download-File "templates/$f" "$SkillDir\templates\$f"
}

# Schemas
$schemas = @(
    "embedding.schema.json","forecast.schema.json","memory.schema.json",
    "obligation.schema.json","promo.schema.json","reminder.schema.json","transaction.schema.json"
)
foreach ($f in $schemas) { Download-File "schemas/$f" "$SkillDir\schemas\$f" }

Write-Host "  Installed: $SkillDir" -ForegroundColor Green

# ── 2. Wire Claude Desktop MCP ─────────────────────────────────────────────────
if (-not $CodeOnly -and (Test-Path (Split-Path $DesktopConfig -Parent))) {
    if (-not (Test-Path $DesktopConfig)) { '{}' | Set-Content $DesktopConfig -Encoding utf8 }
    Copy-Item $DesktopConfig "$DesktopConfig.bak" -Force

    $raw = (Get-Content $DesktopConfig -Raw).Trim()
    if ([string]::IsNullOrEmpty($raw)) { $raw = '{}' }
    try { $cfg = $raw | ConvertFrom-Json } catch { $cfg = [PSCustomObject]@{} }

    if (-not $cfg.PSObject.Properties['mcpServers']) {
        $cfg | Add-Member -NotePropertyName mcpServers -NotePropertyValue ([PSCustomObject]@{}) -Force
    }
    $cfg.mcpServers | Add-Member -NotePropertyName $PluginName -NotePropertyValue ([PSCustomObject]@{
        command = "node"
        args    = @("$SkillDir\mcp-server.js")
    }) -Force

    $cfg | ConvertTo-Json -Depth 20 | Set-Content $DesktopConfig -Encoding utf8
    Write-Host "  Wired: claude_desktop_config.json (MCP server)" -ForegroundColor Green
}

# ── 3. Register Claude Code plugin ────────────────────────────────────────────
if (-not $DesktopOnly -and (Test-Path (Split-Path $CodeSettings -Parent))) {
    if (-not (Test-Path $CodeSettings)) { '{}' | Set-Content $CodeSettings -Encoding utf8 }
    Copy-Item $CodeSettings "$CodeSettings.bak" -Force

    $raw = (Get-Content $CodeSettings -Raw).Trim()
    if ([string]::IsNullOrEmpty($raw)) { $raw = '{}' }
    try { $s = $raw | ConvertFrom-Json } catch { $s = [PSCustomObject]@{} }

    # extraKnownMarketplaces
    if (-not $s.PSObject.Properties['extraKnownMarketplaces']) {
        $s | Add-Member -NotePropertyName extraKnownMarketplaces -NotePropertyValue ([PSCustomObject]@{}) -Force
    }
    $s.extraKnownMarketplaces | Add-Member -NotePropertyName $PluginName -NotePropertyValue ([PSCustomObject]@{
        source = [PSCustomObject]@{
            source = "github"
            repo   = $RepoId
        }
    }) -Force

    # enabledPlugins
    if (-not $s.PSObject.Properties['enabledPlugins']) {
        $s | Add-Member -NotePropertyName enabledPlugins -NotePropertyValue ([PSCustomObject]@{}) -Force
    }
    $pluginKey = "$PluginName@$PluginName"
    $s.enabledPlugins | Add-Member -NotePropertyName $pluginKey -NotePropertyValue $true -Force

    $s | ConvertTo-Json -Depth 20 | Set-Content $CodeSettings -Encoding utf8
    Write-Host "  Wired: ~/.claude/settings.json (Claude Code plugin)" -ForegroundColor Green
}

# ── Done ───────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "Done! Restart Claude Desktop and Claude Code." -ForegroundColor Green
Write-Host ""
Write-Host "Claude Desktop — type in chat:"
Write-Host "  /review        Analyze a statement"
Write-Host "  /due           Upcoming payments"
Write-Host "  /subscriptions Recurring charges"
Write-Host "  /offers        Best card for your spend"
Write-Host "  /safe          Risk score"
Write-Host "  /export        Export data"
Write-Host ""
Write-Host "Claude Code — same commands available as skills."
Write-Host ""
Write-Host "Uninstall: powershell -File install.ps1 -Uninstall"
