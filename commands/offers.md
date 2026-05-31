# /offers

Match card to spend. Find cashback.

## rule
- use `references/ph-cards.md`
- match category + merchant
- NO invented rate. historical only.

## do
1. load cards from ref
2. get spend from /review
3. match % spend to reward cat
4. est monthly + annual cashback
5. rank by annual
6. find gap → suggest 2nd card
7. calc missed if user has diff card

## out

**best card**
- name + bank
- monthly cashback
- annual cashback
- coverage %

| cat | spend | reward | cashback |
|-----|-------|--------|----------|

**2nd card** (if gap)
- name
- cover what cat
- extra annual

**missed** (if user card diff)
- current earn
- potential earn
- diff

## note
- rate = historical
- verify with bank
- no live promo
- assume same spend

show math.
