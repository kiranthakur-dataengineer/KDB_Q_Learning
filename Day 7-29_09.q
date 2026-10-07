/Tables & Queries
n:100000
st:.z.d+09:00:00
et:.z.d+15:00:00
tm:st+asc n?`long$et-st
tm:st+n?`long$et-st
st+21600000000000
-10#tm
sym:n?`AAPL`DELL`GOOG`IBM`META`MSFT`NVDA
px:n?100f
size:n?10000i
side:n?`B`S
exch:n?`O`L`N`Q
trades:([] time:tm;sym:sym;exch:exch;side:side;price:px;size:size)
nq:10000000
st:.z.d+09:00:00
et:.z.d+15:00:00
tm:st+asc nq?`long$et-st
tm:st+n?`long$et-st
st+21600000000000
-10#tm
sym:nq?`AAPL`DELL`GOOG`IBM`META`MSFT`NVDA
bprice:nq?100f
bsize:nq?10000i
aprice:nq?100f
asize:nq?10000i
trades:([] time:tm;sym:sym;exch:exch;side:side;price:px;size:size)
quotes:([] time:tm;sym:sym;bprice:bprice;bsize:bsize;aprice:aprice;asize:asize)

select count i from trades where sym=`IBM
select i from trades where sym=`IBM

meta trades
meta quotes
s:exec distinct sym from trades
/foreign key
stock:([sym:`NVDA`GOOG`IBM`AAPL`META`DELL`MSFT] name:("Nvidia Corp";"Alphabet Inc";"International Business Machines Corp";"Apple Inc";"Meta";"Dell Technologies";"Microsoft Inc");city:7?("New York";"CA";"Seattle";"Seoul"))
stock:([sym:`NVDA`GOOG`IBM`AAPL`META`DELL`MSFT;exch:7?`N`L`O] name:("Nvidia Corp";"Alphabet Inc";"International Business Machines Corp";"Apple Inc";"Meta";"Dell Technologies";"Microsoft Inc");city:7?("New York";"CA";"Seattle";"Seoul"))
stock
type stock
stock`NVDA
update sym:`stock$sym from `trades
update sym: from `trades
meta trades
update sym:`stock$sym from `quotes
update sym:value sym from `quotes
meta quotes
`trades insert(3?.z.P;upper 3?`3;3?`N`L`O;3?`B`S;3?100f;3?1000i)
delete from `stock where sym=`NVDA
select time, sym, exch, side, price, size, sym.name, sym.city from trades
/left join
trades

count trades lj stock
quotes lj stock

/inner join
count trades ij stock
ukstock:0!stock
ukstock
ej[`sym;trades;stock]
ej[`sym;trades;ukstock]
/ej[`sym;trades;quotes]
t1:([] k:1 2 3 4; c:10 20 30 40)
t2:([] k:2 2 3 4 5; c:200 222 300 400 500; v:2.2 22.22 3.3 4.4 5.5)
ej[`k;t1;t2]
ej[`k;t2;t1]


ej[`k;t1;`k xkey t2]
ij[t1;`k xkey t2]

t1:([] c1:`a`b; c2:1 2)
t2:([] c1:`c`d; c2:3 4)

t1 uj t2
t1,t2

t1:([] c1:`a`b`c; c2: 10 20 30)
t2:([] c1:`x`y; c3:8.8 9.9)
t1 uj t2
t3:([] c1:`e`f`g; c2:50 60 70; c3:5.5 6.6 7.7)
(t1 uj t2) uj t3
(uj/)(t1;t2;t3)

/ad-hoc joins
/vertical join
t1:([] c1:`a`b; c2:1 2)
t2:([] c1:`c`d; c2:3 4)
t1,t2
/horizontal join
t1:([] c1:`a`b; c2:1 2)
t2:([] c1:`c`d; c3:3 4)
t1,'t2

/as-of join
/grouped
strades:10000?trades
squotes:100000?quotes
meta strades
meta squotes
\t aj[`sym`time;strades;squotes]
update `g#sym from `strades
update `g#sym from `squotes

meta strades
meta squotes
\t aj[`sym`time;strades;squotes]
update `g#sym from `trades
update `g#sym from `quotes
aj[`sym`time;trades;quotes]

2026.09.29D09:00:00.162260234 AAPL N    B    12.5398   7876 54.84148  9600  98.92918  77   
2026.09.29D09:00:00.582173466 META L    S    89.42179  7999 37.0354   5715  22.05687  5133 
2026.09.29D09:00:01.038452424 META O    S    15.03739  3419 31.77998  1789  94.7126   7488 
2026.09.29D09:00:01.114100776 GOOG Q    S    16.72388  7274 39.53327  2978  74.16373  2506 
2026.09.29D09:00:01.125959493 IBM  O    B    64.46505  53   87.91729  3816  92.95947  1058 

select from quotes where sym=`AAPL
select from quotes where sym=`META
aj0[`sym`time;trades;quotes]

asof[trades;`sym`time!(`IBM;.z.d+10:01:03)]

/window join
w:flip (-0D00:00:00.500;0D00:00:00.500)+/: trades`time
wj[w;`sym`time;trades;(quotes;(max;`bprice);(min;`aprice))]
wj[w;`sym`time;trades;(quotes;(::;`bprice);(::;`aprice))]

/joins
/I/O



