/==========================================================
/ KDB+ Tick Architecture / HDB / Quote-Trade Data Model
/
/ This file shows:
/
/ - a tick process holding live quote and trade tables
/ - how a KDB tickerplant or feed process can populate quote/trade
/ - how to inspect the current book state
/ - how to keep the latest trade/quote per symbol
/ - how HDB partitions and historical data are organized
/
/ Key idea:
/
/ A tick system usually has:
/
/ 1. feed / tickerplant producing real-time updates
/ 2. real-time tables (`quote`, `trade`)
/ 3. historical database (HDB) storing partitioned data by date
/ 4. clients querying live or historical data
/==========================================================

/------------------------------------------
/ Historical database partition list
/------------------------------------------

/ This is a KDB HDB root folder with multiple partitions dates:
/
q).Q.PV
2022.08.28 2023.10.05 2023.10.06 2023.10.08 2023.11.08 2024.04.01 2025.05.15 2025.08.16 2025.08.17 2026.06.26 2026.10.08

/ `.Q.PV` shows all date partitions available in the historical database
/ In a production system, this is how the database knows what dates are loaded

/ Query how many rows exist by date
select count i by date from trade
select count i by date from quote

/ Example output:
/
/ date      | x
/ ----------| ------
/ 2026.10.08| 269419
/
/ This tells us how many trade rows exist for each date
/
/ For the `quote` table, there are usually much more rows than `trade`,
/ because there are often many bid/ask updates per trade.






/==========================================================
/ Tick process running on port 5000 and HDB on port 5012
/==========================================================

/ Example command:
/ c:\work\tick>q tick/r.q :5000 :5012
/
/ This means:
/
/ - tick process is running on port 5000
/ - HDB is running on port 5012
/
/ In a typical KDB tick architecture:
/
/ - tickerplant / feed writes updates to live tables
/ - HDB stores data for historical queries
/ - clients can query either the live process or the HDB
/

q)\a
`s#`quote`trade

/ `\a` shows all tables currently in memory
/ Here we have two live tables:
/
/ `quote` = current bid/ask market data
/ `trade` = executed trades
/

q)count quote
758403
q)count trade
157925

/ These are the current row counts in the live table
/ `quote` typically has more entries than `trade`
/ because quotes update more frequently than trades

/ Over time, these counts continue to increase as new data arrives
q)count quote
759812
q)count trade
158036

/ Example structure of `quote`
q)quote
time                 sym  bid   ask   bsize asize
-------------------------------------------------
0D10:15:00.022000000 DOW  19.08 20.67 89    67
0D10:15:00.022000000 AMD  33    33.82 55    91
0D10:15:00.022000000 AIG  26.56 27.28 26    34
...
/ This is a table with:
/
/ - time
/ - sym
/ - bid
/ - ask
/ - bsize
/ - asize
/
/ It represents the latest quote snapshot for each symbol/timestamp

/ Example structure of `trade`
q)trade
time                 sym  price size
------------------------------------
0D10:15:00.009000000 MSFT 28.99 12
0D10:15:00.009000000 HPQ  36    48
...
/ This is a table with:
/
/ - time
/ - sym
/ - price
/ - size
/
/ It represents executed trades

/------------------------------------------
/ Keeping latest values by symbol
/------------------------------------------

/ `select by sym from quote`
/ This groups the quote table by symbol and returns the last row for each symbol
/ (depending on table ordering and data arrival)
lastquote::select by sym from quote

/ Same idea for trades:
lasttrade::select by sym from trade

/ `lasttrade` is a keyed table, grouped by symbol
/ Each symbol has only one row, the latest trade seen
q)lasttrade
sym | time                 price size
----| -------------------------------
AAPL| 0D11:33:53.051817500 68.61 69
AIG | 0D11:33:54.855812200 41.25 93
AMD | 0D11:33:54.245883300 37.64 77
DELL| 0D11:33:53.657292900 7.9   61
...
/ This tells us the latest trade for each symbol

/ Re-evaluating shows the values change over time as new trades arrive
/ because `select by sym from trade` picks the latest row for each symbol
/ based on current data in the table.

q)lasttrade
sym | time                 price size
----| -------------------------------
AAPL| 0D11:33:55.755403900 67.96 70
...

/ The values can change on every new trade message,
/ which is exactly what we want for the "latest trade" view.

q)lasttrade
sym | time                 price size
----| -------------------------------
AAPL| 0D11:33:57.560754600 67.78 39
...

/ This is a common pattern for market data systems:
/
/ - live table stores all incoming quotes/trades
/ - aggregated view stores the latest state per symbol
/
/ This is often used for monitoring / books / dashboards.











/==========================================================
/ Real-world production interpretation
/==========================================================

/ In a tick architecture, live tables are usually:
/
/ - quote: bid, ask, bid size, ask size
/ - trade: price, size, execution time
/
/ You often want to compute:
/
/ - latest quote by symbol
/ - latest trade by symbol
/ - spread = ask - bid
/ - volume weighted price
/ - trade statistics
/ - historical query by date and symbol
/

/ The pattern is:
/
/ - keep raw stream in `quote` and `trade`
/ - derive `lastquote` and `lasttrade`
/ - query on-demand from HDB for historical data
/

/------------------------------------------
/ HDB relationship
/------------------------------------------

/ `quote` and `trade` may be:
/
/ - current-day real-time tables
/ - historical partitions in the HDB
/
/ A production KDB setup usually stores:
/
/ root/
/   2026.10.08/
/     quote
/     trade
/   2026.10.09/
/     quote
/     trade
/
/ Each date folder contains partitioned data for that day.
/
/ This allows efficient historical access and date-based storage.






/==========================================================
/ Key beginner takeaways
/==========================================================

/ - `quote` stores bid/ask updates
/ - `trade` stores executions
/ - `select by sym from trade` gives the newest trade per symbol
/ - `select by sym from quote` gives the newest quote per symbol
/ - `.Q.PV` shows all historical partitions
/ - `count` tells how many rows currently exist
/ - `\a` lists all active tables in the workspace
/
/ Large market data systems are built around:
/
/ 1. realtime ingestion
/ 2. live tables
/ 3. partitioned historical storage
/ 4. derived "latest state" tables
/
/==========================================================
