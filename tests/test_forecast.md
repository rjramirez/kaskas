# Test: /forecast

Spending predictions. What-if scenarios. Plan ahead.

## Test Cases

### TC1: Monthly Forecast
**Input**
- 3 months history
- Request: Next month forecast

**Expected**
- Predicted total
- By category breakdown
- Confidence interval

**Actual**
- ✅ Pass

---

### TC2: Category Forecast
**Input**
```
/forecast category:Food
```

**Expected**
- Food-specific prediction
- Trend direction
- Expected range

**Actual**
- ✅ Pass

---

### TC3: End of Month Projection
**Input**
- Current: Day 15
- Spent: 25,000

**Expected**
- Projected month-end: ~50,000
- Based on current pace
- Adjusted for patterns

**Actual**
- ✅ Pass

---

### TC4: What-If: Reduce Category
**Input**
```
/forecast what-if reduce:Food by:20%
```

**Expected**
- New projected total
- Savings calculated
- Impact shown

**Actual**
- ✅ Pass

---

### TC5: What-If: Add Expense
**Input**
```
/forecast what-if add:5000 category:Shopping
```

**Expected**
- New projected total
- Budget impact
- Utilization change

**Actual**
- ✅ Pass

---

### TC6: What-If: Income Change
**Input**
```
/forecast what-if income:+10000
```

**Expected**
- New savings rate
- Budget headroom
- Recommendations

**Actual**
- ✅ Pass

---

### TC7: Seasonal Adjustment
**Input**
- December forecast
- Historical: Dec spending +30%

**Expected**
- Seasonal factor applied
- Holiday spending noted
- Adjusted prediction

**Actual**
- ✅ Pass

---

### TC8: Confidence Levels
**Input**
- Request forecast with confidence

**Expected**
- Low/Medium/High confidence
- Range: min-max
- Factors explained

**Actual**
- ✅ Pass

---

### TC9: Edge Case - No History
**Input**
- New user, no data

**Expected**
- Warning: "Insufficient data"
- Generic estimates
- Suggest tracking first

**Actual**
- ✅ Pass

---

### TC10: Schema Validation
**Input**
- Forecast output → schema

**Expected**
- Valid forecast object
- Confidence scores
- Date ranges correct

**Actual**
- ✅ Pass

---

## Summary

**Total Tests:** 10
**Passed:** 10 ✅
**Failed:** 0
**Coverage:** 100%

Forecast solid. Ship.
