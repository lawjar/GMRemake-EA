# GMRemark Martingale EA - Logic Flow Diagram

## Main Execution Flow

```
┌─────────────────────────────────────────┐
│          EA Initialization              │
│          (OnInit)                       │
│  • Initialize entry distance arrays    │
│  • Initialize lot size arrays          │
│  • Print confirmation message          │
└────────────────┬────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────┐
│          On Each Tick                   │
│          (OnTick)                       │
└────────────────┬────────────────────────┘
                 │
                 ▼
        ┌────────────────┐
        │ Check Spread   │
        │ > Max Spread?  │
        └───┬────────┬───┘
            │ YES    │ NO
            │        │
            ▼        ▼
         Return   Continue
                     │
                     ▼
        ┌─────────────────────┐
        │   Count Orders      │
        │ • Count buy orders  │
        │ • Count sell orders │
        │ • Track last prices │
        └──────────┬──────────┘
                   │
                   ▼
        ┌──────────────────────┐
        │ Manage Trailing Stop │
        │  • Check all orders  │
        │  • Update stop loss  │
        └──────────┬───────────┘
                   │
           ┌───────┴───────┐
           │               │
           ▼               ▼
    ┌──────────┐    ┌──────────┐
    │Check Buy │    │Check Sell│
    │ Entry    │    │  Entry   │
    └──────────┘    └──────────┘
```

## Buy Entry Logic Flow

```
┌──────────────────────────────────────────┐
│        CheckBuyEntry(Level N)            │
└──────────────────┬───────────────────────┘
                   │
                   ▼
          ┌────────────────┐
          │ Level > Max?   │
          └───┬────────┬───┘
              │ YES    │ NO
              │        │
              ▼        ▼
           Return   Continue
                       │
                       ▼
              ┌────────────────┐
              │  Level = 1?    │
              └───┬────────┬───┘
                  │ YES    │ NO
                  │        │
                  ▼        ▼
         ┌─────────────┐  ┌──────────────────┐
         │  First      │  │  Martingale      │
         │  Order      │  │  Order Logic     │
         │  Logic      │  │  (Level 2-8)     │
         └──────┬──────┘  └────────┬─────────┘
                │                  │
                │                  ▼
                │         ┌────────────────────┐
                │         │ Check Loss from    │
                │         │ Last Buy Order     │
                │         └────────┬───────────┘
                │                  │
                │                  ▼
                │         ┌────────────────────┐
                │         │ Loss >= Entry      │
                │         │ Distance N?        │
                │         └───┬────────┬───────┘
                │             │ YES    │ NO
                │             │        │
                │             │        ▼
                │             │     Return
                │             │
                │             ▼
                │    ┌─────────────────────┐
                │    │ Trend Protection    │
                │    │ Enabled?            │
                │    └───┬────────┬────────┘
                │        │ YES    │ NO
                │        │        │
                │        ▼        │
                │   ┌─────────┐  │
                │   │ Price   │  │
                │   │ Higher  │  │
                │   │ than    │  │
                │   │ Prev?   │  │
                │   └─┬───┬───┘  │
                │     │NO │YES   │
                │     │   │      │
                │     ▼   └──────┘
                │  Return    │
                │            │
                └────────────┴───────────┐
                                         │
                                         ▼
                              ┌──────────────────┐
                              │ MACD Protection  │
                              │ Enabled?         │
                              └───┬──────┬───────┘
                                  │ YES  │ NO
                                  │      │
                                  ▼      │
                           ┌──────────┐ │
                           │ Check    │ │
                           │ MACD     │ │
                           │ Trend    │ │
                           └─┬───┬────┘ │
                             │OK │FAIL  │
                             │   │      │
                             │   ▼      │
                             │ Return   │
                             │          │
                             └──────────┴─────┐
                                              │
                                              ▼
                                   ┌───────────────────┐
                                   │ EMA Filter Check  │
                                   │ • Check Long EMA  │
                                   │ • Check Short EMA │
                                   └──┬────────┬───────┘
                                      │ PASS   │ FAIL
                                      │        │
                                      │        ▼
                                      │     Return
                                      │
                                      ▼
                            ┌──────────────────┐
                            │  Open Buy Order  │
                            │  • Lot Size N    │
                            │  • At Ask Price  │
                            │  • Magic Number  │
                            └──────────────────┘
```

