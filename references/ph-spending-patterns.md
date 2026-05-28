# Philippine Spending Patterns

## Common Filipino Money Behaviors

### Sweldo Syndrome
**Pattern**: Overspending 1-3 days after payday

**Signs**:
- Large purchases on 15th-17th or 30th-2nd
- Dining out spikes after sweldo
- Shopping sprees post-payday
- "Treat yourself" mentality

**Detection**:
```
IF transaction_date IN (payday + 1 to 3 days)
AND amount > average_daily_spend * 2
THEN flag "Sweldo Syndrome"
```

**Advice (Taglish)**: "Beh, baka pwedeng i-budget muna bago gastusin lahat?"

---

### Tingi Culture
**Pattern**: Small, frequent purchases instead of bulk

**Signs**:
- Multiple small transactions same merchant
- Daily sari-sari store visits
- Sachet purchases (shampoo, coffee, etc.)
- Load purchases in small amounts

**Detection**:
```
IF same_merchant_count > 5 per week
AND average_amount < PHP 100
THEN flag "Tingi Pattern"
```

**Advice (Taglish)**: "Mas tipid kung buo ang bilhin mo, beh!"

---

### Utang Culture
**Pattern**: Borrowing from friends/family, informal loans

**Signs**:
- GCash/Maya transfers to same person monthly
- "Pautang" or "utang" in transaction notes
- Regular small transfers out
- Paluwagan participation

**Detection**:
```
IF recurring_transfer to same_person
AND frequency = monthly
THEN flag "Possible Utang/Paluwagan"
```

**Note**: Not always bad - paluwagan is savings tool

---

### Libre Culture
**Pattern**: Treating others, pasalubong, handaan

**Signs**:
- Large food/dining transactions
- Multiple items same receipt
- Transactions during celebrations
- "Libre" or "treat" patterns

**Detection**:
```
IF dining_amount > average * 3
AND date NEAR (birthday, holiday, payday)
THEN flag "Libre/Celebration"
```

**Advice (Taglish)**: "Okay lang mag-libre, pero budget din!"

---

### Ber Months Spending
**Pattern**: Increased spending Sep-Dec

**Signs**:
- Shopping spike starting September
- Christmas decor purchases
- Gift buying increases
- Party/celebration expenses

**Detection**:
```
IF month IN (9, 10, 11, 12)
AND spending > yearly_average * 1.3
THEN flag "Ber Months Spike"
```

**Advice (Taglish)**: "Ber months na! Mag-budget para sa Pasko!"

---

### Remittance Day Pattern
**Pattern**: OFW families - spending after padala arrives

**Signs**:
- Large deposits mid-month or month-end
- Spending spike 1-2 days after deposit
- Regular international transfers in
- Western Union, Remitly, Wise transactions

**Detection**:
```
IF large_deposit detected
AND spending_spike within 3 days
THEN flag "Remittance Pattern"
```

---

### Fiesta Spending
**Pattern**: Large expenses during local fiestas

**Signs**:
- Food purchases spike
- Travel expenses to province
- Donations/contributions
- Party supplies

**Detection**:
```
IF date NEAR known_fiesta_date
AND (food + travel) spending > average * 2
THEN flag "Fiesta Spending"
```

---

### Petsa de Peligro
**Pattern**: Low funds before payday

**Signs**:
- Very small transactions
- ATM withdrawals of odd amounts (last money)
- Declined transactions
- No spending 3-5 days before payday

**Detection**:
```
IF days_to_payday < 5
AND daily_spending < average * 0.3
THEN flag "Petsa de Peligro"
```

**Advice (Taglish)**: "Konting tiis na lang, malapit na sweldo!"

---

### Installment Addiction
**Pattern**: Multiple active installments

**Signs**:
- 3+ active SIP/installment plans
- New installment while others ongoing
- Installment for small items
- "0% interest" attraction

**Detection**:
```
IF active_installments > 3
THEN flag "Installment Overload"
```

**Advice (Taglish)**: "Dami mo na hulugan, beh. Tapusin muna bago mag-add!"

---

### Sale Hunting
**Pattern**: Buying during sales even if not needed

**Signs**:
- Purchases on 11.11, 12.12, etc.
- "Sale" merchants frequent
- Bulk unnecessary purchases
- "Baka kailanganin" buying

**Detection**:
```
IF transaction_date IN (sale_dates)
AND category NOT IN (essentials)
THEN flag "Sale Impulse"
```

**Advice (Taglish)**: "Sale man yan, kung di naman kailangan, gastos pa rin!"

---

## Positive Patterns to Encourage

### Ipon Habit
- Regular transfers to savings
- Alkansya deposits
- Investment contributions
- Emergency fund building

### Tipid Lifestyle
- Consistent low spending
- Bulk buying
- Home cooking vs dining out
- Generic vs branded

### Suki Benefits
- Loyalty to merchants
- Tawad/discounts earned
- Relationship-based savings

---

## Risk Scoring

| Pattern | Risk Level | Action |
|---------|------------|--------|
| Sweldo Syndrome | Medium | Budget reminder |
| Tingi Culture | Low | Bulk buying tip |
| Utang Culture | High | Debt tracking |
| Libre Culture | Medium | Celebration budget |
| Ber Months | High | Christmas fund |
| Petsa de Peligro | High | Emergency fund |
| Installment Addiction | High | Consolidation advice |
| Sale Hunting | Medium | Needs vs wants |
