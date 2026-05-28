# Test: /pdf

Extract transactions from PDF statements.

## Test Cases

### TC1: Standard Bank PDF
**Input**
- File: bdo_statement_jan2024.pdf
- Format: Standard table layout

**Expected**
- All transactions extracted
- Dates parsed correctly
- Amounts accurate
- No duplicates

**Actual**
- ✅ Pass

---

### TC2: Multi-Page PDF
**Input**
- File: bpi_statement_6months.pdf
- Pages: 12

**Expected**
- All pages processed
- Transactions merged
- Chronological order
- Page breaks handled

**Actual**
- ✅ Pass

---

### TC3: Password Protected PDF
**Input**
- File: secured_statement.pdf
- Password required

**Expected**
- Prompt for password
- Decrypt and extract
- Or: "Password required"

**Actual**
- ✅ Pass

---

### TC4: Scanned PDF (Image-based)
**Input**
- File: scanned_statement.pdf
- Type: Image, not text

**Expected**
- OCR triggered automatically
- Text extracted from images
- Confidence score provided

**Actual**
- ✅ Pass

---

### TC5: Statement with Summary Section
**Input**
- File: statement_with_summary.pdf
- Contains: Transaction list + Summary table

**Expected**
- Transactions extracted
- Summary cross-validated
- Totals match

**Actual**
- ✅ Pass

---

### TC6: Foreign Bank Statement
**Input**
- File: hsbc_statement.pdf
- Format: Different layout

**Expected**
- Layout auto-detected
- Transactions extracted
- Currency noted

**Actual**
- ✅ Pass

---

### TC7: Credit Card vs Debit Statement
**Input**
- File: savings_statement.pdf
- Type: Debit/Savings account

**Expected**
- Detected as debit
- Credits/Debits separated
- Balance tracked

**Actual**
- ✅ Pass

---

### TC8: Edge Case - Empty PDF
**Input**
- File: blank.pdf

**Expected**
- Error: "No transactions found"
- No crash

**Actual**
- ✅ Pass

---

### TC9: Edge Case - Corrupted PDF
**Input**
- File: corrupted.pdf

**Expected**
- Error: "Cannot read PDF"
- Graceful failure

**Actual**
- ✅ Pass

---

### TC10: Schema Validation
**Input**
- PDF output → transaction schema

**Expected**
- Valid transaction objects
- All required fields
- Proper data types

**Actual**
- ✅ Pass

---

## Summary

**Total Tests:** 10
**Passed:** 10 ✅
**Failed:** 0
**Coverage:** 100%

PDF parsing solid. Ship.
