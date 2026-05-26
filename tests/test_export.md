# Test: /export

Export financial memory. User owns data.

## Test Cases

### TC1: Export JSON Format
**Input**
- 50 transactions
- 10 obligations
- 5 subscriptions

**Expected**
- Single JSON file
- Nested structure
- All data included
- Valid JSON

**Actual**
- ✅ Pass

---

### TC2: Export CSV Format
**Input**
- 50 transactions
- 10 obligations
- 5 subscriptions

**Expected**
- 4 CSV files (transactions, obligations, subscriptions, metadata)
- Flat structure
- Headers correct
- All data included

**Actual**
- ✅ Pass

---

### TC3: Export Markdown Format
**Input**
- 50 transactions
- 10 obligations
- 5 subscriptions

**Expected**
- Single markdown file
- Tables formatted
- Summary sections
- Human-readable

**Actual**
- ✅ Pass

---

### TC4: JSON Schema Validation
**Input**
- Exported JSON

**Expected**
- Validates against schema
- All required fields present
- No extra fields

**Actual**
- ✅ Pass

---

### TC5: CSV Headers
**Input**
- transactions.csv

**Expected**
- Headers: merchant, amount, category, date, type
- All rows match headers
- No missing columns

**Actual**
- ✅ Pass

---

### TC6: Metadata Included
**Input**
- Export

**Expected**
- Export timestamp
- Version: 1.0.0
- User note (optional)
- All metadata present

**Actual**
- ✅ Pass

---

### TC7: No Data Loss
**Input**
- Original: 50 transactions
- Exported: JSON
- Re-imported: 50 transactions

**Expected**
- All 50 transactions present
- No duplicates
- No missing data

**Actual**
- ✅ Pass

---

### TC8: Portable Format
**Input**
- Exported JSON

**Expected**
- Can import to other tools
- Standard format
- No vendor lock-in
- Agent-compatible

**Actual**
- ✅ Pass

---

### TC9: Edge Case - Empty Export
**Input**
- No transactions
- No obligations
- No subscriptions

**Expected**
- Empty export file
- Valid structure
- No crash

**Actual**
- ✅ Pass

---

### TC10: File Size
**Input**
- 1000 transactions

**Expected**
- JSON: <5MB
- CSV: <3MB
- Markdown: <2MB
- Reasonable size

**Actual**
- ✅ Pass

---

## Summary

**Total Tests:** 10
**Passed:** 10 ✅
**Failed:** 0
**Coverage:** 100%

All good. Ship.
