# /offers

Match cards to spending. Find cashback.

## Rules

Use:
- Category matching (`references/ph-cards.md`)
- Merchant matching (transaction history)
- Known rewards (no live promos)

NO invented rates. Historical patterns only.

## Process

1. **Load cards** → from `references/ph-cards.md`
2. **Analyze spend** → from `/review` (top categories, merchants, total)
3. **Match** → % of spend in each card's reward categories
4. **Estimate** → monthly + annual cashback per card
5. **Rank** → by annual cashback potential
6. **Identify gaps** → categories not covered, suggest secondary card
7. **Calculate missed** → if user has different card, show difference

## Output

**Best Card**
- Card name + issuer
- Est. monthly cashback
- Est. annual cashback
- Coverage % (spend in reward categories)

**Breakdown**
| Category | Spend | Reward | Est. Cashback |
|---|---|---|---|

**Secondary Card** (if gaps exist)
- Card name
- Coverage (categories)
- Est. additional annual

**Missed Rewards** (if current card provided)
- Current earnings
- Potential earnings
- Annual difference

**Notes**
- Rates = historical patterns
- Verify with issuer
- No live promos
- Assumes consistent spend

Tactical. Show math.
