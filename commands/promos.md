# /promos

Parse promotional offers. Extract card rewards.

## Input
- Promo emails
- Bank websites (pasted text)
- Card offer screenshots
- Promotional materials

## Process

1. **Extract offer text** → from input
2. **Detect card** → identify card name + issuer
3. **Parse reward** → category, rate, conditions
4. **Extract dates** → promo start/end dates
5. **Validate** → check against `schemas/promo.schema.json`
6. **Store** → add to promo database

## Output

**Parsed Promos**
| Card | Category | Reward | Valid Until |
|---|---|---|---|

**Details**
- Card: name + issuer
- Reward type: cashback / points / miles / rebate
- Reward rate: percentage or value
- Conditions: minimum spend, merchant restrictions
- Validity: start date to end date

**Confidence**
- High: clear offer, valid dates
- Medium: partial info, inferred dates
- Low: unclear terms, uncertain validity

**Next Steps**
- Review parsed promos
- Correct errors
- Use in `/offers` recommendations

Extract only. No assumptions.
