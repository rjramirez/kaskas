#!/usr/bin/env bash
# kaskas — one-command installer for macOS / Linux
# Installs kaskas for Claude Desktop (MCP) + Claude Code (plugin)
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/rjramirez/kaskas/main/install.sh | bash
#
# Or local:
#   bash install.sh [--force] [--uninstall] [--desktop-only] [--code-only]

set -euo pipefail

REPO_URL="https://raw.githubusercontent.com/rjramirez/kaskas/main"
REPO_ID="rjramirez/kaskas"
PLUGIN_NAME="kaskas"

# ── Paths ──────────────────────────────────────────────────────────────────────
if [[ "$OSTYPE" == "darwin"* ]]; then
  CLAUDE_DESKTOP_DIR="$HOME/Library/Application Support/Claude"
else
  CLAUDE_DESKTOP_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/Claude"
fi

SKILL_DIR="$CLAUDE_DESKTOP_DIR/kaskas"
DESKTOP_CONFIG="$CLAUDE_DESKTOP_DIR/claude_desktop_config.json"
CODE_SETTINGS="$HOME/.claude/settings.json"

# ── Flags ──────────────────────────────────────────────────────────────────────
FORCE=false UNINSTALL=false DESKTOP_ONLY=false CODE_ONLY=false
for arg in "$@"; do
  case "$arg" in
    --force)        FORCE=true ;;
    --uninstall)    UNINSTALL=true ;;
    --desktop-only) DESKTOP_ONLY=true ;;
    --code-only)    CODE_ONLY=true ;;
  esac
done

# ── Uninstall ──────────────────────────────────────────────────────────────────
if [ "$UNINSTALL" = true ]; then
  [ -d "$SKILL_DIR" ] && rm -rf "$SKILL_DIR" && echo "Removed: $SKILL_DIR"
  if [ -f "$DESKTOP_CONFIG" ] && command -v node &>/dev/null; then
    node -e "
      const fs=require('fs'), p=process.env.DC;
      try {
        const c=JSON.parse(fs.readFileSync(p,'utf8'));
        if(c.mcpServers&&c.mcpServers.kaskas){
          delete c.mcpServers.kaskas;
          if(!Object.keys(c.mcpServers).length) delete c.mcpServers;
          fs.writeFileSync(p,JSON.stringify(c,null,2)+'\n');
          console.log('Removed from claude_desktop_config.json');
        }
      }catch(e){}
    " DC="$DESKTOP_CONFIG" 2>/dev/null || true
  fi
  if [ -f "$CODE_SETTINGS" ] && command -v node &>/dev/null; then
    node -e "
      const fs=require('fs'), p=process.env.CS;
      try {
        const s=JSON.parse(fs.readFileSync(p,'utf8'));
        if(s.extraKnownMarketplaces) delete s.extraKnownMarketplaces.kaskas;
        if(s.enabledPlugins) delete s.enabledPlugins['kaskas@kaskas'];
        fs.writeFileSync(p,JSON.stringify(s,null,2)+'\n');
        console.log('Removed from Claude Code settings');
      }catch(e){}
    " CS="$CODE_SETTINGS" 2>/dev/null || true
  fi
  echo ""; echo "Uninstalled. Restart Claude Desktop and Claude Code."
  exit 0
fi

# ── Pre-checks ─────────────────────────────────────────────────────────────────
if ! command -v node &>/dev/null; then
  echo ""; echo "ERROR: Node.js not found." >&2
  echo "       Install from https://nodejs.org (LTS) then re-run." >&2
  echo ""; exit 1
fi
echo "Node.js $(node --version)"

# ── Already installed? ─────────────────────────────────────────────────────────
if [ "$FORCE" = false ] && [ -f "$SKILL_DIR/mcp-server.js" ]; then
  WIRED=false
  if [ -f "$DESKTOP_CONFIG" ]; then
    WIRED=$(node -e "
      try{ const c=JSON.parse(require('fs').readFileSync(process.env.DC,'utf8'));
           console.log(!!(c.mcpServers&&c.mcpServers.kaskas)); }
      catch(e){ console.log(false); }
    " DC="$DESKTOP_CONFIG" 2>/dev/null || echo "false")
  fi
  if [ "$WIRED" = "true" ]; then
    echo "kaskas already installed. Re-run with --force to overwrite."
    exit 0
  fi
fi

echo ""; echo "Installing kaskas..."

# ── Detect script source ───────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" || SCRIPT_DIR=""

dl() {
  local rel="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/$rel" ]; then
    cp "$SCRIPT_DIR/$rel" "$dest"
  else
    curl -fsSL "$REPO_URL/$rel" -o "$dest"
  fi
}

