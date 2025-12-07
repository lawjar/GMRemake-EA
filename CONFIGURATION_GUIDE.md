# GMRemark Martingale EA - Configuration Guide

## Table of Contents
1. [Quick Start Configuration](#quick-start-configuration)
2. [Conservative Setup](#conservative-setup)
3. [Aggressive Setup](#aggressive-setup)
4. [Parameter Details](#parameter-details)
5. [Optimization Tips](#optimization-tips)
6. [Common Scenarios](#common-scenarios)

## Quick Start Configuration

### Minimal Risk Setup (Recommended for Beginners)
```
Timeframe: H1
Bars Counted Back: 20
Max Buy Order: 3
Max Sell Order: 3

Entry Distance 1: 100
Entry Distance 2: 200
Entry Distance 3: 300

Lot Size 1: 0.01
Lot Size 2: 0.02
Lot Size 3: 0.04

Trend Protection: true
MACD Trend Protection: true

EMA Trend Period (L): 200
EMA Trend Filter (L) For Buy: -50 (buy above EMA-50 points)
EMA Trend Filter (L) For Sell: 50 (sell below EMA+50 points)

Trailing Points: 100
Stop Trailing Points: 50

Spread in Points: 30
```

**Account Requirement**: Minimum $500-1000
**Risk Level**: Low to Moderate
**Expected Drawdown**: 10-20%

## Conservative Setup

### Trend-Following Martingale
This setup focuses on trading with the trend using EMA filters.

```
Timeframe: H4
Bars Counted Back: 30
Max Buy Order: 4
Max Sell Order: 4

Entry Distances: 150, 250, 350, 450
Lot Sizes: 0.01, 0.02, 0.04, 0.08

Trend Protection: true
MACD Trend Protection: true

EMA Trend Period (L): 200
EMA Trend Filter (L) For Buy: -100
EMA Trend Filter (L) For Sell: 100

EMA Trend Period (S): 50
EMA Trend Filter (S) For Buy: -50
EMA Trend Filter (S) For Sell: 50

Trailing Points: 150
Stop Trailing Points: 75
```

**Best For**: Trending markets
**Account Requirement**: Minimum $1000-2000
**Risk Level**: Moderate
**Expected Drawdown**: 15-30%

## Aggressive Setup

### Maximum Martingale Levels
This setup uses all 8 levels for maximum recovery potential.

```
Timeframe: H1
Bars Counted Back: 20
Max Buy Order: 8
Max Sell Order: 8

Entry Distances: 100, 150, 200, 250, 300, 350, 400, 450
Lot Sizes: 0.01, 0.02, 0.04, 0.08, 0.16, 0.32, 0.64, 1.28

Trend Protection: true
MACD Trend Protection: true

EMA Trend Period (L): 200
EMA Trend Filter (L) For Buy: 0 (disabled)
EMA Trend Filter (L) For Sell: 0 (disabled)

Trailing Points: 80
Stop Trailing Points: 40
```

**Best For**: Experienced traders with high risk tolerance
**Account Requirement**: Minimum $5000-10000
**Risk Level**: High
**Expected Drawdown**: 40-70%

## Parameter Details

### Timeframe Selection

| Timeframe | Characteristics | Recommended For |
|-----------|----------------|-----------------|
| M15-M30 | High frequency, more signals | Scalping, Active monitoring |
| H1 | Balanced frequency | General use, Day trading |
| H4 | Lower frequency, stronger signals | Swing trading, Part-time traders |
| D1 | Lowest frequency | Long-term trading |

### Bars Counted Back

- **10-15 bars**: More sensitive, faster entries, more signals
- **20-30 bars**: Balanced, moderate sensitivity
- **40-50 bars**: Less sensitive, fewer but stronger signals

**Recommendation**: Start with 20 bars and adjust based on backtesting results.

### Entry Distance Strategy

#### Progressive Distance (Recommended)
```
Level 1: 100 points
Level 2: 150 points (+50%)
Level 3: 200 points (+33%)
Level 4: 250 points (+25%)
```

This increases distance as levels deepen, giving more room for recovery.

#### Fixed Distance (Conservative)
```
All Levels: 200 points
```

Consistent spacing, easier to calculate risk.

#### Aggressive Distance
```
Level 1: 50 points
Level 2: 80 points
Level 3: 120 points
Level 4: 180 points
```

Tighter spacing for quicker entries, higher risk.

### Lot Size Strategy

#### Classic Doubling
```
0.01 → 0.02 → 0.04 → 0.08 → 0.16 → 0.32 → 0.64 → 1.28
```
**Risk**: High, requires large margin
**Recovery**: Fast recovery when market reverses

#### Conservative Scaling (1.5x)
```
0.01 → 0.015 → 0.023 → 0.035 → 0.053 → 0.08 → 0.12 → 0.18
```
**Risk**: Moderate
**Recovery**: Slower but safer

#### Minimal Scaling (1.3x)
```
0.01 → 0.013 → 0.017 → 0.022 → 0.029 → 0.038 → 0.049 → 0.064
```
**Risk**: Low
**Recovery**: Slowest but safest

### Trend Protection

#### Trend Protection (Price-Based)
- **Enabled**: Only opens new martingale levels when price shows reversal
- **Disabled**: Opens levels based purely on distance

**Recommendation**: Keep enabled to avoid adding to positions in strong trends.

#### MACD Trend Protection
- **Enabled**: Blocks entries when MACD shows 3 consecutive divergent bars
- **Disabled**: Ignores MACD signal

**Recommendation**: Keep enabled to filter out entries during strong momentum.

### EMA Trend Filters

#### Disabled (0 value)
```
EMA Trend Filter (L) For Buy: 0
```
No filtering, allows all entries.

#### Buy Above EMA (Negative value)
```
EMA Trend Filter (L) For Buy: -50
```
Only allows buy orders when price is at least 50 points above EMA.

#### Sell Below EMA (Positive value)
```
EMA Trend Filter (L) For Sell: 50
```
Only allows sell orders when price is at least 50 points below EMA.

**Common Configurations**:

**Trend-Following**:
```
EMA(200) For Buy: -100 (buy above)
EMA(200) For Sell: 100 (sell below)
EMA(50) For Buy: -30 (buy above)
EMA(50) For Sell: 30 (sell below)
```

**Range Trading**:
```
EMA(200) For Buy: 0 (disabled)
EMA(200) For Sell: 0 (disabled)
EMA(50) For Buy: 0 (disabled)
EMA(50) For Sell: 0 (disabled)
```

### Trailing Stop

#### Conservative Trailing
```
Trailing Points: 150
Stop Trailing Points: 100
```
Wider spacing, less likely to close prematurely.

#### Balanced Trailing
```
Trailing Points: 100
Stop Trailing Points: 50
```
Standard configuration.

#### Aggressive Trailing
```
Trailing Points: 50
Stop Trailing Points: 25
```
Tighter trailing, locks profit quickly but may close too early.

## Optimization Tips

### Step 1: Backtest with Historical Data
1. Use at least 1 year of historical data
2. Test on multiple currency pairs
3. Record maximum drawdown and win rate

### Step 2: Forward Test on Demo
1. Run for minimum 1 month
2. Monitor performance in different market conditions
3. Adjust parameters based on results

### Step 3: Optimize Key Parameters
Focus on optimizing these in order:
1. **Entry Distance 1**: Affects entry frequency
2. **Max Orders**: Affects maximum risk
3. **Lot Size Progression**: Affects recovery speed
4. **EMA Filters**: Affects entry quality

### Step 4: Risk Management
Calculate maximum drawdown:
```
Max Drawdown = Sum of (Lot Size × Entry Distance × Point Value)
```

Example for 3 levels:
```
Level 1: 0.01 lots × 100 points × $0.10 = $1
Level 2: 0.02 lots × 200 points × $0.10 = $4
Level 3: 0.04 lots × 300 points × $0.10 = $12
Total Maximum Risk = $17 per direction
```

## Common Scenarios

### Scenario 1: Trending Market (Uptrend)
**Problem**: Multiple sell martingale levels opening, high drawdown

**Solution**:
- Enable EMA Trend Filters
- Set `EMA Trend Filter (L) For Sell: 100` (only sell below EMA+100)
- Reduce `Max Sell Order` to 3-4
- Increase `Entry Distance` for sell orders

### Scenario 2: Ranging Market
**Problem**: Both buy and sell positions opening, choppy price action

**Solution**:
- Disable EMA filters or set to 0
- Enable Trend Protection
- Increase `Bars Counted Back` to 30-40
- Use wider `Entry Distance 1` (150-200 points)

### Scenario 3: High Volatility
**Problem**: Rapid drawdown, multiple levels opening quickly

**Solution**:
- Increase all `Entry Distances` by 50%
- Reduce `Max Orders` to 4-5
- Enable MACD Trend Protection
- Increase `Spread in Points` filter

### Scenario 4: Low Volatility
**Problem**: Few signals, positions held too long

**Solution**:
- Decrease `Entry Distance 1` to 50-80 points
- Use shorter timeframe (M30 or H1)
- Reduce `Trailing Points` to 50-80
- Decrease `Bars Counted Back` to 15

## Currency Pair Recommendations

### Low Spread Pairs (Recommended)
- **EUR/USD**: Spread 0.5-2 pips, high liquidity
- **GBP/USD**: Spread 1-3 pips, good volatility
- **USD/JPY**: Spread 0.5-2 pips, trending behavior
- **AUD/USD**: Spread 1-3 pips, commodity-linked

### Medium Spread Pairs (Use with Caution)
- **EUR/GBP**: Spread 2-4 pips
- **EUR/JPY**: Spread 2-4 pips
- **GBP/JPY**: Spread 3-5 pips, high volatility

### Avoid High Spread Pairs
- Exotic pairs with spreads > 5 pips
- During news events (spreads widen)

## Testing Checklist

Before going live:
- [ ] Backtested for minimum 1 year
- [ ] Forward tested on demo for 1 month
- [ ] Calculated maximum drawdown
- [ ] Verified account balance is sufficient (10x max drawdown)
- [ ] Tested during different market conditions (trending, ranging)
- [ ] Confirmed broker spread is acceptable
- [ ] Set up proper VPS or stable connection
- [ ] Started with minimum lot sizes
- [ ] Limited to 1-2 currency pairs initially
- [ ] Set up monitoring and alerts

## Emergency Procedures

### High Drawdown Alert
If drawdown exceeds 30% of account:
1. Disable EA immediately
2. Close all positions or let trailing stops work
3. Review and adjust configuration
4. Reduce lot sizes and max orders
5. Restart with more conservative settings

### Strong Adverse Trend
If market moves strongly against positions:
1. Monitor MACD and EMA indicators manually
2. Consider manual intervention if all protection levels triggered
3. Let trailing stops manage exits
4. Do not manually add more martingale levels

## Advanced Configurations

### One-Direction Trading

**Buy Only**:
```
Max Buy Order: 8
Max Sell Order: 0
EMA Trend Filter (L) For Buy: -100
```

**Sell Only**:
```
Max Buy Order: 0
Max Sell Order: 8
EMA Trend Filter (L) For Sell: 100
```

### Time-Based Strategy
Use different settings for different sessions:
- **Asian Session**: Smaller distances, range trading
- **London Session**: Larger distances, trend following
- **New York Session**: Medium distances, balanced

### News Event Strategy
During high-impact news:
1. Increase `Spread in Points` to 50+
2. Temporarily reduce `Max Orders` to 2-3
3. Or disable EA 30 minutes before and after news

---

**Remember**: Always start conservative and increase risk gradually as you gain confidence in the EA's performance with your specific settings and market conditions.
