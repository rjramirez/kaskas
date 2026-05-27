# kaskas -- one-command installer for Windows
# Installs kaskas for Claude Desktop (MCP server)
#
# One-liner:
#   irm https://raw.githubusercontent.com/rjramirez/kaskas/main/install.ps1 | iex
#
# Or local (supports flags):
#   powershell -ExecutionPolicy Bypass -File install.ps1 [-Force] [-Uninstall]

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"   # suppress Invoke-WebRequest progress bar

# Parse flags -- works for both -File and irm|iex
$Force     = $args -contains "-Force"     -or $args -contains "--force"
$Uninstall = $args -contains "-Uninstall" -or $args -contains "--uninstall"

$RepoUrl       = "https://raw.githubusercontent.com/rjramirez/kaskas/main"
$PluginName    = "kaskas"
$SkillDir      = Join-Path $env:APPDATA "Claude\kaskas"
$DesktopConfig = Join-Path $env:APPDATA "Claude\claude_desktop_config.json"
$CodeSettings  = Join-Path $env:USERPROFILE ".claude\settings.json"
$IsPipe        = [string]::IsNullOrEmpty($PSCommandPath)

# Banner -- ASCII only, safe on all Windows terminal encodings
Write-Host ""
Write-Host "  +-----------------------------------------------------------+" -ForegroundColor Cyan
Write-Host "  |                                                           |" -ForegroundColor Cyan
Write-Host "  |   KASKAS - Financial Memory for Claude                   |" -ForegroundColor Cyan
Write-Host "  |   Analyze statements | Track dues | Find cashback        |" -ForegroundColor Cyan
Write-Host "  |                                                           |" -ForegroundColor Cyan
Write-Host "  |   Local-only | No external API calls | Your data stays   |" -ForegroundColor Cyan
Write-Host "  |                                                           |" -ForegroundColor Cyan
Write-Host "  +-----------------------------------------------------------+" -ForegroundColor Cyan
Write-Host ""

# ── Uninstall function ─────────────────────────────────────────────────────────
function Do-Uninstall {
    Write-Host "  Uninstalling kaskas..." -ForegroundColor Cyan
    Write-Host ""

    # Step 1: Backup desktop config
    if (Test-Path $DesktopConfig) {
        Copy-Item $DesktopConfig "$DesktopConfig.bak" -Force
        Write-Host "  Backup: $DesktopConfig.bak" -ForegroundColor DarkGray
    }

    # Step 2: Remove from Claude Desktop MCP config
    if (Test-Path $DesktopConfig) {
        try {
            $cfg = Get-Content $DesktopConfig -Raw | ConvertFrom-Json
            if ($cfg.mcpServers -and $cfg.mcpServers.$PluginName) {
                $cfg.mcpServers.PSObject.Properties.Remove($PluginName)
                if (($cfg.mcpServers.PSObject.Properties | Measure-Object).Count -eq 0) {
                    $cfg.PSObject.Properties.Remove('mcpServers')
                }
                $cfg | ConvertTo-Json -Depth 20 | Set-Content $DesktopConfig -Encoding utf8
                Write-Host "  [OK] Removed from claude_desktop_config.json" -ForegroundColor Green
            }
        } catch {}
    }

    # Step 3: Remove from Claude Code settings.json
    if (Test-Path $CodeSettings) {
        try {
            $cs = Get-Content $CodeSettings -Raw | ConvertFrom-Json
            $changed = $false
            if ($cs.PSObject.Properties['enabledPlugins'] -and
                $cs.enabledPlugins.PSObject.Properties['kaskas@kaskas']) {
                $cs.enabledPlugins.PSObject.Properties.Remove('kaskas@kaskas')
                $changed = $true
            }
            if ($cs.PSObject.Properties['extraKnownMarketplaces'] -and
                $cs.extraKnownMarketplaces.PSObject.Properties['kaskas']) {
                $cs.extraKnownMarketplaces.PSObject.Properties.Remove('kaskas')
                $changed = $true
            }
            if ($changed) {
                $cs | ConvertTo-Json -Depth 20 | Set-Content $CodeSettings -Encoding utf8
                Write-Host "  [OK] Removed from ~/.claude/settings.json" -ForegroundColor Green
            }
        } catch {}
    }

    # Step 4: Keep data?
    $DataDir  = Join-Path $SkillDir "data"
    $KeepData = $false
    if ((Test-Path $DataDir) -and -not $IsPipe) {
        Write-Host ""
        $ans = Read-Host "  Keep your financial data? [Y/n]"
        $KeepData = ($ans -eq '' -or $ans -match '^[Yy]')
    }

    # Step 5: Remove skill dir
    if (Test-Path $SkillDir) {
        if ($KeepData) {
            Get-ChildItem $SkillDir -Exclude "data" | Remove-Item -Recurse -Force
            Write-Host "  [OK] Removed skill files (data kept: $DataDir)" -ForegroundColor Green
        } else {
            Remove-Item $SkillDir -Recurse -Force
            Write-Host "  [OK] Removed: $SkillDir" -ForegroundColor Green
        }
    } else {
        Write-Host "  [--] Not found: $SkillDir" -ForegroundColor DarkGray
    }

    Write-Host ""
    Write-Host "  Uninstalled. Restart Claude Desktop." -ForegroundColor Green
    Write-Host ""
}

