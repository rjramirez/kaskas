---
name: kaskas
version: 0.1.0
description: Portable financial memory workflow for reviewing credit card statements, tracking obligations, detecting subscriptions, analyzing utilization, and optimizing cashback usage using Caveman-style reusable commands.
author: rjramirez
license: MIT
repository: https://github.com/rjramirez/kaskas
---

# Kaskas - Claude Desktop Skill

## 🚀 Installation

### Automatic Installation

**Windows (PowerShell)**
```powershell
irm https://raw.githubusercontent.com/rjramirez/kaskas/main/install.ps1 | iex
```

**macOS / Linux (Bash)**
```bash
curl -fsSL https://raw.githubusercontent.com/rjramirez/kaskas/main/install.sh | bash
```

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/rjramirez/kaskas.git
```

2. Copy to Claude Desktop skills directory:

**Windows:**
```
%APPDATA%\Claude\skills\kaskas
```

**macOS:**
```
~/Library/Application Support/Claude/skills/kaskas
```

**Linux:**
```
~/.config/Claude/skills/kaskas
```

3. Restart Claude Desktop

---

## 🧠 Philosophy

Kaskas follows **Caveman-style principles**:

- **Deterministic workflows first** - Predictable, repeatable results
- **Concise outputs** - No fluff, just facts
- **Low token usage** - Efficient AI interactions
- **Markdown-native workflows** - Human-readable, version-controllable
- **User-owned memory** - Your data stays yours
- **Local-first mindset** - Process locally, export globally

### Core Values

Always prefer:
- ✅ Concise tactical summaries
- ✅ Structured markdown
- ✅ Actionable financial insights
- ✅ Deterministic parsing
- ✅ Portable formats (JSON, CSV, Markdown)

Avoid:
- ❌ Verbose explanations
- ❌ Hallucinated promos
- ❌ Fabricated assumptions
- ❌ Proprietary lock-in
- ❌ Permanent data storage

---

## ⚡ Slash Commands

### /review 📊
**Analyze credit card statements and transactions**

Analyzes:
- Statements (PDF, CSV, screenshots)
- Receipts and transaction exports
- Spending patterns and categories
- Recurring charges and installments

Resources:
- `commands/review.md` - Workflow definition
- `references/merchant-categories.md` - Category normalization
- `templates/summary.md` - Output template
- `schemas/transaction.schema.json` - Data validation

**Example:**
```
/review
Analyze this credit card statement PDF
```

---

### /due ⏰
**Track credit card dues and obligations**

Tracks:
- Credit card payment due dates
- Subscription billing dates
- Recurring bill schedules
- Loan payment obligations

Resources:
- `commands/due.md` - Workflow definition
- `templates/obligations.md` - Output template
- `schemas/obligation.schema.json` - Data validation

**Example:**
```
/due
Show all upcoming obligations for next 30 days
```

---

### /subscriptions 🔄
**Detect recurring charges and subscriptions**

Detects:
- Monthly subscription charges
- Recurring payment patterns
- Hidden recurring fees
- Subscription consolidation opportunities

Resources:
- `commands/subscriptions.md` - Workflow definition
- `references/recurring-patterns.md` - Pattern reference
- `schemas/transaction.schema.json` - Data validation

**Example:**
```
/subscriptions
Find all recurring charges in my statements
```

---

### /offers 💳
**Find best card offers and cashback opportunities**

Recommends:
- Best card for specific merchants
- Cashback optimization strategies
- Reward maximization opportunities
- Promo code matching

Resources:
- `commands/offers.md` - Workflow definition
- `references/ph-cards.md` - Card database
- `schemas/promo.schema.json` - Offer validation

**Example:**
```
/offers
What's the best card for dining and groceries?
```

---

### /safe 🛡️
**Check safe spending limits**

Estimates:
- Safe monthly spending threshold
- Utilization risk assessment
- Future obligation impact
- Financial health indicators

Resources:
- `commands/safe.md` - Workflow definition
- `references/utilization-rules.md` - Rules reference

**Example:**
```
/safe
Can I safely spend ₱50,000 this month?
```

---

### /export 📤
**Export financial memory**

Generates:
- JSON exports (structured data)
- CSV exports (spreadsheet-ready)
- Markdown summaries (human-readable)
- Portable memory backups

Resources:
- `commands/export.md` - Workflow definition
- `schemas/transaction.schema.json` - Data schema
- `schemas/obligation.schema.json` - Obligation schema

**Example:**
```
/export
Export all transactions as JSON
```

---

## 📁 Resource Structure

```
kaskas/
├── claude.json                          # Claude Desktop manifest
├── manifest.json                        # Alternative manifest format
├── .clauderc                            # Configuration file
├── SKILL.md                             # This file
├── CHANGELOG.md                         # Version history
├── README.md                            # User guide
├── ROADMAP.md                           # Future plans
├── LICENSE                              # MIT License
├── install.ps1                          # Windows installer
├── install.sh                           # macOS/Linux installer
│
├── commands/                            # Slash command definitions
│   ├── review.md                        # /review workflow
│   ├── due.md                           # /due workflow
│   ├── subscriptions.md                 # /subscriptions workflow
│   ├── offers.md                        # /offers workflow
│   ├── safe.md                          # /safe workflow
│   └── export.md                        # /export workflow
│
├── references/                          # Reference data
│   ├── merchant-categories.md           # Merchant category mapping
│   ├── ph-cards.md                      # Philippine credit cards
│   ├── recurring-patterns.md            # Subscription patterns
│   └── utilization-rules.md             # Credit utilization rules
│
├── templates/                           # Output templates
│   ├── summary.md                       # Statement summary template
│   └── obligations.md                   # Obligations template
│
├── schemas/                             # JSON schemas for validation
│   ├── transaction.schema.json          # Transaction data schema
│   ├── obligation.schema.json           # Obligation data schema
│   └── promo.schema.json                # Promotion data schema
│
└── agents/                              # Agent configurations
    └── openai.yaml                      # Claude Desktop agent config
