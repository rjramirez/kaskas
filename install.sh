#!/usr/bin/env bash
# kaskas -- optimized installer for macOS / Linux
# Fast, safe, clean installation and uninstall

set -euo pipefail

# ── Config ─────────────────────────────────────────────────────────────────────
REPO_URL="https://cdn.jsdelivr.net/gh/rjramirez/kaskas@main"
REPO_URL_GITHUB="https://raw.githubusercontent.com/rjramirez/kaskas/main"
VERSION="4.0.0"

if [[ "$OSTYPE" == "darwin"* ]]; then
  CLAUDE_DIR="$HOME/Library/Application Support/Claude"
else
  CLAUDE_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/Claude"
fi

SKILL_DIR="$CLAUDE_DIR/kaskas"
DESKTOP_CONFIG="$CLAUDE_DIR/claude_desktop_config.json"
CODE_SETTINGS="$HOME/.claude/settings.json"
LOG_FILE="$SKILL_DIR/install.log"

# ── Parse args ─────────────────────────────────────────────────────────────────
FORCE=false UNINSTALL=false
for arg in "$@"; do
  case "$arg" in --force|--uninstall) eval "${arg#--}=true" ;; esac
done

IS_PIPE=! [ -t 0 ]

# ── Helpers ────────────────────────────────────────────────────────────────────
log()   { echo "  $1"; [ -d "$(dirname "$LOG_FILE")" ] && echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE" 2>/dev/null || true; }
err()   { echo "  ERROR: $1" >&2; exit 1; }
info()  { echo "  [OK] $1"; }
warn()  { echo "  [!] $1"; }

# ── Banner ─────────────────────────────────────────────────────────────────────
banner() {
  echo ""
  echo "  +-----------------------------------------------------------+"
  echo "  |  KASKAS - Financial Memory for Claude (v$VERSION)         |"
  echo "  |  Analyze statements | Track dues | Find cashback         |"
  echo "  |  Local-only | No external API calls | Your data stays    |"
  echo "  +-----------------------------------------------------------+"
  echo ""
}

# ── Update config (JSON) ───────────────────────────────────────────────────────
update_config() {
  local config="$1" action="$2"

  if [ ! -f "$config" ]; then
    [ "$action" = "add" ] && echo '{}' > "$config" || return 0
  fi

  node -e "
    const fs=require('fs'), p=process.env.C, a=process.env.A, sd=process.env.SD;
    let c=JSON.parse(fs.readFileSync(p,'utf8')||'{}');
    let changed=false;

    if(a==='add-desktop') {
      if(!c.mcpServers) c.mcpServers={};
      c.mcpServers.kaskas={command:'node',args:[sd+'/mcp-server.js']};
    } else if(a==='remove-desktop' && c.mcpServers) {
      delete c.mcpServers.kaskas;
      if(!Object.keys(c.mcpServers).length) delete c.mcpServers;
    } else if(a==='remove-code') {
      if(c.enabledPlugins?.['kaskas@kaskas']) { delete c.enabledPlugins['kaskas@kaskas']; changed=true; }
      if(c.extraKnownMarketplaces?.kaskas) { delete c.extraKnownMarketplaces.kaskas; changed=true; }
    }

    if(changed) {
      fs.writeFileSync(p,JSON.stringify(c,null,2)+'\n');
    }
    console.log('OK');
  " C="$config" A="$action" SD="$SKILL_DIR" 2>/dev/null || return 1
}

# ── Uninstall ──────────────────────────────────────────────────────────────────
uninstall() {
  log "Uninstalling kaskas..."
  echo ""

  # Backup config
  [ -f "$DESKTOP_CONFIG" ] && cp "$DESKTOP_CONFIG" "$DESKTOP_CONFIG.bak" && log "Backup: $DESKTOP_CONFIG.bak"

  # Remove from configs
  update_config "$DESKTOP_CONFIG" "remove-desktop" && info "Removed from claude_desktop_config.json" || warn "Could not update desktop config"
  update_config "$CODE_SETTINGS" "remove-code" && info "Removed from settings.json" || true

  # Ask about data
  KEEP_DATA=false
  if [ -d "$SKILL_DIR/data" ] && ! $IS_PIPE; then
    echo ""
    printf "  Keep your financial data? [Y/n]: "
    read -r ans || ans=""
    [[ ! "$ans" =~ ^[Nn] ]] && KEEP_DATA=true
  fi

  # Remove skill dir
  if [ -d "$SKILL_DIR" ]; then
    if $KEEP_DATA; then
      find "$SKILL_DIR" -mindepth 1 -maxdepth 1 ! -name "data" -exec rm -rf {} + 2>/dev/null || true
      info "Removed skill files (data kept)"
    else
      rm -rf "$SKILL_DIR"
      info "Removed: $SKILL_DIR"
    fi
  fi

  echo ""
  log "Uninstalled. Restart Claude Desktop."
  echo ""
}

# ── Pre-checks ─────────────────────────────────────────────────────────────────
check_node() {
  command -v node &>/dev/null || err "Node.js not found. Install from https://nodejs.org (LTS)"
  log "Node.js $(node --version)"
}

# ── Already installed? ─────────────────────────────────────────────────────────
check_installed() {
  [ "$FORCE" = true ] && return 0
  [ ! -f "$SKILL_DIR/mcp-server.js" ] && return 0

  WIRED=$(node -e "try{const c=JSON.parse(require('fs').readFileSync(process.env.DC,'utf8'));console.log(!!(c.mcpServers?.kaskas));}catch(e){console.log(false);}" DC="$DESKTOP_CONFIG" 2>/dev/null || echo "false")

  [ "$WIRED" != "true" ] && return 0

  echo ""
  echo "  kaskas is already installed."
  echo "  [1] Update / Reinstall  [2] Uninstall  [3] Cancel"
  echo ""
  printf "  Choice: "
  read -r choice || choice=""
  case "$choice" in
    1) FORCE=true ;;
    2) uninstall; exit 0 ;;
    *) echo "  Cancelled."; echo ""; exit 0 ;;
  esac
}

