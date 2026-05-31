# /review

Read statement. Find spend. Show pattern.

## in
- PDF / paste / screenshot / receipt

## do
1. extract → merchant, amount, date
2. match cat → `references/merchant-categories.md`
3. find recurring → same merchant 2x, monthly ±5d, amount ±10%
4. flag installment → "0%", sequential
5. calc util → spend/limit (`references/utilization-rules.md`)
6. output → `templates/summary.md`

## out

| show | what |
|------|------|
| total | sum spend |
| count | txn count |
| range | date start-end |
| top cat | by amount |
| top merchant | by freq+spend |
| recurring | merchant, monthly est, confidence |

## risk
- util >60%
- 3+ installment
- 5+ subscription
- spike >20%

## opp
- better card → `/offers`
- cut spend
- cancel unused

table only. no prose.
