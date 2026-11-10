/==========================================================
/ Segmented / Memory-Mapped Historical Database (HDB)
/
/ This example explains how KDB+ stores a date-partitioned
/ historical database across multiple segments (storage clusters).
/
/ Key ideas:
/
/ - Data is stored in partitions by date
/ - Each partition can live in a different directory
/ - A root directory contains `par.txt` (segment list)
/ - `sym` file stores symbol metadata
/ - Each segment contains date directories and table data
/ - Q can memory-map the database without loading everything at once
/==========================================================

/------------------------------------------
/ A segmented database is spread across several directories
/------------------------------------------

/ The notes describe a setup like this:
/ 
/ seghdb/
/   par.txt
/   sym
/
/ segs/
/   seg1/
/   seg2/
/   seg3/
/   seg4/
/ 
/ Each segment contains date-partitioned data, for example:
/ 
/ segs/seg3/2026.10.01/trades/
/   .d
/   exch
/   price
/   side
/   size
/   sym
/   time
/   tradecost
/
/ `par.txt` contains the list of segment paths.  
/ Q uses it to determine which segment to read for a given partition.

/
/ Example of creating directories manually (shell commands):
/
>> ../training$ mkdir seghdb
>> ../training$ mkdir segs
>> ../training$ cd segs
>> ../training$/segs$ mkdir seg1
>> ../training$/segs$ mkdir seg2
>> ../training$/segs$ mkdir seg3
>> ../training$/segs$ mkdir seg4
/
/ Then we create a root HDB directory and list the segment paths in par.txt

/------------------------------------------
/ Root directory setup
/------------------------------------------

/ This file lists all segment directories
/ Each line = one segment path
/ KDB+ reads `par.txt` to know the storage layout
/ Example:
/
/ /home/jovyan/developer/workspace/__nouser__/training/segs/seg1
/ /home/jovyan/developer/workspace/__nouser__/training/segs/seg2
/ /home/jovyan/developer/workspace/__nouser__/training/segs/seg3
/ /home/jovyan/developer/workspace/__nouser__/training/segs/seg4
/
/ This is a clustered / segmented storage pattern.


// Start KDB in the HDB root path
/ Example:
/ q .
/ q) .Q.PV
/ 2026.09.30 2026.10.01
/
/ `.Q.PV` shows the list of partitions available in the database

/------------------------------------------
/ Use `.Q.PV` to see partitions
/------------------------------------------

q).Q.PV
/ Output example:
/
/ 2026.09.30 2026.10.01
/
/ Meaning: the database has partitions for these dates.

q)\a
/ lists all tables currently loaded in memory

q)meta trades
/ Shows schema for the `trades` table:
/
/ date | d
/ sym  | s   p
/ time | p
/ exch | s
/ side | s
/ price| f
/ size | i
/
/ `date` is a partition column stored at the HDB level
/ `sym` is a symbol column used as parted/segmented key
/ `time` is timestamp
/ `exch`, `side`, `size`, `price` are normal columns

q)trades
/ Displays the table content

/------------------------------------------
/ Partition path resolution
/------------------------------------------

/ `.Q.par[dbroot;date;table]` returns the physical path to a table partition
/ Example:
q).Q.par[`$":/home/jovyan/developer/workspace/__nouser__/training/seghdb";.z.d-1;`trades]

/ Output example:
/
/ `:/home/jovyan/developer/workspace/__nouser__/training/segs/seg2/2026.09.30/trades
/
/ This tells Q where the partition for the previous day is stored

/------------------------------------------
/ Accessing column files inside partition
/------------------------------------------

/ `.Q.dd[path;colname]` gives the file path for a column within a partition
q).Q.dd[.Q.par[`:.;.z.d-1;`trades];`.d]

/ Example output:
/
/ `:/.../trades/.d
/
/ `.d` is a file storing the column list metadata
q)get .Q.dd[.Q.par[`:.;.z.d-1;`trades];`.d]

/ Output example:
/ `sym`time`exch`side`price`size

/ This means the table has columns:
/ sym, time, exch, side, price, size

q)key .Q.par[`:.;.z.d-1;`trades]
/ `key` tells the table metadata at that path

/ Example output:
/
/ `s#`.d`exch`price`side`size`sym`time`tradecost
/
/ `s#` means symbol-sorted key.  
/ Here the files in the partition are the actual data columns.

q)key .Q.par[`:.;.z.d-2;`trades]
/ If there is no second-day data, it may return null or empty.