# ── File list ──────────────────────────────────────────────────────────────────
FILES=(
  "mcp-server.js:." "manifest.json:." "claude.json:."
  "due.md:commands" "embed.md:commands" "export.md:commands" "forecast.md:commands"
  "insights.md:commands" "llm.md:commands" "memory.md:commands" "ocr.md:commands"
  "offers.md:commands" "pdf.md:commands" "promos.md:commands" "remind.md:commands"
  "review.md:commands" "safe.md:commands" "subscriptions.md:commands"
  "embedding-config.md:references" "forecast-config.md:references" "llm-config.md:references"
  "merchant-categories.md:references" "ph-cards.md:references" "recurring-patterns.md:references"
  "utilization-rules.md:references"
  "obligations.md:templates" "summary.md:templates"
  "embedding.schema.json:schemas" "forecast.schema.json:schemas" "memory.schema.json:schemas"
  "obligation.schema.json:schemas" "promo.schema.json:schemas" "reminder.schema.json:schemas"
  "transaction.schema.json:schemas"
)

# ── Download with retry (multiple sources) ────────────────────────────────────
download_file() {
  local file="$1" dest="$2"
  # Try jsDelivr first (works for public repos), then GitHub API (works for private repos)
  local urls=(
    "$REPO_URL/$file"
    "https://api.github.com/repos/rjramirez/kaskas/contents/$file?ref=main"
  )

  for url in "${urls[@]}"; do
    local retries=2 delay=1
    while [ $retries -gt 0 ]; do
      echo "    Trying: $url" >&2

      # If GitHub API, extract content and decode base64
      if [[ "$url" == *"api.github.com"* ]]; then
        if curl -fsSL "$url" 2>/dev/null | grep -q '"content"'; then
          curl -fsSL "$url" 2>/dev/null | grep '"content"' | sed 's/.*"content": "\(.*\)".*/\1/' | base64 -d > "$dest" 2>/dev/null && {
            echo "    ✓ Success: $file" >&2
            return 0
          }
        fi
      else
        # Standard download for jsDelivr
        if curl -fsSL "$url" -o "$dest" 2>/dev/null; then
          echo "    ✓ Success: $file" >&2
          return 0
        fi
      fi

      retries=$((retries - 1))
      if [ $retries -gt 0 ]; then
        echo "    ✗ Failed, retrying... ($retries left)" >&2
        sleep $delay
        delay=$((delay * 2))
      else
        echo "    ✗ Failed: $url" >&2
      fi
    done
  done

  return 1
}

