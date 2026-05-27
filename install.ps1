# kaskas -- optimized installer for Windows
# Fast, safe, clean installation and uninstall

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# ── Config ─────────────────────────────────────────────────────────────────────
$RepoUrl = "https://raw.githubusercontent.com/rjramirez/kaskas/main"
$Version = "4.0.0"
$SkillDir = Join-Path $env:APPDATA "Claude\kaskas"
$DesktopConfig = Join-Path $env:APPDATA "Claude\claude_desktop_config.json"
$CodeSettings = Join-Path $env:USERPROFILE ".claude\settings.json"
$LogFile = Join-Path $SkillDir "install.log"
$IsPipe = [string]::IsNullOrEmpty($PSCommandPath)

# ── Parse args ─────────────────────────────────────────────────────────────────
$Force = $args -contains "-Force" -or $args -contains "--force"
$Uninstall = $args -contains "-Uninstall" -or $args -contains "--uninstall"

# ── Helpers ────────────────────────────────────────────────────────────────────
function Log([string]$msg) {
  Write-Host "  $msg" -ForegroundColor Gray
  if (Test-Path (Split-Path $LogFile -Parent)) {
    "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg" | Add-Content $LogFile -ErrorAction SilentlyContinue
  }
}

function Info([string]$msg) { Write-Host "  [OK] $msg" -ForegroundColor Green }
function Warn([string]$msg) { Write-Host "  [!] $msg" -ForegroundColor Yellow }
function Err([string]$msg) { Write-Host "  ERROR: $msg" -ForegroundColor Red; exit 1 }

# ── Banner ─────────────────────────────────────────────────────────────────────
function Show-Banner {
  Write-Host ""
  Write-Host "  +-----------------------------------------------------------+" -ForegroundColor Cyan
  Write-Host "  |  KASKAS - Financial Memory for Claude (v$Version)         |" -ForegroundColor Cyan
  Write-Host "  |  Analyze statements | Track dues | Find cashback         |" -ForegroundColor Cyan
  Write-Host "  |  Local-only | No external API calls | Your data stays    |" -ForegroundColor Cyan
  Write-Host "  +-----------------------------------------------------------+" -ForegroundColor Cyan
  Write-Host ""
}

# ── Update config (JSON) ───────────────────────────────────────────────────────
function Update-Config([string]$config, [string]$action) {
  if (-not (Test-Path $config)) {
    if ($action -eq "add") { @{} | ConvertTo-Json | Set-Content $config -Encoding UTF8 }
    else { return }
  }

  $result = & node -e "
    const fs=require('fs'), p=process.env.C, a=process.env.A, sd=process.env.SD;
    let c=JSON.parse(fs.readFileSync(p,'utf8')||'{}');

    if(a==='add-desktop') {
      if(!c.mcpServers) c.mcpServers={};
      c.mcpServers.kaskas={command:'node',args:[sd+'/mcp-server.js']};
    } else if(a==='remove-desktop' && c.mcpServers) {
      delete c.mcpServers.kaskas;
      if(!Object.keys(c.mcpServers).length) delete c.mcpServers;
    } else if(a==='remove-code') {
      let changed=false;
      if(c.enabledPlugins?.['kaskas@kaskas']) { delete c.enabledPlugins['kaskas@kaskas']; changed=true; }
      if(c.extraKnownMarketplaces?.kaskas) { delete c.extraKnownMarketplaces.kaskas; changed=true; }
      if(!changed) return;
    }

    fs.writeFileSync(p,JSON.stringify(c,null,2)+'\n');
    console.log('OK');
  " C="$config" A="$action" SD="$SkillDir" 2>$null

  return ($result -eq 'OK')
}

