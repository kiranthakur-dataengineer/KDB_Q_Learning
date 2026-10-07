/conditional Evaluation
/if[cond;exp1;exp2;...]
/if-else $[c1;expTrue1;exptfalse]
/ $[c1;expTrue1;c2;exptTrue2;c3;exptTrue3;exptfalse]
/ vector conditional evaluation - vector data - ?
a:10
if [a=10;"A is 10";"This will also show";show "and this will also show";show "and this will too";show "and so on..."]
if [a<10;"A is NOT 10";"This will NOT show";show "neither this will show";show "and so on..."]
$[a<10;show "a is less than 10"; show "a is greater than or equal to 10"]
$[a<10;show "a is less than 10"; a>10;show "a is greater than 10";a=10;"a is equal to 10";show "This will never appear"]

l:10?20 / create 10 random number from 0 to 20
?[l<10;10;l] / O/P :13 10 10 10 11 10 10 16 14 10 / Whenever item or element satisfy the condition it will replace it with 10.

/Functions
//  if 1<n<2; then r=8 
//  if 2<n<5;r=5;
//  if n>5;r=4
// Assignment---

func:{[p;n;r]

    
    }

/Iterators
/ Previously adverbs -each, each-left,each-right, each left-each right, each both, peach, each prior
/2 accumulators - over and scan
nl:(2 2;(24 32 21; 23 98 43;("sdf","sdg","rqr");(2 3 5f)))
type nl // Give 0h for mixed type data
type each nl /Gives 7 0h As first element is 2 2 as integer and remain as single element with mixed datatype
type each nl 1 // Gives type for each element type from 1 index
type each nl[1;2] / Gives 10 10 10h as a string

/each-left (\:) and each-right(/:)
("IBM";"GOOG";"MSFT";"AAPL"),\: ".N"

/each-right (/:)
"IBM",/: (".N";".O";".L")

/each-left and each right
("IBM";"GOOG";"MSFT";"AAPL"),/:\: (".N";".O";".L")
count ("IBM";"GOOG";"MSFT";"AAPL"),/:\: (".N";".O";".L") // Give will give 4 rows with N,O, L attached to first list element
raze ("IBM";"GOOG";"MSFT";"AAPL"),/:\: (".N";".O";".L") // raze gives you flat list 
raze `$("IBM";"GOOG";"MSFT";"AAPL"),/:\: (".N";".O";".L") // `$ will gives you List of symbols 
("IBM";"GOOG";"MSFT";"AAPL") cross (".N";".O";".L") // Gives Single diamentional column

/each both
// # item lenght left and right have to match
("IBM";"GOOG";"MSFT";"AAPL") ,' (".N";".O";".L") // Gives Error 'Incompatible list lenght'
("IBM";"GOOG";"MSFT";"AAPL") ,' (".N";".O";".L";".Q")

/peach --> Can't show here as we need slave threads
/ performing parallel operations
// If you are working on process on a multi-core CPU then each opearation is performed on different cores parallay

/Parallel Aggregation in q/KDB+

// When working with a Historical Database (HDB), data is typically partitioned by date. Since each partition can be processed independently, many aggregation operations such as max, min, sum, or avg are excellent candidates for parallel execution.

// Suppose your HDB contains data across multiple date partitions and you have 7 slave processes available. You can start q with:

/-s 7

// The -s 7 option creates seven secondary task handlers (slaves), allowing work to be distributed across multiple threads.

// For example, consider a query that calculates the maximum price across several date partitions. Instead of processing each partition sequentially, you can use peach to execute the aggregation on multiple partitions simultaneously.

// How it works
// The date partitions are divided among the 7 slaves.
// Each slave independently calculates the maximum price for its assigned partition(s).
// After the parallel phase completes, you will have up to 7 intermediate results (one maximum value from each slave).
// The master process then performs a final max on these intermediate results to produce the overall maximum value.

// Conceptually:

// Partition 1  --> max --> Result 1
// Partition 2  --> max --> Result 2
// Partition 3  --> max --> Result 3
// ...
// Partition 7  --> max --> Result 7

// Final Result = max(Result 1, Result 2, ..., Result 7)


