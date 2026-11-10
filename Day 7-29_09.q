/==========================================================
/ Advanced KDB+/Q tables, joins, keyed tables, and as-of joins
/ This script shows how to:
/
/ - create tables
/ - build stock reference tables
/ - convert columns to keys
/ - insert and delete rows
/ - use joins (left, inner, as-of, vertical, horizontal)
/ - use window joins
/==========================================================

/------------------------------------------
/ Generate base trade data
/------------------------------------------

/ Number of trade rows
n:100000

/ Trading window: start and end of day
st:.z.d+09:00:00
et:.z.d+15:00:00

/ Generate times for trade rows
tm:st+asc n?`long$et-st
tm:st+n?`long$et-st

/ Example timestamp
st+21600000000000

/ Preview first 10 timestamps
-10#tm

/ Generate stock symbols
sym:n?`AAPL`DELL`GOOG`IBM`META`MSFT`NVDA

/ Random values for trade columns
px:n?100f
size:n?10000i
side:n?`B`S
exch:n?`O`L`N`Q

/ Create a trade table
trades:([] time:tm;sym:sym;exch:exch;side:side;price:px;size:size)

/------------------------------------------
/ Create another larger dataset
/------------------------------------------

/ A much larger dataset for more realistic performance comparisons
nq:10000000

st:.z.d+09:00:00
et:.z.d+15:00:00

tm:st+asc nq?`long$et-st
tm:st+n?`long$et-st

st+21600000000000
-10#tm

sym:nq?`AAPL`DELL`GOOG`IBM`META`MSFT`NVDA
bprice:nq?100f
bsize:nq?10000i
aprice:nq?100f
asize:nq?10000i

/ Create a quote table
/ Here bid and ask prices/sizes are tracked separately
quotes:([] time:tm;sym:sym;bprice:bprice;bsize:bsize;aprice:aprice;asize:asize)

/------------------------------------------
/ Basic queries
/------------------------------------------

/ Count records for IBM trades
select count i from trades where sym=`IBM

/ Show the row indices for IBM trades
select i from trades where sym=`IBM

/ Inspect table schema
meta trades
meta quotes

/ Distinct symbols in trades
s:exec distinct sym from trades

/------------------------------------------
/ Reference table / dimension table
/------------------------------------------

