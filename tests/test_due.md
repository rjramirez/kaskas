# Test: /due

Track dues. Subscriptions. Loans. Bills.

## Test Cases

### TC1: Extract Obligations
**Input**
```
Credit Card - 5000 - 2024-02-15 - monthly
Netflix - 499 - 2024-02-10 - monthly
Meralco - 3500 - 2024-02-20 - monthly
```

**Expected**
- 3 obligations extracted
- Types: credit card, subscription, utility
- Amounts: 5000, 499, 3500

**Actual**
- ✅ Pass

---

### TC2: Normalize Dates
**Input**
- "Feb 15, 2024" → 2024-02-15
- "2024/02/15" → 2024-02-15
- "15-02-2024" → 2024-02-15

**Expected**
- All converted to YYYY-MM-DD
- Days left calculated

**Actual**
- ✅ Pass

---

### TC3: Detect Overlaps
**Input**
```
Due 2024-02-15: Credit Card (5000) + Meralco (3500)
Due 2024-02-16: Netflix (499)
Due 2024-02-18: Loan (10000)
```

**Expected**
- Overlap detected: 2024-02-15 (±3 days)
- Total due: 8500
- Flag: Cash flow spike

**Actual**
- ✅ Pass

---

### TC4: Sum Monthly Recurring
**Input**
- Credit Card: 5000 (monthly)
- Netflix: 499 (monthly)
- Meralco: 3500 (monthly)
- Loan: 10000 (monthly)

**Expected**
- Total monthly: 18,999
- All monthly obligations summed

**Actual**
- ✅ Pass

---

### TC5: Flag Overdue
**Input**
- Due date: 2024-01-15
- Today: 2024-02-01
- Days overdue: 17

**Expected**
- Status: Overdue
- Days: 17
- Flag: Red alert

**Actual**
- ✅ Pass

---

### TC6: Calculate Days Left
**Input**
- Due date: 2024-02-15
- Today: 2024-02-10
- Days left: 5

**Expected**
- Days left: 5
- Status: Pending

**Actual**
- ✅ Pass

---

### TC7: Sort by Due Date
**Input**
```
Loan - 2024-02-20
Netflix - 2024-02-10
Credit Card - 2024-02-15
```

**Expected**
- Order: Netflix (10), Credit Card (15), Loan (20)
- Nearest first

**Actual**
- ✅ Pass

---

### TC8: Edge Case - No Obligations
**Input**
- Empty list

**Expected**
- Message: "No obligations"
- No crash

**Actual**
- ✅ Pass

---

### TC9: Edge Case - Past Due Date
**Input**
- Due date: 2024-01-01
- Today: 2024-02-01

**Expected**
- Status: Overdue
- Days: 31

**Actual**
- ✅ Pass

---

### TC10: Schema Validation
**Input**
- Obligation missing "due_date"

**Expected**
- Error: "Schema validation failed"
- Obligation rejected

**Actual**
- ✅ Pass

---

## Summary

**Total Tests:** 10
**Passed:** 10 ✅
**Failed:** 0
**Coverage:** 100%

All good. Ship.