# ── 1. Install skill files ─────────────────────────────────────────────────────
mkdir -p "$SKILL_DIR"
echo "  Downloading files..."

for f in mcp-server.js manifest.json claude.json; do dl "$f" "$SKILL_DIR/$f"; done

for f in due.md embed.md export.md forecast.md insights.md llm.md memory.md \
          ocr.md offers.md pdf.md promos.md remind.md review.md safe.md subscriptions.md; do
  dl "commands/$f" "$SKILL_DIR/commands/$f"
done

for f in embedding-config.md forecast-config.md llm-config.md merchant-categories.md \
          ph-cards.md recurring-patterns.md utilization-rules.md; do
  dl "references/$f" "$SKILL_DIR/references/$f"
done

for f in obligations.md summary.md; do dl "templates/$f" "$SKILL_DIR/templates/$f"; done

for f in embedding.schema.json forecast.schema.json memory.schema.json obligation.schema.json \
          promo.schema.json reminder.schema.json transaction.schema.json; do
  dl "schemas/$f" "$SKILL_DIR/schemas/$f"
done

echo "  Installed: $SKILL_DIR"

# ── 2. Wire Claude Desktop MCP ─────────────────────────────────────────────────
if [ "$CODE_ONLY" = false ] && [ -d "$CLAUDE_DESKTOP_DIR" ]; then
  [ -f "$DESKTOP_CONFIG" ] && cp "$DESKTOP_CONFIG" "$DESKTOP_CONFIG.bak"
  [ -f "$DESKTOP_CONFIG" ] || echo '{}' > "$DESKTOP_CONFIG"

  SKILL_DIR_ESC="$SKILL_DIR" node -e "
    const fs=require('fs'), p=process.env.DC, sd=process.env.SKILL_DIR_ESC;
    let raw=(fs.readFileSync(p,'utf8')||'').trim()||'{}';
    let c; try{c=JSON.parse(raw);}catch(e){c={};}
    if(!c.mcpServers) c.mcpServers={};
    c.mcpServers.kaskas={command:'node', args:[sd+'/mcp-server.js']};
    fs.writeFileSync(p,JSON.stringify(c,null,2)+'\n');
    console.log('  Wired: claude_desktop_config.json (MCP server)');
  " DC="$DESKTOP_CONFIG"
fi

# ── 3. Register Claude Code plugin ────────────────────────────────────────────
if [ "$DESKTOP_ONLY" = false ] && [ -d "$(dirname "$CODE_SETTINGS")" ]; then
  [ -f "$CODE_SETTINGS" ] && cp "$CODE_SETTINGS" "$CODE_SETTINGS.bak"
  [ -f "$CODE_SETTINGS" ] || echo '{}' > "$CODE_SETTINGS"

  node -e "
    const fs=require('fs'), p=process.env.CS;
    let raw=(fs.readFileSync(p,'utf8')||'').trim()||'{}';
    let s; try{s=JSON.parse(raw);}catch(e){s={};}
    if(!s.extraKnownMarketplaces) s.extraKnownMarketplaces={};
    s.extraKnownMarketplaces.kaskas={source:{source:'github',repo:'rjramirez/kaskas'}};
    if(!s.enabledPlugins) s.enabledPlugins={};
    s['enabledPlugins']['kaskas@kaskas']=true;
    fs.writeFileSync(p,JSON.stringify(s,null,2)+'\n');
    console.log('  Wired: ~/.claude/settings.json (Claude Code plugin)');
  " CS="$CODE_SETTINGS"
fi

# ── Done ───────────────────────────────────────────────────────────────────────
echo ""
echo "Done! Restart Claude Desktop and Claude Code."
echo ""
echo "Claude Desktop — type in chat:"
echo "  /review        Analyze a statement"
echo "  /due           Upcoming payments"
echo "  /subscriptions Recurring charges"
echo "  /offers        Best card for your spend"
echo "  /safe          Risk score"
echo "  /export        Export data"
echo ""
echo "Claude Code — same commands available as skills."
echo ""
echo "Uninstall: bash install.sh --uninstall"
