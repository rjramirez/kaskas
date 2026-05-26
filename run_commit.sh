#!/bin/bash
cd /sessions/exciting-optimistic-fermi/mnt/kaskas

echo "Killing git processes..."
pkill -9 git 2>/dev/null || true
sleep 2

echo "Deleting lock files..."
rm -f .git/index.lock .git/HEAD.lock .git/objects/maintenance.lock 2>/dev/null || true

echo "Checking git status..."
git status

echo ""
echo "Adding README.md..."
git add README.md

echo "Committing..."
git commit -m "docs: add security section to README"

echo "Pushing to GitHub..."
git push origin main

echo "Done!"
