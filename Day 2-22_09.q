/===========================================================
/ KDB+/Q practice script with explanations
/ This file demonstrates:
/ - data types
/ - date/time conversion
/ - list creation and filtering
/ - sorting and ranking
/ - grouping and bucketing
/===========================================================

/-----------------------------------------------------------
/ 1) Type checks
/-----------------------------------------------------------

/ `type` tells us the q datatypes of expressions
type 10:09:23.234              / time value -> type of time
type 2026.09.22D10:09:23.234   / datetime value -> type of datetime
type 4D02:23:21.133           / timespan/duration value -> type of timespan
type 2026.09m                 / month value -> type of month

/ `key` lists names available in namespaces
key`                          / list of variables/functions in root namespace
key .q                        / list of objects in .q namespace
key .Q                        / list of objects in .Q namespace
key .h                        / list of objects in .h namespace

/ System date/time variables
.z.d                          / today's date
.z.D                          / today's datetime
.z.t                          / current time
.z.T                          / current timestamp
.z.p                          / current process timestamp/port info

/ Assigning values to variables
p:2026.09.18D10:09:23.234     / p stores a datetime value
c:.z.P                        / c stores current timestamp
d:c-p                         / difference between current timestamp and p
type c-p                      / check type of the result
type c                        / type of c

/-----------------------------------------------------------
/ 2) Display format and date conversions
/-----------------------------------------------------------

/ `\P` controls display precision for floating point values
\P 17

/ Example arithmetic showing large numeric value creation
(3*24*60*60*10 xexp 9)+(10*60*60*10 xexp 9)+(9*60*10 xexp 9)+23419347680
/ The expression builds a number using:
 / 3 days, 10 hours, etc.  xexp is exponentiation
 / It is just a numeric demonstration

/ Casts between types
`long$d                       / cast duration-like value to long integer
`int$.z.d                     / cast today's date to integer
`int$.z.d - `int$1998.10.23   / difference in days between today and 1998.10.23
`int$1998.10.23              / integer representation of date 1998.10.23
`month$.z.d                  / convert date to month
`year$.z.p                   / convert timestamp to year
`uu$.z.p                     / convert timestamp to "uu" type

/-----------------------------------------------------------
/ 3) Lists and simple querying
/-----------------------------------------------------------

/ A list is a core q data structure
/lists                        / label for this section

l:20?100                     / generate a list of 20 random integers from 0 to 99
l 12 3 4 8                   / index list `l` at positions 12,3,4,8
l 22                         / get element at index 22
l?19                         / find position of value 19
group l                      / group equal values together
l?30                         / find position of 30
l?20                         / find position of 20

/ Equality and filtering examples
/~ & =                       / comment section showing matching operators
30=l                         / compare each element with 30 -> boolean list
30~l                         / is the entire list exactly 30?
where not 0101110001b        / positions where boolean vector is 0
where 30=l                   / positions where value equals 30
l where 30>l                 / elements less than 30
l where l mod 2              / elements with remainder 1 when divided by 2 (odd)
l where not l mod 2          / elements divisible by 2 (even)
23 mod 2                     / remainder of 23 divided by 2

/-----------------------------------------------------------
/ 4) Modulo and number ranges
/-----------------------------------------------------------

/ m mod n means "remainder after dividing m by n"
/0 ... n-1                   / numbers from 0 to n-1
/n mod 7                     / remainder of n divided by 7
/0 ... 6                     / numbers 0 to 6
l                            / print current list

/-----------------------------------------------------------
/ 5) Sorting and ranking
/-----------------------------------------------------------

asc l                        / sort list in ascending order
desc l                       / sort list in descending order
rank l                       / rank each element in list
l iasc l                     / indices needed to sort `l` ascending
b iasc a                     / sort `b` according to the order in `a`

/ attributes - sorted, grouped, parted & unique
asc                          / a simple ascending sort example

/-----------------------------------------------------------
/ 6) Performance timing
/-----------------------------------------------------------

bl:100000000?100000000       / create a very large random list of 100 million numbers
\t:10 bl?42341324            / time 10 searches for value 42341324 in bl
sbl:asc bl                   / sort the large list once
\t:10 sbl?42341324           / time 10 searches in sorted list

/-----------------------------------------------------------
/ 7) Reverse ordering and filtering
/-----------------------------------------------------------

l idesc l                    / indices needed for descending sort
l where 12<l                 / keep only values greater than 12
l except 63 24 56            / remove specific values 63, 24, 56
7#l                          / take first 7 elements
-8#l                         / take last 8 elements
4_l                          / drop first 4 elements
-5_l                         / drop last 5 elements
4_l                          / same as drop first 4 again
l                            / display list again

/-----------------------------------------------------------
/ 8) Bucketing / grouping into ranges
/-----------------------------------------------------------

/ `xbar` groups numbers into fixed-size bins
5 xbar l                     / group values into buckets of width 5
10 xbar l                    / group values into buckets of width 10
l:1_l                        / reset or modify `l`
l:20?100                     / recreate `l` as random list of 20 values
first asc l                  / first element after sorting ascending
10 xbar l                    / bucket values into ranges of width 10
avg each l group 10 xbar l   / compute average for each bucket
