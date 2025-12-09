//+------------------------------------------------------------------+
//|                                               GMRemake_v1.0.mq4  |
//|                                     Copyright 2025, Lawjar-Algo  |
//|                       MT4 馬丁格爾交易策略 (Martingale Strategy)  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2025, Lawjar-Algo"
#property link      "https://github.com/lawjar/GMRemake-EA"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| 輸入參數 (Input Parameters)                                       |
//+------------------------------------------------------------------+

// 基礎設定 (Basic Settings)
enum ENUM_ENTRY_MODE
{
   ENTRY_MODE_INSTANT = 0,    // 即時突破 (每個 Tick 檢查)
   ENTRY_MODE_CONFIRMED = 1   // 確認突破 (收盤確認/新 K 線)
};

input ENUM_TIMEFRAMES Timeframe = PERIOD_H1;                    // 交易時區 (Trading Timeframe)
input ENUM_ENTRY_MODE EntryModeLevel1 = ENTRY_MODE_CONFIRMED;   // 第 1 層入場模式 (Level 1 Entry Mode)
input int             BarsCountedBack = 3;                      // 回溯 K 線數量 (用於計算高低點)
input int             MaxBuyOrder = 5;                          // 最大買單層數 (0 為不開買單)
input int             MaxSellOrder = 5;                         // 最大賣單層數 (0 為不開賣單)

// 入場距離參數 (點數) - 針對 BTCUSD 優化
input int             EntryDistance1 = 100;                     // 第 1 層入場距離 (首單)
input int             EntryDistance2 = 20000;                   // 第 2 層入場距離 (加倉)
input int             EntryDistance3 = 20000;                   // 第 3 層入場距離
input int             EntryDistance4 = 20000;                   // 第 4 層入場距離
input int             EntryDistance5 = 20000;                   // 第 5 層入場距離
input int             EntryDistance6 = 20000;                   // 第 6 層入場距離
input int             EntryDistance7 = 25000;                   // 第 7 層入場距離
input int             EntryDistance8 = 30000;                   // 第 8 層入場距離

// 手數設定 (Lot Size Parameters)
input double          LotSize1 = 0.01;                          // 第 1 層手數
input double          LotSize2 = 0.02;                          // 第 2 層手數
input double          LotSize3 = 0.04;                          // 第 3 層手數
input double          LotSize4 = 0.08;                          // 第 4 層手數
input double          LotSize5 = 0.16;                          // 第 5 層手數
input double          LotSize6 = 0.32;                          // 第 6 層手數
input double          LotSize7 = 0.64;                          // 第 7 層手數
input double          LotSize8 = 1.28;                          // 第 8 層手數

// 趨勢保護參數 (Trend Protection Parameters)
input bool            TrendProtection = true;                   // 啟用價格行為趨勢保護 (K 線顏色確認)
input bool            MACDTrendProtection = true;               // 啟用 MACD 趨勢保護 (避免逆勢加倉)
input int             MACDFastEMA = 5;                         // MACD 快速 EMA 週期
input int             MACDSlowEMA = 13;                         // MACD 慢速 EMA 週期
input int             MACDSignalSMA = 8;                        // MACD 信號 SMA 週期
input int             MACDDivergenceBars = 3;                   // MACD 背離判斷 K 線數量

// EMA 趨勢過濾參數 (EMA Trend Filter Parameters)
enum ENUM_EMA_FILTER_MODE
{
   EMA_FILTER_DISABLED = 0,   // 停用 (Disabled)
   EMA_FILTER_ABOVE = 1,      // 價格必須在 EMA 之上 (做多有利)
   EMA_FILTER_BELOW = 2       // 價格必須在 EMA 之下 (做空有利)
};

input int             EMATrendPeriodL = 200;                    // 長週期 EMA (Long Period)
input ENUM_EMA_FILTER_MODE EMATrendFilterLModeBuy = EMA_FILTER_DISABLED; // 買單的長週期 EMA 過濾模式
input double          EMATrendFilterLForBuy = 0;                // 買單 EMA(L) 距離緩衝 (+/- points)
input ENUM_EMA_FILTER_MODE EMATrendFilterLModeSell = EMA_FILTER_DISABLED; // 賣單的長週期 EMA 過濾模式
input double          EMATrendFilterLForSell = 0;               // 賣單 EMA(L) 距離緩衝 (+/- points)

