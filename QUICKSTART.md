# Quick Start Guide - GMRemake Martingale EA

## 5-Minute Setup

### Step 1: Install the EA (2 minutes)

1. **Download the EA file**
   - Navigate to `MT4/Experts/GMRemake_Martingale_EA.mq4`
   - Download the file

2. **Install in MT4**
   - Open MetaTrader 4
   - Click `File` → `Open Data Folder`
   - Navigate to `MQL4` → `Experts`
   - Copy `GMRemake_Martingale_EA.mq4` into this folder
   - Return to MT4 and click `Refresh` in Navigator panel (or restart MT4)

3. **Verify Installation**
   - In MT4 Navigator panel, expand `Expert Advisors`
   - You should see `GMRemake_Martingale_EA`

### Step 2: Configure for First Use (2 minutes)

1. **Open a Chart**
   - Open EUR/USD H1 chart (recommended for beginners)
   - Ensure you have at least 1 year of historical data loaded

2. **Attach the EA**
   - Drag `GMRemake_Martingale_EA` from Navigator onto the chart
   - A settings window will appear

3. **Use Beginner Settings**
   ```
   Timeframe: PERIOD_H1
   Bars Counted Back: 20
   Max Buy Order: 3
   Max Sell Order: 3
   
   Entry Distance 1: 100
   Entry Distance 2: 200
   Entry Distance 3: 300
   
   Lot Size 1: 0.01
   Lot Size 2: 0.02
   Lot Size 3: 0.04
   
   (Leave other settings as default)
   ```

4. **Enable Auto Trading**
   - Click `OK` to apply settings
   - Click the `Auto Trading` button in MT4 toolbar (should turn green)
   - Check if smiley face appears in top-right corner of chart

### Step 3: Monitor (1 minute)

1. **Check Terminal Window**
   - Open `Terminal` panel (View → Terminal or Ctrl+T)
   - Go to `Experts` tab
   - You should see: "GMRemake Martingale EA Initialized Successfully"

2. **Verify Settings**
   - Check the log for "Max Buy Orders: 3 | Max Sell Orders: 3"

## What Happens Next?

### The EA Will:
- ✅ Monitor price for breakout signals
- ✅ Open first order when price exceeds highest high by 100 points (for buy)
- ✅ Open martingale levels if price moves against position
- ✅ Apply trailing stop when profitable
- ✅ Close all positions when trailing stop hits

### First Order Entry
- **Buy Signal**: Price rises above 20-bar highest high + 100 points
- **Sell Signal**: Price falls below 20-bar lowest low + 100 points

### Martingale Levels
- **Level 2**: Opens if price loses 200 points from Level 1
- **Level 3**: Opens if price loses 300 points from Level 2

### Exit
- **Trailing Stop**: Activates at 100 points profit
- **Trailing Distance**: 50 points behind current price

## First Day Checklist

- [ ] EA shows initialized message in Experts tab
- [ ] Auto Trading is enabled (green button)
- [ ] Smiley face icon visible on chart
- [ ] Spread is below 3 pips
- [ ] Account balance > $500 (minimum recommended)
- [ ] Using demo account (strongly recommended for first month)

## Watching Your First Trade

### When EA Opens First Order:
1. You'll see order appear in `Terminal` → `Trade` tab
2. Order comment will show "GMRemake_Martingale"
3. Check open price matches entry logic

### When Price Moves Against Position:
1. EA may open additional martingale levels
2. Monitor `Trade` tab for new orders
3. Check `Experts` tab for log messages

### When Price Moves in Favor:
1. EA will activate trailing stop at 100 points profit
2. Stop loss will appear and update automatically
3. Position closes when stop loss hits

## Common First-Time Issues

### Issue: EA Not Opening Trades
**Possible Reasons:**
- Spread too high (> 30 points default limit)
- No clear breakout signal yet
- EMA filters blocking entry (if enabled)
- Auto Trading not enabled

**Solution:**
- Check spread in Market Watch
- Wait for price to break 20-bar high/low
- Verify Auto Trading is ON (green button)

### Issue: Too Many Orders Opening
**Possible Reasons:**
- Volatile market
- Entry distances too small

**Solution:**
- Close EA and all positions
- Increase Entry Distances (150, 250, 350)
- Restart with more conservative settings

### Issue: EA Not Trailing
**Possible Reasons:**
- Profit hasn't reached 100 points yet
- Orders opened too recently

**Solution:**
- Wait for profit to exceed Trailing Points
- Check current profit in Terminal window

## Safety Tips for First Week

1. **Start Small**
   - Use minimum lot sizes (0.01, 0.02, 0.04)
   - Limit to 3 martingale levels
   - Test on one currency pair only

2. **Monitor Daily**
   - Check EA performance at least once per day
   - Review any open positions
   - Verify no unusual behavior

3. **Keep a Journal**
   - Record entry and exit prices
   - Note market conditions
   - Track total profit/loss

4. **Know When to Stop**
   - If drawdown exceeds 20%, disable EA
   - If multiple consecutive losses, review settings
   - If unsure about behavior, stop and ask for help

## Recommended First Week Settings

### Currency Pair
**EUR/USD** - Most recommended
- Tight spreads
- High liquidity
- Moderate volatility

**Alternatives:**
- GBP/USD (higher volatility)
- USD/JPY (trending behavior)

### Timeframe
**H1 (1 Hour)** - Most balanced
- Good signal frequency
- Manageable monitoring
- Suitable for part-time trading

### Account Size
**Minimum: $500 demo**
- Allows proper martingale scaling
- Handles drawdown safely
- Realistic testing environment

## Next Steps After First Week

1. **Review Performance**
   - Calculate total profit/loss
   - Measure maximum drawdown
   - Count winning vs losing sequences

2. **Optimize Settings** (if needed)
   - Adjust Entry Distances based on results
   - Consider different Lot Size progression
   - Experiment with EMA filters

3. **Expand Gradually**
   - Add one more currency pair
   - Increase to 4-5 martingale levels
   - Try different timeframes

4. **Learn More**
   - Read full Configuration Guide
   - Study market conditions that work best
   - Join trading communities for tips

## Emergency Stop Procedure

If something goes wrong:

1. **Immediate Action**
   - Click `Auto Trading` button to disable EA (turns gray)
   - EA will stop opening new orders

2. **Close Positions** (if necessary)
   - Right-click on open order in Terminal
   - Select `Close Order`
   - Or let trailing stops manage exits

3. **Review and Adjust**
   - Check `Experts` tab for error messages
   - Review configuration settings
   - Consult Configuration Guide for fixes

## Getting Help

### Check These First:
1. **Experts Tab** - Look for error messages or unusual logs
2. **Configuration Guide** - Covers common scenarios and solutions
3. **README** - Full feature documentation

### Still Need Help?
- Open an issue on GitHub with:
  - EA version
  - MT4 build number
  - Description of problem
  - Settings used
  - Screenshots if applicable

## Success Indicators

After first week, you should see:
- ✅ EA running without errors
- ✅ Positions opening based on clear signals
- ✅ Martingale levels activating appropriately
- ✅ Trailing stops working correctly
- ✅ No manual intervention needed
- ✅ Reasonable profit/loss ratio

If you see these, congratulations! You're ready to continue with more advanced configurations.

---

**Remember**: 
- Always use DEMO account first
- Start conservative, increase risk gradually
- Monitor regularly, especially first few weeks
- Ask for help if unsure

**Happy Trading! 📈**
