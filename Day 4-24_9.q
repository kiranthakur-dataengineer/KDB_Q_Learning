
// Matrix operation
l:20?100
m:4 cut l 
type m
m 2 1 // index of rows print
m[2;1] //[row;column]
m[2 1] // // index of rows print
m[1;1 2] // [row; column1 col2]
m[0 1 2;2] // [row1 row2 row3;col1]
m[;3] // all rows , 3 index column

// columnwise opearion
sum sum m // each values addition
sum sum each m // sum of each rows sum
sum each m // sum of each rows
count m // # rows
count each m // each rows count

nl:(1 2 3;(4 5;(6 7 8; 9 10;(11;(12 13);14 15; 12 34);(12 45 78;(23 34);78 89)))) 
count nl
nl[1;1;2;3] // fetch value

raze m
raze nl  // flatten the list
raze raze raze raze nl
(raze/)nl

/dictionary
k:-10?`1
v:10?20
d:k!v // create dictioonary
k1:-10?`1 // create single random char symbol, -10 for distinct 10 values
v1:10?20
d1:k1!v1
d+d1 // common key values will get add/sum others remain same
count d+d1

d=d1 // compare 2 dict' keys , 1 means present, 0 means not present
// count d1

flip m // row becomes col and col beacom row like transform
/column dictionary - 
/  Always has list of symbols as key 
/  value is always a list of uniform list
k:-5?`1
v1:5?100
v:(3?100;3?20i;3?10h;3?`2;3?20f)
cd:k!v
flip k!v 
type flip k!v // 

/empty table with column of undefined datatpes
empty_table:([] c1:(); c2:(); c3:() )
meta empty_table
`empty_table insert(`a`b`c;12 13 34i;7 4 8h)
/once table is create table then we can't change datatype
empty_table

//empty table with column of DEFINED datatpes
t:([] c1:`symbol$(); c2:`int$();c3:`short$())
meta t
update c2:`float$c2 from `t
/initialize tabl with data
t:([] c1:`a`b`c;c2:12 13 34i;c3:7 4 8h)
t
meta t
flip `c1`c2`c3!(`a`b`c;12 13 34i;7 4 8h)

/step function
/ flooor ceiling
sd:`s#d // sorted list

/Function




