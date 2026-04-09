
-- Forex trading is a battlefield where discipline, strategy, and consistency determine survival.Having i had journaled every trade for 4 years across 5 pairs and 2 sessions, 
-- I embarked on a journey to uncover the truth behind my own trading performance using MySQL.
-- The dataset contains 7,950 trades from January 2021 to December 2024.

-- The following questions are what this analysis seeks to answer:
-- - Overall win rate across all 4 years
-- - How did my monthly and yearly P&L evolve over time
-- - Which currency pair made me the most and least money
-- - Which day of the week is my most and least profitable
-- - London session vs New York session — which performs better
-- - Buy trades vs Sell trades — which direction is more profitable
-- - What is my average Risk-to-Reward ratio and does it match my win rate
-- - How often did I hit TP vs SL vs Break Even
-- - What is my average trade duration for winning vs losing trades
-- - Which pair has the highest win rate vs highest total PnL (are they the same?)
-- - How does lot size relate to my P&L — do bigger trades perform better or worse
-- - What is my worst drawdown period and how long did it last
-- - Which combination of Pair + Session + Day gives the best results
-- - How consistent is my risk management — is Risk Amount stable over time
-- - What does my equity curve look like year by year
-- - Are there any streaks of consecutive wins or losses
-- - Which trades gave the highest single-trade profit and loss
-- - How has my win rate improved or declined year over year


-- Creating a Database
create database FOREX;
use FOREX;

select * from forex_trading_journal;

-- i already cleaned the data in EXCEL so no need to do here again (the data is clened)

-- 01. Overall win rate across all 4 years

SELECT
COUNT(*) AS total_trades,
SUM(Result = 'Win') AS total_wins,
SUM(Result = 'Loss') AS total_losses,
SUM(TP_Hit = 'BE') AS total_breakeven, 
ROUND(SUM(Result = 'Win') * 100.0 / COUNT(*), 2) AS win_rate_pct,
ROUND(SUM(PnL), 2) AS total_pnl
FROM forex_trading_journal;

-- 02. How did my monthly and yearly P&L evolve over time

-- Monthly PNL
SELECT
YEAR(Date) AS yr,
MONTH(Date) AS mo,
DATE_FORMAT(Date, '%Y-%m') AS month_label,
COUNT(*) AS trades,
SUM(Result = 'Win') AS wins,
ROUND(SUM(Result = 'Win') * 100.0 / COUNT(*), 2) AS win_rate_pct,
ROUND(SUM(PnL), 2) AS monthly_pnl,
ROUND(SUM(SUM(PnL)) OVER (ORDER BY YEAR(Date), MONTH(Date)), 2) AS cumulative_pnl
FROM forex_trading_journal
GROUP BY YEAR(Date), MONTH(Date), DATE_FORMAT(Date, '%Y-%m')
ORDER BY yr, mo;

