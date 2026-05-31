---
layout: default
title: Command Reference
---

# Command Reference

All 15 kaskas commands available in Claude Desktop and Claude Code.

---

## Financial Analysis

### `/review` - Analyze Statements
Extract and analyze credit card statements.

**Input:** Paste statement text, PDF, or screenshot
**Output:** 
- Transaction summary
- Spending by category
- Recurring charges
- Risk flags

**Example:**
```
/review
[paste your credit card statement]
```

---

### `/due` - Track Upcoming Payments
Find bills and payments due in the next 30 days.

**Output:**
- Due date
- Amount
- Merchant
- Risk level

---

### `/subscriptions` - Find Recurring Charges
Detect subscriptions and recurring payments.

**Output:**
- Subscription name
- Monthly cost
- Confidence level
- Cancellation tips

---

### `/offers` - Best Card for Your Spending
Find the best credit card for your spending patterns.

**Input:** Your spending data
**Output:**
- Card recommendations
- Estimated cashback
- Annual savings

---

### `/safe` - Utilization Risk Score
Check your credit card utilization and risk level.

**Output:**
- Utilization percentage
- Safety score (0-100)
- Risk level (Healthy/Moderate/Risky/Dangerous)
- Recommendations

---

## Data Management

### `/export` - Export Your Data
Export transactions and obligations as JSON, CSV, or Markdown.

**Formats:**
- JSON (structured)
- CSV (spreadsheet)
- Markdown (readable)

---

### `/memory` - Persistent Storage
Store and recall financial data using SQLite.

**Features:**
- Local database
- Persistent across sessions
- Semantic search
- Full history

---

## Document Processing

### `/ocr` - Extract from Images
Extract transaction text from receipts and screenshots.

**Input:** Image file or screenshot
**Output:** Extracted text and structured data

---

### `/pdf` - Extract from PDFs
Extract transactions from PDF statements.

**Input:** PDF file
**Output:** Structured transaction data

---

### `/promos` - Parse Card Offers
Extract promotional offers from credit card statements.

**Output:**
- Offer description
- Expiration date
- Terms and conditions

---

## Advanced Analysis

### `/embed` - Semantic Search
Search transactions using natural language.

**Example:**
```
/embed
Find all restaurant spending in the last 3 months
```

---

### `/insights` - Pattern Analysis
Detect spending patterns and anomalies.

**Output:**
- Spending trends
- Anomalies detected
- Recommendations

---

### `/llm` - Local LLM Analysis
Analyze financial data using local LLM (no API calls).

**Features:**
- Privacy-first
- No external calls
- Fast analysis

---

### `/forecast` - Spending Forecasts
Predict future spending and run scenarios.

**Output:**
- Monthly forecast
- Confidence intervals
- What-if scenarios

---

### `/remind` - Payment Reminders
Set proactive payment reminders and alerts.

**Features:**
- Due date alerts
- Spending alerts
- Custom thresholds

---

### `/reset` - Clear or Load Test Data
Clear test data or load sample data for demo purposes.

**Options:**
- Clear test data only
- Clear all data (test + user)
- Load sample data for demo

**Example:**
```
/reset
Clear test data and start fresh
```

---

## Tips

- **Combine commands** - Use `/review` then `/offers` to optimize
- **Export regularly** - Use `/export` to backup your data
- **Check `/safe`** - Monitor utilization weekly
- **Use `/insights`** - Discover spending patterns
- **Set `/remind`** - Never miss a payment

---

## Need Help?

- [Security & Privacy](./security.md)
- [FAQ](./faq.md)
- [GitHub Issues](https://github.com/rjramirez/kaskas/issues)