input int             EMATrendPeriodS = 50;                     // 短週期 EMA (Short Period)
input ENUM_EMA_FILTER_MODE EMATrendFilterSModeBuy = EMA_FILTER_DISABLED; // 買單的短週期 EMA 過濾模式
input double          EMATrendFilterSForBuy = 0;                // 買單 EMA(S) 距離緩衝 (+/- points)
input ENUM_EMA_FILTER_MODE EMATrendFilterSModeSell = EMA_FILTER_DISABLED; // 賣單的短週期 EMA 過濾模式
input double          EMATrendFilterSForSell = 0;               // 賣單 EMA(S) 距離緩衝 (+/- points)

// 移動止損參數 (Trailing Stop Parameters)
input int             TrailingPoints = 8000;                    // 移動止損啟動點數 (獲利達此點數開始追蹤)
input int             StopTrailingPoints = 1000;                // 移動止損回撤距離 (利潤回吐多少點出場)

// 一般參數 (General Parameters)
input int             SlippageInPoints = 30;                    // 允許滑點 (Points)
input int             SpreadInPoints = 2000;                    // 最大允許點差 (Points)
input int             MagicNumber = 20251207;                   // 魔術編號 (Magic Number)
input string          Comment = "GMRemake_Martingale";          // 訂單註解

//+------------------------------------------------------------------+
//| 全域變數 (Global Variables)                                       |
//+------------------------------------------------------------------+
double EntryDistances[8];
double LotSizes[8];
int CurrentBuyOrders = 0;
int CurrentSellOrders = 0;
double LastBuyPrice = 0;
double LastSellPrice = 0;
double MaxBidPrice = 0; // 買單持倉期間的最高 Bid 價格 (用於移動止損)
double MinAskPrice = 0; // 賣單持倉期間的最低 Ask 價格 (用於移動止損)
datetime LastBarTime = 0; // 上一根 K 線時間 (用於新 K 線檢查)

//+------------------------------------------------------------------+
//| EA 初始化函式 (Expert initialization function)                    |
//+------------------------------------------------------------------+
int OnInit()
{
   // 初始化入場距離陣列 (轉換為 Point)
   EntryDistances[0] = EntryDistance1 * Point;
   EntryDistances[1] = EntryDistance2 * Point;
   EntryDistances[2] = EntryDistance3 * Point;
   EntryDistances[3] = EntryDistance4 * Point;
   EntryDistances[4] = EntryDistance5 * Point;
   EntryDistances[5] = EntryDistance6 * Point;
   EntryDistances[6] = EntryDistance7 * Point;
   EntryDistances[7] = EntryDistance8 * Point;
   
   // 初始化手數陣列
   LotSizes[0] = LotSize1;
   LotSizes[1] = LotSize2;
   LotSizes[2] = LotSize3;
   LotSizes[3] = LotSize4;
   LotSizes[4] = LotSize5;
   LotSizes[5] = LotSize6;
   LotSizes[6] = LotSize7;
   LotSizes[7] = LotSize8;
   
   Print("GMRemake Martingale EA 初始化成功 (Initialized Successfully)");
   Print("最大買單層數: ", MaxBuyOrder, " | 最大賣單層數: ", MaxSellOrder);
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| EA 反初始化函式 (Expert deinitialization function)                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   Print("GMRemake Martingale EA 已停止 (Deinitialized). 原因代碼: ", reason);
}

