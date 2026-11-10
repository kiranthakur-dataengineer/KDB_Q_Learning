/==========================================================
/ I/O operations in Q/KDB+ and historical database (HDB) basics
/ This script demonstrates:
/
/ - creating tables
/ - saving/loading data in binary and text formats
/ - reading/writing CSV/JSON
/ - splayed tables and partitioned HDB structures
/ - loading historical data for symbol-based partitioning
/==========================================================

/------------------------------------------
/ Create sample data
/------------------------------------------

/ Number of rows in the trade table
n:100000

/ Use previous trading day as the time window
st:(.z.d-1)+09:00:00
et:(.z.d-1)+15:00:00

/ Generate random timestamps between start and end
tm:st+asc n?`long$et-st
tm:st+n?`long$et-st

/ Example timestamp
st+21600000000000

/ Display first 10 timestamps
-10#tm

/ Random stock symbols
sym:n?`AAPL`DELL`GOOG`IBM`META`MSFT`NVDA

/ Random prices and sizes
px:n?100f
size:n?10000i

/ Random side values: B = Buy, S = Sell
side:n?`B`S

/ Random exchange codes
exch:n?`O`L`N`Q

/ Create a trade table
trades:([] time:tm;sym:sym;exch:exch;side:side;price:px;size:size)

/------------------------------------------
/ Create quote data
/------------------------------------------

/ More rows for a quote table
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

/ Create a quote table
/ Bid and ask prices are captured separately
trades:([] time:tm;sym:sym;exch:exch;side:side;price:px;size:size)
quotes:([] time:tm;sym:sym;bprice:bprice;bsize:bsize;aprice:aprice;asize:asize)

/------------------------------------------
/ Count rows
/------------------------------------------

count trades
count quotes

/------------------------------------------
/ Save a table to a q binary file
/------------------------------------------

/ `save` writes the object to disk in q binary format
save `:trades

/ Show current working directory and files
\pwd
\ls

/ "Display data types and attributes of all symbols in namespace" for debugging
\a

/ Load a saved table from disk
\l trades

/------------------------------------------
/ Save as CSV
/------------------------------------------

/ Save the trade table to a CSV file
save `:trades.csv

/ Read CSV back using q's text loader
/ The format string ("PSSSFI";enlist",") means:
/
/ - P = timestamp
/ - S = symbol
/ - S = exchange
/ - S = side
/ - F = float
/ - I = integer
/
/ `0:` is the q file read operator
trades:("PSSSFI";enlist",") 0: `:trades.csv

/ Different file format / alternative loading
trades:(6#"*";enlist",") 0: `:trades.csv

/ Explicit schema mapping
trades:flip `time`sym`exch`side`price`size!("PSSSFI";",") 0: `:trades.csv

/ Read raw file lines
read0 `:trades.csv

/------------------------------------------
/ Write data to text and JSON files
/------------------------------------------

/ Save table as CSV with a custom filename
(`:trades_20260930.csv) 0: "," 0: trades

/ Save table as tab-delimited text
(`:trades_20260930.txt) 0: "\t" 0: trades

/ Save table as JSON
/ `.j.j` converts the table to a JSON string
`:trades_20260930.json 0: enlist .j.j trades

/ Read JSON back using `.j.k`
/ This deserializes JSON into q objects
update "P"$time, "S"$sym, "S"$exch, "S"$side from .j.k raze read0 `:trades_20260930.json

/------------------------------------------
/ Splayed tables
/------------------------------------------

/ A splayed table is stored as separate column files in a directory
tab:([] c1:1000?100i;c2:1000?100f;c3:1000?.z.P)

/ Save as a splayed table
`:unsplayed_tab set tab

/ A directory name ending with "/" indicates a splayed table
`:tab/ set tab

/ Access files inside the splayed directory
-10#get `:tab/c1
get `:tab/c3
get `:tab/.d

/------------------------------------------
/ Encrypt/compress or encode data
/------------------------------------------

/ `\l` loads q binary data from a file (not necessarily text)
/ Usually used for q database tables and objects
/ "We can't splay a table with a symbol data type" is a reminder:
/
/ - Symbol columns are often stored separately
/ - Some data structures are not directly splayable in the same way
/------------------------------------------

/ `\Q.en` is used to encode data for encryption/compression style table storage
/ This is often used with EOD/HDB storage patterns
.Q.en[`:.;trades]

/ Save encoded data into a directory structure
`:trades/ set .Q.en[`:.;trades]

/------------------------------------------
/ Historical Database (HDB) structure
/------------------------------------------

/ HDB organizes data by date and symbol
/ Example tree structure:
/ -----HDB Root/
/ --------sym
/ --------2026.09.30/
/ ------------trades/
/ ----------------.d
/ ----------------time
/ ----------------sym
/ ----------------exch
/ ------------quotes/
/ ----------------.d
/ ----------------time
/ ----------------sym
/ ----------------bprice
/ ----------------bsize
/ --------2026.09.29/
/ ------------trades/
/ ----------------.d
/ ----------------time
/ ----------------sym
/ ----------------exch
/ ------------quotes/
/ ----------------.d
/ ----------------time
/ ----------------sym
/ ----------------bprice
/ ----------------bsize
/
/ This is a standard partitioned historical database layout in KDB+.

/
/ `dpft` creates a partitioned table and writes data for a date,
/ with `sym` as the segmented key
/ It is commonly used to create HDB directory structures
.Q.dpft[`:hdb;.z.d;`sym;`trades]

/ Partition for previous day
.Q.dpft[`:hdb;.z.d-1;`sym;`trades]
