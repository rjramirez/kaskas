# /ocr

Read pic. Get text.

## in
- screenshot
- photo
- receipt
- statement pic

## do
1. detect text (claude vision)
2. extract → merchant, amount, date, cat
3. normalize format
4. validate schema
5. merge with existing

## out

| merchant | amount | date | cat |
|----------|--------|------|-----|

## confidence
- high: clear, valid
- medium: partial, inferred
- low: blurry, uncertain

## next
- review data
- fix error
- add to /review

no hallucinate. extract only.
