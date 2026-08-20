# Digital Logic Design Projects

這是我在數位邏輯設計課程中的幾項 Verilog Lab 作品。
本儲存庫包含了多個 Verilog HDL 的基礎與進階專案，涵蓋了組合邏輯、序向邏輯、有限狀態機 (FSM) 以及外部硬體感測器時序控制等技術。

## 🛠️ 開發環境 (Environment)
* **硬體描述語言:** Verilog HDL
* **開發/合成工具:** Quartus Prime 18.1
* **模擬工具:** ModelSim / Testbench

## 📂 專案目錄 (Projects)
點擊下方專案名稱，可進入子資料夾查看原始碼與詳細架構：

1. **[BCD 加減法器 (BCD Adder & Subtractor)](./BCD_adder)**
   * **核心技術：** 基礎組合邏輯、二進位與十進位轉換、進位 (Carry) 與借位 (Borrow) 處理。

2. **[LED 多頻段跑馬燈 (LED Multi-frequency Marquee)](./led_light)**
   * **核心技術：** 時脈除頻器 (Clock Divider) 設計、計數器與多工選頻器應用。

3. **[密碼鎖 (Password Lock / Keypad Scanner)](./keypad_scanner)**
   * **核心技術：** 有限狀態機 (FSM) 設計、按鍵防彈跳 (Debounce) 處理。

4. **[PWM 直流馬達控制 (PWM DC Motor Control)](./DC_motor)**
   * **核心技術：** 工作週期 (Duty Cycle) 控制、實體硬體驅動訊號輸出。

5. **[HC-SR04 超音波測距 (Ultrasonic Sensor)](./hc_sr04)**
   * **核心技術：** 外部感測器時序讀寫 (Trigger 發送與 Echo 接收)、精準 Timing Control 與 Datasheet 實作。

## 🚀 關於本儲存庫
這是一個用於展示履歷與實作能力的綜合儲存庫。每個子資料夾內皆包含專案的 `.v` 原始碼與腳位設定檔 (`.qsf`)。