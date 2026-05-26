param(
    [switch]$Help
)

if ($Help) {
    Write-Host "Kaskas Installer for Windows"
    Write-Host ""
    Write-Host "Usage: irm https://raw.githubusercontent.com/rjramirez/kaskas/main/install.ps1 | iex"
    exit 0
}

$SkillDir = "$env:APPDATA\Claude\skills\kaskas"
$RepoUrl = "https://raw.githubusercontent.com/rjramirez/kaskas/main"

Write-Host "🚀 Installing Kaskas..." -ForegroundColor Cyan
Write-Host ""

try {
    # Create skill directory
    New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null
    Write-Host "✓ Created skill directory" -ForegroundColor Green
    
    # Download SKILL.md
    Write-Host "📥 Downloading SKILL.md..." -ForegroundColor Gray
    $skillMdUrl = "$RepoUrl/SKILL.md"
    Invoke-WebRequest -Uri $skillMdUrl -OutFile "$SkillDir\SKILL.md" -ErrorAction Stop
    
    # Download and setup commands
    Write-Host "📂 Setting up commands..." -ForegroundColor Gray
    New-Item -ItemType Directory -Force -Path "$SkillDir\commands" | Out-Null
    $commandFiles = @("due.md", "export.md", "offers.md", "review.md", "safe.md", "subscriptions.md")
    foreach ($file in $commandFiles) {
        Invoke-WebRequest -Uri "$RepoUrl/commands/$file" -OutFile "$SkillDir\commands\$file" -ErrorAction Stop
    }
    
    # Download and setup references
    Write-Host "📂 Setting up references..." -ForegroundColor Gray
    New-Item -ItemType Directory -Force -Path "$SkillDir\references" | Out-Null
    $refFiles = @("merchant-categories.md", "ph-cards.md", "recurring-patterns.md", "utilization-rules.md")
    foreach ($file in $refFiles) {
        Invoke-WebRequest -Uri "$RepoUrl/references/$file" -OutFile "$SkillDir\references\$file" -ErrorAction Stop
    }
    
    # Download and setup templates
    Write-Host "📂 Setting up templates..." -ForegroundColor Gray
    New-Item -ItemType Directory -Force -Path "$SkillDir\templates" | Out-Null
    $templateFiles = @("obligations.md", "summary.md")
    foreach ($file in $templateFiles) {
        Invoke-WebRequest -Uri "$RepoUrl/templates/$file" -OutFile "$SkillDir\templates\$file" -ErrorAction Stop
    }
    
    # Download and setup schemas
    Write-Host "📂 Setting up schemas..." -ForegroundColor Gray
    New-Item -ItemType Directory -Force -Path "$SkillDir\schemas" | Out-Null
    $schemaFiles = @("obligation.schema.json", "promo.schema.json", "transaction.schema.json")
    foreach ($file in $schemaFiles) {
        Invoke-WebRequest -Uri "$RepoUrl/schemas/$file" -OutFile "$SkillDir\schemas\$file" -ErrorAction Stop
    }
    
    # Download and setup agents
    Write-Host "📂 Setting up agents..." -ForegroundColor Gray
    New-Item -ItemType Directory -Force -Path "$SkillDir\agents" | Out-Null
    Invoke-WebRequest -Uri "$RepoUrl/agents/openai.yaml" -OutFile "$SkillDir\agents\openai.yaml" -ErrorAction Stop
    
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
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