## Sell Entry Logic Flow

```
┌──────────────────────────────────────────┐
│        CheckSellEntry(Level N)           │
└──────────────────┬───────────────────────┘
                   │
                   ▼
          ┌────────────────┐
          │ Level > Max?   │
          └───┬────────┬───┘
              │ YES    │ NO
              │        │
              ▼        ▼
           Return   Continue
                       │
                       ▼
              ┌────────────────┐
              │  Level = 1?    │
              └───┬────────┬───┘
                  │ YES    │ NO
                  │        │
                  ▼        ▼
         ┌─────────────┐  ┌──────────────────┐
         │  First      │  │  Martingale      │
         │  Order      │  │  Order Logic     │
         │  Logic      │  │  (Level 2-8)     │
         └──────┬──────┘  └────────┬─────────┘
                │                  │
                │                  ▼
                │         ┌────────────────────┐
                │         │ Check Loss from    │
                │         │ Last Sell Order    │
                │         └────────┬───────────┘
                │                  │
                │                  ▼
                │         ┌────────────────────┐
                │         │ Loss >= Entry      │
                │         │ Distance N?        │
                │         └───┬────────┬───────┘
                │             │ YES    │ NO
                │             │        │
                │             │        ▼
                │             │     Return
                │             │
                │             ▼
                │    ┌─────────────────────┐
                │    │ Trend Protection    │
                │    │ Enabled?            │
                │    └───┬────────┬────────┘
                │        │ YES    │ NO
                │        │        │
                │        ▼        │
                │   ┌─────────┐  │
                │   │ Price   │  │
                │   │ Lower   │  │
                │   │ than    │  │
                │   │ Prev?   │  │
                │   └─┬───┬───┘  │
                │     │NO │YES   │
                │     │   │      │
                │     ▼   └──────┘
                │  Return    │
                │            │
                └────────────┴───────────┐
                                         │
                                         ▼
                              ┌──────────────────┐
                              │ MACD Protection  │
                              │ Enabled?         │
                              └───┬──────┬───────┘
                                  │ YES  │ NO
                                  │      │
                                  ▼      │
                           ┌──────────┐ │
                           │ Check    │ │
                           │ MACD     │ │
                           │ Trend    │ │
                           └─┬───┬────┘ │
                             │OK │FAIL  │
                             │   │      │
                             │   ▼      │
                             │ Return   │
                             │          │
                             └──────────┴─────┐
                                              │
                                              ▼
                                   ┌───────────────────┐
                                   │ EMA Filter Check  │
                                   │ • Check Long EMA  │
                                   │ • Check Short EMA │
                                   └──┬────────┬───────┘
                                      │ PASS   │ FAIL
                                      │        │
                                      │        ▼
                                      │     Return
                                      │
                                      ▼
                            ┌──────────────────┐
                            │ Open Sell Order  │
                            │  • Lot Size N    │
                            │  • At Bid Price  │
                            │  • Magic Number  │
                            └──────────────────┘
```

## MACD Trend Protection Logic

```
┌─────────────────────────────────────┐
│     CheckMACDTrend(isBuy)           │
└──────────────┬──────────────────────┘
               │
               ▼
    ┌──────────────────────┐
    │ Calculate MACD for   │
    │ Last 3 Bars:         │
    │ • Bar 1 (recent)     │
    │ • Bar 2 (previous)   │
    │ • Bar 3 (older)      │
    └──────────┬───────────┘
               │
               ▼
        ┌──────────────┐
        │   isBuy?     │
        └───┬──────┬───┘
            │ YES  │ NO
            │      │
            ▼      ▼
    ┌─────────┐  ┌──────────┐
    │ Check   │  │ Check    │
    │ Bearish │  │ Bullish  │
    │ MACD    │  │ MACD     │
    │ Pattern │  │ Pattern  │
    └────┬────┘  └────┬─────┘
         │            │
         ▼            ▼
    ┌─────────┐  ┌──────────┐
    │ MACD1 < │  │ MACD1 > │
    │ MACD2 < │  │ MACD2 > │
    │ MACD3?  │  │ MACD3?  │
    └─┬───┬───┘  └─┬────┬───┘
      │YES│NO      │YES │NO
      │   │        │    │
      ▼   │        ▼    │
   Return │     Return  │
   FALSE  │     FALSE   │
          │             │
          └─────┬───────┘
                │
                ▼
           Return TRUE
```

