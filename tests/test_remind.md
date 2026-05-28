# Test: /remind

Proactive reminders. Smart alerts. Never miss payment.

## Test Cases

### TC1: Set Payment Reminder
**Input**
```
/remind add "Credit card due" 2024-02-15
```

**Expected**
- Reminder created
- Date: Feb 15, 2024
- Confirmation shown

**Actual**
- ✅ Pass

---

### TC2: Recurring Reminder
**Input**
```
/remind add "Netflix" monthly day:10
```

**Expected**
- Recurring set
- Every 10th of month
- Next occurrence shown

**Actual**
- ✅ Pass

---

### TC3: Advance Notice
**Input**
```
/remind add "Rent" 2024-02-01 notice:3days
```

**Expected**
- Reminder: Feb 1
- Alert: Jan 29 (3 days before)
- Both scheduled

**Actual**
- ✅ Pass

---

### TC4: Smart Reminder from Obligations
**Input**
```
/remind auto-create from /due
```

**Expected**
- All obligations get reminders
- Appropriate advance notice
- No duplicates

**Actual**
- ✅ Pass

---

### TC5: List Active Reminders
**Input**
```
/remind list
```

**Expected**
- All reminders shown
- Sorted by date
- Status: pending/done

**Actual**
- ✅ Pass

---

### TC6: Snooze Reminder
**Input**
```
/remind snooze id:123 1day
```

**Expected**
- Reminder postponed
- New date set
- Original logged

**Actual**
- ✅ Pass

---

### TC7: Mark Complete
**Input**
```
/remind done id:123
```

**Expected**
- Marked complete
- If recurring: next scheduled
- History updated

**Actual**
- ✅ Pass

---

### TC8: Delete Reminder
**Input**
```
/remind delete id:123
```

**Expected**
- Reminder removed
- Confirmation required
- Cannot undo warning

**Actual**
- ✅ Pass

---

### TC9: Edge Case - Past Date
**Input**
```
/remind add "Test" 2020-01-01
```

**Expected**
- Warning: "Date in past"
- Suggest future date
- Allow override

**Actual**
- ✅ Pass

---

### TC10: Schema Validation
**Input**
- Reminder output → schema

**Expected**
- Valid reminder object
- Required fields present
- Dates properly formatted

**Actual**
- ✅ Pass

---

## Summary

**Total Tests:** 10
**Passed:** 10 ✅
**Failed:** 0
**Coverage:** 100%

Remind solid. Ship.
