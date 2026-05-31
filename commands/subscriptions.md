# /subscriptions

Find recurring. Monthly cost.

## detect

| confidence | rule |
|------------|------|
| high | same merchant 2x, monthly ±5d, amount ±10% |
| medium | known service (netflix/spotify) OR "subscription" keyword |
| low | single charge OR quarterly/annual |

## do
1. get txn from /review
2. group by merchant
3. check days between, amount var, known service
4. score confidence
5. est monthly (annual÷12, quarterly÷3)
6. sum total

## out

| merchant | monthly | freq | confidence |
|----------|---------|------|------------|

## summary
- total monthly
- sub count
- savings if cancel

## review
- low confidence → verify
- unused → ask user
- duplicate cat → consolidate

flag uncertain.
