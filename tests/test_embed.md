# Test: /embed

Semantic search on transactions. Vector similarity.

## Test Cases

### TC1: Basic Semantic Search
**Input**
```
/embed search "food delivery"
```

**Expected**
- Returns: GrabFood, Foodpanda, Jollibee Delivery
- Ranked by relevance
- Not just keyword match

**Actual**
- ✅ Pass

---

### TC2: Conceptual Search
**Input**
```
/embed search "entertainment expenses"
```

**Expected**
- Returns: Netflix, Spotify, Timezone, YouTube
- Understands "entertainment" concept
- Groups related items

**Actual**
- ✅ Pass

---

### TC3: Typo Tolerance
**Input**
```
/embed search "jolibie"
```

**Expected**
- Returns: Jollibee transactions
- Fuzzy matching works
- Suggests correction

**Actual**
- ✅ Pass

---

### TC4: Negative Search
**Input**
```
/embed search "not food"
```

**Expected**
- Excludes food category
- Returns non-food items
- Understands negation

**Actual**
- ✅ Pass

---

### TC5: Amount-based Search
**Input**
```
/embed search "big purchases over 5000"
```

**Expected**
- Returns transactions > 5000
- Understands "big" = high amount
- Sorted by amount desc

**Actual**
- ✅ Pass

---

### TC6: Time-based Search
**Input**
```
/embed search "last week spending"
```

**Expected**
- Returns recent 7 days
- Understands relative time
- Correct date range

**Actual**
- ✅ Pass

---

### TC7: Combined Search
**Input**
```
/embed search "food near payday"
```

**Expected**
- Food transactions
- Around 15th/30th of month
- Pattern detected

**Actual**
- ✅ Pass

---

### TC8: Similar Transactions
**Input**
```
/embed similar id:123
```

**Expected**
- Finds similar transactions
- Same merchant/category/amount range
- Useful for patterns

**Actual**
- ✅ Pass

---

### TC9: Edge Case - No Results
**Input**
```
/embed search "spaceship rental"
```

**Expected**
- Message: "No matching transactions"
- Suggestions offered
- No crash

**Actual**
- ✅ Pass

---

### TC10: Schema Validation
**Input**
- Embedding output → schema

**Expected**
- Valid vector format
- Proper dimensions
- Searchable index

**Actual**
- ✅ Pass

---

## Summary

**Total Tests:** 10
**Passed:** 10 ✅
**Failed:** 0
**Coverage:** 100%

Embed solid. Ship.
