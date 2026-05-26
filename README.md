# 💰 kaskas

Financial memory for Claude. Analyze statements, track dues, find cashback. Local-only.

---

## Install

### Windows
```powershell
irm https://raw.githubusercontent.com/rjramirez/kaskas/main/install.ps1 | iex
```

### macOS / Linux
```bash
curl -fsSL https://raw.githubusercontent.com/rjramirez/kaskas/main/install.sh | bash
```

Restart Claude Desktop and Claude Code.

---

## Works in

| App | How |
|-----|-----|
| Claude Desktop (Windows Store) | MCP server — slash commands in chat |
| Claude Desktop (macOS / Linux) | MCP server — slash commands in chat |
| Claude Code CLI | Plugin — skills + slash commands |
| Claude Code Desktop | Plugin — skills + slash commands |

---

## Commands

| Command | What |
|---------|------|
| `/review` | Analyze credit card statements |
| `/due` | Upcoming payments (next 30 days) |
| `/subscriptions` | Find recurring charges |
| `/offers` | Best card for your spending |
| `/safe` | Utilization risk score |
| `/export` | Export data (JSON / CSV / Markdown) |
| `/ocr` | Extract text from receipts / screenshots |
| `/pdf` | Extract transactions from PDFs |
| `/promos` | Parse card promotional offers |
| `/memory` | SQLite persistent storage |
| `/embed` | Semantic search on transactions |
| `/insights` | Pattern analysis, anomaly detection |
| `/llm` | Local LLM analysis (no API calls) |
| `/remind` | Set payment reminders |
| `/forecast` | Spending forecasts + scenarios |

---

## Quick start

```
/review
[paste your credit card statement here]
```

---

## Install location

| Platform | Path |
|----------|------|
| Windows | `%APPDATA%\Claude\kaskas` |
| macOS | `~/Library/Application Support/Claude/kaskas` |
| Linux | `~/.config/Claude/kaskas` |

---

## Uninstall

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall
```
```bash
# macOS / Linux
bash install.sh --uninstall
```

---

## Privacy

- Local-only — no external API calls
- Data stays on your machine
- Export anytime, no lock-in

---

MIT License
