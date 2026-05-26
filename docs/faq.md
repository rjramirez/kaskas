---
layout: default
title: FAQ
---

# Frequently Asked Questions

---

## Installation

### Q: Do I need Node.js?
**A:** Yes, Node.js 18+ is required. Download from [nodejs.org](https://nodejs.org)

### Q: Can I use kaskas without Claude Desktop?
**A:** No, kaskas is a Claude Desktop skill. You need Claude Desktop installed.

### Q: How do I update kaskas?
**A:** Run the installer again with `-Force` flag:
```powershell
powershell -ExecutionPolicy Bypass -File install.ps1 -Force
```

### Q: Can I uninstall kaskas?
**A:** Yes, run:
```powershell
powershell -ExecutionPolicy Bypass -File install.ps1 -Uninstall
```

---

## Usage

### Q: How do I use kaskas?
**A:** Type any command in Claude Desktop chat:
```
/review
[paste your credit card statement]
```

### Q: What format should my statement be?
**A:** Kaskas accepts:
- ✅ Pasted text
- ✅ PDF files
- ✅ Screenshots
- ✅ Images of receipts

### Q: Can kaskas access my real bank account?
**A:** No. Kaskas only analyzes data YOU provide. It never connects to your bank.

### Q: How accurate is the analysis?
**A:** Accuracy depends on statement quality:
- Clear text: 95%+
- Blurry images: 70-80%
- Handwritten: 50-70%

---

## Security & Privacy

### Q: Is my data safe?
**A:** Yes. Kaskas:
- ✅ Stores data locally only
- ✅ Never sends data to external servers
- ✅ Follows PCI DSS standards
- ✅ Stores only last 4 digits of cards

### Q: What data does kaskas store?
**A:** Only what you provide:
- Merchant names
- Transaction amounts
- Dates
- Last 4 digits of cards
- Account numbers (last 4 only)

### Q: Can kaskas see my full card number?
**A:** No. Kaskas only stores the last 4 digits (e.g., `****1234`)

### Q: Where is my data stored?
**A:** In a SQLite database on your machine:
- Windows: `%APPDATA%\Claude\kaskas\`
- macOS: `~/Library/Application Support/Claude/kaskas/`
- Linux: `~/.config/Claude/kaskas/`

### Q: Can I delete my data?
**A:** Yes. Delete the kaskas folder to remove all data.

### Q: Does kaskas use AI APIs?
**A:** No. All analysis happens locally using Claude's built-in capabilities.

---

## Features

### Q: What can kaskas do?
**A:** Kaskas can:
- ✅ Analyze statements
- ✅ Track upcoming payments
- ✅ Find recurring charges
- ✅ Recommend best credit cards
- ✅ Calculate utilization risk
- ✅ Extract from PDFs/images
- ✅ Forecast spending
- ✅ Set payment reminders
- ✅ And 7 more commands!

### Q: Can kaskas predict my spending?
**A:** Yes, use `/forecast` to see spending predictions and scenarios.

### Q: Can kaskas help me save money?
**A:** Yes! Use `/offers` to find the best card for your spending and `/insights` to find optimization opportunities.

### Q: Does kaskas support multiple cards?
**A:** Yes. Analyze statements from different cards and kaskas will track them all.

---

## Troubleshooting

### Q: Installer closes immediately
**A:** Try running with error output:
```powershell
try {
    irm https://raw.githubusercontent.com/rjramirez/kaskas/main/install.ps1 | iex
} catch {
    Write-Host "Error: $_"
}
```

### Q: "Node.js not found" error
**A:** Install Node.js from [nodejs.org](https://nodejs.org) and restart PowerShell.

### Q: Kaskas commands don't appear in Claude Desktop
**A:** Restart Claude Desktop completely (close and reopen).

### Q: "Already installed" message
**A:** Choose [U]pdate or [F]orce reinstall when prompted.

### Q: Commands not working
**A:** Try:
1. Restart Claude Desktop
2. Check Node.js: `node --version`
3. Reinstall: `install.ps1 -Force`

---

## Performance

### Q: Is kaskas slow?
**A:** No. All analysis happens locally and is fast (usually <1 second).

### Q: Does kaskas use much disk space?
**A:** No. Kaskas is ~50MB installed, database grows with your data.

### Q: Can I use kaskas offline?
**A:** Yes! Kaskas works completely offline after installation.

---

## Compatibility

### Q: Works on Mac?
**A:** Yes. Use the bash installer:
```bash
curl -fsSL https://raw.githubusercontent.com/rjramirez/kaskas/main/install.sh | bash
```

### Q: Works on Linux?
**A:** Yes. Same bash installer as Mac.

### Q: Works on Claude Code?
**A:** Yes. Kaskas works in Claude Code CLI and Claude Code Desktop.

---

## Support

### Q: How do I report a bug?
**A:** Open an issue on [GitHub](https://github.com/rjramirez/kaskas/issues)

### Q: Can I contribute?
**A:** Yes! Kaskas is open source. See [GitHub](https://github.com/rjramirez/kaskas)

### Q: How do I get help?
**A:** 
- Check [Troubleshooting](./troubleshooting.md)
- Read [Security](./security.md)
- Open [GitHub issue](https://github.com/rjramirez/kaskas/issues)

---

**Still have questions?** [Open an issue on GitHub](https://github.com/rjramirez/kaskas/issues)
