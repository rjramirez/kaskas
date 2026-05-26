# Claude Desktop Integration Guide

## Overview

This document outlines the complete changes needed to make Kaskas a fully-featured Claude Desktop skill with proper manifest configuration, command definitions, and resource loading.

---

## 1. Create `claude.json` Manifest

**File**: `claude.json` (root directory)

This is the official Claude Desktop skill manifest that tells Claude how to load and use Kaskas.

```json
{
  "name": "kaskas",
  "version": "0.1.0",
  "description": "Portable financial memory workflow for reviewing credit card statements, tracking obligations, detecting subscriptions, analyzing utilization, and optimizing cashback usage",
  "author": "rjramirez",
  "license": "MIT",
  "homepage": "https://github.com/rjramirez/kaskas",
  "repository": {
    "type": "git",
    "url": "https://github.com/rjramirez/kaskas.git"
  },
  "interface": {
    "display_name": "Kaskas",
    "short_description": "Financial memory workflow",
    "description": "Review statements, track obligations, detect subscriptions, and optimize card usage",
    "icon": "💰",
    "color": "#22c55e"
  },
  "commands": [
    {
      "name": "review",
      "description": "Analyze credit card statements, receipts, and transactions",
      "icon": "📊",
      "resources": [
        "commands/review.md",
        "references/merchant-categories.md",
        "templates/summary.md",
        "schemas/transaction.schema.json"
      ]
    },
    {
      "name": "due",
      "description": "Track credit card dues, subscriptions, and recurring bills",
      "icon": "⏰",
      "resources": [
        "commands/due.md",
        "templates/obligations.md",
        "schemas/obligation.schema.json"
      ]
    },
    {
      "name": "subscriptions",
      "description": "Detect recurring charges and subscription patterns",
      "icon": "🔄",
      "resources": [
        "commands/subscriptions.md",
        "references/recurring-patterns.md",
        "schemas/transaction.schema.json"
      ]
    },
    {
      "name": "offers",
      "description": "Find best card offers and cashback opportunities",
      "icon": "💳",
      "resources": [
        "commands/offers.md",
        "references/ph-cards.md",
        "schemas/promo.schema.json"
      ]
    },
    {
      "name": "safe",
      "description": "Check safe spending limits and utilization risk",
      "icon": "🛡️",
      "resources": [
        "commands/safe.md",
        "references/utilization-rules.md"
      ]
    },
    {
      "name": "export",
      "description": "Export financial memory as JSON, CSV, or Markdown",
      "icon": "📤",
      "resources": [
        "commands/export.md",
        "schemas/transaction.schema.json",
        "schemas/obligation.schema.json"
      ]
    }
  ],
  "resources": {
    "commands": "commands/",
    "references": "references/",
    "templates": "templates/",
    "schemas": "schemas/",
    "agents": "agents/"
  },
  "settings": {
    "token_limit": "low",
    "philosophy": "caveman",
    "output_format": "markdown",
    "data_ownership": "user"
  }
}
```

---

## 2. Update `agents/openai.yaml`

**File**: `agents/openai.yaml`

Enhanced with proper Claude Desktop integration metadata.

