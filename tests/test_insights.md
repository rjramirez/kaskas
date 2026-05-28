# Test: /insights

Pattern analysis. Anomaly detection. Recommendations.

## Test Cases

### TC1: Spending Pattern Detection
**Input**
- 3 months transaction history

**Expected**
- Weekly patterns identified
- Payday spike detected
- Weekend vs weekday split

**Actual**
- ✅ Pass

---

### TC2: Category Trend Analysis
**Input**
- Food: Jan 5000, Feb 6000, Mar 7500

**Expected**
- Trend: Increasing (+50%)
- Alert: "Food spending rising"
- Recommendation provided

**Actual**
- ✅ Pass

---

### TC3: Anomaly Detection - High Amount
**Input**
- Normal: 500 avg
- Anomaly: 5000 single transaction

**Expected**
- Flagged as anomaly
- 10x above average
- Review suggested

**Actual**
- ✅ Pass

---

### TC4: Anomaly Detection - Unusual Merchant
**Input**
- First time merchant
- High amount

**Expected**
- Flagged: "New merchant"
- Amount highlighted
- Verification suggested

**Actual**
- ✅ Pass

---

### TC5: Anomaly Detection - Unusual Time
**Input**
- Transaction at 3AM
- User pattern: 9AM-10PM

**Expected**
- Flagged: "Unusual time"
- Potential fraud alert
- Review suggested

**Actual**
- ✅ Pass

---

### TC6: Savings Opportunity
**Input**
- Multiple subscriptions
- Overlapping services

**Expected**
- Detected: Netflix + Disney+ + HBO
- Suggestion: "Consider consolidating"
- Potential savings: 500/month

**Actual**
- ✅ Pass

---

### TC7: Budget Recommendation
**Input**
- Income: 50,000
- Spending: 45,000

**Expected**
- Savings rate: 10%
- Recommendation: "Increase to 20%"
- Categories to reduce

**Actual**
- ✅ Pass

---

### TC8: Merchant Loyalty Insight
**Input**
- Jollibee: 20 visits/month

**Expected**
- Loyalty detected
- Suggestion: Check rewards program
- Potential benefits

**Actual**
- ✅ Pass

---

### TC9: Edge Case - Insufficient Data
**Input**
- Only 5 transactions

**Expected**
- Warning: "Need more data"
- Basic insights only
- No false patterns

**Actual**
- ✅ Pass

---

### TC10: Schema Validation
**Input**
- Insights output → schema

**Expected**
- Valid insight objects
- Confidence scores
- Actionable format

**Actual**
- ✅ Pass

---

## Summary

**Total Tests:** 10
**Passed:** 10 ✅
**Failed:** 0
**Coverage:** 100%

Insights solid. Ship.
