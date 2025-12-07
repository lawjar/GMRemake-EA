//+------------------------------------------------------------------+
//|                                      GMRemark_Martingale_EA.mq4 |
//|                        Copyright 2024, GMRemark Martingale EA    |
//|                      A Martingale Trading Strategy for MT4       |
//|                      Original idea from AlgoX GM                 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, GMRemark Martingale EA"
#property link      "https://github.com/yourusername/GMRemark"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Input Parameters                                                  |
//+------------------------------------------------------------------+

// Basic Settings
input ENUM_TIMEFRAMES Timeframe = PERIOD_H1;                    // Trading Timeframe
input int             BarsCountedBack = 20;                     // Bars Counted for Entry Signal
input int             MaxBuyOrder = 8;                          // Max Buy Orders (0=No Buy)
input int             MaxSellOrder = 8;                         // Max Sell Orders (0=No Sell)

// Entry Distance Parameters (in points)
input int             EntryDistance1 = 100;                     // Entry Distance 1 (First Order)
input int             EntryDistance2 = 150;                     // Entry Distance 2 (Second Order)
input int             EntryDistance3 = 200;                     // Entry Distance 3 (Third Order)
input int             EntryDistance4 = 250;                     // Entry Distance 4 (Fourth Order)
input int             EntryDistance5 = 300;                     // Entry Distance 5 (Fifth Order)
input int             EntryDistance6 = 350;                     // Entry Distance 6 (Sixth Order)
input int             EntryDistance7 = 400;                     // Entry Distance 7 (Seventh Order)
input int             EntryDistance8 = 450;                     // Entry Distance 8 (Eighth Order)

// Lot Size Parameters
input double          LotSize1 = 0.01;                          // Lot Size 1 (First Order)
input double          LotSize2 = 0.02;                          // Lot Size 2 (Second Order)
input double          LotSize3 = 0.04;                          // Lot Size 3 (Third Order)
input double          LotSize4 = 0.08;                          // Lot Size 4 (Fourth Order)
input double          LotSize5 = 0.16;                          // Lot Size 5 (Fifth Order)
input double          LotSize6 = 0.32;                          // Lot Size 6 (Sixth Order)
input double          LotSize7 = 0.64;                          // Lot Size 7 (Seventh Order)
input double          LotSize8 = 1.28;                          // Lot Size 8 (Eighth Order)

// Trend Protection Parameters
input bool            TrendProtection = true;                   // Trend Protection (Price Confirmation)
input bool            MACDTrendProtection = true;               // MACD Trend Protection

// EMA Trend Filter Parameters
input int             EMATrendPeriodL = 200;                    // EMA Trend Period (Long)
input double          EMATrendFilterLForBuy = 0;                // EMA(L) Filter for Buy (0=Disabled, +/-points)
input double          EMATrendFilterLForSell = 0;               // EMA(L) Filter for Sell (0=Disabled, +/-points)
input int             EMATrendPeriodS = 50;                     // EMA Trend Period (Short)
input double          EMATrendFilterSForBuy = 0;                // EMA(S) Filter for Buy (0=Disabled, +/-points)
input double          EMATrendFilterSForSell = 0;               // EMA(S) Filter for Sell (0=Disabled, +/-points)

// Trailing Stop Parameters
input int             TrailingPoints = 100;                     // Trailing Start Points
input int             StopTrailingPoints = 50;                  // Stop Trailing Points (Trail Distance)

// General Parameters
input int             SlippageInPoints = 30;                    // Slippage in Points
input int             SpreadInPoints = 30;                      // Maximum Spread in Points
input int             MagicNumber = 20241207;                   // Magic Number
input string          Comment = "GMRemark_Martingale";          // Order Comment