# ── Uninstall flag ─────────────────────────────────────────────────────────────
if ($Uninstall) {
    Do-Uninstall
    exit 0
}

# ── Pre-checks ─────────────────────────────────────────────────────────────────
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "  ERROR: Node.js not found." -ForegroundColor Red
    Write-Host "         Install from https://nodejs.org (LTS) then re-run." -ForegroundColor Red
    Write-Host ""
    exit 1
}
Write-Host "  Node.js $(& node --version)" -ForegroundColor DarkGray

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
        if ($IsPipe) {
            Write-Host "  [OK] kaskas already installed." -ForegroundColor Green
            Write-Host "       Re-run with -Force to update or -Uninstall to remove."
            Write-Host ""
            exit 0
        }
        Write-Host ""
        Write-Host "  kaskas is already installed." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  [1] Update / Reinstall"
        Write-Host "  [2] Uninstall"
        Write-Host "  [3] Cancel"
        Write-Host ""
        $choice = Read-Host "  Choice"
        switch ($choice) {
            "1" { $Force = $true }
            "2" { Do-Uninstall; exit 0 }
            default { Write-Host "  Cancelled." -ForegroundColor DarkGray; Write-Host ""; exit 0 }
        }
    }
}

Write-Host "  Installing kaskas..." -ForegroundColor Cyan

# ── Detect script source ───────────────────────────────────────────────────────
$ScriptDir = if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "mcp-server.js"))) {
    $PSScriptRoot
} else {
    $null
}

$script:N = 0
function Download-File([string]$RelPath, [string]$Dest) {
    $destDir = Split-Path $Dest -Parent
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }

    if ($ScriptDir) {
        $src = Join-Path $ScriptDir $RelPath
        if (Test-Path $src) {
            Copy-Item $src $Dest -Force
            $script:N++; Write-Host "  [$script:N/34] $RelPath" -ForegroundColor DarkGray
            return
        }
    }
    Invoke-WebRequest -Uri "$RepoUrl/$RelPath" -OutFile $Dest -UseBasicParsing -ErrorAction Stop
    $script:N++; Write-Host "  [$script:N/34] $RelPath" -ForegroundColor DarkGray
}

# ── 1. Install skill files ─────────────────────────────────────────────────────
New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null

# Root
foreach ($f in @("mcp-server.js", "manifest.json", "claude.json")) {
    Download-File $f "$SkillDir\$f"
}

# Commands (15)
foreach ($f in @(
    "due.md","embed.md","export.md","forecast.md","insights.md",
    "llm.md","memory.md","ocr.md","offers.md","pdf.md",
    "promos.md","remind.md","review.md","safe.md","subscriptions.md"
)) { Download-File "commands/$f" "$SkillDir\commands\$f" }

# References (7)
foreach ($f in @(
    "embedding-config.md","forecast-config.md","llm-config.md",
    "merchant-categories.md","ph-cards.md","recurring-patterns.md","utilization-rules.md"
)) { Download-File "references/$f" "$SkillDir\references\$f" }

# Templates (2)
foreach ($f in @("obligations.md","summary.md")) {
    Download-File "templates/$f" "$SkillDir\templates\$f"
}

# Schemas (7)
foreach ($f in @(
    "embedding.schema.json","forecast.schema.json","memory.schema.json",
    "obligation.schema.json","promo.schema.json","reminder.schema.json","transaction.schema.json"
)) { Download-File "schemas/$f" "$SkillDir\schemas\$f" }

Write-Host "  [OK] Installed: $SkillDir" -ForegroundColor Green

# ── 2. Wire Claude Desktop MCP ─────────────────────────────────────────────────
if (Test-Path (Split-Path $DesktopConfig -Parent)) {
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
    Write-Host "  [OK] Wired: claude_desktop_config.json" -ForegroundColor Green
}

# ── Done ───────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  Done! Restart Claude Desktop." -ForegroundColor Green
Write-Host ""
Write-Host "  Commands in Claude Desktop chat:"
Write-Host "    /review        Analyze a statement"
Write-Host "    /due           Upcoming payments"
Write-Host "    /subscriptions Recurring charges"
Write-Host "    /offers        Best card for your spend"
Write-Host "    /safe          Risk score"
Write-Host "    /export        Export data"
Write-Host "    /ocr           Extract text from receipts"
Write-Host "    /pdf           Extract from PDFs"
Write-Host "    /promos        Parse card offers"
Write-Host "    /memory        Persistent storage"
Write-Host "    /embed         Semantic search"
Write-Host "    /insights      Pattern analysis"
Write-Host "    /llm           Local LLM analysis"
Write-Host "    /remind        Payment reminders"
Write-Host "    /forecast      Spending forecasts"
Write-Host ""
Write-Host "  Uninstall: powershell -File install.ps1 -Uninstall"
Write-Host "         or: irm https://raw.githubusercontent.com/rjramirez/kaskas/main/install.ps1 | iex -- -Uninstall"
Write-Host ""
