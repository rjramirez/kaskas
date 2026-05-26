# /pdf

Extract transactions from PDF statements.

## Input
- Credit card statements (PDF)
- Bank statements (PDF)
- Utility bills (PDF)
- Invoice PDFs

## Process

1. **Parse PDF** → extract text + tables
2. **Detect layout** → statement type (credit card, bank, utility)
3. **Extract rows** → merchant, amount, date from tables
4. **Normalize** → standardize merchant names, dates, amounts
5. **Validate** → check against schemas
6. **Deduplicate** → remove duplicates from prior uploads

## Output

**Extracted Transactions**
| Merchant | Amount | Date | Category |
|---|---|---|---|

**Statement Info**
- Type: credit card / bank / utility
- Period: YYYY-MM-DD to YYYY-MM-DD
- Total transactions: X
- Total amount: PHP X,XXX

**Confidence**
- High: clear table, valid format
- Medium: partial extraction, inferred fields
- Low: unstructured text, uncertain values

**Next Steps**
- Review extracted data
- Correct errors
- Add to `/review` analysis

No hallucination. Extract only.
