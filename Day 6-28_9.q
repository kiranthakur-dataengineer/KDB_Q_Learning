/==========================================================
/ Tables & Queries in Q/KDB+
/ This script demonstrates how to create tables, query data,
/ filter rows, aggregate values, update data, and join tables.
/==========================================================

/------------------------------------------
/ Generate sample data
/------------------------------------------

/ Number of rows to generate
n:100000

/ Start and end timestamps for the trading day
st:.z.d+09:00:00
et:.z.d+15:00:00

/ Generate random timestamps between start and end times
/ `long$et-st converts the time difference to integer nanoseconds
/ `long$ means cast to long integer
tm:st+asc n?`long$et-st
tm:st+n?`long$et-st

/ Show one example timestamp
st+21600000000000

/ Preview the first 10 timestamps
-10#tm

/ Create random stock symbols
sym:n?`AAPL`DELL`GOOG`IBM`META`MSFT`NVDA

/ Random prices
px:n?100f

/ Random trade sizes
size:n?10000i

/ Random trade sides: B = Buy, S = Sell
side:n?`B`S

/ Random exchanges: O, L, N, Q
exch:n?`O`L`N`Q

/ Create a table with columns: time, sym, exch, side, price, size
trades:([] time:tm;sym:sym;exch:exch;side:side;price:px;size:size)

/ Display table metadata (column names + types)
meta trades

/ Sort table by time column in ascending order
`time xasc `trades

/ Set the sorted attribute on the time column
/ This improves performance for time-based queries
update `#time from `trades

/------------------------------------------
/ Querying data
/------------------------------------------

/ Run the query without sorted attribute on time
/ This is slower because Q must scan more data
\t:100 select from trades where time.time within 09:00:05 09:00:07

/ Run the query with sorted attribute on time
/ This is more efficient because time is ordered
\t:100 select from trades where time.time within 09:00:05 09:00:07

/ Count rows in the table
count trades

/ Compare two table expressions:
/ (select ...) is equal to delete columns from trades
(select time, sym, price, size from trades)~delete exch, side from trades

/------------------------------------------
/ Delete columns or rows
/------------------------------------------

/ Delete columns from a table
delete col1, col2 from `trades

/ Delete rows based on a condition
delete from trades where clause

/ NOTE: In Q, you cannot do this:
delete col1, col2 from `table where clause

/ Example: delete exch and side columns from rows where sym is IBM or AAPL
delete exch, side from `trades where sym in `IBM`AAPL

/ Important:
/ /`nyi error means "not yet implemented"
delete exch, side from delete from trades where sym in `IBM`AAPL

/------------------------------------------
/ Update existing data
/------------------------------------------

/ Example of conditional expression:
/ If a<10, print "a is less than 10"
/ Else if a>10, print "a is greater than 10"
/ Else print "a is equal to 10"
a:10
$[a<10;show "a is less than 10";a>10;show "a is greater than 10";show "a is equal to 10"]

