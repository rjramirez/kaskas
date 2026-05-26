#!/usr/bin/env bash

set -e

SKILL_DIR="$HOME/Library/Application Support/Claude/skills/kaskas"
REPO_URL="https://raw.githubusercontent.com/rjramirez/kaskas/main"
TEMP_DIR=$(mktemp -d)

echo "🚀 Installing Kaskas..."
echo ""

# Cleanup on exit
cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Create skill directory
mkdir -p "$SKILL_DIR"

# Function to download file
download_file() {
    local url=$1
    local out_path=$2
    local filename=$(basename "$out_path")
    
    echo "  📥 Downloading $filename..."
    if ! curl -fsSL "$url" -o "$out_path"; then
        echo "  ❌ Failed to download $url"
        exit 1
    fi
}

# Function to download directory files
download_directory() {
    local dir_name=$1
    local files=()
    
    case "$dir_name" in
        "commands")
            files=("due.md" "export.md" "offers.md" "review.md" "safe.md" "subscriptions.md")
            ;;
        "references")
            files=("merchant-categories.md" "ph-cards.md" "recurring-patterns.md" "utilization-rules.md")
            ;;
        "templates")
            files=("obligations.md" "summary.md")
            ;;
        "schemas")
            files=("obligation.schema.json" "promo.schema.json" "transaction.schema.json")
            ;;
        "agents")
            files=("openai.yaml")
            ;;
    esac
    
    echo "  📂 Setting up $dir_name..."
    mkdir -p "$SKILL_DIR/$dir_name"
    
    for file in "${files[@]}"; do
        local url="$REPO_URL/$dir_name/$file"
        local out_path="$SKILL_DIR/$dir_name/$file"
        download_file "$url" "$out_path"
    done
}

# Download manifest files (CRITICAL for Claude Desktop)
echo "📥 Downloading manifest files..."
manifest_files=("claude.json" "manifest.json" ".clauderc" "SKILL.md")
for file in "${manifest_files[@]}"; do
    download_file "$REPO_URL/$file" "$SKILL_DIR/$file"
done

echo ""

# Download directories
for dir in commands references templates schemas agents; do
    download_directory "$dir"
done

echo ""
echo "✅ Kaskas installed successfully!"
echo ""
echo "📍 Location: $SKILL_DIR"
echo ""
echo "⚡ Next steps:"
echo "  1. Restart Claude Desktop"
echo "  2. Try using /review, /due, /subscriptions, /offers, /safe, /export"
echo ""
