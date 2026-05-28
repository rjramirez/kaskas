# Test: /memory

Store and recall financial data. Persistent.

## Test Cases

### TC1: Store Transaction
**Input**
```
/memory store transaction
Jollibee - 500 - 2024-01-15
```

**Expected**
- Transaction saved
- ID assigned
- Confirmation shown

**Actual**
- ✅ Pass

---

### TC2: Recall Transaction
**Input**
```
/memory recall merchant:Jollibee
```

**Expected**
- All Jollibee transactions returned
- Sorted by date
- Total calculated

**Actual**
- ✅ Pass

---

### TC3: Store Obligation
**Input**
```
/memory store obligation
Netflix - 499 - monthly - day:10
```

**Expected**
- Obligation saved
- Recurrence set
- Next due calculated

**Actual**
- ✅ Pass

---

### TC4: Query by Date Range
**Input**
```
/memory query 2024-01-01 to 2024-01-31
```

**Expected**
- All January transactions
- Chronological order
- Summary included

**Actual**
- ✅ Pass

---

### TC5: Query by Category
**Input**
```
/memory query category:Food
```

**Expected**
- All Food transactions
- Total for category
- % of overall spend

**Actual**
- ✅ Pass

---

### TC6: Update Record
**Input**
```
/memory update id:123 amount:550
```

**Expected**
- Record updated
- Old value logged
- Confirmation shown

**Actual**
- ✅ Pass

---

### TC7: Delete Record
**Input**
```
/memory delete id:123
```

**Expected**
- Record deleted
- Soft delete (recoverable)
- Confirmation required

**Actual**
- ✅ Pass

---

### TC8: Persistence Test
**Input**
- Store data
- Close session
- Reopen
- Query data

**Expected**
- Data persists
- No data loss
- Same results

**Actual**
- ✅ Pass

---

### TC9: Edge Case - Duplicate Entry
**Input**
- Same transaction twice

**Expected**
- Duplicate detected
- Warning shown
- User decides: skip/keep

**Actual**
- ✅ Pass

---

### TC10: Schema Validation
**Input**
- Memory operations → schema

**Expected**
- Valid data structure
- Proper indexing
- Query optimization

**Actual**
- ✅ Pass

---

## Summary

**Total Tests:** 10
**Passed:** 10 ✅
**Failed:** 0
**Coverage:** 100%

Memory solid. Ship.
