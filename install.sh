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
# Uses jq if available; falls back to node (same dep as the MCP server itself)
update_config() {
  local config="$1" action="$2"

  if [ ! -f "$config" ]; then
    [ "$action" = "add-desktop" ] && echo '{}' > "$config" || return 0
  fi

  if command -v jq &>/dev/null; then
    case "$action" in
      add-desktop)
        jq --arg sd "$SKILL_DIR" \
          '.mcpServers.kaskas = {command: "node", args: [$sd + "/mcp-server.js"]}' \
          "$config" > "$config.tmp" && mv "$config.tmp" "$config"
        ;;
      remove-desktop)
        jq 'del(.mcpServers.kaskas) | if (.mcpServers | length) == 0 then del(.mcpServers) else . end' \
          "$config" > "$config.tmp" && mv "$config.tmp" "$config"
        ;;
      remove-code)
        jq 'del(.enabledPlugins["kaskas@kaskas"]) | del(.extraKnownMarketplaces.kaskas)' \
          "$config" > "$config.tmp" && mv "$config.tmp" "$config"
        ;;
    esac
    return 0
  elif command -v node &>/dev/null; then
    # Node.js fallback — writes UTF-8 no BOM
    node -e "
      const fs=require('fs'), p=process.env.CFG, sd=process.env.SD, action=process.env.ACTION;
      let c; try{c=JSON.parse(fs.readFileSync(p,'utf8'));}catch(e){c={};}
      if(action==='add-desktop'){
        if(!c.mcpServers) c.mcpServers={};
        c.mcpServers.kaskas={command:'node',args:[sd+'/mcp-server.js']};
      } else if(action==='remove-desktop'){
        if(c.mcpServers) delete c.mcpServers.kaskas;
        if(c.mcpServers&&!Object.keys(c.mcpServers).length) delete c.mcpServers;
      } else if(action==='remove-code'){
        if(c.enabledPlugins) delete c.enabledPlugins['kaskas@kaskas'];
        if(c.extraKnownMarketplaces) delete c.extraKnownMarketplaces.kaskas;
      }
      fs.writeFileSync(p,JSON.stringify(c,null,2)+'\n',{encoding:'utf8'});
    " CFG="$config" SD="$SKILL_DIR" ACTION="$action" 2>/dev/null
    return $?
  else
    return 1
  fi
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

# ── Download file silently ─────────────────────────────────────────────────────
download_file() {
  local file="$1" dest="$2"
  local urls=(
    "$REPO_URL/$file"
    "https://api.github.com/repos/rjramirez/kaskas/contents/$file?ref=main"
  )

  for url in "${urls[@]}"; do
    local retries=2 delay=1
    while [ $retries -gt 0 ]; do
      if [[ "$url" == *"api.github.com"* ]]; then
        if curl -fsSL "$url" 2>/dev/null | grep -q '"content"'; then
          curl -fsSL "$url" 2>/dev/null | grep '"content"' | sed 's/.*"content": "\(.*\)".*/\1/' | base64 -d > "$dest" 2>/dev/null && return 0
        fi
      else
        curl -fsSL "$url" -o "$dest" 2>/dev/null && return 0
      fi
      retries=$((retries - 1))
      [ $retries -gt 0 ] && sleep $delay && delay=$((delay * 2))
    done
  done
  return 1
}

# ── Progress bar helper ────────────────────────────────────────────────────────
show_progress() {
  local percent=$1
  local bar_width=30
  local filled=$((bar_width * percent / 100))
  local empty=$((bar_width - filled))
  local bar=$(printf "%${filled}s" | tr ' ' '=')$(printf "%${empty}s" | tr ' ' '-')
  printf "\r  Downloading: [%s] %d%%" "$bar" "$percent"
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
  COUNT=0
  TOTAL=${#FILES[@]}
  FAILED_FILES=()
  
  show_progress 0
  
  for entry in "${FILES[@]}"; do
    IFS=: read -r file dir <<< "$entry"
    mkdir -p "$TEMP_DIR/$dir"

    FULL_PATH="$dir/$file"
    if download_file "$FULL_PATH" "$TEMP_DIR/$dir/$file"; then
      COUNT=$((COUNT + 1))
    else
      FAILED_FILES+=("$FULL_PATH")
      FAILED=$((FAILED + 1))
    fi
    
    PERCENT=$(( (COUNT + FAILED) * 100 / TOTAL ))
    show_progress $PERCENT
  done
  echo ""

  if [ $FAILED -gt 0 ]; then
    echo ""
    warn "Some files failed to download. Check network and try again."
    err "Installation failed."
  fi

  # Verify
  ACTUAL=$(find "$TEMP_DIR" -type f | wc -l)
  [ $ACTUAL -ne ${#FILES[@]} ] && err "Incomplete download. Please try again."
  info "Download complete"

  # Validate JSON
  for json in "$TEMP_DIR"/*.json "$TEMP_DIR"/schemas/*.json; do
    [ -f "$json" ] && ! node -e "JSON.parse(require('fs').readFileSync(process.env.F,'utf8'))" F="$json" 2>/dev/null && err "Invalid JSON: $(basename "$json")"
  done
  info "Validated"

  # Move to final location
  rm -rf "$SKILL_DIR"
  mv "$TEMP_DIR" "$SKILL_DIR"
  info "Installed"

  # Wire Claude Desktop
  if [ -d "$CLAUDE_DIR" ]; then
    [ -f "$DESKTOP_CONFIG" ] && cp "$DESKTOP_CONFIG" "$DESKTOP_CONFIG.bak"
    [ -f "$DESKTOP_CONFIG" ] || echo '{}' > "$DESKTOP_CONFIG"

    update_config "$DESKTOP_CONFIG" "add-desktop" && info "Configured" || err "Could not wire config"
  fi

  # Health check
  if timeout 2 node "$SKILL_DIR/mcp-server.js" <<< '{"jsonrpc":"2.0","id":1,"method":"initialize"}' 2>/dev/null | grep -q "kaskas"; then
    info "Ready"
  else
    warn "Health check failed (non-critical)"
  fi

  echo ""
  info "Installation complete!"
  echo ""
  echo "  Next steps:"
  echo "  1. Restart Claude Desktop"
  echo "  2. Try: /due, /insights, /review, /forecast"
  echo ""
}

# ── Main ───────────────────────────────────────────────────────────────────────
banner

if [ "$UNINSTALL" = true ]; then
  uninstall
  exit 0
fi

check_node
check_installed
install