/ A stock lookup table:
/
/ - key column: sym
/ - name: company name
/ - city: HQ city
stock:([sym:`NVDA`GOOG`IBM`AAPL`META`DELL`MSFT]
       name:("Nvidia Corp";"Alphabet Inc";"International Business Machines Corp";"Apple Inc";"Meta";"Dell Technologies";"Microsoft Inc");
       city:7?("New York";"CA";"Seattle";"Seoul"))

/ Another stock table with an exchange column too
stock:([sym:`NVDA`GOOG`IBM`AAPL`META`DELL`MSFT;exch:7?`N`L`O]
       name:("Nvidia Corp";"Alphabet Inc";"International Business Machines Corp";"Apple Inc";"Meta";"Dell Technologies";"Microsoft Inc");
       city:7?("New York";"CA";"Seattle";"Seoul"))

/ Display the lookup table
stock

/ Check table type
type stock

/ Access row by key
stock`NVDA

/------------------------------------------
/ Updating symbol values using a foreign key
/------------------------------------------

/ Convert sym column in trades to a key-based lookup
/ This effectively maps symbols to their stock reference row
update sym:`stock$sym from `trades

/ This is an incomplete example; used here to show conceptual update logic
update sym: from `trades

/ Inspect updated schema
meta trades

/ Apply the same idea to quotes
update sym:`stock$sym from `quotes
update sym:value sym from `quotes
meta quotes

/------------------------------------------
/ Insert rows
/------------------------------------------

/ Insert a few new random rows into trades
`trades insert(3?.z.P;upper 3?`3;3?`N`L`O;3?`B`S;3?100f;3?1000i)

/------------------------------------------
/ Delete rows from a keyed table
/------------------------------------------

/ Remove the NVDA symbol from the stock table
delete from `stock where sym=`NVDA

/------------------------------------------
/ Select with lookup values
/------------------------------------------

/ This selects symbols together with name and city from stock
/ `sym.name` and `sym.city` fetch related fields from the keyed lookup
select time, sym, exch, side, price, size, sym.name, sym.city from trades

/------------------------------------------
/ Joins in Q
/------------------------------------------

/ Left join:
/
/ Keep all rows from the left table, and add matching rows from the right table
trades
count trades lj stock
quotes lj stock

/ Inner join:
/
/ Keep only rows where the key exists in both tables
count trades ij stock

/ A unique keyed stock table
ukstock:0!stock
ukstock

/ Equi-join on symbol (ej)
ej[`sym;trades;stock]
ej[`sym;trades;ukstock]

/ Another example
t1:([] k:1 2 3 4; c:10 20 30 40)
t2:([] k:2 2 3 4 5; c:200 222 300 400 500; v:2.2 22.22 3.3 4.4 5.5)

ej[`k;t1;t2]
ej[`k;t2;t1]

/ Create a keyed version of t2 before joining
ej[`k;t1;`k xkey t2]
ij[t1;`k xkey t2]

/------------------------------------------
/ Union / append tables
/------------------------------------------

/ `uj` = union join
/ It combines tables with same columns and fills missing values
t1:([] c1:`a`b; c2:1 2)
t2:([] c1:`c`d; c2:3 4)

t1 uj t2
t1,t2

/ Example where columns differ
t1:([] c1:`a`b`c; c2: 10 20 30)
t2:([] c1:`x`y; c3:8.8 9.9)

t1 uj t2

/ Create a third table and apply repeated union joins
t3:([] c1:`e`f`g; c2:50 60 70; c3:5.5 6.6 7.7)

(t1 uj t2) uj t3
(uj/)(t1;t2;t3)

/------------------------------------------
/ Ad-hoc joins
/------------------------------------------

/ Vertical join: append rows from one table to another
t1:([] c1:`a`b; c2:1 2)
t2:([] c1:`c`d; c2:3 4)
t1,t2

/ Horizontal join: append columns side-by-side
t1:([] c1:`a`b; c2:1 2)
t2:([] c1:`c`d; c3:3 4)
t1,'t2

/------------------------------------------
/ As-of joins
/------------------------------------------

/ As-of join finds the last matching row before/at the time in the left table
/ This is useful for "most recent quote at or before trade time"
strades:10000?trades
squotes:100000?quotes

meta strades
meta squotes

/ Time the as-of join
\t aj[`sym`time;strades;squotes]

/ Sort by symbol for better as-of performance
update `g#sym from `strades
update `g#sym from `squotes

meta strades
meta squotes
\t aj[`sym`time;strades;squotes]

/ Apply as-of join to the main trades and quotes tables
update `g#sym from `trades
update `g#sym from `quotes
aj[`sym`time;trades;quotes]

/ Example output:
/
/ time                    sym  exch side price size bprice bsize aprice asize
/ 2026.09.29D09:00:00.162...
/ ...
/ ...
/ This shows the latest quote data for each symbol at or before the trade time

/ Query quotes individually
select from quotes where sym=`AAPL
select from quotes where sym=`META

/ `aj0` is "as-of join with nulls when not found"
aj0[`sym`time;trades;quotes]

/ Example asof lookup by key and time
asof[trades;`sym`time!(`IBM;.z.d+10:01:03)]

/------------------------------------------
/ Window join
/------------------------------------------

/ A window join returns aggregated values across a time window
/ Example: look at bid/ask prices within +/- 0.5 seconds around each trade
w:flip (-0D00:00:00.500;0D00:00:00.500)+/: trades`time

/ wj = window join
wj[w;`sym`time;trades;(quotes;(max;`bprice);(min;`aprice))]
wj[w;`sym`time;trades;(quotes;(::;`bprice);(::;`aprice))]

/------------------------------------------
/ Final notes
/------------------------------------------

/ KEY CONCEPTS:
/ - `lj` = left join
/ - `ij` = inner join
/ - `ej` = equi join
/ - `aj` = as-of join
/ - `wj` = window join
/ - `uj` = union join
/ - `xkey` = create a keyed table
/ - `0!` = unkey a table
/ - `update` can be used to assign values or re-map columns
/
/ Why these matter:
/ - KDB+ is optimized for time-series and large datasets
/ - joins are essential for linking trade and quote tables
/ - keyed lookup tables are much faster than scanning raw tables
/ - as-of joins match the most recent available data before a timestamp
/
/ For beginners:
/
/ - `trades` and `quotes` are table objects
/ - `sym` is often used as a key
/ - `stock` is a reference or dimension table
/ - join operations combine related data tables efficiently
/ - `aj` is especially important in market data systems
/------------------------------------------