//+------------------------------------------------------------------+
//| EA Tick 處理函式 (Expert tick function)                           |
//+------------------------------------------------------------------+
void OnTick()
{
   // 檢查點差 (Check spread)
   double spread = (Ask - Bid) / Point;
   if(spread > SpreadInPoints)
   {
      return; // 點差過大，暫停交易
   }
   
   // 計算當前訂單 (Count current orders)
   CountOrders();
   
   // 若無訂單，重置虛擬追蹤高低點
   if(CurrentBuyOrders == 0) MaxBidPrice = 0;
   if(CurrentSellOrders == 0) MinAskPrice = 0;
   
   // 強制執行最大層數限制 (Enforce Max Orders Limits)
   if(CurrentBuyOrders > MaxBuyOrder)
   {
      CloseAllBuyOrders();
      return;
   }
   
   if(CurrentSellOrders > MaxSellOrder)
   {
      CloseAllSellOrders();
      return;
   }
   
   // 檢查止損 (達到最大層數 + 額外距離)
   CheckStopLoss();
   
   // 管理現有訂單的移動止損 (Manage Trailing Stop)
   ManageTrailingStop();
   
   // 檢查新 K 線 (Check for New Bar)
   bool isNewBar = false;
   if(LastBarTime != iTime(Symbol(), Timeframe, 0))
   {
       isNewBar = true;
       LastBarTime = iTime(Symbol(), Timeframe, 0);
   }
   
   // 檢查新入場訊號 (第 1 層 - 突破策略)
   if(CurrentBuyOrders == 0 && MaxBuyOrder > 0)
   {
      if(EntryModeLevel1 == ENTRY_MODE_INSTANT || (EntryModeLevel1 == ENTRY_MODE_CONFIRMED && isNewBar))
      {
         CheckBuyEntry(1);
      }
   }
   
   if(CurrentSellOrders == 0 && MaxSellOrder > 0)
   {
      if(EntryModeLevel1 == ENTRY_MODE_INSTANT || (EntryModeLevel1 == ENTRY_MODE_CONFIRMED && isNewBar))
      {
         CheckSellEntry(1);
      }
   }
   
   // 檢查馬丁格爾加倉 (第 2-8 層)
   // 加倉通常在新 K 線確認時檢查 (避免同一根 K 線重複加倉)
   if(isNewBar)
   {
       if(CurrentBuyOrders > 0 && CurrentBuyOrders < MaxBuyOrder)
       {
          CheckBuyEntry(CurrentBuyOrders + 1);
       }
       
       if(CurrentSellOrders > 0 && CurrentSellOrders < MaxSellOrder)
       {
          CheckSellEntry(CurrentSellOrders + 1);
       }
   }
}

