# kaskas -- local installer (copies from current directory)
# Use this for testing before pushing to GitHub

$ErrorActionPreference = "Stop"
$SkillDir = Join-Path $env:APPDATA "Claude\kaskas"
$UTF8NoBOM = [System.Text.UTF8Encoding]::new($false)

Write-Host ""
Write-Host "  KASKAS Local Install" -ForegroundColor Cyan
Write-Host "  Copying from: $(Get-Location)" -ForegroundColor Gray
Write-Host "  Installing to: $SkillDir" -ForegroundColor Gray
Write-Host ""

# Create skill directory
if (-not (Test-Path $SkillDir)) {
    New-Item -ItemType Directory -Path $SkillDir -Force | Out-Null
}

# Copy all files
$dirs = @(".", "commands", "references", "templates", "schemas", "data")
foreach ($dir in $dirs) {
    $srcDir = if ($dir -eq ".") { "." } else { $dir }
    $destDir = if ($dir -eq ".") { $SkillDir } else { Join-Path $SkillDir $dir }
    
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    
    Get-ChildItem $srcDir -Filter "*.md" -ErrorAction SilentlyContinue | Copy-Item -Destination $destDir -Force
    Get-ChildItem $srcDir -Filter "*.json" -ErrorAction SilentlyContinue | Copy-Item -Destination $destDir -Force
    Get-ChildItem $srcDir -Filter "*.js" -ErrorAction SilentlyContinue | Copy-Item -Destination $destDir -Force
}

$fileCount = (Get-ChildItem $SkillDir -Recurse -File | Measure-Object).Count
Write-Host "  [OK] Copied $fileCount files" -ForegroundColor Green

# Update all Claude configs
$configs = @(
    (Join-Path $env:APPDATA "Claude\claude_desktop_config.json"),
    (Join-Path $env:LOCALAPPDATA "Claude-3p\claude_desktop_config.json")
)

# Add Windows Store config if exists
$ClaudePackages = Get-ChildItem "$env:LOCALAPPDATA\Packages" -Filter "*Claude*" -ErrorAction SilentlyContinue
if ($ClaudePackages) {
    $configs += Join-Path $ClaudePackages[0].FullName "LocalCache\Roaming\Claude-3p\claude_desktop_config.json"
}

$serverPath = ($SkillDir -replace '\\','/') + "/mcp-server.js"

foreach ($configPath in $configs) {
    $parentDir = Split-Path $configPath -Parent
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
    }
    
    if (Test-Path $configPath) {
        $config = Get-Content $configPath -Raw | ConvertFrom-Json
    } else {
        $config = [PSCustomObject]@{}
    }
    
    if (-not $config.PSObject.Properties['mcpServers']) {
        $config | Add-Member -NotePropertyName "mcpServers" -NotePropertyValue ([PSCustomObject]@{}) -Force
    }
    
    $config.mcpServers | Add-Member -NotePropertyName "kaskas" -NotePropertyValue ([PSCustomObject]@{
        command = "node"
        args = @($serverPath)
    }) -Force
    
    $json = $config | ConvertTo-Json -Depth 20
    [System.IO.File]::WriteAllText($configPath, $json, $UTF8NoBOM)
    Write-Host "  [OK] Updated: $configPath" -ForegroundColor Green
}

Write-Host ""
Write-Host "  Installation complete!" -ForegroundColor Green
Write-Host "  Restart Claude Desktop to use kaskas." -ForegroundColor Cyan
Write-Host ""
