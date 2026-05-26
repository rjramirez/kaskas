# /forecast

Predict future spending. Financial forecasting.

## Input
- Historical transactions (from `/memory`)
- Spending patterns (from `/insights`)
- Seasonal data
- User goals

## Process

1. **Analyze history** → 3-6 months of data
2. **Detect patterns** → seasonal, weekly, daily
3. **Model trends** → linear regression, exponential smoothing
4. **Generate forecast** → next 1-3 months
5. **Confidence intervals** → show uncertainty

## Forecasts

**Category Forecast**
- Food: PHP X,XXX ±PHP XXX
- Shopping: PHP X,XXX ±PHP XXX
- Utilities: PHP X,XXX ±PHP XXX
- Transport: PHP X,XXX ±PHP XXX

**Total Spending**
- Next month: PHP X,XXX
- Next quarter: PHP X,XXX
- Next year: PHP X,XXX

**Obligation Forecast**
- Total due next month: PHP X,XXX
- Peak month: PHP X,XXX (month)
- Lowest month: PHP X,XXX (month)

**Subscription Forecast**
- Current: PHP X,XXX/month
- Projected (no changes): PHP X,XXX/month
- With cancellations: PHP X,XXX/month

## Commands

- `/forecast month` → next 30 days
- `/forecast quarter` → next 90 days
- `/forecast year` → next 365 days
- `/forecast category [name]` → category forecast
- `/forecast scenario [changes]` → what-if analysis

## Scenarios

**What-if Analysis**
- Cancel subscription X → save PHP XXX/month
- Reduce dining 20% → save PHP XXX/month
- Switch card → earn PHP XXX/month
- Consolidate bills → save PHP XXX/month

## Accuracy

- 1 month: 85-95% accuracy
- 3 months: 75-85% accuracy
- 12 months: 60-75% accuracy

Improves with more data.

## Confidence

- High: >90% confidence
- Medium: 70-90% confidence
- Low: <70% confidence

Based on data quality + pattern strength.

Predict. Plan. Optimize.
