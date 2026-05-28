# kaskas -- optimized installer for Windows
# Fast, safe, clean installation and uninstall

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# ── Config ─────────────────────────────────────────────────────────────────────
$RepoUrl = "https://cdn.jsdelivr.net/gh/rjramirez/kaskas@main"
$Version = "4.0.0"
$SkillDir = Join-Path $env:APPDATA "Claude\kaskas"
$DesktopConfig = Join-Path $env:APPDATA "Claude\claude_desktop_config.json"
$CodeSettings = Join-Path $env:USERPROFILE ".claude\settings.json"
$LogFile = Join-Path $SkillDir "install.log"

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
function Err([string]$msg) { 
  Write-Host "  ERROR: $msg" -ForegroundColor Red
  $null = Read-Host "  Press Enter to exit"
  Stop-Process -Id $PID
}

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

# ── Update config (JSON) ──────────────────────────────────────────────────────
# Uses [System.IO.File]::WriteAllText with UTF8NoBOM -- avoids PS5.1 BOM bug
$UTF8NoBOM = [System.Text.UTF8Encoding]::new($false)

function Write-JsonFile([string]$path, [object]$obj) {
  $json = $obj | ConvertTo-Json -Depth 20
  [System.IO.File]::WriteAllText($path, $json + "`n", $UTF8NoBOM)
}

function Update-Config([string]$config, [string]$action) {
  if (-not (Test-Path $config)) {
    if ($action -eq "add-desktop") {
      [System.IO.File]::WriteAllText($config, '{}', $UTF8NoBOM)
    } else { return $false }
  }

  try {
    $raw = (Get-Content $config -Raw).Trim()
    if ([string]::IsNullOrEmpty($raw)) { $raw = '{}' }
    $c = $raw | ConvertFrom-Json
    $changed = $false

    if ($action -eq "add-desktop") {
      if (-not $c.PSObject.Properties['mcpServers']) {
        $c | Add-Member -NotePropertyName "mcpServers" -NotePropertyValue ([PSCustomObject]@{}) -Force
      }
      $serverPath = ($SkillDir -replace '\\','/') + "/mcp-server.js"
      $c.mcpServers | Add-Member -NotePropertyName "kaskas" -NotePropertyValue ([PSCustomObject]@{
        command = "node"
        args    = @($serverPath)
      }) -Force
      $changed = $true
    } elseif ($action -eq "remove-desktop" -and $c.PSObject.Properties['mcpServers']) {
      $c.mcpServers.PSObject.Properties.Remove("kaskas")
      if (($c.mcpServers.PSObject.Properties | Measure-Object).Count -eq 0) {
        $c.PSObject.Properties.Remove("mcpServers")
      }
      $changed = $true
    } elseif ($action -eq "remove-code") {
      if ($c.PSObject.Properties['enabledPlugins'] -and
          $c.enabledPlugins.PSObject.Properties['kaskas@kaskas']) {
        $c.enabledPlugins.PSObject.Properties.Remove("kaskas@kaskas")
        $changed = $true
      }
      if ($c.PSObject.Properties['extraKnownMarketplaces'] -and
          $c.extraKnownMarketplaces.PSObject.Properties['kaskas']) {
        $c.extraKnownMarketplaces.PSObject.Properties.Remove("kaskas")
        $changed = $true
      }
    }

    if ($changed) { Write-JsonFile $config $c }
    return $true
  } catch {
    return $false
  }
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
  if (Test-Path "$SkillDir\data") {
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
function Test-Node {
  if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Err "Node.js not found. Install from https://nodejs.org (LTS)"
  }
  Log "Node.js $(& node --version)"
}

# ── Already installed? ─────────────────────────────────────────────────────────
function Test-KaskasInstalled {
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
    "2" { 
      Uninstall-Kaskas
      $null = Read-Host "  Press Enter to exit"
      Stop-Process -Id $PID
    }
    default { 
      Write-Host "  Cancelled."
      Write-Host ""
      $null = Read-Host "  Press Enter to exit"
      Stop-Process -Id $PID
    }
  }
}

# ── File list ──────────────────────────────────────────────────────────────────
$Files = @(
  @("mcp-server.js", "."), @("manifest.json", "."), @("claude.json", "."),
  @("kaskas.md", "commands"), @("due.md", "commands"), @("embed.md", "commands"), @("export.md", "commands"), @("forecast.md", "commands"),
  @("insights.md", "commands"), @("llm.md", "commands"), @("memory.md", "commands"), @("ocr.md", "commands"),
  @("offers.md", "commands"), @("pdf.md", "commands"), @("promos.md", "commands"), @("remind.md", "commands"),
  @("review.md", "commands"), @("safe.md", "commands"), @("subscriptions.md", "commands"),
  @("embedding-config.md", "references"), @("forecast-config.md", "references"), @("llm-config.md", "references"),
  @("merchant-categories.md", "references"), @("ph-cards.md", "references"), @("recurring-patterns.md", "references"),
  @("utilization-rules.md", "references"), @("ph-calendar.md", "references"), @("ph-expressions.md", "references"),
  @("ph-financial-terms.md", "references"), @("ph-promos.md", "references"), @("ph-spending-patterns.md", "references"),
  @("obligations.md", "templates"), @("summary.md", "templates"),
  @("embedding.schema.json", "schemas"), @("forecast.schema.json", "schemas"), @("memory.schema.json", "schemas"),
  @("obligation.schema.json", "schemas"), @("promo.schema.json", "schemas"), @("reminder.schema.json", "schemas"),
  @("transaction.schema.json", "schemas"),
  @("merchants.json", "data"), @("cards.json", "data"), @("calendar.json", "data"), @("promos.json", "data"),
  @("patterns.json", "data"), @("expressions.json", "data"), @("terms.json", "data"), @("spending-patterns.json", "data")
)