# ── Uninstall ──────────────────────────────────────────────────────────────────
function Uninstall-Kaskas {
  Log "Uninstalling kaskas..."
  Write-Host ""

  # Backup config
  if (Test-Path $DesktopConfig) {
    Copy-Item $DesktopConfig "$DesktopConfig.bak" -Force
    Log "Backup: $DesktopConfig.bak"
  }

  # Remove from configs
  if (Update-Config $DesktopConfig "remove-desktop") { Info "Removed from claude_desktop_config.json" }
  else { Warn "Could not update desktop config" }

  if (Update-Config $CodeSettings "remove-code") { Info "Removed from settings.json" }

  # Ask about data
  $KeepData = $false
  if ((Test-Path "$SkillDir\data") -and -not $IsPipe) {
    Write-Host ""
    try {
      $ans = Read-Host "  Keep your financial data? [Y/n]"
      $KeepData = ($ans -eq '' -or $ans -match '^[Yy]')
    } catch {
      $KeepData = $true
    }
  }

  # Remove skill dir
  if (Test-Path $SkillDir) {
    if ($KeepData) {
      Get-ChildItem $SkillDir -Exclude "data" | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
      Info "Removed skill files (data kept)"
    } else {
      Remove-Item $SkillDir -Recurse -Force
      Info "Removed: $SkillDir"
    }
  }

  Write-Host ""
  Log "Uninstalled. Restart Claude Desktop."
  Write-Host ""
}

# ── Pre-checks ─────────────────────────────────────────────────────────────────
function Check-Node {
  if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Err "Node.js not found. Install from https://nodejs.org (LTS)"
  }
  Log "Node.js $(& node --version)"
}

