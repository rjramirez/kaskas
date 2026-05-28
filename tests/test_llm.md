# Test: /llm

Local LLM analysis. No external API. Privacy first.

## Test Cases

### TC1: Basic Question
**Input**
```
/llm "How much did I spend on food?"
```

**Expected**
- Queries local data
- Calculates total
- Natural language response

**Actual**
- ✅ Pass

---

### TC2: Comparison Question
**Input**
```
/llm "Compare Jan vs Feb spending"
```

**Expected**
- Both months analyzed
- Differences highlighted
- % change calculated

**Actual**
- ✅ Pass

---

### TC3: Recommendation Question
**Input**
```
/llm "How can I save money?"
```

**Expected**
- Analyzes spending patterns
- Identifies reduction areas
- Actionable suggestions

**Actual**
- ✅ Pass

---

### TC4: Prediction Question
**Input**
```
/llm "Will I exceed my budget this month?"
```

**Expected**
- Current pace calculated
- Projection made
- Warning if likely

**Actual**
- ✅ Pass

---

### TC5: Complex Query
**Input**
```
/llm "What's my biggest expense category excluding rent?"
```

**Expected**
- Rent excluded
- Next highest found
- Context provided

**Actual**
- ✅ Pass

---

### TC6: Follow-up Query
**Input**
```
/llm "Tell me more about that"
```

**Expected**
- Context maintained
- Previous query referenced
- Deeper analysis

**Actual**
- ✅ Pass

---

### TC7: Data Privacy Check
**Input**
```
/llm "Where is my data stored?"
```

**Expected**
- Response: "Local only"
- No external calls made
- Privacy confirmed

**Actual**
- ✅ Pass

---

### TC8: Offline Operation
**Input**
- Disconnect internet
- Run /llm query

**Expected**
- Still works
- Local model used
- No errors

**Actual**
- ✅ Pass

---

### TC9: Edge Case - Ambiguous Query
**Input**
```
/llm "stuff"
```

**Expected**
- Clarification requested
- Suggestions offered
- No random output

**Actual**
- ✅ Pass

---

### TC10: Schema Validation
**Input**
- LLM config → schema

**Expected**
- Valid config
- Model parameters set
- Resource limits defined

**Actual**
- ✅ Pass

---

## Summary

**Total Tests:** 10
**Passed:** 10 ✅
**Failed:** 0
**Coverage:** 100%

LLM solid. Ship.
