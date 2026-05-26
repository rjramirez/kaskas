# /due

Track dues. Subscriptions. Loans. Bills.

## Input
- Obligation type (credit card, subscription, loan, bill)
- Amount
- Due date
- Frequency (one-time, monthly, quarterly, annual)

## Process

1. **Extract** → type, amount, due date, frequency
2. **Normalize dates** → YYYY-MM-DD, calc days left
3. **Detect overlaps** → dues within 3 days = cash flow spike
4. **Sum recurring** → total monthly outflow
5. **Flag risks** → overdue, overlapping, high cost (>30% income), 5+ obligations
6. **Sort** → by due date (nearest first)

## Output

**Upcoming (Next 30 Days)**
| Item | Type | Amount | Due | Days |
|---|---|---|---|---|

**Summary**
- Total monthly recurring
- Next due date
- Overdue count

**Risks**
- Overlapping dues (±3 days)
- High recurring (>50% income)
- Overdue items
- Complexity (5+ obligations)

**Tips**
- Consolidate payment dates
- Reminders 3 days before
- Cancel unused subscriptions

Tactical. Tables only.
