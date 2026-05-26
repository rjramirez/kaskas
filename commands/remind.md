# /remind

Proactive alerts. Smart notifications.

## Input
- Obligations (from `/due`)
- Subscriptions (from `/subscriptions`)
- Spending patterns (from `/insights`)
- User preferences

## Process

1. **Detect triggers** → upcoming dues, anomalies, patterns
2. **Generate alerts** → based on rules + ML
3. **Schedule** → send at optimal time
4. **Track** → user acknowledgment
5. **Learn** → improve timing over time

## Alert Types

**Due Reminders**
- 7 days before due date
- 3 days before due date
- 1 day before due date
- On due date

**Spending Alerts**
- Category spike (>30% above avg)
- Unusual merchant (new vendor)
- Subscription added (new charge)
- Utilization high (>60%)

**Opportunity Alerts**
- Unused subscription (low activity)
- Better card available (for spending)
- Cashback opportunity (high spend category)
- Consolidation opportunity (similar merchants)

**Anomaly Alerts**
- Duplicate charge (same merchant, same day)
- Unusual time (spending at odd hours)
- Unusual location (if available)
- Fraud risk (pattern mismatch)

## Commands

- `/remind list` → show all active reminders
- `/remind add [type] [trigger]` → create reminder
- `/remind snooze [id] [days]` → delay reminder
- `/remind dismiss [id]` → ignore reminder
- `/remind settings` → configure preferences

## Timing

Smart scheduling:
- Morning: due reminders (7am)
- Afternoon: spending alerts (2pm)
- Evening: insights (6pm)
- Customizable per user

## Privacy

- Local only
- No external notifications
- User controls all alerts
- Can disable anytime

Smart. Timely. Helpful.
