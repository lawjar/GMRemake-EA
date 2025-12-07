# 快速入門指南 - GMRemake Martingale EA

## 5 分鐘快速設定

### 步驟 1: 安裝 EA (2 分鐘)

1. **下載 EA 檔案**
   - 找到 `MT4/Experts/GMRemake.mq4`
   - 下載此檔案

2. **安裝到 MT4**
   - 開啟 MetaTrader 4
   - 點擊 `文件 (File)` → `打開數據文件夾 (Open Data Folder)`
   - 進入 `MQL4` → `Experts`
   - 將 `GMRemake.mq4` 複製到此資料夾
   - 回到 MT4，在「導航器 (Navigator)」面板右鍵點擊 `刷新 (Refresh)` (或重啟 MT4)

3. **確認安裝**
   - 在 MT4 導航器面板，展開 `Expert Advisors`
   - 您應該能看到 `GMRemake`

### 步驟 2: 首次使用設定 (2 分鐘)

1. **開啟圖表**
   - 開啟 EUR/USD H1 圖表 (建議新手使用)
   - 確保您已載入至少 1 年的歷史數據

2. **掛載 EA**
   - 從導航器將 `GMRemake` 拖曳到圖表上
   - 設定視窗將會出現

3. **使用新手設定**
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
   
   (其他設定保持預設)
   ```

4. **啟用自動交易**
   - 點擊 `確定 (OK)` 套用設定
   - 點擊 MT4 工具列上的 `自動交易 (Auto Trading)` 按鈕 (應變為綠色)
   - 檢查圖表右上角是否出現笑臉圖示

### 步驟 3: 監控 (1 分鐘)

1. **檢查終端視窗**
   - 開啟 `終端 (Terminal)` 面板 (檢視 → 終端 或 Ctrl+T)
   - 切換到 `EA (Experts)` 標籤頁
   - 您應該看到訊息："GMRemake Martingale EA Initialized Successfully"

2. **確認設定**
   - 檢查日誌中顯示 "Max Buy Orders: 3 | Max Sell Orders: 3"

## 接下來會發生什麼？

### EA 將會：
- ✅ 監控價格突破訊號
- ✅ 當價格超過最高點 100 點時開啟首張買單
- ✅ 若價格逆勢，將開啟馬丁加倉
- ✅ 當獲利時，啟動移動止損
- ✅ 當移動止損觸發時，平掉所有倉位

### 首單入場
- **買入訊號**：價格高於 20 根 K 線的最高點 + 100 點
- **賣出訊號**：價格低於 20 根 K 線的最低點 - 100 點

### 馬丁加倉
- **第 2 層**：若價格比第 1 層下跌 200 點 (做多時)
- **第 3 層**：若價格比第 2 層下跌 300 點 (做多時)

### 出場
- **移動止損**：獲利超過 100 點時啟動
- **回撤距離**：保持在當前價格後方 50 點

## 首日檢查清單

- [ ] EA 在 Experts 標籤頁顯示初始化成功訊息
- [ ] 自動交易按鈕已啟用 (綠色)
- [ ] 圖表上有笑臉圖示
- [ ] 點差 (Spread) 低於 30 點 (3 pips)
- [ ] 帳戶餘額 > $500 (建議最低金額)
- [ ] 使用模擬帳戶 (強烈建議首月使用)

## 觀察您的第一筆交易

### 當 EA 開啟首張訂單時：
1. 您會在 `終端` → `交易` 標籤頁看到訂單
2. 訂單註釋 (Comment) 會顯示 "GMRemake_Martingale"
3. 檢查開倉價格是否符合入場邏輯
