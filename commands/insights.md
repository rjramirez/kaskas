# /insights

Semantic analysis. Pattern discovery. Smart recommendations.

## Input
- All stored transactions (from `/memory`)
- All embeddings (from `/embed`)
- Historical patterns
- User behavior

## Process

1. **Analyze patterns** → semantic clustering of transactions
2. **Detect anomalies** → unusual spending, new merchants
3. **Find correlations** → spending triggers, seasonal patterns
4. **Generate insights** → actionable recommendations
5. **Learn preferences** → improve categorization over time

## Output

**Spending Patterns**
- Seasonal trends (higher in X month)
- Weekly patterns (peak spending on X day)
- Category trends (growing/declining categories)
- Merchant loyalty (repeat merchants)

**Anomalies**
- Unusual transactions (spike >30% vs average)
- New merchants (first-time vendors)
- Category mismatches (likely miscategorized)
- Subscription changes (new/cancelled)

**Correlations**
- Spending triggers (events that cause spending)
- Time-based patterns (time of day, day of week)
- Category relationships (often bought together)
- Merchant clustering (similar vendors)

**Recommendations**
- Optimize card usage (based on patterns)
- Cancel unused subscriptions (low engagement)
- Consolidate merchants (similar services)
- Budget alerts (category trending high)

## Commands

- `/insights patterns` → spending patterns
- `/insights anomalies` → unusual activity
- `/insights correlations` → spending triggers
- `/insights recommendations` → smart suggestions
- `/insights trend [category]` → category trend analysis

## Learning

Improves over time:
- More data = better patterns
- User feedback = better recommendations
- Seasonal data = better predictions

Semantic memory. No rules. Pure data.
