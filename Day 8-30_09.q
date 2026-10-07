/I/O operations
/Tables & Queries
/ Generating Sample Data for trade table
n:100000 / Number of rows.
// Start and end times for the day (e.g., 9 AM to 3 PM).
st:(.z.d-1)+09:00:00
et:(.z.d-1)+15:00:00

/tm - Random times between start and end times.
tm:st+asc n?`long$et-st
tm:st+n?`long$et-st
st+21600000000000 //
-10#tm / For fetch last 10 records

// sym - Random symbols like AAPL, GOOG, etc. representing stocks.
sym:n?`AAPL`DELL`GOOG`IBM`META`MSFT`NVDA

// px - Price values.
// size - Trade size.
// side - Buy (B) or Sell (S) indicator.
// exch - Exchange codes like O, L, N, Q.

px:n?100f
size:n?10000i
side:n?`B`S
exch:n?`O`L`N`Q

/create Table
trades:([] time:tm;sym:sym;exch:exch;side:side;price:px;size:size)

/ Generating Sample Data for quote table
nq:10000000
st:(.z.d-1)+09:00:00
et:(.z.d-1)+15:00:00
tm:st+asc nq?`long$et-st
tm:st+n?`long$et-st
st+21600000000000
-10#tm
sym:nq?`AAPL`DELL`GOOG`IBM`META`MSFT`NVDA
bprice:nq?100f
bsize:nq?10000i
aprice:nq?100f
asize:nq?10000i
trades:([] time:tm;sym:sym;exch:exch;side:side;price:px;size:size)
quotes:([] time:tm;sym:sym;bprice:bprice;bsize:bsize;aprice:aprice;asize:asize)

/Check row counts
count trades
count quotes

// Saving Tables in Binary Format
save `:trades

\pwd / current working directory
\ls  / list files in current working directory
delete trades from `. / Remove table from memory
\a  / Show Current Namespace
\l trades / Show Current Namespace

// Exporting to CSV
save `:trades.csv / Save in CSV

// Reading csv
/ Read Using Explicit Types
trades:("PSSSFI";enlist",") 0: `:trades.csv
/ Read Everything as Strings
trades:(6#"*";enlist",") 0: `:trades.csv
/ In case csv don't have column name, then data is present in row format, So Column name  is a key and data store in row. To cconvert that into column we have to perform flip
trades:flip `time`sym`exch`side`price`size!("PSSSFI";",") 0: `:trades.csv / 0: is the read operator, (P=Timestamp, S=Symbol, F=Float, I=Integer).

// Read File as Text
read0 `:trades.csv
/trades_20260930.csv
/set
trades

// Export To Delimited Files
(`:trades_20260930.csv) 0: "," 0: trades  / Creates comma-separated file.
(`:trades_20260930.txt) 0: "\t" 0: trades / Creates TAB-separated file.
(`:trades_20260930.txt) 0: "\t" 0: trades

// JSON Operations
/  Export JSON
`:trades_20260930.json 0: enlist .j.j trades / Convert JSON to table format using .j.j for parsing
update "P"$time, "S"$sym, "S"$exch, "S"$side from .j.k raze read0 `:trades_20260930.json
/Splayed table
tab:([] c1:1000?100i;c2:1000?100f;c3:1000?.z.P)
`:unsplayed_tab set tab
`:tab/ set tab
-10#get `:tab/c1
get `:tab/c3
get `:tab/.d
/ \l - load the data which is in q binary format 
/We can't spaly a table with a symbol data type
.Q.en[`:.;trades]
`:trades/ set .Q.en[`:.;trades]


////// A structure to organize data over multiple days and symbols:

/Historical Database (HDB)
/Structure
/-----HDB Root/
/--------sym
/--------2026.09.30/
/------------trades/
/----------------.d
/----------------time
/----------------sym
/----------------exch
/------------quotes/
/----------------.d
/----------------time
/----------------sym
/----------------bprice
/----------------bsize
/--------2026.09.29/
/------------trades/
/----------------.d
/----------------time
/----------------sym
/----------------exch
/------------quotes/
/----------------.d
/----------------time
/----------------sym
/----------------bprice
/----------------bsize
/--------2026.09.28/
/------------trades/
/----------------.d
/----------------time
/----------------sym
/----------------exch
/------------quotes/
/----------------.d
/----------------time
/----------------sym
/----------------bprice
/----------------bsize
/--------2026.09.25/
/------------trades/
/----------------.d
/----------------time
/----------------sym
/----------------exch
/------------quotes/
/----------------.d
/----------------time
/----------------sym
/----------------bprice
/----------------bsize

// .Q.dpft loads partitioned data from the HDB by date and symbol.
.Q.dpft[`:hdb;.z.d;`sym;`trades] / Loads today's trades from the hdb database, partitioned by sym.

.Q.dpft[`:hdb;.z.d-1;`sym;`trades] / 


