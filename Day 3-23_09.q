a:5
b:a-3
c:1+3*b
d:a*c+b*2
c:1+3*b:-3+a:5 /alwyas think right to left
a
b
type 123
type 123f
type 2014.09m
type `kg /single item which takes single memory block
type "asdfasdfsdf"
count "asdfasdfsdf"
s:"asdfasdfsdf"
s[2]:"r"
s
sl:`asdfasdf`qweqwe`wrtyu
count sl
type sl
type "kdbguru"

l1:20?50
l2:20?50
l3:l1,l2 /

l3:(l1;l2) / 2D list
l:(1;2;3;4;5)/ same as below list
l:1 2 3 4 5
l: (1 2;3 4)
l: ("abc";"def";"pqr")
type l
l1+l2 /sum of corresponding operands

/same length of list required and same data type also

5*l
l1*10
avg l2
l1
l1 where l1>avg l2
l1:(1 2 3;`a`b`c;4 5 6f;10110b)
type l1

/ list operations strings char/list

/ss - string search
ss["hello world";"lo"] /it will search lo in hellow world string
ss["hello wolrd";"b"]/if the string is notb there it returns long data type long list

/ssr : string search replce
ssr["hello world";"lo";"p"]
ssr["hello world";"o";"p"]

/sv - string from vector 
sl:("hello";"how";"are";"you")
count sl

sv[" ";sl] /prefix way of writing

" "sv sl /infix way of writing

st:sv[" ";sl]

/vs -vector from string
vs[" ";st]/it will give separte word of list
" " vs st

st except "hello" /it will remove occurences of h e ll o 

/Amend list

l2[4 6 9]:5 12 30

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