```yaml
# Kaskas Agent Configuration for Claude Desktop

interface:
  display_name: "Kaskas"
  short_description: "Portable financial memory workflow"
  description: "Review statements, track obligations, detect subscriptions, and optimize card usage using local-first reusable workflows."
  icon: "💰"
  color: "#22c55e"

agent:
  name: "kaskas"
  version: "0.1.0"
  model: "claude-3-5-sonnet"
  
system_prompt: |
  You are Kaskas, a financial memory assistant built on Caveman principles.
  
  Your role:
  - Analyze financial statements and transactions
  - Track obligations and due dates
  - Detect subscription patterns
  - Recommend card usage optimization
  - Estimate safe spending limits
  - Export portable financial memory
  
  Core principles:
  - Deterministic workflows first
  - Concise, tactical summaries
  - Structured markdown output
  - Low token usage
  - User-owned data
  - Local-first mindset
  
  Always:
  - Use provided schemas for validation
  - Reference merchant categories for normalization
  - Load relevant templates for output
  - Provide actionable insights
  - Avoid hallucinated data
  
  Never:
  - Store sensitive data permanently
  - Make assumptions about user finances
  - Recommend without evidence
  - Use verbose explanations

commands:
  review:
    description: "Analyze statements, receipts, transactions, screenshots"
    icon: "📊"
    resources:
      - commands/review.md
      - references/merchant-categories.md
      - templates/summary.md
      - schemas/transaction.schema.json
    
  due:
    description: "Track dues, subscriptions, recurring bills, obligations"
    icon: "⏰"
    resources:
      - commands/due.md
      - templates/obligations.md
      - schemas/obligation.schema.json
    
  subscriptions:
    description: "Detect recurring charges and subscription patterns"
    icon: "🔄"
    resources:
      - commands/subscriptions.md
      - references/recurring-patterns.md
      - schemas/transaction.schema.json
    
  offers:
    description: "Find best card offers and cashback opportunities"
    icon: "💳"
    resources:
      - commands/offers.md
      - references/ph-cards.md
      - schemas/promo.schema.json
    
  safe:
    description: "Check safe spending limits and utilization risk"
    icon: "🛡️"
    resources:
      - commands/safe.md
      - references/utilization-rules.md
    
  export:
    description: "Export financial memory as JSON, CSV, or Markdown"
    icon: "📤"
    resources:
      - commands/export.md
      - schemas/transaction.schema.json
      - schemas/obligation.schema.json

resources:
  commands_dir: "commands/"
  references_dir: "references/"
  templates_dir: "templates/"
  schemas_dir: "schemas/"
  agents_dir: "agents/"

settings:
  token_efficiency: "high"
  philosophy: "caveman"
  output_format: "markdown"
  data_ownership: "user-first"
  cache_resources: true
  validate_schemas: true
```

---

## 3. Create `manifest.json` (Alternative Format)

**File**: `manifest.json` (root directory)

For broader compatibility with skill managers.

```json
{
  "manifest_version": "1.0",
  "skill": {
    "id": "kaskas",
    "name": "Kaskas",
    "version": "0.1.0",
    "description": "Portable financial memory workflow for reviewing credit card statements, tracking obligations, detecting subscriptions, analyzing utilization, and optimizing cashback usage",
    "author": {
      "name": "rjramirez",
      "url": "https://github.com/rjramirez"
    },
    "license": "MIT",
    "repository": "https://github.com/rjramirez/kaskas",
    "homepage": "https://github.com/rjramirez/kaskas",
    "keywords": [
      "finance",
      "credit-cards",
      "budgeting",
      "subscriptions",
      "cashback",
      "portable-memory",
      "caveman"
    ],
    "categories": [
      "finance",
      "productivity",
      "analysis"
    ]
  },
  "interface": {
    "display_name": "Kaskas",
    "short_description": "Financial memory workflow",
    "description": "Review statements, track obligations, detect subscriptions, and optimize card usage",
    "icon": "💰",
    "color": "#22c55e",
    "theme": "light"
  },
  "commands": [
    {
      "id": "review",
      "name": "Review",
      "description": "Analyze credit card statements, receipts, and transactions",
      "icon": "📊",
      "handler": "commands/review.md",
      "resources": [
        "references/merchant-categories.md",
        "templates/summary.md",
        "schemas/transaction.schema.json"
      ]
    },
    {
      "id": "due",
      "name": "Due",
      "description": "Track credit card dues, subscriptions, and recurring bills",
      "icon": "⏰",
      "handler": "commands/due.md",
      "resources": [
        "templates/obligations.md",
        "schemas/obligation.schema.json"
      ]
    },
    {
      "id": "subscriptions",
      "name": "Subscriptions",
      "description": "Detect recurring charges and subscription patterns",
      "icon": "🔄",
      "handler": "commands/subscriptions.md",
      "resources": [
        "references/recurring-patterns.md",
        "schemas/transaction.schema.json"
      ]
    },
    {
      "id": "offers",
      "name": "Offers",
      "description": "Find best card offers and cashback opportunities",
      "icon": "💳",
      "handler": "commands/offers.md",
      "resources": [
        "references/ph-cards.md",
        "schemas/promo.schema.json"
      ]
    },
    {
      "id": "safe",
      "name": "Safe",
      "description": "Check safe spending limits and utilization risk",
      "icon": "🛡️",
      "handler": "commands/safe.md",
      "resources": [
        "references/utilization-rules.md"
      ]
    },
    {
      "id": "export",
      "name": "Export",
      "description": "Export financial memory as JSON, CSV, or Markdown",
      "icon": "📤",
      "handler": "commands/export.md",
      "resources": [
        "schemas/transaction.schema.json",
        "schemas/obligation.schema.json"
      ]
    }
  ],
  "resources": {
    "base_path": "./",
    "directories": {
      "commands": "commands/",
      "references": "references/",
      "templates": "templates/",
      "schemas": "schemas/",
      "agents": "agents/"
    }
  },
  "configuration": {
    "token_efficiency": "high",
    "philosophy": "caveman",
    "output_format": "markdown",
    "data_ownership": "user-first",
    "cache_resources": true,
    "validate_schemas": true,
    "security": {
      "requires_authentication": false,
      "data_storage": "local-only",
      "data_export": true
    }
  },
  "dependencies": [],
  "installation": {
    "windows": {
      "path": "%APPDATA%\\Claude\\skills\\kaskas",
      "script": "install.ps1"
    },
    "macos": {
      "path": "~/Library/Application Support/Claude/skills/kaskas",
      "script": "install.sh"
    },
    "linux": {
      "path": "~/.config/Claude/skills/kaskas",
      "script": "install.sh"
    }
  }
}
```