## EMA Trend Filter Logic

```
┌─────────────────────────────────────┐
│   CheckEMATrendFilter(isBuy)        │
└──────────────┬──────────────────────┘
               │
               ▼
    ┌──────────────────────┐
    │ Get Current Price    │
    │ (Ask for Buy,        │
    │  Bid for Sell)       │
    └──────────┬───────────┘
               │
       ┌───────┴───────┐
       │               │
       ▼               ▼
┌─────────────┐  ┌─────────────┐
│   Check     │  │   Check     │
│  Long EMA   │  │  Short EMA  │
│   Filter    │  │   Filter    │
└──────┬──────┘  └──────┬──────┘
       │                │
       ▼                ▼
┌─────────────┐  ┌─────────────┐
│ Filter = 0? │  │ Filter = 0? │
└──┬──────┬───┘  └──┬──────┬───┘
   │YES   │NO       │YES   │NO
   │      │         │      │
   │      ▼         │      ▼
   │  ┌────────┐   │  ┌────────┐
   │  │Calculate│   │  │Calculate│
   │  │EMA and │   │  │EMA and │
   │  │Check   │   │  │Check   │
   │  │Threshold│   │  │Threshold│
   │  └───┬────┘   │  └───┬────┘
   │      │        │      │
   │      ▼        │      ▼
   │  ┌────────┐  │  ┌────────┐
   │  │ Valid? │  │  │ Valid? │
   │  └─┬────┬─┘  │  └─┬────┬─┘
   │    │NO  │YES │    │NO  │YES
   │    │    │    │    │    │
   │    ▼    │    │    ▼    │
   │ Return  │    │ Return  │
   │ FALSE   │    │ FALSE   │
   │         │    │         │
   └─────────┴────┴─────────┘
               │
               ▼
         Return TRUE
```

## Trailing Stop Management Logic

```
┌─────────────────────────────────────┐
│    ManageTrailingStop()             │
└──────────────┬──────────────────────┘
               │
               ▼
    ┌──────────────────────┐
    │ Loop Through All     │
    │ Open Orders          │
    └──────────┬───────────┘
               │
               ▼
    ┌──────────────────────┐
    │ Filter Orders:       │
    │ • Same Symbol        │
    │ • Same Magic Number  │
    └──────────┬───────────┘
               │
          ┌────┴────┐
          │         │
          ▼         ▼
    ┌─────────┐  ┌──────────┐
    │  Buy    │  │   Sell   │
    │ Order?  │  │  Order?  │
    └────┬────┘  └────┬─────┘
         │            │
         ▼            ▼
    ┌─────────┐  ┌──────────┐
    │Calculate│  │Calculate │
    │ Profit: │  │ Profit:  │
    │Bid-Open │  │Open-Ask  │
    └────┬────┘  └────┬─────┘
         │            │
         ▼            ▼
    ┌─────────┐  ┌──────────┐
    │ Profit ≥│  │ Profit ≥ │
    │Trailing │  │Trailing  │
    │Points?  │  │Points?   │
    └─┬───┬───┘  └─┬────┬───┘
      │YES│NO      │YES │NO
      │   │        │    │
      │   ▼        │    ▼
      │ Skip       │  Skip
      │            │
      ▼            ▼
    ┌─────────┐  ┌──────────┐
    │Calculate│  │Calculate │
    │ New SL: │  │ New SL:  │
    │ Bid -   │  │ Ask +    │
    │ Trail   │  │ Trail    │
    └────┬────┘  └────┬─────┘
         │            │
         ▼            ▼
    ┌─────────┐  ┌──────────┐
    │ New SL  │  │ New SL   │
    │ Better? │  │ Better?  │
    └─┬───┬───┘  └─┬────┬───┘
      │YES│NO      │YES │NO
      │   │        │    │
      │   ▼        │    ▼
      │ Skip       │  Skip
      │            │
      ▼            ▼
    ┌─────────┐  ┌──────────┐
    │ Modify  │  │  Modify  │
    │ Order   │  │  Order   │
    │ Stop    │  │  Stop    │
    │ Loss    │  │  Loss    │
    └─────────┘  └──────────┘
```

## Decision Tree: When to Open Martingale Level

