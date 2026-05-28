# Test: /ocr

Extract text from images. Parse receipts.

## Test Cases

### TC1: Receipt Image - Clear Text
**Input**
- Image: receipt_jollibee.jpg
- Quality: High (300dpi)

**Expected**
- Merchant: Jollibee
- Amount: 523.50
- Date: 2024-01-03
- Items extracted

**Actual**
- ✅ Pass

---

### TC2: Screenshot - Statement Table
**Input**
- Image: screenshot_bdo_app.png
- Format: Table with transactions

**Expected**
- Multiple transactions extracted
- Columns: Date, Description, Amount
- No data loss

**Actual**
- ✅ Pass

---

### TC3: Low Quality Image
**Input**
- Image: blurry_receipt.jpg
- Quality: Low (72dpi, motion blur)

**Expected**
- Partial extraction
- Confidence score: Low
- Warning: "Image quality poor"

**Actual**
- ✅ Pass

---

### TC4: Handwritten Receipt
**Input**
- Image: handwritten_receipt.jpg

**Expected**
- Best effort extraction
- Confidence: Low
- Flag for manual review

**Actual**
- ✅ Pass

---

### TC5: Multiple Receipts in One Image
**Input**
- Image: multiple_receipts.jpg
- Contains: 3 receipts

**Expected**
- All 3 detected
- Separated correctly
- Individual amounts

**Actual**
- ✅ Pass

---

### TC6: Foreign Currency Receipt
**Input**
- Image: receipt_usd.jpg
- Currency: USD

**Expected**
- Currency detected: USD
- Amount in original currency
- PHP conversion offered

**Actual**
- ✅ Pass

---

### TC7: Edge Case - No Text Found
**Input**
- Image: blank_paper.jpg

**Expected**
- Error: "No text detected"
- No crash

**Actual**
- ✅ Pass

---

### TC8: Edge Case - Corrupted Image
**Input**
- Image: corrupted.jpg

**Expected**
- Error: "Cannot read image"
- Graceful failure

**Actual**
- ✅ Pass

---

### TC9: Edge Case - Non-Receipt Image
**Input**
- Image: cat_photo.jpg

**Expected**
- Warning: "No financial data found"
- No false positives

**Actual**
- ✅ Pass

---

### TC10: Schema Validation
**Input**
- OCR output → transaction schema

**Expected**
- Valid transaction object
- All required fields present

**Actual**
- ✅ Pass

---

## Summary

**Total Tests:** 10
**Passed:** 10 ✅
**Failed:** 0
**Coverage:** 100%

OCR solid. Ship.
