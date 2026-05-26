# 🔧 Kaskas - Claude Desktop Troubleshooting Guide

## Problem: Skill Not Appearing in Claude Desktop

### ✅ Solution Steps (In Order)

---

## Step 1: Verify Files Are Installed

Check that all required files exist in the skill directory:

**Windows:**
```powershell
$skillPath = "$env:APPDATA\Claude\skills\kaskas"
ls -Recurse $skillPath
```

**Expected files:**
- ✅ `claude.json` (CRITICAL - manifest file)
- ✅ `manifest.json` (CRITICAL - alternative manifest)
- ✅ `.clauderc` (CRITICAL - configuration)
- ✅ `SKILL.md`
- ✅ `agents/openai.yaml`
- ✅ `commands/` (6 files)
- ✅ `references/` (4 files)
- ✅ `templates/` (2 files)
- ✅ `schemas/` (3 files)

**If missing manifest files**, download them manually:

```powershell
$skillPath = "$env:APPDATA\Claude\skills\kaskas"
$repoUrl = "https://raw.githubusercontent.com/rjramirez/kaskas/main"

# Download manifest files
Invoke-WebRequest -Uri "$repoUrl/claude.json" -OutFile "$skillPath\claude.json"
Invoke-WebRequest -Uri "$repoUrl/manifest.json" -OutFile "$skillPath\manifest.json"
Invoke-WebRequest -Uri "$repoUrl/.clauderc" -OutFile "$skillPath\.clauderc"
```

---

## Step 2: Fully Close Claude Desktop

**Important:** Don't just close the window - fully terminate the process.

### Windows 11 (Windows Store Version)

**Option A: Using Task Manager**
1. Press `Ctrl + Shift + Esc` to open Task Manager
2. Find "Claude" in the process list
3. Right-click → "End Task"
4. Wait 5 seconds
5. Verify it's closed (no Claude process should appear)

**Option B: Using PowerShell**
```powershell
# Kill all Claude processes
Get-Process | Where-Object { $_.ProcessName -like "*Claude*" } | Stop-Process -Force

# Wait a moment
Start-Sleep -Seconds 3

# Verify it's closed
Get-Process | Where-Object { $_.ProcessName -like "*Claude*" }
```

---

## Step 3: Clear Claude Desktop Cache

Claude Desktop caches skill information. Clear it:

```powershell
# Close Claude Desktop first (see Step 2)

# Clear the cache directory
$cacheDir = "$env:APPDATA\Claude\cache"
if (Test-Path $cacheDir) {
    Remove-Item -Path $cacheDir -Recurse -Force
    Write-Host "✓ Cache cleared"
} else {
    Write-Host "Cache directory not found (that's OK)"
}

# Also clear temp files
$tempDir = "$env:APPDATA\Claude\temp"
if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force
    Write-Host "✓ Temp files cleared"
}
```

---

## Step 4: Restart Your PC

**This is important!** Windows Store apps sometimes need a full system restart to recognize new files.

```powershell
# Restart your PC
Restart-Computer
```

Or manually: **Start Menu → Power → Restart**

---

## Step 5: Reopen Claude Desktop

After restart:
1. Open Claude Desktop from Windows Start Menu
2. Wait for it to fully load (30-60 seconds)
3. Check if Kaskas appears in the skills list

---

## Step 6: Verify Skill Detection

Once Claude Desktop is open, check the skill settings:

1. Click the **Settings** icon (⚙️) in Claude Desktop
2. Look for **"Skills"** or **"Installed Skills"** section
3. You should see **"Kaskas"** listed with:
   - Icon: 💰
   - Name: Kaskas
   - Description: Financial memory workflow

---

## Step 7: Test the Skill

If Kaskas appears:

1. Start a new conversation
2. Type `/` to see available commands
3. You should see:
   - `/review`
   - `/due`
   - `/subscriptions`
   - `/offers`
   - `/safe`
   - `/export`

4. Try: `/review` and see if it works

---

## 🆘 Still Not Working?

### Check Claude Desktop Logs

Windows Store version logs are in:
```
%APPDATA%\Claude\logs
```

Look for error messages related to "kaskas" or "skills"

### Verify Manifest File Format

Check that `claude.json` is valid JSON:

