# /promos

Parse promo. Get card deal.

## in
- promo email
- bank site text
- card offer pic
- promo material

## do
1. extract text
2. detect card + bank
3. parse reward → cat, rate, condition
4. get dates → start/end
5. validate `schemas/promo.schema.json`
6. store

## out

| card | cat | reward | valid til |
|------|-----|--------|-----------|

## detail
- card + bank
- type: cashback/points/miles/rebate
- rate: % or value
- condition: min spend, merchant
- valid: start to end

## confidence
- high: clear, valid date
- medium: partial
- low: unclear

## next
- review
- fix error
- use in /offers

extract only. no assume.
