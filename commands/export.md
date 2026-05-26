# /export

Export financial memory. User owns data.

## Principle

Exports must be:
- Agent-compatible (re-importable)
- Inspectable (human-readable)
- Portable (no lock-in)
- Complete (all data)

## Process

1. **Gather** → transactions (`/review`), obligations (`/due`), subscriptions (`/subscriptions`), metadata
2. **Validate** → against schemas (transaction, obligation, promo)
3. **Generate** → JSON, CSV, or Markdown
4. **Package** → single file or zip

## Formats

**JSON** → single file, nested structure, agent-compatible
```
{
  "metadata": { "exported_at": "...", "version": "1.0" },
  "transactions": [...],
  "obligations": [...],
  "subscriptions": [...],
  "summary": { "total_spend": 0, "total_recurring": 0, "utilization": 0 }
}
```

**CSV** → 4 files in zip
- transactions.csv (merchant, amount, category, date, type)
- obligations.csv (type, amount, due_date, frequency, status)
- subscriptions.csv (merchant, monthly_amount, confidence, start_date)
- metadata.csv (key, value)

**Markdown** → single file, tables + summary + analysis

## Commands

- `/export json` → JSON file
- `/export csv` → CSV zip
- `/export markdown` → Markdown file
- `/export all` → all three

## Includes

- Complete transaction history
- All obligations
- All subscriptions
- Analysis metadata
- Export timestamp

No data loss. User can import elsewhere, share with accountant, archive, switch agents anytime.

Portable.
