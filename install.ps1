$SkillDir = "$env:APPDATA\Claude\skills\kaskas"

Write-Host "Installing Kaskas..."

New-Item -ItemType Directory -Force -Path $SkillDir | Out-Null

Copy-Item -Path "$PSScriptRoot\SKILL.md" -Destination $SkillDir -Force
Copy-Item -Path "$PSScriptRoot\commands" -Destination $SkillDir -Recurse -Force
Copy-Item -Path "$PSScriptRoot\references" -Destination $SkillDir -Recurse -Force
Copy-Item -Path "$PSScriptRoot\templates" -Destination $SkillDir -Recurse -Force
Copy-Item -Path "$PSScriptRoot\schemas" -Destination $SkillDir -Recurse -Force
Copy-Item -Path "$PSScriptRoot\agents" -Destination $SkillDir -Recurse -Force

Write-Host ""
Write-Host "Kaskas installed successfully."
Write-Host "Restart Claude Desktop."