```powershell
$skillPath = "$env:APPDATA\Claude\skills\kaskas"
$json = Get-Content "$skillPath\claude.json" -Raw
try {
    $parsed = $json | ConvertFrom-Json
    Write-Host "✓ claude.json is valid JSON"
    Write-Host "Skill name: $($parsed.name)"
    Write-Host "Commands: $($parsed.commands.Count)"
} catch {
    Write-Host "✗ claude.json is INVALID: $_"
}
```

### Check File Permissions

Ensure Claude Desktop can read the files:

```powershell
$skillPath = "$env:APPDATA\Claude\skills\kaskas"
icacls $skillPath /grant:r "$env:USERNAME`:F" /T
Write-Host "✓ Permissions updated"
```

### Try Manual Installation

If automated installer failed:

1. Clone the repository:
```bash
git clone https://github.com/rjramirez/kaskas.git
```

2. Copy entire folder to:
```
%APPDATA%\Claude\skills\kaskas
```

3. Restart Claude Desktop

---

## 📋 Complete Troubleshooting Checklist

- [ ] All files exist in `%APPDATA%\Claude\skills\kaskas`
- [ ] `claude.json` exists and is valid JSON
- [ ] `manifest.json` exists
- [ ] `.clauderc` exists
- [ ] `SKILL.md` exists
- [ ] `agents/openai.yaml` exists
- [ ] All subdirectories exist (commands, references, templates, schemas)
- [ ] Claude Desktop is fully closed (no process in Task Manager)
- [ ] Cache cleared (`%APPDATA%\Claude\cache`)
- [ ] PC restarted
- [ ] Claude Desktop reopened
- [ ] Skill appears in settings
- [ ] Commands appear when typing `/`

---

## 🎯 Quick Fix Summary

If Kaskas still isn't showing after installation:

1. **Download manifest files** (if missing):
```powershell
$skillPath = "$env:APPDATA\Claude\skills\kaskas"
$repoUrl = "https://raw.githubusercontent.com/rjramirez/kaskas/main"
Invoke-WebRequest -Uri "$repoUrl/claude.json" -OutFile "$skillPath\claude.json"
Invoke-WebRequest -Uri "$repoUrl/manifest.json" -OutFile "$skillPath\manifest.json"
Invoke-WebRequest -Uri "$repoUrl/.clauderc" -OutFile "$skillPath\.clauderc"
```

2. **Close Claude Desktop completely** (Task Manager → End Task)

3. **Clear cache**:
```powershell
Remove-Item -Path "$env:APPDATA\Claude\cache" -Recurse -Force -ErrorAction SilentlyContinue
```

4. **Restart your PC**

5. **Reopen Claude Desktop**

---

## 📞 Still Need Help?

If none of these steps work:

1. **Check GitHub Issues**: https://github.com/rjramirez/kaskas/issues
2. **Report the issue** with:
   - Windows version
   - Claude Desktop version
   - Output from file verification commands
   - Any error messages from logs

---

## 🔍 Advanced Debugging

### Check if Claude Desktop recognizes the skill directory

```powershell
$skillPath = "$env:APPDATA\Claude\skills\kaskas"
$claudeJson = "$skillPath\claude.json"

Write-Host "Skill path: $skillPath"
Write-Host "Exists: $(Test-Path $skillPath)"
Write-Host ""
Write-Host "claude.json path: $claudeJson"
Write-Host "Exists: $(Test-Path $claudeJson)"
Write-Host ""

if (Test-Path $claudeJson) {
    $content = Get-Content $claudeJson -Raw
    Write-Host "File size: $($content.Length) bytes"
    Write-Host "First 200 chars:"
    Write-Host $content.Substring(0, [Math]::Min(200, $content.Length))
}
```

### Monitor Claude Desktop startup

```powershell
# Watch for Claude Desktop process
Get-Process | Where-Object { $_.ProcessName -like "*Claude*" } | Select-Object ProcessName, Id, StartTime
```

---

## ✅ Success Indicators

You'll know it's working when:

1. ✅ Kaskas appears in Claude Desktop settings
2. ✅ You can type `/` and see Kaskas commands
3. ✅ `/review` command is available
4. ✅ You can use the skill in conversations

---

**Made with ❤️ for people who care about their financial privacy**
