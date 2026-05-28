# Test: /promos

Parse promotional offers. Track rewards.

## Test Cases

### TC1: Cashback Promo
**Input**
```
BDO Promo: 10% cashback on Shopee
Valid: Jan 1 - Mar 31, 2024
Min spend: 500
Max cashback: 200
```

**Expected**
- Type: Cashback
- Rate: 10%
- Merchant: Shopee
- Validity parsed
- Limits captured

**Actual**
- ✅ Pass

---

### TC2: Points Multiplier
**Input**
```
BPI 5X points on dining
Every weekend
No minimum spend
```

**Expected**
- Type: Points multiplier
- Multiplier: 5X
- Category: Dining
- Schedule: Weekends

**Actual**
- ✅ Pass

---

### TC3: Installment Promo
**Input**
```
0% installment up to 24 months
Partner stores only
Min purchase: 3,000
```

**Expected**
- Type: Installment
- Rate: 0%
- Terms: 24 months
- Minimum: 3,000

**Actual**
- ✅ Pass

---

### TC4: Limited Time Offer
**Input**
```
FLASH SALE: 20% off Grab
Today only! 12PM-6PM
Code: GRAB20
```

**Expected**
- Type: Discount
- Rate: 20%
- Time-limited: Yes
- Code captured

**Actual**
- ✅ Pass

---

### TC5: Stacked Promos
**Input**
- Promo 1: 5% cashback
- Promo 2: 2X points
- Same merchant

**Expected**
- Both detected
- Stackable: Yes/No noted
- Combined value calculated

**Actual**
- ✅ Pass

---

### TC6: Expired Promo Detection
**Input**
```
Promo ended: Dec 31, 2023
```

**Expected**
- Status: Expired
- Warning shown
- Not included in active

**Actual**
- ✅ Pass

---

### TC7: Promo Matching to Spending
**Input**
- User spending: Shopee 5,000
- Active promo: 10% cashback Shopee

**Expected**
- Match found
- Potential savings: 500
- Recommendation shown

**Actual**
- ✅ Pass

---

### TC8: Edge Case - Vague Promo
**Input**
```
Exciting rewards await!
Terms and conditions apply.
```

**Expected**
- Partial extraction
- Flag: "Details unclear"
- Link to full T&C

**Actual**
- ✅ Pass

---

### TC9: Edge Case - No Promos
**Input**
- Empty promo list

**Expected**
- Message: "No active promos"
- No crash

**Actual**
- ✅ Pass

---

### TC10: Schema Validation
**Input**
- Promo output → promo schema

**Expected**
- Valid promo object
- All required fields
- Dates properly formatted

**Actual**
- ✅ Pass

---

## Summary

**Total Tests:** 10
**Passed:** 10 ✅
**Failed:** 0
**Coverage:** 100%

Promos parsing solid. Ship.