# ── Install ────────────────────────────────────────────────────────────────────
install() {
  log "Installing kaskas..."

  # Backup if updating
  if [ "$FORCE" = true ] && [ -d "$SKILL_DIR" ]; then
    BACKUP_DIR="$SKILL_DIR.backup.$(date +%s)"
    cp -r "$SKILL_DIR" "$BACKUP_DIR"
    log "Backup: $BACKUP_DIR"
  fi

  # Create temp dir
  TEMP_DIR=$(mktemp -d)
  trap "rm -rf $TEMP_DIR" EXIT

  # Download files
  FAILED=0
  FAILED_FILES=()
  for entry in "${FILES[@]}"; do
    IFS=: read -r file dir <<< "$entry"
    mkdir -p "$TEMP_DIR/$dir"

    FULL_PATH="$dir/$file"
    if download_file "$FULL_PATH" "$TEMP_DIR/$dir/$file"; then
      echo -ne "\r  Downloaded: ${#FILES[@]} files"
    else
      echo ""
      warn "Failed to download $FULL_PATH (after 3 retries)"
      FAILED_FILES+=("$FULL_PATH")
      FAILED=$((FAILED + 1))
    fi
  done
  echo ""

  if [ $FAILED -gt 0 ]; then
    echo ""
    warn "Failed files:"
    for f in "${FAILED_FILES[@]}"; do
      echo "  - $f"
    done
    err "Failed to download $FAILED file(s). Check network and try again."
  fi

  # Verify count
  ACTUAL=$(find "$TEMP_DIR" -type f | wc -l)
  [ $ACTUAL -ne ${#FILES[@]} ] && err "Incomplete download: $ACTUAL/${#FILES[@]} files"
  info "Verified: $ACTUAL/${#FILES[@]} files"

  # Validate JSON
  for json in "$TEMP_DIR"/*.json "$TEMP_DIR"/schemas/*.json; do
    [ -f "$json" ] && ! node -e "JSON.parse(require('fs').readFileSync(process.env.F,'utf8'))" F="$json" 2>/dev/null && err "Invalid JSON: $(basename "$json")"
  done
  info "Validated: JSON syntax OK"

  # Move to final location
  rm -rf "$SKILL_DIR"
  mv "$TEMP_DIR" "$SKILL_DIR"
  info "Installed: $SKILL_DIR"

  # Wire Claude Desktop
  if [ -d "$CLAUDE_DIR" ]; then
    [ -f "$DESKTOP_CONFIG" ] && cp "$DESKTOP_CONFIG" "$DESKTOP_CONFIG.bak"
    [ -f "$DESKTOP_CONFIG" ] || echo '{}' > "$DESKTOP_CONFIG"

    update_config "$DESKTOP_CONFIG" "add-desktop" && info "Wired: claude_desktop_config.json" || err "Could not wire config"
  fi

  # Health check
  if timeout 2 node "$SKILL_DIR/mcp-server.js" <<< '{"jsonrpc":"2.0","id":1,"method":"initialize"}' 2>/dev/null | grep -q "kaskas"; then
    inf