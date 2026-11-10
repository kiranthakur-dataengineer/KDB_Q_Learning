/==========================================================
/ Sync & Async Communication in KDB+
/ Deferred synchronous communication / IPC / HDB concepts
/
/ This file covers:
/
/ - opening a connection to a remote KDB server
/ - deferred synchronous query execution
/ - async query handling
/ - table attributes (`sorted`, `grouped`, `parted`, `unique`)
/ - real-world HDB concepts
/ - symbol vs string enumeration
/ - tickerplant architecture
/==========================================================

/------------------------------------------
/ Deferred synchronous communication
/------------------------------------------

/ In KDB+, a common pattern is to:
/
/ 1. send a query asynchronously
/ 2. store the result using the client handle
/ 3. retrieve it later when the client is ready
/
/ This is useful for request/reply architectures
/ where the process should not block on a long-running query.

\p 15000
/ Start a KDB server on port 15000

d:()!()
/ Create an empty dictionary
/ This will map client handle -> result

/ `handler` is executed on the server side when a client sends a request
/ It stores the result in `d` using the client handle `.z.w`
handler:{d[.z.w]:x}

/ `execute` asks the remote process to evaluate the result associated with a handle
/ It sends the result back to the client using the negative handle
execute:{(neg x)value d[x]}

/ Show the dictionary state
d

/ `.z.W` typically contains the current client's handle or working handle info
.z.W

/ The dictionary `d` is being used like a result cache keyed by handle
/ `value d 13` evaluates the value stored for handle 13
value d 13

/ Manual execution of the stored query
execute 13

/ Another example:
execute 10
value d 10

/------------------------------------------
/ Table attributes
/------------------------------------------

/ KDB tables can have attributes that optimize query behavior:
/
/ - `s` = sorted
/ - `g` = grouped
/ - `p` = parted
/ - `u` = unique
/
/ These are important for performance and storage layout.

/
/ `sorted` attribute:
/
/ A sorted attribute on a column allows binary searches
/ and faster range queries on ordered data.
/
/ Example: `\`s#sym` on a symbol column
/
/ `grouped` attribute:
/
/ Helps optimize grouped aggregations and operations on data
/ already grouped by a key.
/
/ Important:
/
/ - grouped attribute does not automatically update when new rows are added
/ - it may require a re-apply if data changes
/ - it has additional memory overhead
/
/ `parted` attribute:
/
/ Used for on-disk partitioned data
/ Helps the engine access partitioned data faster
/ by keeping the data physically contiguous on disk
/
/ Important:
/
/ - appending new rows can remove the parted attribute
/ - it must be re-applied after inserts or updates
/
/ `unique` attribute:
/
/ Used when a column has unique values
/ Helpful for fast lookup and dictionary-like operations
/
/ Real-world applications:
/
/ - symbol or ID columns often use unique/sorted attributes
/

/
/ Real-world KDB challenges:
/
/ Intraday HDB (IDB) and RDB (Real-time database):
/ - IDB holds current day or in-memory data
/ - RDB processes current live updates
/ - HDB holds historical partitions
/
/ The system usually separates:
/
/ 0 = current day or in-memory data
/ 1 = previous day
/ 2 = prior partitions
/ 3, 4, 5 = maybe historical segments
/
/ This is a typical architecture for market data systems.

/
/------------------------------------------
/ Enumeration / memory optimization
/------------------------------------------