# ── Already installed? ─────────────────────────────────────────────────────────
function Check-Installed {
  if ($Force) { return }
  if (-not (Test-Path "$SkillDir\mcp-server.js")) { return }

  $Wired = $false
  if (Test-Path $DesktopConfig) {
    try {
      $cfg = Get-Content $DesktopConfig -Raw | ConvertFrom-Json
      $Wired = $null -ne $cfg.mcpServers -and $null -ne $cfg.mcpServers.kaskas
    } catch {}
  }

  if (-not $Wired) { return }

  Write-Host ""
  Write-Host "  kaskas is already installed."
  Write-Host "  [1] Update / Reinstall  [2] Uninstall  [3] Cancel"
  Write-Host ""

  try {
    $choice = Read-Host "  Choice"
  } catch {
    $choice = "3"
  }

  switch ($choice) {
    "1" { $script:Force = $true }
    "2" { Uninstall-Kaskas; Write-Host ""; Write-Host "  Press any key to exit..."; $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown"); exit 0 }
    default { Write-Host "  Cancelled."; Write-Host ""; Write-Host "  Press any key to exit..."; $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown"); exit 0 }
  }
}

# ── File list ──────────────────────────────────────────────────────────────────
$Files = @(
  @("mcp-server.js", "."), @("manifest.json", "."), @("claude.json", ".")
  @("due.md", "commands"), @("embed.md", "commands"), @("export.md", "commands"), @("forecast.md", "commands")
  @("insights.md", "commands"), @("llm.md", "commands"), @("memory.md", "commands"), @("ocr.md", "commands")
  @("offers.md", "commands"), @("pdf.md", "commands"), @("promos.md", "commands"), @("remind.md", "commands")
  @("review.md", "commands"), @("safe.md", "commands"), @("subscriptions.md", "commands")
  @("embedding-config.md", "references"), @("forecast-config.md", "references"), @("llm-config.md", "references")
  @("merchant-categories.md", "references"), @("ph-cards.md", "references"), @("recurring-patterns.md", "references")
  @("utilization-rules.md", "references")
  @("obligations.md", "templates"), @("summary.md", "templates")
  @("embedding.schema.json", "schemas"), @("forecast.schema.json", "schemas"), @("memory.schema.json", "schemas")
  @("obligation.schema.json", "schemas"), @("promo.schema.json", "schemas"), @("reminder.schema.json", "schemas")
  @("transaction.schema.json", "schemas")
)

# ── Download with retry ────────────────────────────────────────────────────────
function Download-File([string]$file, [string]$dest) {
  $retries = 3
  $delay = 500
  while ($retries -gt 0) {
    try {
      Invoke-WebRequest -Uri "$RepoUrl/$file" -OutFile $dest -UseBasicParsing -ErrorAction Stop
      return $true
    } catch {
      $retries--
      if ($retries -gt 0) {
        Start-Sleep -Milliseconds $delay
        $delay = $delay * 2
      }
    }
  }
  return $false
}

# ── Install ────────────────────────────────────────────────────────────────────
function Install-Kaskas {
  Log "Installing kaskas..."

  # Backup if updating
  if ($Force -and (Test-Path $SkillDir)) {
    $BackupDir = "$SkillDir.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item $SkillDir $BackupDir -Recurse -Force
    Log "Backup: $BackupDir"
  }

  # Create temp dir
  $TempDir = New-Item -ItemType Directory -Path ([System.IO.Path]::GetTempPath()) -Name "kaskas-$(Get-Random)" -Force

  try {
    # Download files
    $Failed = 0
    $Count = 0
    $FailedFiles = @()
    foreach ($entry in $Files) {
      $file, $dir = $entry
      $destDir = Join-Path $TempDir $dir
      if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }

      $fullPath = "$dir/$file"
      if (Download-File $fullPath (Join-Path $destDir $file)) {
        $Count++
        Write-Host -NoNewline "`r  Downloaded: $Count/$($Files.Count) files"
      } else {
        Write-Host ""
        Warn "Failed to download $fullPath (after 3 retries)"
        $FailedFiles += $fullPath
        $Failed++
      }
    }
    Write-Host ""

    if ($Failed -gt 0) {
      Write-Host ""
      Warn "Failed files:"
      foreach ($f in $FailedFiles) { Write-Host "  - $f" -ForegroundColor Yellow }
      Err "Failed to download $Failed file(s). Check network and try again."
    }

    # Verify count
    $Actual = @(Get-ChildItem $TempDir -Recurse -File).Count
    if ($Actual -ne $Files.Count) { Err "Incomplete download: $Actual/$($Files.Count) files" }
    Info "Verified: $Actual/$($Files.Count) files"

    # Validate JSON
    foreach ($json in Get-ChildItem $TempDir -Recurse -Filter "*.json") {
      try {
        $null = Get-Content $json.FullName | ConvertFrom-Json
      } catch {
        Err "Invalid JSON: $($json.Name)"
      }
    }
    Info "Validated: JSON syntax OK"

    # Move to final location
    if (Test-Path $SkillDir) { Remove-Item $SkillDir -Recurse -Force }
    Move-Item $TempDir $SkillDir -Force
    Info "Installed: $SkillDir"

    # Wire Claude Desktop
    if (Test-Path (Split-Path $DesktopConfig -Parent)) {
      if (-not (Test-Path $DesktopConfig)) {
        @{} | ConvertTo-Json | Set-Content $DesktopConfig -Encoding UTF8
      }
      Copy-Item $DesktopConfig "$DesktopConfig.bak" -Force

      if (Update-Config $DesktopConfig "add-desktop") {
        Info "Wired: claude_desktop_config.json"
      } else {
        Err "Could not wire config"
      }
    }

    # Health check
    try {
      $result = & node -e "
        const readline=require('readline');
        const rl=readline.createInterface({input:process.stdin,terminal:false});
        rl.on('line',line=>{
          try{const req=JSON.parse(line);
          if(req.method==='initialize'){
            console.log(JSON.stringify({jsonrpc:'2.0',id:req.id,result:{protocolVersion:'2024-11-05',capabilities:{prompts:{}},serverInfo:{name:'kaskas',version:'4.0.0'}}}));
            process.exit(0);
          }}catch(e){}
        });
      " -InputObject '{"jsonrpc":"2.0","id":1,"method":"initialize"}' 2>$null

      if ($result -like "*kaskas*") { Info "MCP server responds" }
      else { Warn "MCP server not responding (may need restart)" }
    } catch {
      Warn "Could not test MCP server"
    }
  } finally {
    if (Test-Path $TempDir) { Remove-Item $TempDir -Recurse -Force -ErrorAction SilentlyContinue }
  }
}

# ── Main ───────────────────────────────────────────────────────────────────────
Show-Banner
Check-Node

if ($Uninstall) {
  Uninstall-Kaskas
} else {
  Check-Installed
  Install-Kaskas

  Write-Host ""
  Info "Done! Restart Claude Desktop."
  Write-Host ""
  Write-Host "  Commands: /review /due /subscriptions /offers /safe /export /ocr /pdf /promos /memory /embed /insights /llm /remind /forecast"
  Write-Host "  Uninstall: powershell -File install.ps1 -Uninstall"
  Write-Host ""
}

# ── Wait for user (if piped) ───────────────────────────────────────────────────
if ($IsPipe) {
  Write-Host ""
  Write-Host "  Press any key to exit..."
  $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
