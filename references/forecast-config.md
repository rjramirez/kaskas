# Forecasting Configuration

## Models

### Linear Regression
- Best for: stable trends
- Data needed: 3+ months
- Accuracy: 80-90%
- Speed: fast

### Exponential Smoothing
- Best for: trending data
- Data needed: 2+ months
- Accuracy: 75-85%
- Speed: fast

### ARIMA
- Best for: complex patterns
- Data needed: 6+ months
- Accuracy: 85-95%
- Speed: medium

### Prophet
- Best for: seasonal data
- Data needed: 1+ year
- Accuracy: 90-95%
- Speed: medium

## Data Requirements

**Minimum**
- 30 days of data
- 10+ transactions
- Model: linear regression

**Recommended**
- 90 days of data
- 50+ transactions
- Model: exponential smoothing

**Optimal**
- 365 days of data
- 200+ transactions
- Model: ARIMA or Prophet

## Confidence Intervals

**95% Confidence**
- Upper bound: mean + 1.96 × std dev
- Lower bound: mean - 1.96 × std dev

**Accuracy Metrics**
- MAE: mean absolute error
- RMSE: root mean square error
- MAPE: mean absolute percentage error

## Seasonal Patterns

**Detected Automatically**
- Weekly: Mon-Sun patterns
- Monthly: day-of-month patterns
- Quarterly: 3-month cycles
- Yearly: 12-month cycles

## Trend Detection

**Uptrend**
- Slope > 0
- Increasing average

**Downtrend**
- Slope < 0
- Decreasing average

**Stable**
- Slope ≈ 0
- Consistent average

## Anomaly Handling

**Outliers**
- Detected: >2 std dev from mean
- Option 1: exclude from model
- Option 2: include with weight reduction
- User choice

## Retraining

**Automatic**
- Weekly: new data added
- Monthly: full retraining
- Quarterly: model evaluation

**Manual**
- `/forecast retrain` → force retraining
- `/forecast reset` → clear history

## Accuracy

Improves with:
- More data (longer history)
- Consistent patterns
- Fewer anomalies
- Regular updates

Local forecasting. No cloud.
