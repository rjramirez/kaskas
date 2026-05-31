# /export

Dump data. User own.

## rule
- re-importable
- human readable
- no lock-in
- all data

## do
1. gather → txn, obligation, sub, meta
2. validate → schema
3. generate → JSON/CSV/MD
4. package → file or zip

## format

**JSON**
```json
{
  "metadata": {...},
  "transactions": [...],
  "obligations": [...],
  "subscriptions": [...],
  "summary": {...}
}
```

**CSV** → zip with 4 file
- transactions.csv
- obligations.csv
- subscriptions.csv
- metadata.csv

**Markdown** → single file, table + summary

## cmd
- `/export json`
- `/export csv`
- `/export markdown`
- `/export all`

## include
- all txn
- all obligation
- all sub
- meta + timestamp

no lock-in. portable.
