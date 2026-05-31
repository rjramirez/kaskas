# /due

Track due. Bill. Subscription. Loan.

## in
- type: card/sub/loan/bill
- amount
- due date
- freq: once/monthly/quarterly/annual

## do
1. extract → type, amount, due, freq
2. normalize → YYYY-MM-DD, calc days left
3. find overlap → dues ±3d = cash spike
4. sum monthly → total outflow
5. flag risk → overdue, overlap, >30% income, 5+ items
6. sort → nearest first

## out

| item | type | amount | due | days |
|------|------|--------|-----|------|

## summary
- monthly total
- next due
- overdue count

## risk
- overlap ±3d
- >50% income
- overdue
- 5+ obligations

## tip
- consolidate dates
- remind 3d before
- cancel unused

table only.
