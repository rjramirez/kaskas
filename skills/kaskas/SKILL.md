---
name: kaskas
description: >
  Financial memory skill. Analyze credit card statements, track obligations,
  find cashback opportunities. Trigger when user shares statements, asks about
  spending, dues, subscriptions, card rewards, or uploads receipts/PDFs.
  Commands: /review /due /subscriptions /offers /safe /export /ocr /pdf
  /promos /memory /embed /insights /llm /remind /forecast
---

Kaskas: financial memory for Claude. Local-only. Zero external calls.

## Commands

| Command | What |
|---------|------|
| `/review` | Analyze statements, extract spend, find patterns |
| `/due` | Track upcoming dues, bills, subscriptions |
| `/subscriptions` | Detect recurring charges with confidence scoring |
| `/offers` | Best card for each spending category (PH cards) |
| `/safe` | Utilization risk score, safe spend threshold |
| `/export` | Export data as JSON/CSV/Markdown |
| `/ocr` | Extract text from images, screenshots, receipts |
| `/pdf` | Extract transactions from PDF statements |
| `/promos` | Parse card promotional offers |
| `/memory` | SQLite persistent storage, deduplication |
| `/embed` | Semantic search on transactions |
| `/insights` | Pattern analysis, anomaly detection |
| `/llm` | Local LLM financial analysis (no API calls) |
| `/remind` | Set proactive payment reminders |
| `/forecast` | Spending forecasts, what-if scenarios |

## Behavior

Output concise. Tables only — no prose blocks. Amounts in PHP. Tactical.
Never: long paragraphs, vague advice, external API calls, invented rates.
Always: validate data against schemas, reference merchant-categories and utilization-rules.

Auto-trigger when user:
- Pastes credit card statement text
- Asks "how much did I spend"
- Mentions due dates, bills, overdue payments
- Uploads receipt, statement image, or PDF
- Asks about best card for a category

## Data Schemas

All extracted data validates against:
- `schemas/transaction.schema.json` (merchant, amount, date, category, type)
- `schemas/obligation.schema.json` (type, amount, due_date, frequency, status)

## References

- `references/merchant-categories.md` — category mapping (Food/Shopping/Utilities/Transport/Entertainment/Healthcare/Education)
- `references/ph-cards.md` — 8 PH credit card reward patterns
- `references/utilization-rules.md` — risk thresholds (0-30% healthy, 31-60% moderate, 61-85% risky, 86%+ danger)
- `references/recurring-patterns.md` — subscription detection patterns

## Output Templates

- `templates/summary.md` — financial summary layout
- `templates/obligations.md` — dues tracking layout