# ── Download with retry (multiple sources) ────────────────────────────────────
function Get-RemoteFile([string]$file, [string]$fullPath, [string]$dest) {
  $urls = @(
    "$RepoUrl/$fullPath",
    "https://api.github.com/repos/rjramirez/kaskas/contents/$fullPath`?ref=main"
  )

  foreach ($url in $urls) {
    $retries = 3
    $delay = 500
    $success = $false
    while ($retries -gt 0 -and -not $success) {
      try {
        Write-Host "    Trying: $url" -ForegroundColor DarkGray

        if ($url -like "*api.github.com*") {
          $response = Invoke-WebRequest -Uri $url -UseBasicParsing -ErrorAction Stop
          $json = $response.Content | ConvertFrom-Json
          if ($json.content) {
            $base64 = $json.content -replace '\s', ''
            $content = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($base64))
            [System.IO.File]::WriteAllText($dest, $content, $UTF8NoBOM)
            Write-Host "    [OK] $file" -ForegroundColor Green
            $success = $true
          } else {
            throw "No content in response"
          }
        } else {
          Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing -ErrorAction Stop
          Write-Host "    [OK] $file" -ForegroundColor Green
          $success = $true
        }
      } catch {
        $retries--
        if ($retries -gt 0) {
          Write-Host "    [!] Failed, retrying... ($retries left)" -ForegroundColor Yellow
          Start-Sleep -Milliseconds $delay
          $delay = $delay * 2
        } else {
          Write-Host "    [!] Failed: $url" -ForegroundColor Red
        }
      }
    }
    if ($success) { return $true }
  }
  return $false
}

# ── Install ────────────────────────────────────────────────────────────────────
function Install-Kaskas {
  Write-Host ""
  Write-Host "  Installing kaskas..." -ForegroundColor Cyan
  Write-Host ""

  # Backup if updating
  if ($Force -and (Test-Path $SkillDir)) {
    $BackupDir = "$SkillDir.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
    Copy-Item $SkillDir $BackupDir -Recurse -Force
    Log "Backup: $BackupDir"
  }

  # Create temp dir
  $TempDir = (New-Item -ItemType Directory -Path ([System.IO.Path]::GetTempPath()) -Name "kaskas-$(Get-Random)" -Force).FullName

  try {
    # Download files
    $Failed = 0
    $Count = 0
    $FailedFiles = @()
    foreach ($entry in $Files) {
      $file, $dir = $entry
      $destDir = Join-Path $TempDir $dir
      if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }

      $fullPath = if ($dir -eq ".") { $file } else { "$dir/$file" }
      if (Get-RemoteFile $file $fullPath (Join-Path $destDir $file)) {
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

    $Actual = (Get-ChildItem $TempDir -Recurse -File | Measure-Object).Count
    if ($Actual -ne $Files.Count) { Err "Incomplete download: $Actual/$($Files.Count) files" }
    Info "Verified: $Actual/$($Files.Count) files"

    # Validate JSON
    foreach ($json in Get-ChildItem $TempDir -Recurse -Filter "*.json") {
      try {
        $null = Get-Content $json.FullName | ConvertFrom-Json -ErrorAction Stop
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
    try {
      $ConfigParent = Split-Path $DesktopConfig -Parent
      if (Test-Path $ConfigParent) {
        if (-not (Test-Path $DesktopConfig)) {
          [System.IO.File]::WriteAllText($DesktopConfig, '{}', $UTF8NoBOM)
        }
        Copy-Item $DesktopConfig "$DesktopConfig.bak" -Force

        if (Update-Config $DesktopConfig "add-desktop") {
          Info "Wired: claude_desktop_config.json"
        } else {
          Err "Could not wire config"
        }
      }
    } catch {
      Warn "Could not wire Claude Desktop config (non-critical)"
    }

    # Health check
    if (Test-Path "$SkillDir/mcp-server.js") {
      Info "Health check: OK"
    } else {
      Warn "Health check failed (non-critical)"
    }

    Write-Host ""
    Info "Installation complete!"
    Write-Host ""
    Write-Host "  Next steps:"
    Write-Host "  1. Restart Claude Desktop"
    Write-Host "  2. Try: /due, /insights, /review, /forecast"
    Write-Host ""
  } finally {
    if (Test-Path $TempDir) { Remove-Item $TempDir -Recurse -Force -ErrorAction SilentlyContinue }
  }
}

# ── Main ───────────────────────────────────────────────────────────────────────
Show-Banner

if ($Uninstall) {
  Uninstall-Kaskas
  $null = Read-Host "  Press Enter to exit"
  Stop-Process -Id $PID
}

Test-Node
Test-KaskasInstalled
Install-Kaskas
$null = Read-Host "  Press Enter to exit"
Stop-Process -Id $PID