//+------------------------------------------------------------------+
//| 計算當前訂單 (Count current orders)                               |
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
               // 記錄最後一張買單的價格 (通常是最低的買入價，因為是逆勢加倉)
               if(LastBuyPrice == 0 || OrderOpenPrice() < LastBuyPrice)
               {
                  LastBuyPrice = OrderOpenPrice();
               }
            }
            else if(OrderType() == OP_SELL)
            {
               CurrentSellOrders++;
               // 記錄最後一張賣單的價格 (通常是最高的賣出價)
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
//| 檢查買入訊號 (Check for Buy Entry Signal)                         |
//+------------------------------------------------------------------+
void CheckBuyEntry(int orderLevel)
{
   if(orderLevel > MaxBuyOrder) return;
   if(orderLevel > 8) return;
   
   // 根據入場模式決定 Shift (即時或確認)
   int shift = 1;
   double checkPrice = Ask;
   double currentPrice = Ask;
   
   if(orderLevel == 1 && EntryModeLevel1 == ENTRY_MODE_CONFIRMED)
   {
      shift = 2; // 從前一根 K 線開始回溯
      checkPrice = iClose(Symbol(), Timeframe, 1); // 檢查前一根 K 線收盤價是否突破
   }

   // 取得區間高點
   double highestHigh = iHigh(Symbol(), Timeframe, iHighest(Symbol(), Timeframe, MODE_HIGH, BarsCountedBack, shift));
   
   bool canEnter = false;
   
   // 首單邏輯 (First order logic)
   if(orderLevel == 1)
   {
      double entryThreshold = highestHigh + EntryDistances[0];
      
      if(checkPrice >= entryThreshold)
      {
         canEnter = true;
      }
   }
   // 馬丁格爾加倉邏輯 (Martingale orders 2nd to 8th)
   else if(orderLevel >= 2 && orderLevel <= 8)
   {
      if(LastBuyPrice > 0)
      {
         double requiredDistance = EntryDistances[orderLevel - 1];
         double currentLoss = LastBuyPrice - currentPrice;
         
         if(currentLoss >= requiredDistance)
         {
            canEnter = true;
            Print("Debug Buy Level ", orderLevel, ": 距離達成. 虧損: ", currentLoss, " 需求: ", requiredDistance);
            
            // 趨勢保護：檢查前一根 K 線是否收陽 (Bullish) 且突破前前一根高點
            if(TrendProtection && orderLevel >= 2)
            {
               double prevClose = iClose(Symbol(), Timeframe, 1);
               double prevOpen = iOpen(Symbol(), Timeframe, 1);
               double prevPrevHigh = iHigh(Symbol(), Timeframe, 2);
               
               // 如果前一根不是陽線 (Close <= Open) 或 收盤價未高於前前一根最高價，不進場
               if(prevClose <= prevOpen || prevClose <= prevPrevHigh)
               {
                  canEnter = false;
                  Print("Debug Buy Level ", orderLevel, ": 被趨勢保護阻擋. Close[1]: ", prevClose, " <= Open[1] or <= High[2]: ", prevPrevHigh);
               }
            }
         }
      }
   }
   
   if(!canEnter) return;
   
   // MACD 趨勢保護 (MACD Trend Protection)
   if(MACDTrendProtection && orderLevel >= 2)
   {
      if(!CheckMACDTrend(true))
      {
         Print("Debug Buy Level ", orderLevel, ": 被 MACD 保護阻擋");
         return;
      }
   }
   
   // EMA 趨勢過濾 (EMA Trend Filter)
   if(!CheckEMATrendFilter(true))
   {
      Print("Debug Buy Level ", orderLevel, ": 被 EMA 過濾器阻擋");
      return;
   }
   
   // 開立買單 (Open Buy Order)
   double lotSize = LotSizes[orderLevel - 1];
   Print("Debug: 嘗試開單 (Attempting OrderSend). Level: ", orderLevel, " Lot: ", lotSize, " Ask: ", Ask, " Bid: ", Bid);
   
   int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, SlippageInPoints, 0, 0, Comment, MagicNumber, 0, clrBlue);
   
   if(ticket > 0)
   {
      Print("買單已開啟 (Buy Order Opened): Level ", orderLevel, " | Lot: ", lotSize, " | Price: ", Ask);
      // 重置 MaxBidPrice 為當前價格，避免立即觸發移動止損
      MaxBidPrice = Ask; 
   }
   else
   {
      Print("開立買單失敗 (Error opening Buy order): ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| 檢查賣出訊號 (Check for Sell Entry Signal)                        |
//+------------------------------------------------------------------+
void CheckSellEntry(int orderLevel)
{
   if(orderLevel > MaxSellOrder) return;
   if(orderLevel > 8) return;
   
   // 根據入場模式決定 Shift
   int shift = 1;
   double checkPrice = Bid;
   double currentPrice = Bid;
   
   if(orderLevel == 1 && EntryModeLevel1 == ENTRY_MODE_CONFIRMED)
   {
      shift = 2; 
      checkPrice = iClose(Symbol(), Timeframe, 1); 
   }
   
   // 取得區間低點
   double lowestLow = iLow(Symbol(), Timeframe, iLowest(Symbol(), Timeframe, MODE_LOW, BarsCountedBack, shift));
   
   bool canEnter = false;
   
   // 首單邏輯
   if(orderLevel == 1)
   {
      double entryThreshold = lowestLow - EntryDistances[0];
      
      if(checkPrice <= entryThreshold)
      {
         canEnter = true;
      }
   }
   // 馬丁格爾加倉邏輯
   else if(orderLevel >= 2 && orderLevel <= 8)
   {
      if(LastSellPrice > 0)
      {
         double requiredDistance = EntryDistances[orderLevel - 1];
         double currentLoss = currentPrice - LastSellPrice;
         
         if(currentLoss >= requiredDistance)
         {
            canEnter = true;
            Print("Debug Sell Level ", orderLevel, ": 距離達成. 虧損: ", currentLoss, " 需求: ", requiredDistance);
            
            // 趨勢保護：檢查前一根 K 線是否收陰 (Bearish) 且跌破前前一根低點
            if(TrendProtection && orderLevel >= 2)
            {
               double prevClose = iClose(Symbol(), Timeframe, 1);
               double prevOpen = iOpen(Symbol(), Timeframe, 1);
               double prevPrevLow = iLow(Symbol(), Timeframe, 2);
               
               // 如果前一根不是陰線 (Close >= Open) 或 收盤價未低於前前一根最低價，不進場
               if(prevClose >= prevOpen || prevClose >= prevPrevLow)
               {
                  canEnter = false;
                  Print("Debug Sell Level ", orderLevel, ": 被趨勢保護阻擋. Close[1]: ", prevClose, " >= Open[1] or >= Low[2]: ", prevPrevLow);
               }
            }
         }
      }
   }
   
   if(!canEnter) return;
   
   // MACD 趨勢保護
   if(MACDTrendProtection && orderLevel >= 2)
   {
      if(!CheckMACDTrend(false))
      {
         Print("Debug Sell Level ", orderLevel, ": 被 MACD 保護阻擋");
         return;
      }
   }
   
   // EMA 趨勢過濾
   if(!CheckEMATrendFilter(false))
   {
      Print("Debug Sell Level ", orderLevel, ": 被 EMA 過濾器阻擋");
      return;
   }
   
   // 開立賣單 (Open Sell Order)
   double lotSize = LotSizes[orderLevel - 1];
   Print("Debug: 嘗試開單 (Attempting OrderSend). Level: ", orderLevel, " Lot: ", lotSize, " Ask: ", Ask, " Bid: ", Bid);

   int ticket = OrderSend(Symbol(), OP_SELL, lotSize, Bid, SlippageInPoints, 0, 0, Comment, MagicNumber, 0, clrRed);
   
   if(ticket > 0)
   {
      Print("賣單已開啟 (Sell Order Opened): Level ", orderLevel, " | Lot: ", lotSize, " | Price: ", Bid);
      // 重置 MinAskPrice 為當前價格
      MinAskPrice = Bid;
   }
   else
   {
      Print("開立賣單失敗 (Error opening Sell order): ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| 檢查 MACD 趨勢 (Check MACD Trend)                                 |
//| 若 MACD 未顯示連續 N 根背離，返回 true                             |
//+------------------------------------------------------------------+
bool CheckMACDTrend(bool isBuy)
{
   if (MACDDivergenceBars < 2) return true; // 至少需要比較 2 根 K 線

   bool isDivergent = true;

   for (int i = 1; i < MACDDivergenceBars; i++)
   {
      double currentMACD = iMACD(Symbol(), Timeframe, MACDFastEMA, MACDSlowEMA, MACDSignalSMA, PRICE_CLOSE, MODE_MAIN, i);
      double prevMACD = iMACD(Symbol(), Timeframe, MACDFastEMA, MACDSlowEMA, MACDSignalSMA, PRICE_CLOSE, MODE_MAIN, i + 1);

      if (isBuy)
      {
         // 做多時，若 MACD 持續下跌 (Current < Prev)，則視為背離/逆勢
         if (currentMACD >= prevMACD)
         {
            isDivergent = false;
            break;
         }
      }
      else
      {
         // 做空時，若 MACD 持續上升 (Current > Prev)，則視為背離/逆勢
         if (currentMACD <= prevMACD)
         {
            isDivergent = false;
            break;
         }
      }
   }
   
   // 如果確認為背離 (isDivergent 為 true)，則返回 false (不允許交易)
   if (isDivergent)
   {
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| 檢查 EMA 趨勢過濾 (Check EMA Trend Filter)                        |
//+------------------------------------------------------------------+
bool CheckEMATrendFilter(bool isBuy)
{
   double currentPrice = isBuy ? Ask : Bid;
   
   // --- 長週期 EMA 檢查 (Long EMA Check) ---
   double emaL = iMA(Symbol(), Timeframe, EMATrendPeriodL, 0, MODE_EMA, PRICE_CLOSE, 0);
   
   // 買單 - 長週期 EMA
   if(isBuy && EMATrendFilterLModeBuy != EMA_FILTER_DISABLED)
   {
      double threshold = emaL + (EMATrendFilterLForBuy * Point);
      if(EMATrendFilterLModeBuy == EMA_FILTER_ABOVE && currentPrice <= threshold) return false;
      if(EMATrendFilterLModeBuy == EMA_FILTER_BELOW && currentPrice >= threshold) return false;
   }
   
   // 賣單 - 長週期 EMA
   if(!isBuy && EMATrendFilterLModeSell != EMA_FILTER_DISABLED)
   {
      double threshold = emaL + (EMATrendFilterLForSell * Point);
      if(EMATrendFilterLModeSell == EMA_FILTER_ABOVE && currentPrice <= threshold) return false;
      if(EMATrendFilterLModeSell == EMA_FILTER_BELOW && currentPrice >= threshold) return false;
   }

   // --- 短週期 EMA 檢查 (Short EMA Check) ---
   double emaS = iMA(Symbol(), Timeframe, EMATrendPeriodS, 0, MODE_EMA, PRICE_CLOSE, 0);

   // 買單 - 短週期 EMA
   if(isBuy && EMATrendFilterSModeBuy != EMA_FILTER_DISABLED)
   {
      double threshold = emaS + (EMATrendFilterSForBuy * Point);
      if(EMATrendFilterSModeBuy == EMA_FILTER_ABOVE && currentPrice <= threshold) return false;
      if(EMATrendFilterSModeBuy == EMA_FILTER_BELOW && currentPrice >= threshold) return false;
   }

   // 賣單 - 短週期 EMA
   if(!isBuy && EMATrendFilterSModeSell != EMA_FILTER_DISABLED)
   {
      double threshold = emaS + (EMATrendFilterSForSell * Point);
      if(EMATrendFilterSModeSell == EMA_FILTER_ABOVE && currentPrice <= threshold) return false;
      if(EMATrendFilterSModeSell == EMA_FILTER_BELOW && currentPrice >= threshold) return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| 管理移動止損 (Manage Trailing Stop - Basket Logic)                |
//+------------------------------------------------------------------+
void ManageTrailingStop()
{
   double trailingStart = TrailingPoints * Point;
   double trailingStop = StopTrailingPoints * Point;
   
   // --- 買單籃子邏輯 (Buy Basket Logic) ---
   if(CurrentBuyOrders > 0)
   {
      // 1. 更新最高水位線 (MaxBidPrice)
      if(MaxBidPrice == 0 || Bid > MaxBidPrice) MaxBidPrice = Bid;
      
      // 2. 計算買單平均價格 (加權平均)
      double totalLots = 0;
      double weightedPrice = 0;
      for(int i = OrdersTotal() - 1; i >= 0; i--)
      {
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         {
            if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol() && OrderType() == OP_BUY)
            {
               weightedPrice += OrderOpenPrice() * OrderLots();
               totalLots += OrderLots();
            }
         }
      }
      
      if(totalLots > 0)
      {
         double avgPrice = weightedPrice / totalLots;
         
         // 3. 檢查是否進入獲利區間 (高於均價 + 啟動點數)
         if(MaxBidPrice > avgPrice + trailingStart)
         {
            // 4. 檢查回撤 (價格從高點回落)
            if(MaxBidPrice - Bid >= trailingStop)
            {
               Print("買單移動止損觸發 (Basket Trailing Stop Triggered for BUY). AvgPrice: ", avgPrice, " High: ", MaxBidPrice, " Close: ", Bid);
               CloseAllBuyOrders();
            }
         }
      }
   }
   
   // --- 賣單籃子邏輯 (Sell Basket Logic) ---
   if(CurrentSellOrders > 0)
   {
      // 1. 更新最低水位線 (MinAskPrice)
      if(MinAskPrice == 0 || Ask < MinAskPrice) MinAskPrice = Ask;
      
      // 2. 計算賣單平均價格
      double totalLots = 0;
      double weightedPrice = 0;
      for(int i = OrdersTotal() - 1; i >= 0; i--)
      {
         if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         {
            if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol() && OrderType() == OP_SELL)
            {
               weightedPrice += OrderOpenPrice() * OrderLots();
               totalLots += OrderLots();
            }
         }
      }
      
      if(totalLots > 0)
      {
         double avgPrice = weightedPrice / totalLots;
         
         // 3. 檢查是否進入獲利區間 (低於均價 - 啟動點數)
         if(MinAskPrice < avgPrice - trailingStart)
         {
            // 4. 檢查回撤 (價格從低點反彈)
            if(Ask - MinAskPrice >= trailingStop)
            {
               Print("賣單移動止損觸發 (Basket Trailing Stop Triggered for SELL). AvgPrice: ", avgPrice, " Low: ", MinAskPrice, " Close: ", Ask);
               CloseAllSellOrders();
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| 平倉所有買單 (Close All Buy Orders)                               |
//+------------------------------------------------------------------+
void CloseAllBuyOrders()
{
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol() && OrderType() == OP_BUY)
         {
            bool closed = OrderClose(OrderTicket(), OrderLots(), Bid, SlippageInPoints, clrRed);
            if(closed) 
               Print("已平倉買單 #", OrderTicket(), " (原因: 達到最大層數或止損)");
            else 
               Print("平倉買單失敗 #", OrderTicket(), " Error: ", GetLastError());
         }
      }
   }
   CurrentSellOrders = 0;
}

//+------------------------------------------------------------------+
//| 檢查止損 - 最大層數保護 (Check Stop Loss)                         |
//+------------------------------------------------------------------+
void CheckStopLoss()
{
   // 買單方向
   if(CurrentBuyOrders >= MaxBuyOrder && MaxBuyOrder > 0)
   {
      // 決定止損距離
      // 規則：如果 MaxBuyOrder=6，使用第 7 層的 EntryDistance 作為止損距離
      
      int distanceIndex = MaxBuyOrder; 
      
      // 如果下一層超過定義的 8 層，使用最後一層的距離
      if(distanceIndex >= 8) distanceIndex = 7; 
      
      double stopLossDistance = EntryDistances[distanceIndex];
      
      if(LastBuyPrice > 0)
      {
         double currentLoss = LastBuyPrice - Bid;
         if(currentLoss >= stopLossDistance)
         {
            Print("止損觸發 (Stop Loss Triggered): 買單達最大層數 (", MaxBuyOrder, ") 且價格移動 ", currentLoss/Point, " 點 (目標: ", stopLossDistance/Point, ").");
            CloseAllBuyOrders();
         }
      }
   }

   // 賣單方向
   if(CurrentSellOrders >= MaxSellOrder && MaxSellOrder > 0)
   {
      int distanceIndex = MaxSellOrder; 
      
      if(distanceIndex >= 8) distanceIndex = 7;
      
      double stopLossDistance = EntryDistances[distanceIndex];
      
      if(LastSellPrice > 0)
      {
         double currentLoss = Ask - LastSellPrice;
         if(currentLoss >= stopLossDistance)
         {
            Print("止損觸發 (Stop Loss Triggered): 賣單達最大層數 (", MaxSellOrder, ") 且價格移動 ", currentLoss/Point, " 點 (目標: ", stopLossDistance/Point, ").");
            CloseAllSellOrders();
         }
      }
   }
}

//+------------------------------------------------------------------+
//| 平倉所有賣單 (Close All Sell Orders)                              |
//+------------------------------------------------------------------+
void CloseAllSellOrders()
{
   for(int i = OrdersTotal() - 1; i >= 0; i--)
   {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol() && OrderType() == OP_SELL)
         {
            bool closed = OrderClose(OrderTicket(), OrderLots(), Ask, SlippageInPoints, clrBlue);
            if(closed) 
               Print("已平倉賣單 #", OrderTicket(), " (原因: 達到最大層數或止損)");
            else 
               Print("平倉賣單失敗 #", OrderTicket(), " Error: ", GetLastError());
         }
      }
   }
   CurrentSellOrders = 0;
}
