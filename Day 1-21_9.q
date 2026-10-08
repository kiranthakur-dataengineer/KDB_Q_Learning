/KDB & Q
/This file is a quick Q tutorial showing the main data types, list operations,
/aggregation functions, and comparison operators used in KDB+/Q.
/Everything in Q revolves around atoms, lists, dictionaries, and tables.

/Datatypes in Q
/---------------------------------------------
/Numeric: integers, floats, longs, reals, etc.
/Text: strings and characters.
/Temporal: date, time, timestamp, timespan, month, and year.
/Examples of temporal values:
/    date      -> 2026.09.21
/    time      -> 12:34:56.789
/    timestamp -> 2026.09.21D12:34:56.789
/    timespan  -> 12:34:56.789000000
/    hour      -> 12h
/    min       -> 15m
/    sec       -> 30s
/    month     -> 2026.09m
/    year      -> 2026

/Atom or List
/---------------------------------------------
/Atom: a single value, such as one number, one character, or one date.
/List: a collection of values, such as a list of numbers, strings, or nested lists.

/Dictionary
/---------------------------------------------
/A dictionary maps keys to values.
/Here, key 2 maps to value 5 and key 4 maps to value 7.
(2 4)!5 7

/Tables
/---------------------------------------------
/A table is a set of columns, usually represented as a dictionary of columns.
/Using flip converts a list of column vectors into a table.
flip `a`b`c!(1 2 3;4 5 6;7 8 9)

/Atoms
/---------------------------------------------
/Boolean values are 0b and 1b, representing false and true.
0b 1b

/char identifier
/---------------------------------------------
/A character is a single symbol/char in Q; symbols are often used as identifiers.
/a char suffixed to a data  -> symbol/identifier names like `a, `b, `c

/Numeric
/---------------------------------------------
/The type function reveals the internal datatype of a value.
type 1231
type 132i
type 234
type 34h
type "f"
type "sdfd"
type 12 34 78
type 12 34 78i
type 12 34 78h
type 2026.09.21
type 2026.09.21 2026.09.20
type 2026.09m
type 2026.09
type 12 34 78f
type (12f;34f;78f)
type (12i;34h;78f)
type (12 34 56;78 89 21)
type each (12 34 56;78 89 21)
type each (12 34 56h;78 89 21f)

/til creates a sequence from 0 to n-1.
/It is commonly used to generate ranges.
til 10
til 20

/vector based language
/---------------------------------------------
/Q is a vector-based language, so arithmetic and functions often operate on entire lists.
12 34 45 56+5
5+12 34 45 56
5+12
2*1+til 10

/Random selection from a list/range.
/10?20 means choose 10 random integers from 0 to 19.
10?20
/-10?20 is a variation using a negative range pattern in Q.
-10?20

/Assigning variables
/---------------------------------------------
/Variables are assigned with a colon (:).
a:10
l:10?20
l
type l
count l
first l
last l
sum l
prd l
max l
min l
sums l
l
prev l
asc l
desc l

/-5 to 20 count 10
/This expression creates a range from -5 to 19 and appends a second range.
/It demonstrates list creation and concatenation in Q.
10?(neg til 5),1+til 20

/Moving averages and rotations
/---------------------------------------------
/avg gives the arithmetic mean of a list.
avg l
/2 mavg l and 3 mavg l compute moving averages using windows of 2 and 3 values.
2 mavg l
3 mavg l
/rotate shifts items in a list left or right.
2 rotate l
-2 rotate l
l

/group combines equal values and groups them together.
/This is useful for aggregating records by a key.
group l

type 12
type enlist 12
l

/match operators
/---------------------------------------------
/ ~  -> deep match (value and type)
/ =  -> equality comparison
/These examples show how Q compares values and types.
(1 2 3)~(1 2 3 4h)
(1 2 3)~(1 2 3 4j)
1=1i
1~1i
