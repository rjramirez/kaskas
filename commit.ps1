# Kill git
Write-Host "Killing git processes..." -ForegroundColor Cyan
Get-Process git -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

# Delete locks
Write-Host "Deleting lock files..." -ForegroundColor Cyan
Remove-Item .git\index.lock -Force -ErrorAction SilentlyContinue
Remove-Item .git\HEAD.lock -Force -ErrorAction SilentlyContinue

# Check status
Write-Host "Checking git status..." -ForegroundColor Cyan
git status

# Commit
Write-Host "Adding README.md..." -ForegroundColor Cyan
git add README.md

Write-Host "Committing..." -ForegroundColor Cyan
git commit -m "docs: add security section to README"

# Push
Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
git push origin main

Write-Host "Done!" -ForegroundColor Green
Read-Host "Press Enter to close"
