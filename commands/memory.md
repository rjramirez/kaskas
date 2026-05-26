# /memory

Store financial data. Persistent local memory.

## Input
- Transactions (from `/review`, `/ocr`, `/pdf`)
- Obligations (from `/due`)
- Subscriptions (from `/subscriptions`)
- Promos (from `/promos`)

## Process

1. **Store** → SQLite database (local, encrypted)
2. **Index** → by date, merchant, category, type
3. **Deduplicate** → check for existing records
4. **Validate** → against schemas before insert
5. **Timestamp** → record creation/update time

## Output

**Storage Status**
- Records stored: X
- New records: X
- Duplicates skipped: X
- Errors: X

**Database Info**
- Location: ~/.kaskas/memory.db
- Size: X MB
- Last updated: YYYY-MM-DD HH:MM:SS

**Queries**
- `/memory list` → show all stored records
- `/memory search [query]` → find records
- `/memory stats` → database statistics
- `/memory export` → export to JSON/CSV
- `/memory clear` → delete all (confirm first)

## Security

- Local-only storage (no cloud)
- Encrypted at rest (optional)
- User owns all data
- Can export anytime
- Can delete anytime

No sync. No tracking. User control.
