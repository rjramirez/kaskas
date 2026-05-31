# /pdf

Read PDF. Get txn.

## in
- credit card PDF
- bank PDF
- utility PDF
- invoice PDF

## do
1. parse PDF → text + table
2. detect type → card/bank/utility
3. extract row → merchant, amount, date
4. normalize name, date, amount
5. validate schema
6. dedupe

## out

| merchant | amount | date | cat |
|----------|--------|------|-----|

## info
- type: card/bank/utility
- period: start to end
- txn count
- total PHP

## confidence
- high: clear table
- medium: partial
- low: unstructured

## next
- review
- fix error
- add to /review

no hallucinate. extract only.
