/Q1 Write Q expressions for: -
// · a=5
// · b=a-3
// · c=3b+1

a:5
b:a-3
c:3*b+1

/Q2 Repeat Q 2 in one single assignment statement.
a:5;b:a-3;c:3*b+1 /--> wrong
/>>correct Ans==> c:1+3*b:-3+a:5 // process right to left

/Q3 Find the type values of the following objects: -

type 123 / -7h int  
type 123f /-9h  float 
type 2014.09m / -13h  month 
type `kg / -11h  symbol  
type "kdbguru" / 10h  char list

/Q4 Create 2 lists, l1 & l2 with 20 random values less than 50
l1:20?50
l2:20?50
// 4.1 Make a new list l3 with l1 & l2 combined
l3:l1,l2 /--> single diamentional list 
l3:(l1;l2) /--> Nested list , apear as multidiamentional 

// 4.2 Sum the elements of l1 & l2
sum l1
sum l2
l1+l2 /-->l1[0] + l2[0], .... / both list supposed to same length otherwise length error will appear
// 4.3 Multiple all the elements in l1 by 10
l1:l1*10

// 4.4 Find all the elements of l1 which are greater than average of l2
l1 where l1>avg l2


/Q5 Create the following nested list and store it in l1
// 1 2 3
// `a`b`c
// 4 5 6f
// 100110b

l1:(1 2 3;
   `a`b`c;
    4 5 6f;
    100110b)
// a) Find the type value of l1
type l1 /0h

// b) Find the type value of each row
type each l1 / 7 11 9 1h
type each l1[0] / -7 -7 -7h
type each l1[1] / -11 -11 -11h
type each l1[2] / -9 -9 -9h 
type each l1[3] / -1 -1 -1 -1 -1 -1h
type `[l1]