/ Update price:
/
/ If side = S (sell), multiply price by -1
/ If side != S, keep price positive
/ This creates signed price values for trade direction
update price:?[side=`S;-1;1]*price from trades

/ Select a few columns and compute a derived field: tradecost
select sym, price, size, tradecost:price*size from trades

/ Set output precision for display
\P 17

/ Aggregate trade cost by symbol
select tradecost:sum price*size by sym from trades

/ Save the selection as a variable
v::select by sym from trades

/ Insert new rows into the table
`trades insert(2026.09.28D15:00:00.1234 2026.09.28D15:00:00.2345 2026.09.28D15:00:00.3456 2026.09.28D15:00:00.4567;
  `AAPL`DELL`GOOG`IBM;
  `L`O`N`Q;
  `S`B`S`B;
  123 244 233 311f;
  234 2345 2423 2452)
v

/ Group by exchange
select by exch from trades

/ Sort table by symbol
`sym xasc `trades

/ Display the table
trades

/ Preview last 20 rows
-20#trades

/ Grouping again by symbol
select by sym from trades

/ Aggregate trade cost by symbol and exchange
select tradecost:sum price*size by sym, exch from trades

/ Filter aggregated results for AAPL and exchange Q
select from (update tradecost:sum price*size by sym, exch from trades) where sym=`AAPL, exch=`Q

/------------------------------------------
/ Data definition / column rearrangement
/------------------------------------------

/ Reorder columns in the table
`time`sym`side xcols trades

/ Rename columns
`time`sym`src xcol trades

/ Rename columns using a mapping
(enlist[`exch]!enlist`src) xcol trades
(`exch`price`size!`src`px`vol) xcol trades

/------------------------------------------
/ Sorting and keys
/------------------------------------------

/ Sort by multiple columns
`sym`exch xasc trades

/ Create a keyed table on symbol
`sym xkey trades

/ Check the type of the keyed table
type `sym`exch xkey trades
type trades

/------------------------------------------
/ Querying with filters
/------------------------------------------

/ Select rows where symbol = AAPL and price is within range 10 to 20
select from trades where sym=`AAPL, price within 10 20f

/------------------------------------------
/ Grouping & aggregations, time windows
/------------------------------------------

/ `xbar` groups times into fixed intervals
/ Example: 15-minute buckets
select minpx:min price, maxpx:max price by sym, interval:15 xbar time.minute from trades

/ Count trades per symbol in 15-minute buckets
select count price by sym, interval:15 xbar time.minute from trades

/ OHLC (Open, High, Low, Close) calculation per symbol and hour
select open:first price, high:max price, low:min price, close:last price by sym, interval:1 xbar time.hh from trades

/------------------------------------------
/ VWAP (Volume Weighted Average Price)
 / VWAP = sum(price * size) / sum(size)
 / This is a price weighted by trading volume
/------------------------------------------

/ Example math:
12 10000 - 12*10000
10 100 - 10*100
15 5000 - 15*5000
5  200 - 5*200
avg 12 10 15 5
(120000+1000+75000+1000)%(10000+100+5000+200)
12.88

/ Compute VWAP per symbol
select vwap:sum(price*size)%sum size by sym from trades

/ q also supports weighted average price shorthand:
select vwap:wavg[size;price] by sym from trades

/------------------------------------------
/ Derived values and comparisons
/------------------------------------------

/ Return all rows where price is greater than the average price for that symbol
update avgpx:avg price by sym from trades

/ Use calculated average price from the updated table
select from (update avgpx:avg price by sym from trades) where price> avgpx

/ Select time/exchange/side/price/size and average price by symbol in one query
select time, exch, side, price, size, avgpx:avg price by sym from trades

/ In one select statement without nested query
select from trades where price>(avg;price) fby sym
select from trades where price>(avg;price) fby ([] sym; exch)

/------------------------------------------
/ fby on dyadic operation
/------------------------------------------

/ `fby` applies a function by partition
/ Example: compare current price to symbol-specific average
select from trades where price>vwap by sym
select from (update wavgpx:wavg[size;price] by sym from trades) where price> wavgpx

/ A functional form of the same idea
select from trades where price>({wavg[x`size;x`price]};([] price;size)) fby sym

/------------------------------------------
/ Joins
/------------------------------------------

/ Q supports joins for combining tables
/ Foreign key relationships are common in KDB+ data models
/ Example: join tables by common key columns
/ attributes

/------------------------------------------
/ Notes for beginners
/------------------------------------------
/ - `select` is used for reading/querying data
/ - `update` changes values in a table
/ - `delete` removes columns or rows
/ - `by` groups rows by one or more columns
/ - `xbar` bins values into fixed-size intervals
/ - `fby` evaluates functions over grouped partitions
/ - `wavg` computes weighted average
/ - `xasc` / `xkey` are used for ordering and keying
/ - table columns are often called fields
/ - Q is mostly column-oriented and vectorized
/ - in-memory performance is a major advantage of KDB+
/------------------------------------------