//+------------------------------------------------------------------+
//| Global Variables                                                  |
//+------------------------------------------------------------------+
double EntryDistances[8];
double LotSizes[8];
int CurrentBuyOrders = 0;
int CurrentSellOrders = 0;
double LastBuyPrice = 0;
double LastSellPrice = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   // Initialize entry distances array
   EntryDistances[0] = EntryDistance1 * Point;
   EntryDistances[1] = EntryDistance2 * Point;
   EntryDistances[2] = EntryDistance3 * Point;
   EntryDistances[3] = EntryDistance4 * Point;
   EntryDistances[4] = EntryDistance5 * Point;
   EntryDistances[5] = EntryDistance6 * Point;
   EntryDistances[6] = EntryDistance7 * Point;
   EntryDistances[7] = EntryDistance8 * Point;
   
   // Initialize lot sizes array
   LotSizes[0] = LotSize1;
   LotSizes[1] = LotSize2;
   LotSizes[2] = LotSize3;
   LotSizes[3] = LotSize4;
   LotSizes[4] = LotSize5;
   LotSizes[5] = LotSize6;
   LotSizes[6] = LotSize7;
   LotSizes[7] = LotSize8;
   
   Print("GMRemark Martingale EA Initialized Successfully");
   Print("Max Buy Orders: ", MaxBuyOrder, " | Max Sell Orders: ", MaxSellOrder);
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Print("GMRemark Martingale EA Deinitialized. Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Check spread
   double spread = (Ask - Bid) / Point;
   if(spread > SpreadInPoints)
   {
      return;
   }
   
   // Count current orders
   CountOrders();
   
   // Check trailing stop for existing orders
   ManageTrailingStop();
   
   // Check for new entry signals
   if(CurrentBuyOrders == 0 && MaxBuyOrder > 0)
   {
      CheckBuyEntry(1);
   }
   
   if(CurrentSellOrders == 0 && MaxSellOrder > 0)
   {
      CheckSellEntry(1);
   }
   
   // Check for martingale entries
   if(CurrentBuyOrders > 0 && CurrentBuyOrders < MaxBuyOrder)
   {
      CheckBuyEntry(CurrentBuyOrders + 1);
   }
   
   if(CurrentSellOrders > 0 && CurrentSellOrders < MaxSellOrder)
   {
      CheckSellEntry(CurrentSellOrders + 1);
   }
}