-- yearly PNL
SELECT
YEAR(Date) AS yr,
COUNT(*) AS trades,
SUM(CASE WHEN Result = 'Win' THEN 1 ELSE 0 END) AS wins,
ROUND(SUM(CASE WHEN Result = 'Win' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS win_rate_pct,
ROUND(SUM(PnL), 2)AS yearly_pnl,
ROUND(SUM(SUM(PnL)) OVER (ORDER BY YEAR(Date)), 2) AS cumulative_pnl
FROM forex_trading_journal
GROUP BY YEAR(Date)
ORDER BY yr;

-- 03.  Which currency pair made me the most and least money

SELECT
Pair,
COUNT(*) AS total_trades,
SUM(Result = 'Win') AS wins,
SUM(Result = 'Loss') AS losses,
ROUND(SUM(Result = 'Win') * 100.0 / COUNT(*), 2) AS win_rate_pct,
ROUND(SUM(PnL), 2) AS total_pnl,
ROUND(AVG(PnL), 2) AS avg_pnl_per_trade
FROM forex_trading_journal
GROUP BY Pair
ORDER BY total_pnl DESC;

-- 04. Which day of the week is my most and least profitable

SELECT
Day,
COUNT(*) AS total_trades,
SUM(Result = 'Win') AS wins,
ROUND(SUM(Result = 'Win') * 100.0 / COUNT(*), 2) AS win_rate_pct,
ROUND(SUM(PnL), 2) AS total_pnl,
ROUND(AVG(PnL), 2) AS avg_pnl_per_trade
FROM forex_trading_journal
GROUP BY Day
ORDER BY FIELD(Day, 'Monday','Tuesday','Wednesday','Thursday','Friday');

-- 05. London session vs New York session — which performs better

SELECT
Session,
COUNT(*) AS total_trades,
SUM(Result='Win') AS wins,
SUM(Result='Loss') AS losses,
ROUND(SUM(Result='Win')*100.0/COUNT(*),2) AS win_rate_pct,
ROUND(SUM(PnL),2) AS total_pnl,
ROUND(AVG(PnL),2) AS avg_pnl_per_trade,
ROUND(AVG(RR),2) AS avg_rr
FROM forex_trading_journal
GROUP BY Session
ORDER BY total_pnl DESC;

-- 06. Buy trades vs Sell trades — which direction is more profitable

SELECT
Direction,
COUNT(*) AS total_trades,
SUM(Result='Win') AS wins,
SUM(Result='Loss') AS losses,
ROUND(SUM(Result='Win')*100.0/COUNT(*),2) AS win_rate_pct,
ROUND(SUM(PnL),2) AS total_pnl,
ROUND(AVG(PnL),2) AS avg_pnl_per_trade
FROM forex_trading_journal
GROUP BY Direction
ORDER BY total_pnl DESC;

-- 07. What is my average Risk-to-Reward ratio and does it match my win rate

WITH stats AS (
SELECT
AVG(RR) avg_rr,
SUM(Result='Win')*100.0/COUNT(*) win_rate
FROM forex_trading_journal
)
SELECT
ROUND(avg_rr,2) AS avg_rr,
ROUND(100/(1+avg_rr),2) AS breakeven_win_rate_pct,
ROUND(win_rate,2) AS actual_win_rate_pct,
ROUND(win_rate - 100/(1+avg_rr),2) AS edge_pct
FROM stats;

-- 08. How often did I hit TP vs SL vs Break Even

SELECT
TP_Hit outcome,
COUNT(*) c,
ROUND(COUNT(*)*100.0/SUM(COUNT(*)) OVER (),2) pct,
ROUND(SUM(PnL),2) pnl,
ROUND(AVG(PnL),2) avg_pnl
FROM forex_trading_journal
GROUP BY TP_Hit
ORDER BY c DESC;

-- 09. What is my average trade duration for winning vs losing trades

WITH d AS (
SELECT
Result,
COALESCE(REGEXP_SUBSTR(Trade_Duration,'[0-9]+(?=h)')*60,0) +
COALESCE(REGEXP_SUBSTR(Trade_Duration,'[0-9]+(?=m)'),0) AS mins
FROM forex_trading_journal
)
SELECT
Result,
COUNT(*) trades,
ROUND(AVG(mins),1) avg_duration_minutes,
CONCAT(FLOOR(AVG(mins)/60),'h ',ROUND(MOD(AVG(mins),60)),'m') avg_duration_hm
FROM d
GROUP BY Result
ORDER BY Result;

-- 10. Which pair has the highest win rate vs highest total PnL (are they the same?)

SELECT
Pair,
COUNT(*) total_trades,
ROUND(SUM(Result='Win')*100.0/COUNT(*),2) win_rate_pct,
ROUND(SUM(PnL),2) total_pnl,
RANK() OVER (ORDER BY SUM(Result='Win')*100.0/COUNT(*) DESC) win_rate_rank,
RANK() OVER (ORDER BY SUM(PnL) DESC) pnl_rank
FROM forex_trading_journal
GROUP BY Pair
ORDER BY total_pnl DESC;

-- 11.  How does lot size relate to my P&L — do bigger trades perform better or worse

SELECT
CASE
WHEN Lot_Size < 0.5 THEN '<0.5'
WHEN Lot_Size < 1   THEN '0.5-1'
WHEN Lot_Size < 2   THEN '1-2'
WHEN Lot_Size < 3   THEN '2-3'
ELSE '3+'
END as bucket,
COUNT(*) trades,
ROUND(AVG(Lot_Size),2) avg_lot,
ROUND(SUM(Result='Win')*100.0/COUNT(*),2)as win_rate,
ROUND(SUM(PnL),2)as pnl,
ROUND(AVG(PnL),2)as avg_pnl
FROM forex_trading_journal
GROUP BY bucket
ORDER BY avg_lot;

-- 12. What is my worst drawdown period and how long did it last

WITH d AS (
SELECT
Date,
Account_Balance,
MAX(Account_Balance) OVER (ORDER BY Date,SNo) peak,
MAX(Account_Balance) OVER (ORDER BY Date,SNo) 
FROM forex_trading_journal
)
SELECT
Date AS worst_dd_date,
Account_Balance,
peak AS peak_balance,
ROUND(dd,2) max_drawdown_usd,
ROUND(dd/peak*100,2) max_drawdown_pct
FROM d
ORDER BY dd DESC
LIMIT 1;

-- Drawdown duration — consecutive losing period
WITH s AS (
SELECT
Date,
Result,
PnL,
SUM(Result='Win') OVER (ORDER BY Date,SNo)as g
FROM forex_trading_journal
)
SELECT
MIN(Date) as streak_start,
MAX(Date) as streak_end,
COUNT(*) as losing_trades,
ROUND(SUM(PnL),2) as streak_pnl,
DATEDIFF(MAX(Date),MIN(Date)) as days_duration
FROM s
WHERE Result='Loss'
GROUP BY g
ORDER BY losing_trades DESC
LIMIT 5;

-- 13. Which combination of Pair + Session + Day gives the best results

SELECT
Pair,Session,Day,
COUNT(*) trades,
SUM(Result='Win') as wins,
ROUND(SUM(Result='Win')*100.0/COUNT(*),2) as win_rate,
ROUND(SUM(PnL),2) as pnl,
ROUND(AVG(PnL),2) as avg_pnl
FROM forex_trading_journal
GROUP BY Pair,Session,Day
HAVING trades>=10
ORDER BY win_rate DESC,avg_pnl DESC
LIMIT 10;

-- 14.How consistent is my risk management — is Risk Amount stable over time

SELECT
DATE_FORMAT(Date,'%Y-%m') m,
ROUND(AVG(Risk_Amount),2) avg_risk,
ROUND(MIN(Risk_Amount),2) min_risk,
ROUND(MAX(Risk_Amount),2) max_risk,
ROUND(STDDEV(Risk_Amount),2) sd,
ROUND(STDDEV(Risk_Amount)/AVG(Risk_Amount)*100,2) cv,
COUNT(*) trades
FROM forex_trading_journal
GROUP BY m
ORDER BY m;

-- Overall Stats 
SELECT
ROUND(AVG(Risk_Amount),2) avg,
ROUND(STDDEV(Risk_Amount),2) sd,
ROUND(MIN(Risk_Amount),2) min,
ROUND(MAX(Risk_Amount),2) max,
ROUND(STDDEV(Risk_Amount)/AVG(Risk_Amount)*100,2) as cv
FROM forex_trading_journal;

-- 15. What does my equity curve look like year by year

SELECT
YEAR(Date) as yr,
DATE_FORMAT(Date,'%Y-%m') as m,
ROUND(SUM(PnL),2) as pnl,
ROUND(MAX(Account_Balance),2) as bal,
ROUND(SUM(SUM(PnL)) OVER (PARTITION BY YEAR(Date) ORDER BY YEAR(Date),MONTH(Date)),2) as ytd_pnl,
ROUND(SUM(SUM(PnL)) OVER (ORDER BY YEAR(Date),MONTH(Date)),2) as total_pnl
FROM forex_trading_journal
GROUP BY YEAR(Date),MONTH(Date),m
ORDER BY YEAR(Date),MONTH(Date);

-- 16. Are there any streaks of consecutive wins or losses

WITH s AS (
SELECT
Result,
ROW_NUMBER() OVER (ORDER BY Date,SNo) - ROW_NUMBER() OVER (PARTITION BY Result ORDER BY Date,SNo) g,
Date,
PnL
FROM forex_trading_journal
WHERE Result IN ('Win','Loss')
),
x AS (
SELECT
Result,
g,
COUNT(*) len,
MIN(Date) start,
MAX(Date) end,
ROUND(SUM(PnL),2) pnl
FROM s
GROUP BY Result,g
)
(SELECT 'Win' type,len,start,end,pnl 
FROM x 
WHERE Result='Win' 
ORDER BY len DESC LIMIT 5)
UNION ALL
(SELECT 'Loss',len,start,end,pnl 
FROM x 
WHERE Result='Loss' 
ORDER BY len DESC LIMIT 5)
ORDER BY type,len DESC;

-- 17. Which trades gave the highest single-trade profit and loss

-- best and Wrost Trade 
(SELECT 'Best' as label,SNo,Date,Pair,Session,Day,Direction,Lot_Size,RR,PnL,Result,Trade_Duration
FROM forex_trading_journal 
ORDER BY PnL DESC LIMIT 1)
UNION ALL
(SELECT 'Worst',SNo,Date,Pair,Session,Day,Direction,Lot_Size,RR,PnL,Result,Trade_Duration
 FROM forex_trading_journal
 ORDER BY PnL ASC LIMIT 1);
 
 -- top 10 win and loss
 (SELECT 'Top Win' as c,SNo,Date,Pair,Direction,PnL,RR,Lot_Size
 FROM forex_trading_journal
 ORDER BY PnL DESC LIMIT 10)
UNION ALL
(SELECT 'Top Loss',SNo,Date,Pair,Direction,PnL,RR,Lot_Size
 FROM forex_trading_journal 
 ORDER BY PnL ASC LIMIT 10);
 
 -- 18. How has my win rate improved or declined year over year
 
SELECT
YEAR(Date) yr,
COUNT(*) trades,
SUM(Result='Win') wins,
SUM(Result='Loss') losses,
ROUND(SUM(Result='Win')*100.0/COUNT(*),2) win_rate,
ROUND(SUM(PnL),2) pnl,
ROUND(AVG(RR),2) avg_rr,
ROUND(SUM(Result='Win')*100.0/COUNT(*)- LAG(SUM(Result='Win')*100.0/COUNT(*)) OVER (ORDER BY YEAR(Date)),2) yoy_win_rate,
ROUND(SUM(PnL) - LAG(SUM(PnL)) OVER (ORDER BY YEAR(Date)),2) yoy_pnl
FROM forex_trading_journal
GROUP BY yr
ORDER BY yr;