```

---

## 🔒 Data Ownership & Privacy

Kaskas is designed with **privacy-first architecture**:

✅ **Local-first processing** - Everything stays on your machine  
✅ **Portable memory** - Export anytime, no vendor lock-in  
✅ **Temporary parsing** - Data doesn't linger  
✅ **User-owned data** - You control what's stored  

### Best Practices

- 🔐 Mask card numbers before sharing statements
- 🗑️ Don't store raw statements permanently
- 📤 Export structured memory only for backups
- 🔒 Keep your skills folder private

---

## 🆘 Troubleshooting

### Skill not appearing in Claude Desktop

1. Check installation path:
   - Windows: `%APPDATA%\Claude\skills\kaskas`
   - macOS: `~/Library/Application Support/Claude/skills/kaskas`
   - Linux: `~/.config/Claude/skills/kaskas`

2. Verify all files are present:
   - `claude.json` or `manifest.json`
   - `SKILL.md`
   - `commands/` directory with all .md files
   - `references/`, `templates/`, `schemas/` directories

3. Restart Claude Desktop completely

### Commands not working

1. Check that all resource files exist
2. Verify JSON schemas are valid
3. Check Claude Desktop logs for errors
4. Try restarting Claude Desktop

### Installation script fails

1. Ensure you have internet connection
2. Check that GitHub is accessible
3. Try manual installation instead
4. Report issue on GitHub

---

## 🤝 Contributing

Have ideas? Found a bug? Want to improve Kaskas?

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 📄 License

MIT License - See LICENSE file for details

---

## 🔗 Support

- 📖 [GitHub Repository](https://github.com/rjramirez/kaskas)
- 🐛 [Issue Tracker](https://github.com/rjramirez/kaskas/issues)
- 💬 [Discussions](https://github.com/rjramirez/kaskas/discussions)

---

## 🌍 Portability Principle

All financial memory must remain:
- **Exportable** - Take it with you
- **Inspectable** - Human-readable formats
- **User-owned** - You control it
- **Agent-compatible** - Works with any AI

Prefer:
- JSON
- CSV
- Markdown
- SQLite

Avoid proprietary lock-in.

---

**Made with ❤️ for people who care about their financial privacy**
