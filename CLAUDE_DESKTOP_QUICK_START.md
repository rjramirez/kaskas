# 🚀 Kaskas - Claude Desktop Quick Start

## What is Kaskas?

**Kaskas** is a portable financial memory skill for Claude Desktop that helps you:
- 📊 Analyze credit card statements
- ⏰ Track payment obligations
- 🔄 Detect subscriptions
- 💳 Find cashback opportunities
- 🛡️ Check safe spending limits
- 📤 Export financial data

---

## ⚡ 60-Second Setup

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/rjramirez/kaskas/main/install.ps1 | iex
```

### macOS / Linux (Bash)
```bash
curl -fsSL https://raw.githubusercontent.com/rjramirez/kaskas/main/install.sh | bash
```

**Then:** Restart Claude Desktop

**Done!** ✅

---

## 💬 Using Kaskas

### 1. Review Statements 📊
```
/review
Analyze this credit card statement
```

### 2. Check Due Dates ⏰
```
/due
Show upcoming obligations
```

### 3. Find Subscriptions 🔄
```
/subscriptions
List all recurring charges
```

### 4. Optimize Rewards 💳
```
/offers
Best card for dining?
```

### 5. Check Spending Limits 🛡️
```
/safe
Can I spend ₱50,000 this month?
```

### 6. Export Data 📤
```
/export
Export as JSON
```

---

## 🎯 Key Features

| Feature | Benefit |
|---------|---------|
| 🏠 Local-first | Your data stays on your machine |
| 📦 Portable | Export anytime, use anywhere |
| 🔐 Private | No cloud storage, no tracking |
| ⚡ Fast | Low token usage, quick responses |
| 📝 Structured | Markdown output, easy to read |
| 🔄 Reusable | Works with any AI agent |

---

## 📁 What Gets Installed

```
Kaskas installs to:

Windows:  %APPDATA%\Claude\skills\kaskas
macOS:    ~/Library/Application Support/Claude/skills/kaskas
Linux:    ~/.config/Claude/skills/kaskas

Contents:
├── 6 slash commands
├── Reference data (merchant categories, card info, etc.)
├── Output templates
├── JSON schemas for validation
└── Configuration files
```

---

## 🆘 Troubleshooting

### Skill doesn't appear?
1. Check installation path exists
2. Restart Claude Desktop completely
3. Try manual installation

### Commands not working?
1. Verify all files downloaded
2. Check internet connection
3. Restart Claude Desktop

### Need help?
- 📖 Read `SKILL.md` for detailed docs
- 🐛 Check GitHub issues
- 💬 Start a discussion

---

## 📚 Learn More

| Document | Purpose |
|----------|---------|
| `README.md` | Overview & features |
| `SKILL.md` | Detailed command guide |
| `CLAUDE_DESKTOP_INTEGRATION.md` | Technical details |
| `IMPLEMENTATION_SUMMARY.md` | What was built |
| `ROADMAP.md` | Future plans |

---

## 🔒 Privacy First

Kaskas is built on privacy principles:

✅ **Local Processing** - Everything happens on your machine  
✅ **No Cloud** - Data never leaves your computer  
✅ **Exportable** - You own your data  
✅ **Temporary** - Data doesn't persist  
✅ **Portable** - Works with any AI agent  

---

## 🎓 Example Workflows

### Workflow 1: Monthly Review
```
1. /review [paste statement]
2. /subscriptions [see recurring charges]
3. /due [check upcoming payments]
4. /safe [verify spending capacity]
5. /export [backup data]
```

### Workflow 2: Optimize Rewards
```
1. /review [analyze spending]
2. /offers [find best cards]
3. /export [save recommendations]
```

### Workflow 3: Track Obligations
```
1. /due [see all obligations]
2. /subscriptions [find recurring]
3. /export [create backup]
```

---

## 🚀 Next Steps

1. **Install** - Run the installer script
2. **Restart** - Restart Claude Desktop
3. **Try** - Use `/review` with a statement
4. **Explore** - Try other commands
5. **Export** - Backup your data

---

## 💡 Pro Tips

- 🔐 **Mask card numbers** before sharing statements
- 📤 **Export regularly** to backup your data
- 🔄 **Use /subscriptions** monthly to catch new charges
- 💳 **Use /offers** before major purchases
- 🛡️ **Use /safe** before spending

---

## 🤝 Contributing

Have ideas? Found a bug?

1. Fork on GitHub
2. Make changes
3. Submit pull request
4. Help improve Kaskas!

---

## 📄 License

MIT License - Free to use and modify

---

## 🔗 Links

- 🏠 [GitHub Repository](https://github.com/rjramirez/kaskas)
- 📖 [Full Documentation](https://github.com/rjramirez/kaskas/blob/main/SKILL.md)
- 🐛 [Report Issues](https://github.com/rjramirez/kaskas/issues)
- 💬 [Discussions](https://github.com/rjramirez/kaskas/discussions)

---

## ❓ FAQ

**Q: Is my data safe?**  
A: Yes! Everything stays on your machine. No cloud storage.

**Q: Can I use it offline?**  
A: Yes! Kaskas works completely offline.

**Q: Can I export my data?**  
A: Yes! Use `/export` to get JSON, CSV, or Markdown.

**Q: Does it work with other AI agents?**  
A: Yes! Export your data and use it anywhere.

**Q: How much does it cost?**  
A: Free! MIT License.

**Q: Can I modify it?**  
A: Yes! It's open source.

---

**Ready to take control of your finances? Install Kaskas now! 💰**

```powershell
# Windows
irm https://raw.githubusercontent.com/rjramirez/kaskas/main/install.ps1 | iex
```

```bash
# macOS / Linux
curl -fsSL https://raw.githubusercontent.com/rjramirez/kaskas/main/install.sh | bash
```

---

**Made with ❤️ for people who care about their financial privacy**