// Because the expensive part of the computation is distributed across 7 slaves and runs concurrently, the aggregation can be significantly faster than a single-threaded execution. In an ideal scenario, the performance improvement can approach 6-7×, although the actual speedup depends on factors such as:

// Data distribution across partitions
// CPU availability
// I/O bandwidth
// Overhead of task distribution and result collection

// Using peach together with -s 7 is therefore a common technique in q/KDB+ for accelerating partition-wise aggregations on large HDB datasets. The bulk of the work is performed in parallel, while the final reduction step (for example, taking the max of the intermediate results) is very small and completes almost instantaneously.

/each-prior(':)
l
l-':l
// l =10 2 4 1 13 1 18 17 15 4

// 0 8 6 9 -3 9 -8 -7 -5 6 // 10-10 =0, 10-2=8, 10-4=6
// -8                       // 2-10 =-8
// 2                        // 4-2 = 2                      
// -3                       
// 12                       
// -12                       
// 17                       
// -1                       
// -2                       
// -11                       

signum l-':l // 1 increase, -1 value is decrease and 0 is value is not changed.
deltas l    // 10 -8 2 -3 12 -12 17 -1 -2 -11 like 2-10=-8, 4-2=2,1-4=-3,
signum deltas l // we can use in the color to indicate the up and down

/Accumulators - over and scan
// Matematical functions either converging and diverging 
// // google search - Convergence means coming together toward a single point or finite limit, 
  //                  while divergence means moving apart or heading toward infinity without settling on a number
// again and again a function is applied on data recursively
// Diverge means it will go to infinity
// Converge means it will go to finite number

// over gives you only the final result.
// While scan gives you the result at every intermediate steps.
// over is forward slash and the scan is backward slash.
{x*x}[2] - 
{sqrt x}2

5 {x*x}/2 / over
5 {x*x}\2 / scan

5 {sqrt x}/4294967296
5 {sqrt x}\4294967296

({sqrt x}/)4294967296
({sqrt x}\)4294967296

10 {1+2*x}\ 0 // 10 values start from 0
0 {y+2*x}\ 1 2 3 4 5 6 7 8 9 10
//    X  Y  result
//    0  1   1  (1+2*0)
//    1  2   4  (2+2*1)
//    4  3   11 (3+2*4)

/ Fibinacci sequene
5 {x, sum -2#x}/ 0 1 / -2#x used for the fetch last 2 element from list
5 {0N!x, sum -2#x}/ 0 1 / we can give 0 instead of x
/ 10 {x, sum -2#x}\ 0 1  / to know each steps 

fib:{x,sum -2#x}
10 (fib/) 0 1

{100>last x} fib/ 0 1


/ protected evaluation

used for handling any error, whenever an error occurs in, queue, it throws you to a debug console,  now suppose you have a process, a daily batch process, which is running to load the data or something like that, and or even your RDB process. So something happens and it throws it to the debug console. 

/ @ - apply
@ is used for monadic function. 
. is used if you have dyadic function or multivalent function where the input parameter takes more than one parameters.

@[+;(2;3)]
.[+;(2;3)]

.[+;(2;`3)] --> type error

To handle it 
.[+;(2;`3);{"Error: ", x}] --> 
.[+;(2;3;4);{"Error: ", x}] 
.[+;(2 5;3 6;4 7 8);{"Error: ", x}] 
.[fib;(0 1);{"Error: ", x}]
@[fib;0 1;{"Error: ", x}]
@[fib;(0; `a);{"Error: ", x}]

/using signal - always gives the non 0 result. 
func:{[a;b] c:a*b;if[c>50;show "Exceeds the range"];c} // with show
func[3;4]

func[13;4] -- Error
func:{[a;b] c:a*b;if[c>50;'"Exceeds the range"];c} // with signal

/default parameter - x, y, z(implicit parameter


fun:{x*y*z*0.01}
fun[100,2;10]
fun:{x*y}
fun:{x+y*2}
fun:{x+z*2}
fun[2;3] -- give error for projection. expecting value to z to accept

/// If you are using  z and passing single value it will not consider for it for z. It will consider it for the x. 


