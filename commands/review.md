# /review

Parse statements. Extract spend. Find patterns.

## Input
- PDF statements
- Pasted transactions
- Screenshots
- Receipts

## Process

1. **Extract** → merchant, amount, date
2. **Normalize** → match categories (see `references/merchant-categories.md`)
3. **Detect recurring** → same merchant 2+ times, monthly cadence ±5 days, amount ±10%
4. **Flag installments** → "installment" keyword, "0%", sequential charges
5. **Calculate utilization** → spend / limit (see `references/utilization-rules.md`)
6. **Summarize** → use `templates/summary.md`

## Output

**Summary**
- Total spend
- Transaction count
- Date range
- Top categories (by amount)
- Top merchants (by frequency + spend)

**Recurring**
- Merchant
- Est. monthly
- Confidence (high/medium/low)

**Risks**
- Utilization >60%
- 3+ installments active
- 5+ subscriptions
- Spending spike >20%

**Opportunities**
- Cashback optimization → `/offers`
- Spending cuts
- Cancel unused subscriptions

Concise. Tables only.
