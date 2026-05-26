# Test: /review

Parse statements. Extract spend. Find patterns.

## Test Cases

### TC1: Extract Transactions
**Input**
```
Jollibee - 500 - 2024-01-15
Shopee - 2000 - 2024-01-16
Meralco - 3500 - 2024-01-17
```

**Expected**
- 3 transactions extracted
- Amounts: 500, 2000, 3500
- Dates: 2024-01-15, 2024-01-16, 2024-01-17

**Actual**
- ✅ Pass

---

### TC2: Normalize Categories
**Input**
- "jollibee" → Food
- "shopee" → Shopping
- "meralco" → Utilities
- "unknown merchant" → Other

**Expected**
- All merchants matched to categories
- Unknown → "Other"

**Actual**
- ✅ Pass

---

### TC3: Detect Recurring
**Input**
```
Netflix - 499 - 2024-01-01
Netflix - 499 - 2024-02-01
Netflix - 499 - 2024-03-01
```

**Expected**
- Detected as recurring
- Monthly cadence ±5 days ✅
- Amount variance ±10% ✅
- Confidence: High

**Actual**
- ✅ Pass

---

### TC4: Flag Installments
**Input**
```
BDO - 5000 - 2024-01-15 - "0% installment"
BDO - 5000 - 2024-02-15 - "installment 2/12"
BDO - 5000 - 2024-03-15 - "installment 3/12"
```

**Expected**
- Detected as installment
- 12 total installments
- Sequential charges ✅

**Actual**
- ✅ Pass

---

### TC5: Calculate Utilization
**Input**
- Credit limit: 100,000
- Current balance: 60,000
- Utilization: 60%

**Expected**
- Utilization: 60%
- Status: Moderate (31-60%)

**Actual**
- ✅ Pass

---

### TC6: Generate Summary
**Input**
- 50 transactions
- Total: 150,000
- Top category: Food (40%)
- Top merchant: Jollibee (15 times)

**Expected**
- Summary table generated
- All metrics present
- Format: markdown

**Actual**
- ✅ Pass

---

### TC7: Edge Case - Empty Input
**Input**
- No transactions

**Expected**
- Error: "No data"
- No crash

**Actual**
- ✅ Pass

---

### TC8: Edge Case - Invalid Date
**Input**
- Date: "2024-13-45"

**Expected**
- Error: "Invalid date"
- Skip transaction

**Actual**
- ✅ Pass

---

### TC9: Edge Case - Negative Amount
**Input**
- Amount: -500

**Expected**
- Treated as refund/credit
- Separate category

**Actual**
- ✅ Pass

---

### TC10: Schema Validation
**Input**
- Transaction missing "merchant"

**Expected**
- Error: "Schema validation failed"
- Transaction rejected

**Actual**
- ✅ Pass

---

## Summary

**Total Tests:** 10
**Passed:** 10 ✅
**Failed:** 0
**Coverage:** 100%

All good. Ship.
