---
layout: default
title: User Guide - Kaskas
---

# Kaskas User Guide

**Financial memory for Claude. Analyze statements, track dues, find cashback. Local-only.**

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Installation](#installation)
3. [Available Commands](#available-commands)
4. [Basic Usage](#basic-usage)
5. [Advanced Workflows](#advanced-workflows)
6. [Real-World Scenarios](#real-world-scenarios)
7. [How It Works](#how-it-works)
8. [Extending Kaskas](#extending-kaskas)
9. [Security & Privacy](#security--privacy)
10. [Troubleshooting](#troubleshooting)
11. [Future Roadmap](#future-roadmap)

---

## Quick Start

### Installation

**Windows:**
```powershell
irm https://raw.githubusercontent.com/rjramirez/kaskas/main/install.ps1 | iex
```

**macOS/Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/rjramirez/kaskas/main/install.sh | bash
```

Then **restart Claude Desktop**.

### First Use

1. Open Claude Desktop Chat
2. Type: `/review`
3. Paste your credit card statement (CSV or text)
4. Get tables, patterns, and recommendations

---

## Installation

### Supported Platforms

| Platform | Integration Type | Status |
|----------|------------------|--------|
| Claude Desktop (Windows) | MCP Server | ✅ Active |
| Claude Desktop (macOS/Linux) | MCP Server | ✅ Active |
| Claude Code CLI | Plugin + Skills | ✅ Active |
| Claude Code Desktop | Plugin + Skills | ✅ Active |

### Installation Paths

| Platform | Path |
|----------|------|
| **Windows** | `%APPDATA%\Claude\kaskas` |
| **macOS** | `~/Library/Application Support/Claude/kaskas` |
| **Linux** | `~/.config/Claude/kaskas` |

---

## Available Commands

### Core Financial Analysis

| Command | Purpose | Input | Output |
|---------|---------|-------|--------|
| `/review` | Analyze credit card statements | Statement text/CSV | Transaction table + patterns |
| `/due` | Track upcoming payments (30 days) | Transaction history | Obligations + due dates |
| `/subscriptions` | Detect recurring charges | Transaction list | Subscriptions + confidence |
| `/offers` | Find best card for spending | Spending patterns | Card recommendations |
| `/safe` | Utilization risk score (0-100) | Limits + balances | Risk score + threshold |

### Data Management

| Command | Purpose |
|---------|---------|
| `/export` | Export as JSON/CSV/Markdown |
| `/memory` | SQLite persistent storage |
| `/embed` | Semantic search on transactions |

### Advanced Analysis

| Command | Purpose |
|---------|---------|
| `/ocr` | Extract text from receipts/screenshots |
| `/pdf` | Extract transactions from PDFs |
| `/promos` | Parse card promotional offers |
| `/insights` | Pattern analysis & anomaly detection |
| `/llm` | Local LLM analysis (no API calls) |
| `/remind` | Set payment reminders |
| `/forecast` | Spending forecasts & scenarios |
| `/reset` | Clear test data or load samples |

---

## Basic Usage

### Analyze a Credit Card Statement

```
User: /review
[Paste credit card statement]

Output:
| Merchant | Amount | Category | Frequency |
|----------|--------|----------|-----------|
| Jollibee | ₱450 | Food | Weekly |
| Meralco | ₱2,500 | Utilities | Monthly |
| Netflix | ₱549 | Entertainment | Monthly |
```

### Track Upcoming Dues

```
User: /due

Output:
| Obligation | Amount | Due Date | Risk |
|-----------|--------|----------|------|
| Credit Card | ₱15,000 | 2026-06-15 | 🔴 High |
| Internet | ₱1,500 | 2026-06-01 | 🟢 Low |
```

### Find Subscriptions

```
User: /subscriptions

Output:
| Service | Amount | Interval | Confidence |
|---------|--------|----------|------------|
| Netflix | ₱549 | Monthly | 95% |
| Spotify | ₱129 | Monthly | 90% |
```

### Check Utilization Risk

```
User: /safe

Output:
| Card | Balance | Limit | Utilization | Risk |
|------|---------|-------|-------------|------|
| Card A | ₱8,000 | ₱10,000 | 80% | 🟡 Alert |
| Card B | ₱2,000 | ₱15,000 | 13% | 🟢 Safe |
```

### Find Best Card Offers

```
User: /offers

Output:
| Card | Cashback | Annual Savings | Best For |
|------|----------|----------------|----------|
| Card X | 5% Food | ₱2,700 | Dining |
| Card Y | 3% Travel | ₱1,800 | Flights |
```

---

## Advanced Workflows

### Complete Monthly Financial Review

```
Step 1: /review      → Analyze statement
Step 2: /subscriptions → Find recurring charges
Step 3: /due         → Calculate obligations
Step 4: /safe        → Check utilization
Step 5: /insights    → Identify patterns
Step 6: /forecast    → Project next month
Step 7: /export      → Save as JSON/CSV
```

### Spending Optimization

```
Step 1: /review      → Analyze 3 months
Step 2: /insights    → Find patterns
Step 3: /offers      → Find better cards
Step 4: /forecast    → Project savings
Step 5: /remind      → Set reminders
```

### Subscription Audit

```
Step 1: /review      → Analyze 3 months
Step 2: /subscriptions → Detect recurring
Step 3: /insights    → Find unused services
Step 4: /offers      → Find alternatives
```

---

## Real-World Scenarios

### Monthly Financial Review

**When:** First day of month

1. `/review` last month's statement
2. `/subscriptions` to identify recurring
3. `/due` for upcoming obligations
4. `/safe` to check utilization
5. `/insights` for spending patterns
6. `/forecast` for next month projection
7. `/export` to save summary

### Subscription Audit

**When:** Quarterly

1. `/review` 3 months of statements
2. `/subscriptions` to detect all recurring
3. `/insights` to find unused services
4. `/offers` for cheaper alternatives

### Credit Card Optimization

**When:** Considering new card

1. `/review` 6 months of statements
2. `/offers` for best card match
3. `/safe` to check current utilization
4. `/forecast` to estimate savings

---

## How It Works

### Architecture

```
┌─────────────────────────────────────────┐
│ Claude Desktop Chat                     │
│ User: "/review [statement]"             │
└────────────────┬────────────────────────┘
                 │
                 ↓ (JSON-RPC)
┌─────────────────────────────────────────┐
│ mcp-server.js (MCP Server)              │
│                                         │
│ 1. Parse request                        │
│ 2. Load command instructions            │
│ 3. Load reference files                 │
│ 4. Build prompt context                 │
│ 5. Return response                      │
└────────────────┬────────────────────────┘
                 │
                 ↓ (JSON-RPC)
┌─────────────────────────────────────────┐
│ Claude Desktop Chat                     │
│ Claude processes + returns analysis     │
└─────────────────────────────────────────┘
```

### Key Files

| File | Purpose |
|------|---------|
| `mcp-server.js` | MCP server (stdio JSON-RPC) |
| `claude.json` | Plugin metadata |
| `commands/*.md` | Command instructions |
| `references/*.md` | Reference data |
| `schemas/*.json` | Data validation |
| `templates/*.md` | Output templates |

### Data Flow

```
User Input → MCP Server (local) → Claude (local context) → User Output
            [NEVER SENT EXTERNALLY]
```

---

## Extending Kaskas

### Adding a New Command

**Step 1: Create command file**

```markdown
# commands/budget.md

# Budget Planning

Help users set spending limits and track progress.

## Output Format
| Category | Budget | Spent | % Used | Status |
|----------|--------|-------|--------|--------|
| Food | ₱5,000 | ₱3,200 | 64% | 🟢 OK |
```

**Step 2: Register in MCP server**

```javascript
// mcp-server.js
const COMMANDS = [
  // ... existing
  { name: 'budget', description: 'Set spending limits' },
];

const CMD_REFS = {
  // ... existing
  budget: ['merchant-categories.md'],
};
```

**Step 3: Restart Claude Desktop**

---

## Security & Privacy

### What's Safe to Store

✅ **Safe:**
- Merchant names
- Transaction amounts and dates
- Last 4 digits of cards (`****1234`)

❌ **Never stored:**
- Full card numbers
- CVV / security codes
- Passwords or PINs
- Full account numbers

### Why It's Safe

- **Local-only**: All data stays on your machine
- **No external calls**: Zero cloud uploads
- **No lock-in**: Export anytime
- **PCI DSS compliant**: Follows banking standards

### What's Safe to Paste

✅ **Safe:**
- Credit card statements
- Transaction lists
- Bank statements
- Receipt images

❌ **Never paste:**
- Full card numbers
- CVV codes
- Passwords
- Full account numbers

---

## Troubleshooting

### Command Not Appearing

**Checklist:**
- [ ] File exists: `commands/yourcommand.md`
- [ ] Registered in `COMMANDS` array
- [ ] Registered in `CMD_REFS` object
- [ ] Claude Desktop restarted

### MCP Server Not Starting

**Debug:**
1. Verify Node.js: `node --version`
2. Check permissions: `ls -la mcp-server.js`
3. Check path in Claude Desktop config
4. Check for syntax errors: `node mcp-server.js`

### Wrong Output Format

**Check:**
1. Command instructions in `commands/*.md`
2. Reference files in `references/*.md`
3. PREAMBLE in `mcp-server.js`

### Performance Tips

1. **Batch commands**: Chain related commands
2. **Limit data**: Start with 3 months
3. **Use export**: Save results for reference
4. **Cache**: MCP server caches reference files

---

## Future Roadmap

### Phase 1: MCP Tools
- Direct function execution
- Tools: `analyze_statement()`, `detect_subscriptions()`
- Better error handling
- Faster execution

### Phase 2: Persistent Storage
- SQLite database
- Query transactions across months
- Track subscription changes
- Build spending forecasts

### Phase 3: MCP Resources
- Expose transaction database
- Real-time data access
- Advanced analytics

### Phase 4: Enhanced Features
- Visualization (charts, graphs)
- Custom reports
- Advanced anomaly detection

---

## Configuration

### Settings (claude.json)

```json
{
  "settings": {
    "token_limit": "low",
    "philosophy": "caveman",
    "output_format": "markdown",
    "data_ownership": "user"
  }
}
```

### Locale Settings (manifest.json)

```json
{
  "locale": {
    "language": "en",
    "taglish": false,
    "currency": "PHP",
    "currency_symbol": "₱"
  }
}
```

Enable Taglish mode:
- Config: `"taglish": true`
- Per-command: `/review --taglish`
- Chat: "Use Taglish mode"

---

## Quick Reference

### All Commands

```
/review        → Analyze statements
/due           → Track payments
/subscriptions → Find recurring
/offers        → Card recommendations
/safe          → Utilization risk
/export        → Export data
/ocr           → Extract from images
/pdf           → Extract from PDFs
/promos        → Parse offers
/memory        → Persistent storage
/embed         → Semantic search
/insights      → Pattern analysis
/llm           → Local LLM
/remind        → Payment reminders
/forecast      → Spending forecasts
/reset         → Clear test data
```

### Installation Paths

```
Windows: %APPDATA%\Claude\kaskas
macOS:   ~/Library/Application Support/Claude/kaskas
Linux:   ~/.config/Claude/kaskas
```

---

## Resources

- **GitHub**: [https://github.com/rjramirez/kaskas](https://github.com/rjramirez/kaskas)
- **License**: MIT
- **Author**: rjramirez
- **MCP Spec**: [https://modelcontextprotocol.io/](https://modelcontextprotocol.io/)

---

## Summary

Kaskas is a **local-only financial memory skill** for Claude Desktop that:

✅ **Analyzes** credit card statements  
✅ **Tracks** upcoming payments  
✅ **Detects** subscriptions  
✅ **Optimizes** card usage  
✅ **Forecasts** spending  
✅ **Exports** data  

All processing is **local-only** with **zero external API calls**.

**Get started:** Install kaskas, restart Claude Desktop, type `/review`!

---

[← Back to Home](./)
