# 🚀 My 4-Year Forex Trading Journey: Data-Driven Performance & Strategy Analysis

## 📌 Project Overview

Analyzed **7,950 real-world forex trades (2021–2024)** to uncover profitability patterns, risk behavior, and strategy performance.  
This project transforms raw trading data into actionable insights using **SQL and Power BI**, focusing on decision-making, not just analysis.

---

## 📊 Dataset

| Attribute | Value |
|---|---|
| Total Trades | 7,950 |
| Duration | Jan 2021 – Dec 2024 (4 Years) |
| Currency Pairs | XAUUSD, EURUSD, GBPUSD, USDCAD, EURGBP |
| Sessions | London, New York |

---

## 📌 Attributes

- **Trade Identification:** SNo, Date
- **Market Details:** Pair, Session, Day
- **Trade Setup:** Direction (Buy/Sell), Lot Size
- **Risk Management:** Risk Amount, Risk-to-Reward (RR)
- **Trade Outcome:** Result (Win/Loss), TP Hit (TP/SL/BE)
- **Performance Metrics:** PnL, Account Balance
- **Time Analysis:** Trade Duration

---

## ❓ Business Questions

- Which trading session is most profitable?
- Which currency pair generates the highest returns?
- Does win rate align with risk-reward strategy?
- What is the worst drawdown period?
- Which day/session combination performs best?
- Are larger lot sizes more profitable or risky?

---

## 📈 Key Insights

| Metric | Value |
|---|---|
| 💰 Total Profit | **$3,71,966.01** |
| 📈 Growth vs Last Year | **+298.1%** |
| 📉 Win Rate | **30.24%** (2,404 wins / 7,950 trades) |
| ⚖️ Avg Risk:Reward | **1.50** (Target: 1:3 setups) |
| 🔢 Total Trades | **7,950** (Avg 9.6 trades/day) |
| 🥇 Best Pair | **EURGBP** ($82,029) |
| 📊 Second Best Pair | **XAUUSD** ($79,868) |
| 🏙️ London P&L | **$170.21K** (29.4% WR) |
| 🗽 New York P&L | **$201.76K** (31.0% WR) |
| 📅 Best Year | **2024** ($2,99,303.07) |
| 📉 Worst Year | **2022** (-$2,713.85) |
| ⏱️ Avg Win Duration | **~4h 47m** |
| ⏱️ Avg Loss Duration | **~0h 42m** |

### Strategy Edge
- Required Win Rate for break-even: ~40%
- **Actual Win Rate: 30.24%**
- → **Profitability achieved via higher Risk-Reward ratio (1.50 avg)**
- ⚠️ Losing trades had significantly shorter durations, indicating premature exits or tight stop losses

---

## 💡 Business Recommendations

- ✅ **Focus trading during London & New York sessions** — both are profitable
- ❌ **Avoid low-performing days** (e.g., Friday NY session based on heatmap)
- 📊 **Optimize for Risk-Reward (RR)** instead of chasing higher win rate
- 📉 **Reduce variability in lot size** to control risk consistency
- 🎯 **Focus on high-performing setups** — Top setup: EURGBP | New York | Friday (37% WR)
- 📈 **2023–2024 shows exponential equity growth** — strategy matured over time

---

## 📊 Dashboard Features

- **KPI Cards:** Total P&L, Win Rate, Total Trades, Avg RR, Best/Worst Trade
- **Equity Curve** — Cumulative P&L Over Time (2021–2024)
- **TP vs SL vs Break Even** — Donut chart of trade outcomes
- **Total P&L by Direction** — Buy vs Sell win rates & P&L
- **P&L by Currency Pairs** — Horizontal bar chart
- **London vs New York Session** — Side-by-side P&L & WR comparison
- **Total P&L by Year** — Annual bar chart
- **Top Setups** — Pair + Session + Day combinations ranked by win %
- **Risk Amount Consistency Over Time** — Line chart with avg reference
- **Win Rate Year Over Year** — Annual trend line
- **P&L Heatmap** — Day × Session matrix
- **Trade Duration: Win vs Loss** — Avg duration comparison by outcome

---

## 📸 Dashboard Preview

<img width="515" height="796" alt="image" src="https://github.com/user-attachments/assets/4bf6b4a8-025b-438e-b6b9-f5b1c367552c" />


---

## 🛠 Tech Stack

| Tool | Usage |
|---|---|
| **SQL (MySQL)** | Data extraction, aggregation, business queries |
| **Power BI** | Interactive dashboard, DAX measures, visualizations |
| **Excel** | Data cleaning, initial exploration |

---

## 🧠 Key Learning

This project highlights how **profitability is not dependent on win rate alone**, but on:
- ✅ Consistent risk management
- ✅ High Risk-Reward ratio execution
- ✅ Strategic session & pair selection
- ✅ Patience — winning trades last ~7x longer than losing trades

> A 30% win rate CAN be profitable — if your winners are significantly larger than your losers.

---

## 🔗 Links

- **GitHub:** [github.com/Himaanshu1520](https://github.com/Himaanshu1520)
- **LinkedIn:** [linkedin.com/in/himaanshu-yadav](https://www.linkedin.com/in/himaanshu-yadav)