---

## 4. Enhanced `SKILL.md`

**File**: `SKILL.md` (updated)

Add Claude Desktop specific instructions.

```markdown
---
name: kaskas
version: 0.1.0
description: Portable financial memory workflow for reviewing credit card statements, tracking obligations, detecting subscriptions, analyzing utilization, and optimizing cashback usage using Caveman-style reusable commands.
author: rjramirez
license: MIT
repository: https://github.com/rjramirez/kaskas
---

# Kaskas - Claude Desktop Skill

## Installation

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

## Philosophy

Kaskas follows Caveman-style principles:

- **Deterministic workflows first** - Predictable, repeatable results
- **Concise outputs** - No fluff, just facts
- **Low token usage** - Efficient AI interactions
- **Markdown-native workflows** - Human-readable, version-controllable
- **User-owned memory** - Your data stays yours
- **Local-first mindset** - Process locally, export globally

### Core Values

Always prefer:
- Concise tactical summaries
- Structured markdown
- Actionable financial insights
- Deterministic parsing
- Portable formats (JSON, CSV, Markdown)

Avoid:
- Verbose explanations
- Hallucinated promos
- Fabricated assumptions
- Proprietary lock-in
- Permanent data storage

---

## Slash Commands

### /review
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

Example:
```
/review
Analyze this credit card statement PDF
```

---

### /due
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

Example:
```
/due
Show all upcoming obligations for next 30 days
```

---

### /subscriptions
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

Example:
```
/subscriptions
Find all recurring charges in my statements
```

---

### /offers
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

Example:
```
/offers
What's the best card for dining and groceries?
```

---

### /safe
**Check safe spending limits**

Estimates:
- Safe monthly spending threshold
- Utilization risk assessment
- Future obligation impact
- Financial health indicators

Resources:
- `commands/safe.md` - Workflow definition
- `references/utilization-rules.md` - Rules reference

Example:
```
/safe
Can I safely spend ₱50,000 this month?
```

---

### /export
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

Example:
```
/export
Export all transactions as JSON
```

---

## Resource Structure

```
kaskas/
├── claude.json                          # Claude Desktop manifest
├── manifest.json                        # Alternative manifest format
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

## Data Ownership & Privacy

Kaskas is designed with privacy-first architecture:

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

