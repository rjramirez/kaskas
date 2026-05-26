# /ocr

Extract text from images. Parse statements.

## Input
- Screenshots
- Photos
- Scanned receipts
- Statement images

## Process

1. **Detect text** → use vision API (Claude)
2. **Extract fields** → merchant, amount, date, category
3. **Normalize** → standardize format
4. **Validate** → check against schemas
5. **Merge** → combine with existing transactions

## Output

**Extracted Transactions**
| Merchant | Amount | Date | Category |
|---|---|---|---|

**Confidence**
- High: clear text, valid format
- Medium: partial text, inferred fields
- Low: blurry, uncertain values

**Next Steps**
- Review extracted data
- Correct errors
- Add to `/review` analysis

Caveman mode. No hallucination.