//+------------------------------------------------------------------+
//| Count current orders                                             |
//+------------------------------------------------------------------+
void CountOrders()
{
   CurrentBuyOrders = 0;
   CurrentSellOrders = 0;
   LastBuyPrice = 0;
   LastSellPrice = 0;
   
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol())
         {
            if(OrderType() == OP_BUY)
            {
               CurrentBuyOrders++;
               if(LastBuyPrice == 0 || OrderOpenPrice() < LastBuyPrice)
               {
                  LastBuyPrice = OrderOpenPrice();
               }
            }
            else if(OrderType() == OP_SELL)
            {
               CurrentSellOrders++;
               if(LastSellPrice == 0 || OrderOpenPrice() > LastSellPrice)
               {
                  LastSellPrice = OrderOpenPrice();
               }
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Check for Buy Entry Signal                                       |
//+------------------------------------------------------------------+
void CheckBuyEntry(int orderLevel)
{
   if(orderLevel > MaxBuyOrder) return;
   if(orderLevel > 8) return;
   
   // Get bars data
   double highestHigh = iHigh(Symbol(), Timeframe, iHighest(Symbol(), Timeframe, MODE_HIGH, BarsCountedBack, 1));
   double currentPrice = Ask;
   
   bool canEnter = false;
   
   // First order logic
   if(orderLevel == 1)
   {
      double entryThreshold = highestHigh + EntryDistances[0];
      if(currentPrice >= entryThreshold)
      {
         canEnter = true;
      }
   }
   // Martingale orders (2nd to 8th)
   else if(orderLevel >= 2 && orderLevel <= 8)
   {
      if(LastBuyPrice > 0)
      {
         double requiredDistance = EntryDistances[orderLevel - 1];
         double currentLoss = LastBuyPrice - currentPrice;
         
         if(currentLoss >= requiredDistance)
         {
            canEnter = true;
            
            // Trend Protection: Check if price is higher than previous candle
            if(TrendProtection && orderLevel >= 2)
            {
               double prevClose = iClose(Symbol(), Timeframe, 1);
               double prev2Close = iClose(Symbol(), Timeframe, 2);
               if(prevClose <= prev2Close)
               {
                  canEnter = false;
               }
            }
         }
      }
   }
   
   if(!canEnter) return;
   
   // MACD Trend Protection
   if(MACDTrendProtection && orderLevel >= 2)
   {
      if(!CheckMACDTrend(true))
      {
         return;
      }
   }
   
   // EMA Trend Filter
   if(!CheckEMATrendFilter(true))
   {
      return;
   }
   
   // Open Buy Order
   double lotSize = LotSizes[orderLevel - 1];
   int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, SlippageInPoints, 0, 0, Comment, MagicNumber, 0, clrBlue);
   
   if(ticket > 0)
   {
      Print("Buy Order Opened: Level ", orderLevel, " | Lot: ", lotSize, " | Price: ", Ask);
   }
   else
   {
      Print("Error opening Buy order: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Check for Sell Entry Signal                                      |
//+------------------------------------------------------------------+
void CheckSellEntry(int orderLevel)
{
   if(orderLevel > MaxSellOrder) return;
   if(orderLevel > 8) return;
   
   // Get bars data
   double lowestLow = iLow(Symbol(), Timeframe, iLowest(Symbol(), Timeframe, MODE_LOW, BarsCountedBack, 1));
   double currentPrice = Bid;
   
   bool canEnter = false;
   
   // First order logic
   if(orderLevel == 1)
   {
      double entryThreshold = lowestLow - EntryDistances[0];
      if(currentPrice <= entryThreshold)
      {
         canEnter = true;
      }
   }
   // Martingale orders (2nd to 8th)
   else if(orderLevel >= 2 && orderLevel <= 8)
   {
      if(LastSellPrice > 0)
      {
         double requiredDistance = EntryDistances[orderLevel - 1];
         double currentLoss = currentPrice - LastSellPrice;
         
         if(currentLoss >= requiredDistance)
         {
            canEnter = true;
            
            // Trend Protection: Check if price is lower than previous candle
            if(TrendProtection && orderLevel >= 2)
            {
               double prevClose = iClose(Symbol(), Timeframe, 1);
               double prev2Close = iClose(Symbol(), Timeframe, 2);
               if(prevClose >= prev2Close)
               {
                  canEnter = false;
               }
            }
         }
      }
   }
   
   if(!canEnter) return;
   
   // MACD Trend Protection
   if(MACDTrendProtection && orderLevel >= 2)
   {
      if(!CheckMACDTrend(false))
      {
         return;
      }
   }
   
   // EMA Trend Filter
   if(!CheckEMATrendFilter(false))
   {
      return;
   }
   
   // Open Sell Order
   double lotSize = LotSizes[orderLevel - 1];
   int ticket = OrderSend(Symbol(), OP_SELL, lotSize, Bid, SlippageInPoints, 0, 0, Comment, MagicNumber, 0, clrRed);
   
   if(ticket > 0)
   {
      Print("Sell Order Opened: Level ", orderLevel, " | Lot: ", lotSize, " | Price: ", Bid);
   }
   else
   {
      Print("Error opening Sell order: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Check MACD Trend                                                 |
//| Returns true if MACD is not showing 3 consecutive divergences   |
//+------------------------------------------------------------------+
bool CheckMACDTrend(bool isBuy)
{
   // MACD with period 14
   double macd1 = iMACD(Symbol(), Timeframe, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 1);
   double macd2 = iMACD(Symbol(), Timeframe, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 2);
   double macd3 = iMACD(Symbol(), Timeframe, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 3);
   
   if(isBuy)
   {
      // Check for bullish trend (MACD rising)
      if(macd1 < macd2 && macd2 < macd3)
      {
         // 3 consecutive bars showing bearish divergence - don't open buy
         return false;
      }
   }
   else
   {
      // Check for bearish trend (MACD falling)
      if(macd1 > macd2 && macd2 > macd3)
      {
         // 3 consecutive bars showing bullish divergence - don't open sell
         return false;
      }
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check EMA Trend Filter                                           |
//+------------------------------------------------------------------+
bool CheckEMATrendFilter(bool isBuy)
{
   double currentPrice = isBuy ? Ask : Bid;
   
   // Check Long EMA Filter
   if(isBuy && EMATrendFilterLForBuy != 0)
   {
      double emaL = iMA(Symbol(), Timeframe, EMATrendPeriodL, 0, MODE_EMA, PRICE_CLOSE, 0);
      double threshold = emaL + (EMATrendFilterLForBuy * Point);
      
      if(EMATrendFilterLForBuy > 0 && currentPrice < threshold)
      {
         return false;
      }
      if(EMATrendFilterLForBuy < 0 && currentPrice > threshold)
      {
         return false;
      }
   }
   
   if(!isBuy && EMATrendFilterLForSell != 0)
   {
      double emaL = iMA(Symbol(), Timeframe, EMATrendPeriodL, 0, MODE_EMA, PRICE_CLOSE, 0);
      double threshold = emaL + (EMATrendFilterLForSell * Point);
      
      if(EMATrendFilterLForSell > 0 && currentPrice < threshold)
      {
         return false;
      }
      if(EMATrendFilterLForSell < 0 && currentPrice > threshold)
      {
         return false;
      }
   }
   
   // Check Short EMA Filter
   if(isBuy && EMATrendFilterSForBuy != 0)
   {
      double emaS = iMA(Symbol(), Timeframe, EMATrendPeriodS, 0, MODE_EMA, PRICE_CLOSE, 0);
      double threshold = emaS + (EMATrendFilterSForBuy * Point);
      
      if(EMATrendFilterSForBuy > 0 && currentPrice < threshold)
      {
         return false;
      }
      if(EMATrendFilterSForBuy < 0 && currentPrice > threshold)
      {
         return false;
      }
   }
   
   if(!isBuy && EMATrendFilterSForSell != 0)
   {
      double emaS = iMA(Symbol(), Timeframe, EMATrendPeriodS, 0, MODE_EMA, PRICE_CLOSE, 0);
      double threshold = emaS + (EMATrendFilterSForSell * Point);
      
      if(EMATrendFilterSForSell > 0 && currentPrice < threshold)
      {
         return false;
      }
      if(EMATrendFilterSForSell < 0 && currentPrice > threshold)
      {
         return false;
      }
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Manage Trailing Stop                                             |
//+------------------------------------------------------------------+
void ManageTrailingStop()
{
   double trailingStart = TrailingPoints * Point;
   double trailingStop = StopTrailingPoints * Point;
   
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol())
         {
            if(OrderType() == OP_BUY)
            {
               double profit = Bid - OrderOpenPrice();
               
               if(profit >= trailingStart)
               {
                  double newSL = Bid - trailingStop;
                  
                  if(OrderStopLoss() == 0 || newSL > OrderStopLoss())
                  {
                     bool modified = OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0, clrBlue);
                     if(modified)
                     {
                        Print("Trailing Stop Updated for Buy Order #", OrderTicket(), " New SL: ", newSL);
                     }
                  }
               }
            }
            else if(OrderType() == OP_SELL)
            {
               double profit = OrderOpenPrice() - Ask;
               
               if(profit >= trailingStart)
               {
                  double newSL = Ask + trailingStop;
                  
                  if(OrderStopLoss() == 0 || newSL < OrderStopLoss())
                  {
                     bool modified = OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0, clrRed);
                     if(modified)
                     {
                        Print("Trailing Stop Updated for Sell Order #", OrderTicket(), " New SL: ", newSL);
                     }
                  }
               }
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