## Troubleshooting

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

## Contributing

Have ideas? Found a bug? Want to improve Kaskas?

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## License

MIT License - See LICENSE file for details

---

## Support

- 📖 [GitHub Repository](https://github.com/rjramirez/kaskas)
- 🐛 [Issue Tracker](https://github.com/rjramirez/kaskas/issues)
- 💬 [Discussions](https://github.com/rjramirez/kaskas/discussions)

---

**Made with ❤️ for people who care about their financial privacy**
```

---

## 5. Update Installation Scripts

### Enhanced `install.ps1`

Add manifest validation:

```powershell
# ... existing code ...

# Validate installation
Write-Host "🔍 Validating installation..." -ForegroundColor Gray
$requiredFiles = @(
    "SKILL.md",
    "claude.json",
    "commands/review.md",
    "commands/due.md",
    "commands/subscriptions.md",
    "commands/offers.md",
    "commands/safe.md",
    "commands/export.md",
    "references/merchant-categories.md",
    "references/ph-cards.md",
    "references/recurring-patterns.md",
    "references/utilization-rules.md",
    "templates/summary.md",
    "templates/obligations.md",
    "schemas/transaction.schema.json",
    "schemas/obligation.schema.json",
    "schemas/promo.schema.json",
    "agents/openai.yaml"
)

$missingFiles = @()
foreach ($file in $requiredFiles) {
    if (-not (Test-Path "$SkillDir\$file")) {
        $missingFiles += $file
    }
}

if ($missingFiles.Count -gt 0) {
    Write-Host "⚠️  Missing files:" -ForegroundColor Yellow
    foreach ($file in $missingFiles) {
        Write-Host "  - $file" -ForegroundColor Yellow
    }
}
else {
    Write-Host "✓ All files validated" -ForegroundColor Green
}

# ... rest of code ...
```

---

## 6. Create `.clauderc` Configuration File

**File**: `.clauderc` (root directory)

Optional configuration for Claude Desktop:

```json
{
  "skill": {
    "id": "kaskas",
    "enabled": true,
    "auto_load": true,
    "cache_resources": true
  },
  "behavior": {
    "token_limit": "low",
    "philosophy": "caveman",
    "output_format": "markdown"
  },
  "security": {
    "sandbox": true,
    "local_only": true,
    "no_external_calls": true
  }
}
```

---

## Summary of Changes

| File | Change | Purpose |
|------|--------|---------|
| `claude.json` | **NEW** | Official Claude Desktop manifest |
| `manifest.json` | **NEW** | Alternative manifest format |
| `.clauderc` | **NEW** | Configuration file |
| `SKILL.md` | **ENHANCED** | Add Claude Desktop instructions |
| `agents/openai.yaml` | **ENHANCED** | Add command definitions |
| `install.ps1` | **ENHANCED** | Add validation |
| `install.sh` | **ENHANCED** | Add validation |
| `README.md` | **ALREADY DONE** | User-friendly guide |

---

## Implementation Priority

1. **Phase 1 (Critical)**: Create `claude.json` manifest
2. **Phase 2 (Important)**: Update `SKILL.md` with Claude Desktop instructions
3. **Phase 3 (Nice-to-have)**: Create `manifest.json` for broader compatibility
4. **Phase 4 (Polish)**: Add `.clauderc` configuration
5. **Phase 5 (Testing)**: Validate installation scripts

---

## Testing Checklist

- [ ] Skill appears in Claude Desktop
- [ ] All 6 slash commands are available
- [ ] Each command loads correct resources
- [ ] JSON schemas validate correctly
- [ ] Installation script completes without errors
- [ ] Manual installation works
- [ ] Skill persists after Claude Desktop restart
- [ ] Commands execute without errors
- [ ] Output follows Caveman principles

---

## Next Steps

1. Create `claude.json` in root directory
2. Update `agents/openai.yaml` with command definitions
3. Enhance `SKILL.md` with Claude Desktop instructions
4. Test installation and functionality
5. Commit and push to GitHub
6. Update README with new features

