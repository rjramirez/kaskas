$SkillDir = "$env:APPDATA\Claude\skills\kaskas"
$RepoUrl = "https://raw.githubusercontent.com/rjramirez/kaskas/main"
$TempDir = "$env:TEMP\kaskas-install"

Write-Host "🚀 Installing Kaskas..." -ForegroundColor Cyan
Write-Host ""

# Create skill directory
New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
New-Item -ItemType Directory -Force -Path $TempDir | Out-Null

# Function to download file
function Download-File {
    param(
        [string]$Url,
        [string]$OutPath
    )
    try {
        Write-Host "  📥 Downloading $(Split-Path $OutPath -Leaf)..." -ForegroundColor Gray
        Invoke-WebRequest -Uri $Url -OutFile $OutPath -ErrorAction Stop
    }
    catch {
        Write-Host "  ❌ Failed to download $Url" -ForegroundColor Red
        throw $_
    }
}

# Function to download and extract directory
function Download-Directory {
    param(
        [string]$DirName
    )
    $dirs = @("commands", "references", "templates", "schemas", "agents")
    $files = @("SKILL.md")
    
    if ($DirName -in $files) {
        $url = "$RepoUrl/$DirName"
        $outPath = "$SkillDir\$DirName"
        Download-File -Url $url -OutPath $outPath
    }
    elseif ($DirName -in $dirs) {
        Write-Host "  📂 Setting up $DirName..." -ForegroundColor Gray
        New-Item -ItemType Directory -Force -Path "$SkillDir\$DirName" | Out-Null
        
        # Download files from directory (simplified - downloads key files)
        $files = @()
        switch ($DirName) {
            "commands" { $files = @("due.md", "export.md", "offers.md", "review.md", "safe.md", "subscriptions.md") }
            "references" { $files = @("merchant-categories.md", "ph-cards.md", "recurring-patterns.md", "utilization-rules.md") }
            "templates" { $files = @("obligations.md", "summary.md") }
            "schemas" { $files = @("obligation.schema.json", "promo.schema.json", "transaction.schema.json") }
            "agents" { $files = @("openai.yaml") }
        }
        
        foreach ($file in $files) {
            $url = "$RepoUrl/$DirName/$file"
            $outPath = "$SkillDir\$DirName\$file"
            Download-File -Url $url -OutPath $outPath
        }
    }
}

try {
    # Download SKILL.md
    Download-Directory -DirName "SKILL.md"
    
    # Download directories
    @("commands", "references", "templates", "schemas", "agents") | ForEach-Object {
        Download-Directory -DirName $_
    }
    
    Write-Host ""
    Write-Host "✅ Kaskas installed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📍 Location: $SkillDir" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "⚡ Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Restart Claude Desktop"
    Write-Host "  2. Try using /review, /due, /subscriptions, /offers, /safe, /export"
    Write-Host ""
}
catch {
    Write-Host ""
    Write-Host "❌ Installation failed!" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
finally {
    # Cleanup temp directory
    if (Test-Path $TempDir) {
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
