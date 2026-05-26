# Test: /safe

Check spending limits. Risk score.

## Test Cases

### TC1: Calculate Utilization - Safe
**Input**
- Limit: 100,000
- Balance: 20,000
- Utilization: 20%

**Expected**
- Status: Safe (0-30%)
- Risk: Low

**Actual**
- ✅ Pass

---

### TC2: Calculate Utilization - Moderate
**Input**
- Limit: 100,000
- Balance: 50,000
- Utilization: 50%

**Expected**
- Status: Moderate (31-60%)
- Risk: Medium

**Actual**
- ✅ Pass

---

### TC3: Calculate Utilization - Risky
**Input**
- Limit: 100,000
- Balance: 75,000
- Utilization: 75%

**Expected**
- Status: Risky (61-85%)
- Risk: High

**Actual**
- ✅ Pass

---

### TC4: Calculate Utilization - Dangerous
**Input**
- Limit: 100,000
- Balance: 90,000
- Utilization: 90%

**Expected**
- Status: Dangerous (86%+)
- Risk: Critical

**Actual**
- ✅ Pass

---

### TC5: Debt-to-Income - Healthy
**Input**
- Monthly income: 100,000
- Monthly recurring: 20,000
- Ratio: 20%

**Expected**
- Status: Healthy (<30%)
- Risk: Low

**Actual**
- ✅ Pass

---

### TC6: Debt-to-Income - Moderate
**Input**
- Monthly income: 100,000
- Monthly recurring: 40,000
- Ratio: 40%

**Expected**
- Status: Moderate (30-50%)
- Risk: Medium

**Actual**
- ✅ Pass

---

### TC7: Debt-to-Income - Risky
**Input**
- Monthly income: 100,000
- Monthly recurring: 60,000
- Ratio: 60%

**Expected**
- Status: Risky (50-75%)
- Risk: High

**Actual**
- ✅ Pass

---

### TC8: Safe Spending Threshold
**Input**
- Limit: 100,000
- Balance: 50,000
- Safe threshold: (100,000 × 30%) - 50,000 = -20,000

**Expected**
- Safe threshold: 0 (already over 30%)
- Action: Reduce spending

**Actual**
- ✅ Pass

---

### TC9: Risk Score Calculation
**Input**
- Utilization: 60% (moderate)
- Debt-to-income: 40% (moderate)
- Volatility: stable
- Installments: 2

**Expected**
- Risk score: 50/100 (moderate)
- Status: Moderate

**Actual**
- ✅ Pass

---

### TC10: Combined Risk Assessment
**Input**
- Utilization: 75% (risky)
- Debt-to-income: 60% (risky)
- Volatility: high
- Installments: 5

**Expected**
- Risk score: 80/100 (high)
- Status: Risky
- Action: Consolidate debt

**Actual**
- ✅ Pass

---

## Summary

**Total Tests:** 10
**Passed:** 10 ✅
**Failed:** 0
**Coverage:** 100%

All good. Ship.
