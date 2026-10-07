/KDB & Q
/Datatypes in Q
/Numeric
/Text
/Temporal
    /date
    /time
    /timestamp
    /timespan
    /hour
    /min
    /sec
    /month
    /year

/Atom or List
/Atom
/A number
/A char
/A date
/A time
/List
/A list of numbers
/A list of chars
/A list of dates
/A list of lists
/Dictionary
/A list of keys & values mapped to each other
(2 4)!5 7
/Tables
flip `a`b`c!(1 2 3;4 5 6;7 8 9)
/Atoms
/Boolean
0b 1b
/char identifier
/a char suffixed to a data
/Numeric
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
til 10
til 20
/vector based language
12 34 45 56+5
5+12 34 45 56
5+12
2*1+til 10
10?20
-10?20
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
/0 to 20 -5 to 0
10?(neg til 5),1+til 20
avg l
2 mavg l
3 mavg l
2 rotate l
-2 rotate l
l
group l
type 12
type enlist 12
l
/match operators
(1 2 3)~(1 2 3 4h)
(1 2 3)~(1 2 3 4j)
/=
(1 2 3)=(1 2 3h)
1=1i
1~1i
