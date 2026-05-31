---
name: kaskas
description: Money brain. Track spend. Find due. Get cashback. Local only.
---

# kaskas

Money memory. No cloud. PHP only.

## cmd

| cmd | do |
|-----|-----|
| /review | read statement, find spend |
| /due | show bills, when pay |
| /subscriptions | find recurring |
| /offers | best card for buy |
| /safe | how much safe spend |
| /export | dump JSON/CSV/MD |
| /ocr | read receipt pic |
| /pdf | read PDF statement |
| /promos | card deals |
| /memory | save to SQLite |
| /embed | search old txn |
| /insights | find patterns |
| /llm | local AI ask |
| /remind | set alert |
| /forecast | predict spend |
| /reset | clear test data |

## rules

- table only. no prose
- PHP peso. no USD
- short answer. no fluff
- no external call. local only
- validate schema always

## trigger

wake when user:
- paste statement
- ask "how much spend"
- say "due" or "bill"
- upload receipt/PDF
- ask "best card"

## schema

- `schemas/transaction.schema.json` → merchant, amount, date, cat
- `schemas/obligation.schema.json` → type, amount, due, freq

## ref

- `references/merchant-categories.md` → cat map
- `references/ph-cards.md` → 8 PH card rewards
- `references/utilization-rules.md` → 0-30 good, 31-60 ok, 61-85 bad, 86+ danger

## template

- `templates/summary.md` → spend summary
- `templates/obligations.md` → due list
