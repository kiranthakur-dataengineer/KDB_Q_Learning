/==========================================================
/ Q/KDB+ basics: variables, data types, lists, strings, and list ops
/==========================================================

/ Assign values to variables
a:5
b:a-3
c:1+3*b
d:a*c+b*2

/ In Q, expressions on the right side are evaluated before assignment.
/ So here, the right-hand side is computed first, then stored in the left variable.
c:1+3*b:-3+a:5 / always think right to left

/ Display variable values
a
b

/------------------------------------------
/ Basic data types
/------------------------------------------

/ `type` tells us the data type of an expression
type 123
type 123f
type 2014.09m
type `kg / single item, stored as a symbol (single memory block)
type "asdfasdfsdf"
count "asdfasdfsdf"

/ A string is just a list of characters
s:"asdfasdfsdf"
s[2]:"r"          / change the 3rd character (0-based indexing in Q)
s

/ A symbol list: each item is treated as a symbol, not a string
sl:`asdfasdf`qweqwe`wrtyu
count sl
type sl
type "kdbguru"

/------------------------------------------
/ Lists and list creation
/------------------------------------------

/ `?` generates random values from a range
l1:20?50
l2:20?50

/ Concatenate two lists horizontally
l3:l1,l2

/ Create a 2D list (nested list)
l3:(l1;l2) / 2D list

/ Different ways to create lists
l:(1;2;3;4;5) / same as below list
l:1 2 3 4 5

/ A list of lists (each inner list is an item)
l:(1 2;3 4)

/ A list of strings
l:("abc";"def";"pqr")
type l

/------------------------------------------
/ List arithmetic
/------------------------------------------

/ Element-wise addition only works when both lists are same length and type
l1+l2 / sum of corresponding operands

/ Same length of list required
/ Same data type also required for many operations
/ Example: element-wise operations work on matching list shapes

/ Multiply every element by 5
5*l

/ Multiply each element in the list by 10
l1*10

/ Average of list values
avg l2

/ Show the original list
l1

/ Filter values greater than the average of l2
l1 where l1>avg l2

/------------------------------------------
/ Mixed-type nested list
/------------------------------------------

/ A list can contain different types inside nested lists
l1:(1 2 3;`a`b`c;4 5 6f;10110b)
type l1

/------------------------------------------
/ String and list operations
/------------------------------------------

/ `ss` = string search
/ it finds a substring inside a string
ss["hello world";"lo"] / search for "lo" in "hello world"

/ If substring is not found, Q returns null/empty-type indicator
ss["hello wolrd";"b"] / if the string is not there it returns long datatype / null-like result

/ `ssr` = string search and replace
ssr["hello world";"lo";"p"]
ssr["hello world";"o";"p"]

/ `sv` = string from vector
/ Join list items with a separator
sl:("hello";"how";"are";"you")
count sl

sv[" ";sl] / prefix way of writing
" "sv sl   / infix way of writing

st:sv[" ";sl]   / store joined string

/ `vs` = vector from string
/ split a string into words based on a separator
vs[" ";st] / it will give separate words as a list
" " vs st

/ Remove occurrences of a word/string from a string
st except "hello" / removes occurrences of "hello"

/------------------------------------------
/ Amend list / update elements
/------------------------------------------

/ Change specific positions in a list
l2[4 6 9]:5 12 30

/ Another way to view/define list elements
[l2: 4;6;9]
l2


/ My code

// l2[4 6 9]:5 12 30
// l2

l1:10?50
l2:10?`1
d:l2!l1
d `a 
d `e // If duplicate keys then fetch first occurance value
d[`e]:21 // update value for key `e, if key is duplicate then update only first occurance

d?13 //search by value and return key of first occurance

d`e`h`o // return values of provided keys value
`e`h`o#d // return in dictinary format 

sum d // gives sum of all values
max d // max values from d
min d // min 
avg d // avg

where d>20  // gives keys 
d where d>20 // gives values
(where d>20)#d // give result in dictonary format
(value d)min each group key d
(value d)max each group key d
