# /safe

Check spending limits. Risk score.

## Inputs
- Credit limit
- Current balance
- Monthly income
- Monthly recurring costs
- Spending pattern

## Process

1. **Utilization** → balance / limit (see `references/utilization-rules.md`)
2. **Debt-to-income** → recurring / income
   - <30% healthy
   - 30-50% moderate
   - 50-75% risky
   - 75%+ danger
3. **Safe threshold** → (limit × 30%) - balance OR (income × 70%) - recurring (use conservative)
4. **Risk score** → combine utilization + debt-to-income + volatility + installments (0-100)
5. **Signals** → positive/warning/danger flags

## Output

**Safety Score**
SAFE KASKAS: XX%
(100% = safe, 0% = danger)

**Status**
- Utilization: XX%
- Debt-to-income: XX%
- Monthly recurring: PHP XX
- Safe threshold: PHP XX

**Positive**
- Utilization <30%
- Debt-to-income <30%
- Stable spend
- No overdue

**Warning**
- Utilization 30-60%
- Debt-to-income 30-50%
- Spending spikes
- 3+ installments
- Subscription creep

**Danger**
- Utilization >60%
- Debt-to-income >50%
- Overdue items
- 5+ installments
- Spike >20%

**Action**
- Safe → maintain
- Moderate → cut discretionary
- Risky → consolidate, cancel subs
- Danger → seek counseling

Concise. Show math.
