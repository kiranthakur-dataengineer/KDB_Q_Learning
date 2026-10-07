/Tables & Queries
n:100000
st:.z.d+09:00:00
et:.z.d+15:00:00
tm:st+asc n?`long$et-st
tm:st+n?`long$et-st
st+21600000000000
-10#tm
sym:n?`AAPL`DELL`GOOG`IBM`META`MSFT`NVDA
px:n?100f
size:n?10000i
side:n?`B`S
exch:n?`O`L`N`Q
trades:([] time:tm;sym:sym;exch:exch;side:side;price:px;size:size)
meta trades
`time xasc `trades
update `#time from `trades
/run the query without sorted attr on time
\t:100 select from trades where time.time within 09:00:05 09:00:07
/run the query with sorted attr on time
\t:100 select from trades where time.time within 09:00:05 09:00:07
count trades

(select time, sym, price, size from trades)~delete exch, side from trades

/delete columns
delete col1, col2 from `trades
/delete rows
delete from trades where clause
/can't do
delete col1, col2 from `table where clause

delete exch, side from `trades where sym in `IBM`AAPL
/`nyi error
delete exch, side from delete from trades where sym in `IBM`AAPL
/update
/change the price to neg price if the side is sell
a:10
$[a<10;show "a is less than 10";a>10;show "a is greater than 10";show "a is equal to 10"]

update price:?[side=`S;-1;1]*price from trades

select sym, price, size, tradecost:price*size from trades
\P 17
select tradecost:sum price*size by sym from trades

v::select by sym from trades

`trades insert(2026.09.28D15:00:00.1234 2026.09.28D15:00:00.2345 2026.09.28D15:00:00.3456 2026.09.28D15:00:00.4567;`AAPL`DELL`GOOG`IBM;`L`O`N`Q;`S`B`S`B;123 244 233 311f;234 2345 2423 2452)
v

select by exch from trades
`sym xasc `trades
trades


-20#trades
select by sym from trades

select tradecost:sum price*size by sym, exch from trades
select from (update tradecost:sum price*size by sym, exch from trades)where sym=`AAPL, exch=`Q
/DDL
/re-arrange columns
`time`sym`side xcols trades
/rename columns
`time`sym`src xcol trades
(enlist[`exch]!enlist`src) xcol trades
(`exch`price`size!`src`px`vol) xcol trades
/sorting on a col or set of cols
`sym`exch xasc trades
/key on col or set of cols
`sym xkey trades    
type `sym`exch xkey trades
type trades
/Queries
select from trades where sym=`AAPL, price within 10 20f
/Grouping & aggregations based on time window
/xbar
select minpx:min price, maxpx:max price by sym, interval:15 xbar time.minute from trades

select count price by sym, interval:15 xbar time.minute from trades

/OHLC - Open, High, Low, Close
select open:first price, high:max price, low:min price, close:last price by sym, interval:1 xbar time.hh from trades 

/VWAP - Volume Weighted Average Price
12 10000 - 12*10000
10 100 - 10*100
15 5000 - 15*5000
5  200 - 5*200
avg 12 10 15 5
(120000+1000+75000+1000)%(10000+100+5000+200)
12.88
select vwap:sum(price*size)%sum size by sym from trades
select vwap:wavg[size;price] by sym from trades

/return all the rows where price>avg price by symbol
update avgpx:avg price by sym from trades

select from (update avgpx:avg price by sym from trades) where price> avgpx
select time, exch, side, price, size, avgpx:avg price by sym from trades
/in one select statement without nested query
select from trades where price>(avg;price) fby sym
select from trades where price>(avg;price) fby ([] sym; exch)
/fby on dyadic operation
/select from trades where price>vwap by sym
select from (update wavgpx:wavg[size;price] by sym from trades) where price> wavgpx
select from trades where price>({wavg[x`size;x`price]};([] price;size)) fby sym
/Joins
/foreign key
/attributes









