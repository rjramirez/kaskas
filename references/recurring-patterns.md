# Recurring Patterns

## Detection Indicators

### Strong Subscription Signals
Known subscription services (high confidence):
- Netflix
- Spotify
- YouTube Premium
- Disney+
- Amazon Prime
- Canva
- ChatGPT Plus
- iCloud
- Adobe Creative Cloud
- Microsoft 365
- Dropbox
- Notion
- Figma
- Slack
- Zoom
- Grammarly

### Pattern Matching Rules

**High Confidence (all 3 match):**
1. Same merchant appears 2+ times in data
2. Monthly cadence: charges ±5 days apart
3. Similar amounts: variance ±10%

**Medium Confidence (2 of 3 match):**
- Known subscription service (even if only 1 charge)
- Merchant name contains keywords: "subscription", "membership", "premium"
- Quarterly or annual pattern (every 3 or 12 months)

**Low Confidence (1 indicator):**
- Single charge from merchant
- Infrequent pattern (6+ months apart)
- Merchant name suggests subscription but no pattern

## Frequency Patterns

### Monthly
- Most common
- Charges 28-31 days apart
- Examples: Netflix, Spotify, subscriptions

### Quarterly
- Every 90 days (±5 days)
- Examples: insurance, some memberships

### Annual
- Every 365 days (±10 days)
- Examples: domain registration, annual memberships

### Bi-weekly
- Every 14 days
- Examples: some services, payroll-aligned

## Amount Variance Rules

- ±10%: high confidence (same subscription)
- ±15%: medium confidence (possible price increase)
- ±20%+: low confidence (different service or variable billing)

## Keywords to Flag

Subscription indicators:
- "subscription"
- "membership"
- "premium"
- "pro"
- "plus"
- "annual"
- "renewal"
- "recurring"

Installment indicators:
- "installment"
- "0%"
- "EMI"
- "payment plan"
- "monthly payment"
