---
layout: default
title: Security & Privacy
---

# Security & Privacy

Kaskas is designed with privacy and security as first-class concerns.

---

## What Kaskas Stores

✅ **Safe to store:**
- Merchant names (e.g., "Jollibee", "Meralco")
- Transaction amounts and dates
- Last 4 digits of cards (e.g., `****1234`)
- Last 4 digits of account numbers (e.g., `****5678`)
- Spending categories
- Payment due dates

❌ **Never stored:**
- Full card numbers
- CVV / security codes
- Passwords or PINs
- Full account numbers
- Personal identification numbers
- Social security numbers

---

## Why It's Safe

### Last 4 Digits
- Cannot be used for fraud alone
- Industry standard for identification
- Used by banks on statements
- Insufficient for unauthorized access

### Local-Only Storage
- All data stays on your machine
- No cloud uploads
- No external API calls
- You control the data

### No External Calls
- Financial analysis happens locally
- No data sent to third parties
- No tracking or analytics
- Your privacy is protected

---

## Compliance

### PCI DSS (Payment Card Industry Data Security Standard)
✅ Kaskas complies with PCI DSS requirements:
- Never stores full card numbers
- Stores only last 4 digits (tokenization equivalent)
- Local-only storage (no transmission)
- No unnecessary sensitive data retention

### Banking Standards
✅ Kaskas follows banking industry standards:
- Last 4 digits = standard for card identification
- Account numbers masked = standard practice
- Merchant names = public information

### Privacy Best Practices
✅ Kaskas implements privacy best practices:
- Minimal data collection (only what's needed)
- No external API calls
- User-controlled storage (SQLite on your machine)
- Soft deletes (data can be recovered if needed)

---

## Data Flow

```
Your Input (Statement/Receipt)
    ↓
Extract: Merchant, Amount, Date
    ↓
Normalize: Match to categories
    ↓
Store: Last 4 digits (if card) + Company name
    ↓
SQLite (Local, encrypted at rest)
```

**No external transmission at any step.**

---

## Safe Usage

### ✅ Safe to Share with Kaskas
- Credit card statements
- Bank statements
- Receipt images
- PDF statements
- Transaction lists

### ❌ Never Share with Kaskas
- Full card numbers
- CVV/CVC codes
- Online banking credentials
- Account PINs
- Passwords
- Social security numbers
- Full account numbers

---

## Data Encryption

### At Rest
- SQLite database stored locally
- Encrypted by your OS (Windows BitLocker, macOS FileVault, Linux LUKS)
- Only accessible by your user account

### In Transit
- No data transmitted externally
- All processing happens locally
- No network calls for analysis

---

## Uninstall & Data Removal

When you uninstall kaskas:

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall
```

```bash
# macOS / Linux
bash install.sh --uninstall
```

This removes:
- ✅ All kaskas files
- ✅ MCP server configuration
- ✅ Claude Desktop integration
- ✅ Claude Code plugin

**Your data in SQLite is NOT automatically deleted.** To remove it:

```bash
# Find and delete the database
rm -rf ~/.config/Claude/kaskas/  # Linux
rm -rf ~/Library/Application\ Support/Claude/kaskas/  # macOS
rmdir %APPDATA%\Claude\kaskas\  # Windows
```

---

## Transparency

Kaskas is open source. You can:
- ✅ Inspect the code
- ✅ Audit the security
- ✅ Run locally
- ✅ Modify for your needs
- ✅ Contribute improvements

**Repository:** [github.com/rjramirez/kaskas](https://github.com/rjramirez/kaskas)

---

## Questions?

- [FAQ](./faq.md)
- [GitHub Issues](https://github.com/rjramirez/kaskas/issues)

---

**Your financial data is yours. Kaskas keeps it that way.**