```
NEW MARTINGALE LEVEL DECISION TREE
===================================

Question 1: Is Max Order Limit Reached?
├─ YES → Do NOT open new level
└─ NO → Continue to Question 2

Question 2: Is Required Loss Distance Met?
├─ NO → Do NOT open new level
└─ YES → Continue to Question 3

Question 3: Is Trend Protection Enabled?
├─ NO → Continue to Question 4
└─ YES → Check Price Movement
    ├─ For Buy: Is price higher than previous candle?
    │   ├─ NO → Do NOT open new level
    │   └─ YES → Continue to Question 4
    └─ For Sell: Is price lower than previous candle?
        ├─ NO → Do NOT open new level
        └─ YES → Continue to Question 4

Question 4: Is MACD Protection Enabled?
├─ NO → Continue to Question 5
└─ YES → Check MACD Trend
    ├─ 3 Consecutive Divergent Bars?
    │   ├─ YES → Do NOT open new level
    │   └─ NO → Continue to Question 5

Question 5: Are EMA Filters Active?
├─ All Disabled (= 0) → Continue to Question 6
└─ Some Enabled → Check Price vs EMA
    ├─ Price Outside Allowed Zone?
    │   ├─ YES → Do NOT open new level
    │   └─ NO → Continue to Question 6

Question 6: Is Spread Acceptable?
├─ Spread > Max Spread?
│   ├─ YES → Do NOT open new level
│   └─ NO → OPEN NEW MARTINGALE LEVEL ✓
```

## Martingale Level Progression Example

```
EXAMPLE: 8-Level Buy Martingale Sequence
=========================================

Initial State:
- No open positions
- Market price at 1.1000

Level 1:
- Trigger: Price breaks above 20-bar high + 100 points
- Entry: 1.1100
- Lot Size: 0.01
- Status: Opened ✓

Price moves against us...

Level 2:
- Trigger: Price falls 150 points below Level 1 (1.1100 - 0.0150 = 1.0950)
- Current Price: 1.0950
- Checks: ✓ Trend Protection, ✓ MACD, ✓ EMA
- Entry: 1.0950
- Lot Size: 0.02
- Cumulative Lots: 0.03
- Status: Opened ✓

Price continues against us...

Level 3:
- Trigger: Price falls 200 points below Level 2 (1.0950 - 0.0200 = 1.0750)
- Current Price: 1.0750
- Checks: ✓ Trend Protection, ✓ MACD, ✓ EMA
- Entry: 1.0750
- Lot Size: 0.04
- Cumulative Lots: 0.07
- Status: Opened ✓

[Continues through Level 8 if losses persist]

Price Finally Reverses:
- Price rises to 1.1200 (profitable)
- Profit reaches 100 points above average entry
- Trailing Stop Activates at 1.1150
- Stop Loss trails at 50 points
- Final Close when price pulls back to 1.1150
- All positions closed with profit ✓
```

## Key Protection Mechanisms Summary

```
PROTECTION LAYER 1: Spread Filter
├─ Blocks all trading when spread > max
└─ Default: 30 points

PROTECTION LAYER 2: Entry Distance
├─ Ensures adequate spacing between levels
└─ Default: 100, 150, 200, 250, 300, 350, 400, 450 points

PROTECTION LAYER 3: Trend Protection
├─ Price must show reversal signs
└─ Prevents adding during strong adverse trends

PROTECTION LAYER 4: MACD Protection
├─ Monitors MACD momentum
└─ Blocks entry during 3-bar divergence

PROTECTION LAYER 5: EMA Filters
├─ Long EMA (200): Major trend alignment
├─ Short EMA (50): Minor trend alignment
└─ Configurable thresholds with +/- offsets

PROTECTION LAYER 6: Trailing Stop
├─ Activates at profit threshold
├─ Trails at configured distance
└─ Protects profits and ensures exits
```

---

**Understanding the Flow:**

1. **Initialization**: Sets up all parameters and arrays
2. **Every Tick**: Checks conditions and manages positions
3. **Entry Logic**: Multiple filters ensure quality entries
4. **Protection**: Layered protection prevents excessive losses
5. **Exit Logic**: Trailing stop protects profits
6. **Continuous**: Repeats for every market tick

This flow ensures disciplined, rule-based trading with multiple safety mechanisms.
