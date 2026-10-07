d:()!()
d[.z.w]

/attributes 
// sorted
// grouped - creates the hash map, for in-memory data, doesn't get affected with the new data, has got some memory overead
// parted  - while saving down data we first data in sym column then parted in attribute. no memory overhead, if new addition to table, removes the aprted attribute after inserting new data. 
///////////// In histrical data we don't modify but possibly on current day
// unique  - 

/ -------------------------------------

/Sync & Async
/Deferred sync
\p 15000
d:()!()
handler:{d[.z.w]:x}
execute:{(neg x)value d[x]}
d
.z.W
value d 13
execute 13
execute 10

value d 10
/attributes
/sorted, grouped, parted & unique
/grouped attribute is for in-memory data
/grouped attribute doesn't get affected with the new data
/grouped attribute has got some memory overhead
/parted attribute
/works for data on-disk
/makes the query faster by storing the data contiguously for the column on which parted attribute is applied
/adding new entry to the table removes the parted attribute
/parted attribute needs to be re-applied after every insert/update/upsert
/unique

/Real world challenges in KDB
/Intra day HDB
/0 1 2 3 4 5
/today's partition
/IDB - RDB

/Enumeration
/String (char list)
/Symbol - A single data which takes a single memory location
/10000000 / 20000 unique - Ideal for symbol datatype
/1000000 / 100000 unique or descriptive text - char list
/Tickerplant architecture
/KX Academy workshops