/ In KDB, strings and symbols are different:
/
/ String = char list
/ Example: "ABC"
/
/ Symbol = atomic value stored once in memory and reused
/ Example: `AAPL`MSFT`IBM
/
/ Symbol is memory efficient when the number of unique values is small.
/
/ Use symbol for:
/ - ticker symbols
/ - exchange codes
/ - side codes
/ - status values
/
/ Use string/char list for:
/ - descriptive text
/ - long text fields
/ - non-repeating text data
/
/ Rule of thumb:
/
/ - If values are repeated many times and limited in number,
/   use symbol
/ - If values are descriptive and many unique values exist,
/   prefer string or char list
/
/
/ Example:
/
/ 10,000,000 rows with 20,000 unique values -> symbol is ideal
/ 1,000,000 rows with 100,000 unique descriptive texts -> char list may be more appropriate

/------------------------------------------
/ Tickerplant architecture
/------------------------------------------

/ Tickerplant = real-time feed ingestion layer in KDB systems
/ It receives market data and publishes it to downstream processes
/
/ Typical architecture:
/
/ Feed -> Tickerplant -> RDB / IDB -> HDB
/
/ It is common in financial / market data pipelines
/ KX Academy workshops often teach this architecture as a base pattern.

/
/==========================================================
/ Remote query and async example from console
/==========================================================

/ Example remote connection:
q)h:hopen`::15000

/ Now `h` is a handle to the server
q)h
/ returns a handle ID, e.g. 4i

/ Asynchronous query:
q)(neg h)(`handler;"select from trades where sym=`IBM");res:h(::)

/ Explanation:
/
/ - `(neg h)` sends an async message to the server
/ - `handler` is the callback function on the remote server
/ - It stores the result in the dictionary `d` keyed by `.z.w`
/ - `res:h(::)` waits to receive the result from the server
/
/ After this, `res` contains the requested data.

q)res
/ Output sample:
/
/ time                          sym exch side price     size
/ ----------------------------------------------------------
/ 2026.10.05D09:00:00.809551030 IBM O    B    60.81167  9247
/ ...
/
/ This is a table of IBM trades returned over IPC.

/
/------------------------------------------
/ Querying the HDB / historical database
/------------------------------------------

/ In a historical database directory:
/
/ hdb/
/   2026.09.29/
/   2026.09.30/
/   sym1
/
/ `sym1` is often an enumerated symbol file
/ It maps integer codes to actual symbol values

/ Example from console:
q)select from trades
/ Shows rows from the loaded historical table

q)\l .
/ Load all database files in the current directory

q)select from trades
/ Re-run the table query after load

/ The displayed output shows:
/
/ date       sym time                          exch side price    size
/ --------------------------------------------------------------------
/ 2026.09.29 AAPL ...
/
/ Here, `sym` is the symbol field
/ In an enumerated database, the actual symbol may be stored as an integer index
/ and resolved through the `sym` file.

/------------------------------------------
/ Symbol enumeration example
/------------------------------------------

/ In some HDB setups, symbols are stored as integer references instead of raw symbol strings
/ because it saves memory and improves speed.
/
/ Example:
/
/ date       sym time ...
/ 2026.09.29 2   ...
/
/ Here `2` is not the literal symbol "AAPL" but the internal symbol index
/ It is mapped to the actual symbol using the `sym` file or symbol enumeration table

/ The exact mapping is usually internal to KDB, but conceptually:
/
/ enum code 2 -> `AAPL
/ enum code 10 -> `IBM
/
/ This is why enumeration is useful for large datasets.

/------------------------------------------
/ Important KDB notes
/------------------------------------------

/ - `hopen` creates a remote connection using IPC
/ - `neg h` sends async messages
/ - `value` evaluates KDB expressions dynamically
/ - A handler function can store results keyed by client handle
/ - This pattern is useful for request/reply systems
/ - Table attributes optimize large datasets
/ - Symbols are memory-efficient values useful for repeated labels
/ - HDB uses partitioned storage and symbol enumeration for performance
/ - Real-time and historical data systems often use a layered architecture
/
/==========================================================
/ Final summary
/==========================================================

/ This file introduces foundational KDB concepts often used in production:
/
/ - IPC communication
/ - async/sync request flow
/ - callback handling
/ - table attributes
/ - enumeration and memory optimization
/ - HDB partitioning and symbol storage
/ - real-world market-data architecture
/
/ These are critical for understanding KDB+ at both beginner and professional levels.
/
