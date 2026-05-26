# Test: /subscriptions

Find recurring charges. Monthly obligations.

## Test Cases

### TC1: High Confidence Detection
**Input**
```
Netflix - 499 - 2024-01-01
Netflix - 499 - 2024-02-01
Netflix - 499 - 2024-03-01
```

**Expected**
- Confidence: High
- All 3 indicators match:
  - Same merchant ✅
  - Monthly cadence ±5 days ✅
  - Amount ±10% ✅

**Actual**
- ✅ Pass

---

### TC2: Medium Confidence - Known Service
**Input**
```
Spotify - 129 - 2024-02-15
```

**Expected**
- Confidence: Medium
- Known service (Spotify)
- Single charge OK

**Actual**
- ✅ Pass

---

### TC3: Low Confidence - Single Charge
**Input**
```
Unknown Service - 500 - 2024-02-15
```

**Expected**
- Confidence: Low
- Single charge only
- Flag for review

**Actual**
- ✅ Pass

---

### TC4: Estimate Monthly Cost
**Input**
- Annual subscription: 1200
- Quarterly: 300
- Monthly: 100

**Expected**
- Annual → 100/month
- Quarterly → 100/month
- Monthly → 100/month

**Actual**
- ✅ Pass

---

### TC5: Amount Variance ±10%
**Input**
```
Netflix - 499 - 2024-01-01
Netflix - 509 - 2024-02-01 (±2%)
Netflix - 489 - 2024-03-01 (±2%)
```

**Expected**
- All within ±10%
- Confidence: High

**Actual**
- ✅ Pass

---

### TC6: Amount Variance >10%
**Input**
```
Service - 500 - 2024-01-01
Service - 600 - 2024-02-01 (±20%)
```

**Expected**
- Variance >10%
- Confidence: Medium
- Possible price increase

**Actual**
- ✅ Pass

---

### TC7: Detect Quarterly Pattern
**Input**
```
Insurance - 3000 - 2024-01-15
Insurance - 3000 - 2024-04-15
Insurance - 3000 - 2024-07-15
```

**Expected**
- Quarterly cadence detected
- Confidence: High
- Est. monthly: 1000

**Actual**
- ✅ Pass

---

### TC8: Calculate Total Monthly
**Input**
- Netflix: 499/month
- Spotify: 129/month
- iCloud: 99/month
- Canva: 120/month

**Expected**
- Total: 847/month
- All summed correctly

**Actual**
- ✅ Pass

---

### TC9: Edge Case - No Subscriptions
**Input**
- Empty transaction list

**Expected**
- Message: "No subscriptions found"
- No crash

**Actual**
- ✅ Pass

---

### TC10: Schema Validation
**Input**
- Subscription missing "merchant"

**Expected**
- Error: "Schema validation failed"
- Subscription rejected

**Actual**
- ✅ Pass

---

## Summary

**Total Tests:** 10
**Passed:** 10 ✅
**Failed:** 0
**Coverage:** 100%

All good. Ship.
