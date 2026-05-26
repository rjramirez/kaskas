---
name: kaskas
description: Portable financial memory workflow for reviewing credit card statements, tracking obligations, detecting subscriptions, analyzing utilization, and optimizing cashback usage using Caveman-style reusable commands.
version: 0.1.0
---

# Kaskas

## Philosophy

Kaskas follows Caveman-style principles:

- deterministic workflows first
- concise outputs
- low token usage
- markdown-native workflows
- user-owned memory
- local-first mindset

Always prefer:
- concise tactical summaries
- structured markdown
- actionable financial insights

Avoid:
- verbose explanations
- hallucinated promos
- fabricated assumptions

---

# Slash Commands

## /review

Analyze:
- statements
- receipts
- transaction exports
- screenshots

Load:
- commands/review.md
- references/merchant-categories.md
- templates/summary.md

---

## /due

Track:
- credit card dues
- subscriptions
- recurring bills
- loan obligations

Load:
- commands/due.md
- templates/obligations.md

---

## /subscriptions

Detect:
- recurring charges
- monthly obligations
- subscription patterns

Load:
- commands/subscriptions.md
- references/recurring-patterns.md

---

## /offers

Recommend:
- best card usage
- cashback opportunities
- reward optimization

Load:
- commands/offers.md
- references/ph-cards.md

---

## /safe

Estimate:
- utilization risk
- safe spending threshold
- future obligations

Load:
- commands/safe.md
- references/utilization-rules.md

---

## /export

Generate:
- JSON exports
- CSV exports
- markdown summaries

Goal:
portable financial memory across AI agents.

---

# Portability Principle

All financial memory must remain:
- exportable
- inspectable
- user-owned
- agent-compatible

Prefer:
- JSON
- CSV
- Markdown
- SQLite

Avoid proprietary lock-in.
