# GMRemake
A Martingale Trading strategies for MT4 and MT5 EA, Original idea from AlgoX GM.

## Overview
GMRemake is a sophisticated Martingale Expert Advisor designed for MetaTrader 4 (MT4) platform. The EA implements an advanced martingale strategy with multiple layers of risk management, trend protection, and EMA filters to optimize trading performance.

## Features

### Core Martingale Strategy
- **Up to 8 Levels**: Supports up to 8 martingale levels for both buy and sell positions
- **Configurable Entry Distances**: Each level has its own configurable entry distance
- **Customizable Lot Sizes**: Independent lot size control for each martingale level
- **Directional Control**: Can be configured for buy-only, sell-only, or both directions

### Risk Management
- **Trailing Stop**: Automatically trails stop loss when profit reaches specified threshold
- **Spread Filter**: Prevents trading during high spread conditions
- **Slippage Control**: Limits order execution slippage

### Trend Protection
- **Price Trend Protection**: Ensures new martingale levels only open when price confirms trend reversal
- **MACD Trend Protection**: Monitors MACD indicator to avoid opening positions during strong adverse trends
- **EMA Filters**: Dual EMA filter system (long and short periods) to align trades with market trends

### Technical Indicators
- **EMA (Exponential Moving Average)**: Configurable long and short period EMAs for trend filtering
- **MACD (Moving Average Convergence Divergence)**: Used for trend protection and divergence detection

## Installation

### For MT4:
1. Download the `GMRemake_Martingale_EA.mq4` file from the `MT4/Experts` folder
2. Copy the file to your MT4 installation directory:
   - Windows: `C:\Program Files\MetaTrader 4\MQL4\Experts\`
   - Or through MT4: File → Open Data Folder → MQL4 → Experts
3. Restart MT4 or click "Refresh" in the Navigator panel
4. Drag and drop the EA onto your desired chart
5. Enable "Auto Trading" in MT4

## Configuration Parameters

### Basic Settings
- **Timeframe**: Trading timeframe (default: H1)
- **Bars Counted Back**: Number of bars to analyze for entry signal (default: 20)
- **Max Buy Order**: Maximum number of buy martingale levels (0-8, 0 disables buy orders)
- **Max Sell Order**: Maximum number of sell martingale levels (0-8, 0 disables sell orders)

### Entry Distance Parameters (in points)
Configure the distance in points for each martingale level:
- **Entry Distance 1-8**: Distance required to trigger each successive martingale level
- Default progression: 100, 150, 200, 250, 300, 350, 400, 450 points

### Lot Size Parameters
Configure the lot size for each martingale level:
- **Lot Size 1-8**: Lot size for each martingale level
- Default progression: 0.01, 0.02, 0.04, 0.08, 0.16, 0.32, 0.64, 1.28 (doubling strategy)

### Trend Protection
- **Trend Protection**: Requires price confirmation before opening additional martingale levels (default: true)
- **MACD Trend Protection**: Prevents opening positions when MACD shows 3 consecutive divergent bars (default: true)

### EMA Trend Filters
- **EMA Trend Period (L)**: Long EMA period (default: 200)
- **EMA Trend Filter (L) For Buy**: Long EMA threshold for buy orders (0 = disabled, +/- points)
- **EMA Trend Filter (L) For Sell**: Long EMA threshold for sell orders (0 = disabled, +/- points)
- **EMA Trend Period (S)**: Short EMA period (default: 50)
- **EMA Trend Filter (S) For Buy**: Short EMA threshold for buy orders (0 = disabled, +/- points)
- **EMA Trend Filter (S) For Sell**: Short EMA threshold for sell orders (0 = disabled, +/- points)

### Trailing Stop
- **Trailing Points**: Profit threshold to activate trailing stop (default: 100 points)
- **Stop Trailing Points**: Distance to trail stop loss behind current price (default: 50 points)

### General Settings
- **Slippage in Points**: Maximum allowed slippage (default: 30 points)
- **Spread in Points**: Maximum allowed spread (default: 30 points)
- **Magic Number**: Unique identifier for EA orders (default: 20241207)
- **Comment**: Custom comment for orders (default: "GMRemake_Martingale")

## Strategy Explanation

### Entry Logic

#### First Level Entry (Level 1)
- **Buy Signal**: Price exceeds the highest high of the last N bars by Entry Distance 1
- **Sell Signal**: Price falls below the lowest low of the last N bars by Entry Distance 1

#### Martingale Levels (Level 2-8)
- **Buy Orders**: Opens when price falls below last buy order by the specified Entry Distance
- **Sell Orders**: Opens when price rises above last sell order by the specified Entry Distance
- **Trend Protection**: Optionally requires price to show reversal signs before opening
- **MACD Protection**: Optionally blocks entries during strong adverse MACD trends

### Exit Logic
- **Trailing Stop**: Activates when profit exceeds Trailing Points threshold
- **Stop Loss Trail**: Follows price at Stop Trailing Points distance
- **All Positions**: Closes when trailing stop is hit

## Risk Warning

⚠️ **IMPORTANT RISK DISCLOSURE** ⚠️

Martingale strategies involve significant risk:
- **High Drawdown Potential**: Multiple losing levels can quickly deplete account balance
- **No Guaranteed Profit**: Past performance does not guarantee future results
- **Requires Adequate Margin**: Ensure sufficient account balance for maximum martingale levels
- **Test Thoroughly**: Always test on demo account before live trading

**Recommended:**
- Start with minimal lot sizes
- Use on currency pairs with low spreads
- Ensure adequate account balance (recommended: 10x maximum position size)
- Monitor open positions regularly
- Consider maximum drawdown limits

## Usage Tips

1. **Backtesting**: Always backtest the EA with your desired settings before live trading
2. **Demo Testing**: Run on demo account for at least 1 month before going live
3. **Conservative Settings**: Start with lower lot sizes and fewer martingale levels
4. **Monitor Spread**: Ensure your broker offers competitive spreads
5. **VPS Recommended**: Use a VPS for 24/7 operation and reduced latency

## Support

For issues, questions, or contributions, please:
- Open an issue on GitHub
- Submit a pull request for improvements
- Share your configuration settings and results

## License

This project is open source. Please check the LICENSE file for details.

## Disclaimer

This EA is provided for educational purposes. Trading forex involves substantial risk of loss and is not suitable for all investors. The developers assume no responsibility for any trading losses incurred through the use of this EA.
