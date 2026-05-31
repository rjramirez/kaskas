# /safe

Check limit. Risk score.

## in
- credit limit
- balance
- income
- recurring
- spend pattern

## do
1. util → balance/limit (`references/utilization-rules.md`)
2. debt-to-income → recurring/income
   - <30% good
   - 30-50% ok
   - 50-75% bad
   - 75%+ danger
3. safe threshold → min(limit×30%-balance, income×70%-recurring)
4. risk score → 0-100 (util + DTI + volatility + installments)

## out

```
SAFE KASKAS: XX%
(100=safe, 0=danger)
```

| metric | value |
|--------|-------|
| util | XX% |
| DTI | XX% |
| recurring | PHP XX |
| safe spend | PHP XX |

## signal

| good | warn | danger |
|------|------|--------|
| util <30% | util 30-60% | util >60% |
| DTI <30% | DTI 30-50% | DTI >50% |
| stable | spike | overdue |
| no overdue | 3+ installment | 5+ installment |

## action
- safe → maintain
- moderate → cut discretionary
- risky → consolidate, cancel sub
- danger → seek help

show math.
