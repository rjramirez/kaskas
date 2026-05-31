# /reset — Clear Test Data

Reset kaskas to a clean state. Options:

## Usage

```
/reset              — Show current data status
/reset test         — Remove test data only (keep user data)
/reset all          — Remove ALL data (fresh start)
/reset load         — Load sample test data for demo
```

## Behavior

### `/reset` (no args)
Show what data exists:

| Data Type | Count | Source |
|-----------|-------|--------|
| Transactions | X | test/user |
| Obligations | X | test/user |
| Cards | X | test/user |

### `/reset test`
Remove only test data (has `_meta.description` containing "test"):
- `data/test-transactions.json` — sample transactions
- Any SQLite records marked as test data

Keep:
- User-imported statements
- User-created obligations
- User card configurations

### `/reset all`
**WARNING: Destructive!**

Remove ALL kaskas data:
- All transactions
- All obligations
- All card configs
- SQLite database
- Embeddings cache

Confirm with: "I understand, delete everything"

### `/reset load`
Load sample test data for demo purposes:
- 3 credit cards (BDO, BPI, Security Bank)
- 50 sample transactions (Jan-Feb 2024)
- 10 obligations (cards, subscriptions, utilities)
- Recurring patterns (Netflix, Spotify, gym, etc.)

Good for:
- Testing commands
- Demo to others
- Learning kaskas features

## Output

```
Reset complete.

| Action | Items |
|--------|-------|
| Removed | 50 transactions, 10 obligations |
| Kept | 0 user records |

Run /review to start fresh.
```

## Safety

- Always confirm before `/reset all`
- Test data is clearly marked
- User data preserved by default
- No external calls — local only
