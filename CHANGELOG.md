# Changelog

All notable changes to the GMRemark Martingale EA project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-12-07

### Added
- Initial release of GMRemark Martingale EA for MT4
- Complete martingale strategy with up to 8 levels
- Configurable entry distances for each martingale level
- Independent lot size configuration for each level
- Trend protection based on price action confirmation
- MACD trend protection to avoid entries during strong adverse trends
- Dual EMA trend filter system (long and short periods)
- Trailing stop functionality with configurable activation and distance
- Spread filter to prevent trading during unfavorable conditions
- Slippage control for order execution
- Support for both buy and sell directions
- Ability to disable buy or sell trading independently
- Magic number system for order identification
- Comprehensive documentation including:
  - Main README with feature overview
  - Configuration guide with multiple setup examples
  - Risk warnings and usage tips
  - Installation instructions
- MIT License

### Features in Detail

#### Core Martingale System
- Maximum 8 martingale levels per direction
- Configurable entry distances: 100, 150, 200, 250, 300, 350, 400, 450 points (default)
- Configurable lot sizes: 0.01, 0.02, 0.04, 0.08, 0.16, 0.32, 0.64, 1.28 (default doubling)
- Independent buy/sell order control

#### Risk Management
- Trailing stop with customizable activation threshold (default: 100 points)
- Trailing stop distance (default: 50 points)
- Maximum spread filter (default: 30 points)
- Slippage protection (default: 30 points)

#### Trend Protection
- Price-based trend protection (requires candle confirmation)
- MACD trend protection (blocks entry on 3 consecutive divergent bars)
- Long EMA filter (default period: 200)
- Short EMA filter (default period: 50)
- Configurable EMA offset thresholds for buy/sell

#### Technical Implementation
- Proper order counting and tracking
- Last price tracking for martingale level calculation
- Highest/lowest bar detection over configurable period (default: 20 bars)
- Separate buy and sell logic with independent filters
- Comprehensive error handling and logging

### Configuration Options
- Timeframe: Any MT4 timeframe (default: H1)
- Bars Counted: 1-1000 (default: 20)
- Max Buy/Sell Orders: 0-8 (default: 8)
- Entry Distances: 1-10000 points per level
- Lot Sizes: 0.01-100 lots per level
- EMA Periods: 1-500 (defaults: 200 and 50)
- Trailing Points: 0-1000 (default: 100)
- Stop Trailing Points: 0-1000 (default: 50)
- Spread/Slippage: 0-100 points (default: 30)

### Documentation
- Comprehensive README with installation guide
- Detailed configuration guide with 3 preset strategies:
  - Conservative setup (3-4 levels, tight risk)
  - Balanced setup (5-6 levels, moderate risk)
  - Aggressive setup (8 levels, high risk)
- Parameter explanation and optimization tips
- Risk management guidelines
- Backtesting and forward testing recommendations
- Currency pair recommendations
- Emergency procedures

### Known Limitations
- Requires manual monitoring during high-impact news events
- Performance depends heavily on broker spread and execution
- High drawdown potential with aggressive settings
- Requires adequate account balance for maximum martingale levels

### Tested On
- MetaTrader 4 Build 1090+
- Windows platform

### Future Considerations
- MT5 version
- Additional technical indicators for entry signals
- Time-based trading filters
- Maximum drawdown protection
- Break-even functionality
- Multi-currency support
- News filter integration
- Enhanced logging and reporting

---

## Release Notes

### Version 1.0.0 - Initial Release

This is the first public release of the GMRemark Martingale EA. The EA has been developed based on the original AlgoX GM concept and includes comprehensive risk management features.

**What's Working:**
- All core martingale functionality
- Entry signal generation based on bar extremes
- Martingale level tracking and execution
- Trend protection filters (price and MACD)
- EMA trend filters
- Trailing stop management
- Order counting and tracking

**Recommended Use:**
- Start with demo account
- Use conservative settings initially
- Test on major currency pairs with low spreads
- Ensure adequate account balance (minimum 10x maximum position size)

**Support:**
For questions, issues, or feature requests, please open an issue on GitHub.

---

## Upgrade Instructions

### From: None (Initial Release)
### To: 1.0.0

This is the initial release. Simply follow the installation instructions in README.md.

---

## Security

### Reporting Security Issues

If you discover a security vulnerability in this EA, please send an email to the repository maintainers. Please do not create public GitHub issues for security vulnerabilities.

---

## Credits

- **Original Concept**: AlgoX GM
- **Development**: GMRemark Team
- **Contributors**: See GitHub contributors list

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.
