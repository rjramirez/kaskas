#!/usr/bin/env bash

set -e

SKILL_DIR="$HOME/Library/Application Support/Claude/skills/kaskas"

echo "Installing Kaskas..."

mkdir -p "$SKILL_DIR"

cp SKILL.md "$SKILL_DIR"
cp -R commands "$SKILL_DIR"
cp -R references "$SKILL_DIR"
cp -R templates "$SKILL_DIR"
cp -R schemas "$SKILL_DIR"
cp -R agents "$SKILL_DIR"

echo ""
echo "Kaskas installed successfully."
echo "Restart Claude Desktop."
