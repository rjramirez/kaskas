# /subscriptions

Find recurring charges. Monthly obligations.

## Detection Rules

**High Confidence** (all 3):
- Same merchant 2+ times
- Monthly cadence ±5 days
- Amount ±10% variance

**Medium Confidence** (2 of 3):
- Known service (Netflix, Spotify, etc.)
- "subscription" keyword in name

**Low Confidence** (1 indicator):
- Single charge
- Quarterly/annual pattern

## Process

1. **Extract** → transactions from `/review` or new input
2. **Group** → by merchant
3. **Analyze** → days between charges, amount variance, known services
4. **Score** → high/medium/low confidence
5. **Estimate monthly** → if annual divide by 12, if quarterly by 3
6. **Sum** → total monthly recurring

## Output

**Recurring Charges**
| Merchant | Monthly | Frequency | Confidence |
|---|---|---|---|

**Summary**
- Total monthly recurring
- Subscription count
- Potential savings (cancellation candidates)

**Review**
- Low-confidence items (verify)
- Unused services (ask user)
- Duplicates (same category)

Concise. Flag uncertain.