q).Q.PV
/ This shows the available partitions again

/------------------------------------------
/ Segmenting logic
/------------------------------------------

/ The example uses:
/
(.z.d+2) mod 4
/
/ This calculates a segment number from a date
/
/ Why?
/ - Dates are converted internally to integers
/ - Modulo 4 decides which segment should receive the partition
/ - This spreads data evenly across segments
/
/ Weekday logic:
/
/ 2000.01.01 was a Saturday
/ So:
/ - 0 and 1 are weekend-like offsets
/ - 2 to 6 represent weekdays
/
/ This is a rough explanation of how KDB+ date-to-segment mapping works.

q).Q.dpft[`:seghdb;.z.d;`sym;`trades]
/ `.Q.dpft` stores a table into a partitioned database
/ It writes data by:
/
/ - root path = `:seghdb
/ - date = `.z.d
/ - sym = symbol key
/ - table = `trades
/
/ So the partition is stored in the segment assigned to that date.

q).Q.par[`$":/home/jovyan/developer/workspace/__nouser__/training/seghdb";.z.d-1;`trades]
/ This resolves the path for yesterday's partition

/------------------------------------------
/ Add a new column to all partitions
/------------------------------------------

/ This function adds a new field to a table in every partition.
/
/ It:
/ 1. Finds the physical partition path
/ 2. Creates a column file
/ 3. Fills it with null values (`0n`) matching row count
/ 4. Updates `.d` metadata to include the new column
/
q)addcol:{[dbroot;tab;nc;part]
  path:.Q.par[dbroot;part;tab];
  .Q.dd[path;nc] set (count get .Q.dd[path;`sym])#0n;
  .Q.dd[path;`.d] 0: (get .Q.dd[path;`.d]),nc;
  }

q)newcol:`tradecost
/ New column name we want to add

q)dbroot:`$":/home/jovyan/developer/workspace/__nouser__/training/seghdb"
q)addcol[dbroot;`trades;newcol]each .Q.PV
/ This runs the function for each partition in `.Q.PV`

/ At this point, each partition has a new `tradecost` column

q)\l .
/ Reload the database / reinitialize namespace

q)meta trades
/ Now the table schema includes the new column:
/
/ tradecost | f

/------------------------------------------
/ Delete a column from all partitions
/------------------------------------------

/ This function removes a column name from `.d` metadata
/ for each partition, effectively removing it from the table schema.
q)delcol:{[dbroot;tab;col;part]
  path:.Q.par[dbroot;part;tab];
  @[path;`.d;:;(get .Q.dd[path;`.d])except col];
  }

q)delcol[dbroot;`trades;`tradecost]each .Q.PV
/ Remove the new column across all partitions

q)\l .
q)meta trades
/ Schema is back to original form with no `tradecost`

/------------------------------------------
/ Important points about HDB and segmented storage
/------------------------------------------

/ - `par.txt` stores the list of segments
/ - A segment can hold multiple date partitions
/ - `.Q.PV` shows the available partitions
/ - `.Q.par` resolves the physical path for a date + table
/ - `.Q.dd` resolves the internal path to a column or metadata file
/ - `.d` contains the list of columns in a partition
/ - `sym` file stores symbol metadata used in the partitioned database
/ - This layout helps KDB+ handle massive time-series datasets with efficient disk access
/ - Memory mapping allows Q to read only needed data without full in-memory load
/
/ This architecture is optimized for:
/
/   - large historical datasets
/   - fast filtering by date and symbol
/   - efficient time-series queries
/   - low memory overhead when using segmented storage
/==========================================================

/==========================================================
/ Extra shell observations from the example
/==========================================================

/ The file system layout looked like:
/
/ training/
/
/   seghdb/
 /     par.txt
 /     sym
/
/   segs/
 /     seg1/
 /     seg2/
 /       2026.09.30/
 /         trades/
 /           .d
 /           exch
 /           price
 /           side
 /           size
 /           sym
 /           time
 /           tradecost
 /     seg3/
 /       2026.10.01/
 /         trades/
 /           .d
 /           exch
 /           price
 /           side
 /           size
 /           sym
 /           time
 /     seg4/
/
/ This demonstrates a real-world clustered HDB design.
/
/ The database is not a single flat file.
/
/ Instead, it is logically partitioned and physically spread across segments.
/
/ This is why KDB+ performs well on large historical datasets.
/
/==========================================================