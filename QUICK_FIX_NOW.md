# ⚡ QUICK FIX - Do This NOW

## The Problem
The installer wasn't downloading the **manifest files** that Claude Desktop needs to recognize Kaskas as a skill.

## The Solution (3 Steps)

### Step 1: Download Missing Manifest Files (2 minutes)

**Copy and paste this into PowerShell:**

```powershell
$skillPath = "$env:APPDATA\Claude\skills\kaskas"
$repoUrl = "https://raw.githubusercontent.com/rjramirez/kaskas/main"

Write-Host "📥 Downloading manifest files..." -ForegroundColor Cyan

# Download the critical files
Invoke-WebRequest -Uri "$repoUrl/claude.json" -OutFile "$skillPath\claude.json"
Write-Host "✓ Downloaded claude.json"

Invoke-WebRequest -Uri "$repoUrl/manifest.json" -OutFile "$skillPath\manifest.json"
Write-Host "✓ Downloaded manifest.json"

Invoke-WebRequest -Uri "$repoUrl/.clauderc" -OutFile "$skillPath\.clauderc"
Write-Host "✓ Downloaded .clauderc"

Write-Host ""
Write-Host "✅ All manifest files downloaded!" -ForegroundColor Green
```

### Step 2: Close Claude Desktop Completely (1 minute)

**Press `Ctrl + Shift + Esc`** to open Task Manager:
1. Find "Claude" in the list
2. Right-click → "End Task"
3. Wait 5 seconds
4. Close Task Manager

### Step 3: Restart Your PC (5 minutes)

**This is important!** Windows Store apps need a restart to recognize new files.

**Press `Win + X` → Restart** or:

```powershell
Restart-Computer
```

---

## After Restart

1. Open Claude Desktop
2. Wait 30-60 seconds for it to load
3. Look for **Kaskas** in the skills list
4. Try typing `/` to see the commands

---

## If It Still Doesn't Work

Run this to verify everything is installed:

```powershell
$skillPath = "$env:APPDATA\Claude\skills\kaskas"
Write-Host "Checking Kaskas installation..." -ForegroundColor Cyan
Write-Host ""

$requiredFiles = @(
    "claude.json",
    "manifest.json", 
    ".clauderc",
    "SKILL.md",
    "agents\openai.yaml",
    "commands\review.md",
    "commands\due.md",
    "commands\subscriptions.md",
    "commands\offers.md",
    "commands\safe.md",
    "commands\export.md"
)

$missing = @()
foreach ($file in $requiredFiles) {
    $fullPath = Join-Path $skillPath $file
    if (Test-Path $fullPath) {
        Write-Host "✓ $file"
    } else {
        Write-Host "✗ $file MISSING"
        $missing += $file
    }
}

Write-Host ""
if ($missing.Count -eq 0) {
    Write-Host "✅ All files present!" -ForegroundColor Green
} else {
    Write-Host "❌ Missing files: $($missing -join ', ')" -ForegroundColor Red
}
```

---

## What Changed

**Before:** Installer only downloaded content files (commands, references, etc.)  
**After:** Installer now downloads **manifest files** that Claude Desktop needs

The manifest files tell Claude Desktop:
- ✅ This is a skill called "Kaskas"
- ✅ It has 6 commands (/review, /due, etc.)
- ✅ Where to find the resources
- ✅ How to configure it

---

## Summary

| Step | Action | Time |
|------|--------|------|
| 1 | Download manifest files | 2 min |
| 2 | Close Claude Desktop | 1 min |
| 3 | Restart PC | 5 min |
| 4 | Reopen Claude Desktop | 1 min |
| **Total** | | **~9 minutes** |

---

**Do this now and Kaskas should appear! 🚀**

If you have any issues, check `TROUBLESHOOTING_CLAUDE_DESKTOP.md` for detailed help.
