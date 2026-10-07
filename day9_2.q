jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/seghdb$ ll
total 16
drwxr-sr-x 2 jovyan users 4096 Oct  1 05:15 .
drwxrwsr-x 9 jovyan users 4096 Oct  1 05:12 ..
-rw-r--r-- 1 jovyan users  252 Oct  1 05:14 par.txt
-rw-r--r-- 1 jovyan users   54 Oct  1 05:15 sym
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/seghdb$ q .
KDB-X 5.0 2026.05.01 Copyright (C) 1993-2026 Kx Systems
l64/ 8()core 64307MB jovyan jupyter-kdbguru-40gmail-2ecom 10.33.243.192 EXPIRE 2027.01.19    localkod 00000000-0000-0000-0000-000000000000

q)\a
,`trades
q).Q.PV
,2026.10.01
q)\l .
q)
q)
q).Q.PV
2026.09.30 2026.10.01
q)select from trades where date=2026.09.30, sym=`IBM
date       sym time                          exch side price     size
---------------------------------------------------------------------
2026.09.30 IBM 2026.09.30D09:00:00.902021862 N    B    78.07789  4326
2026.09.30 IBM 2026.09.30D09:00:01.402471773 L    B    82.87714  3387
2026.09.30 IBM 2026.09.30D09:00:04.873278737 N    S    27.65956  4874
2026.09.30 IBM 2026.09.30D09:00:06.808552891 N    S    9.186277  3503
2026.09.30 IBM 2026.09.30D09:00:10.914273932 N    S    17.60588  7076
2026.09.30 IBM 2026.09.30D09:00:12.476144358 N    B    58.18687  6553
2026.09.30 IBM 2026.09.30D09:00:12.925483100 O    S    14.5915   9097
2026.09.30 IBM 2026.09.30D09:00:13.424524851 O    B    82.90155  1018
2026.09.30 IBM 2026.09.30D09:00:14.361021481 N    S    0.0774717 5620
2026.09.30 IBM 2026.09.30D09:00:15.056058950 L    S    57.53633  1298
2026.09.30 IBM 2026.09.30D09:00:18.136478774 O    S    63.20765  6552
2026.09.30 IBM 2026.09.30D09:00:18.199006095 Q    B    9.345012  5960
2026.09.30 IBM 2026.09.30D09:00:18.864225782 L    S    78.34406  3262
2026.09.30 IBM 2026.09.30D09:00:25.736880116 L    S    92.69368  430 
2026.09.30 IBM 2026.09.30D09:00:26.434673555 N    B    19.91308  6635
2026.09.30 IBM 2026.09.30D09:00:29.167373478 L    B    22.67369  5827
2026.09.30 IBM 2026.09.30D09:00:30.683679878 O    S    0.5471848 9083
2026.09.30 IBM 2026.09.30D09:00:31.901149637 O    S    78.1352   8572
2026.09.30 IBM 2026.09.30D09:00:34.028657712 Q    B    22.1443   1993
2026.09.30 IBM 2026.09.30D09:00:35.129622370 Q    S    78.17119  7507
2026.09.30 IBM 2026.09.30D09:00:35.394230671 N    B    96.98771  5217
2026.09.30 IBM 2026.09.30D09:00:36.074004694 O    S    63.484    7560
..
q).Q.par[`$":/home/jovyan/developer/workspace/__nouser__/training/seghdb";.z.d-1;`trades]
`:/home/jovyan/developer/workspace/__nouser__/training/segs/seg2/2026.09.30/trades
q).Q.par
k){[d;p;t]`/:($[@!h:`/:d,`par.txt;`$":",h .q.mod[p;#h:0:h];d];`$$p;t)}
q)addcol:{[dbroot;tab;nc;part] path:.Q.par[dbroot;part;tab]; .Q.dd[path;nc] set (count get .Q.dd[path;`sym])#0n; .Q.dd[path;`.d] 0: (get .Q.dd[path;`.d]),nc;}
q)addcol
{[dbroot;tab;nc;part] path:.Q.par[dbroot;part;tab]; .Q.dd[path;nc] set (count get .Q.dd[path;`sym])#0n; .Q.dd[path;`.d] 0: (get .Q.dd[path;`.d]),..
q)addcol[dbroot;`trades;newcol]each .Q.PV
'newcol
  [0]  addcol[dbroot;`trades;newcol]each .Q.PV
                             ^
q)newcol:`tradecost
q)dbroot
'dbroot
  [0]  dbroot
       ^
q)dbroot:`$":/home/jovyan/developer/workspace/__nouser__/training/seghdb"
q)addcol[dbroot;`trades;newcol]each .Q.PV
'type
  [2]  addcol:{[dbroot;tab;nc;part] path:.Q.par[dbroot;part;tab]; .Q.dd[path;nc] set (count get .Q.dd[path;`sym])#0n; .Q.dd[path;`.d] 0: (get .Q.dd[path;`.d]),nc;}
                                                                                                                                      ^
q))\
q)addcol:{[dbroot;tab;nc;part] path:.Q.par[dbroot;part;tab]; .Q.dd[path;nc] set (count get .Q.dd[path;`sym])#0n; .[.Q.dd[path;`.d];();(get .Q.dd[path;`.d]),nc;}
'}
  [0]  addcol:{[dbroot;tab;nc;part] path:.Q.par[dbroot;part;tab]; .Q.dd[path;nc] set (count get .Q.dd[path;`sym])#0n; .[.Q.dd[path;`.d];();(get .Q.dd[path;`.d]),nc;}
                                                                                                                                                                    ^
q)addcol:{[dbroot;tab;nc;part] path:.Q.par[dbroot;part;tab]; .Q.dd[path;nc] set (count get .Q.dd[path;`sym])#0n; .[.Q.dd[path;`.d];();(get .Q.dd[path;`.d])],nc;}
q)addcol[dbroot;`trades;newcol]each .Q.PV
'type
  [2]  addcol:{[dbroot;tab;nc;part] path:.Q.par[dbroot;part;tab]; .Q.dd[path;nc] set (count get .Q.dd[path;`sym])#0n; .[.Q.dd[path;`.d];();(get .Q.dd[path;`.d])],nc;}
                                                                                                                      ^
q))\
q)addcol:{[dbroot;tab;nc;part] path:.Q.par[dbroot;part;tab]; .Q.dd[path;nc] set (count get .Q.dd[path;`sym])#0n; .[hopen .Q.dd[path;`.d];();(get .Q.dd[path;`.d])],nc;}
q)addcol[dbroot;`trades;newcol]each .Q.PV
::
::
q)\l .
q)meta trades
c    | t f a
-----| -----
date | d    
sym  | s   p
time | p    
exch | s    
side | s    
price| f    
size | i    
q)
q)
q)
q)addcol:{[dbroot;tab;nc;part] path:.Q.par[dbroot;part;tab]; .Q.dd[path;nc] set (count get .Q.dd[path;`sym])#0n; .Q.dd[path;`.d] 0: enlist(get .Q.dd[path;`.d]),nc;}
q)addcol[dbroot;`trades;newcol]each .Q.PV
'type
  [2]  addcol:{[dbroot;tab;nc;part] path:.Q.par[dbroot;part;tab]; .Q.dd[path;nc] set (count get .Q.dd[path;`sym])#0n; .Q.dd[path;`.d] 0: enlist(get .Q.dd[path;`.d]),nc;}
                                                                                                                                      ^
q))\
q)path:.Q.par[dbroot;.z.d;`trades]
q)path
`:/home/jovyan/developer/workspace/__nouser__/training/segs/seg3/2026.10.01/trades
q).Q.dd[path;`.d] 0: get .Q.dd[path;`.d]
'type
  [0]  .Q.dd[path;`.d] 0: get .Q.dd[path;`.d]
                       ^
q).Q.dd[path;`.d] 0: enlist get .Q.dd[path;`.d]
'type
  [0]  .Q.dd[path;`.d] 0: enlist get .Q.dd[path;`.d]
                       ^
q)get .Q.dd[path;`.d]
`sym`time`exch`side`price`size
q)(get .Q.dd[path;`.d]),`tradecost
`sym`time`exch`side`price`size`tradecost
q).Q.dd[path;`.d] 0: (get .Q.dd[path;`.d]),`tradecost
'type
  [0]  .Q.dd[path;`.d] 0: (get .Q.dd[path;`.d]),`tradecost
                       ^
q)@[path;`.d;,;`tradecost]
`:/home/jovyan/developer/workspace/__nouser__/training/segs/seg3/2026.10.01/trades
q)get .Q.dd[path;`.d]
`sym`time`exch`side`price`size`tradecost
q)@[path;`.d;_;`tradecost]
'type
  [0]  @[path;`.d;_;`tradecost]
       ^
q).Q.dd[path;`.d]
`:/home/jovyan/developer/workspace/__nouser__/training/segs/seg3/2026.10.01/trades/.d
q).Q.dd[path;`.d] set `sym`time`exch`side`price`size
`:/home/jovyan/developer/workspace/__nouser__/training/segs/seg3/2026.10.01/trades/.d
q)
q)
q)get .Q.dd[path;`.d]
`sym`time`exch`side`price`size
q)addcol:{[dbroot;tab;nc;part] path:.Q.par[dbroot;part;tab]; .Q.dd[path;nc] set (count get .Q.dd[path;`sym])#0n; @[path;`.d;,;nc];}
q)addcol[dbroot;`trades;newcol]each .Q.PV
::
::
q)\l .
q)meta trades
c        | t f a
---------| -----
date     | d    
sym      | s   p
time     | p    
exch     | s    
side     | s    
price    | f    
size     | i    
tradecost| f    
q)delcol:{[dbroot;tab;col;part] path:.Q.par[dbroot;part;tab];@[path;`.d;:;(get .Q.dd[path;`.d])except col]}
q)delcol[dbroot;`trades;`tradecost]each .Q.PV
`:/home/jovyan/developer/workspace/__nouser__/training/segs/seg2/2026.09.30/trades`:/home/jovyan/developer/workspace/__nouser__/training/segs/seg..
q)\l .
q)meta trades
c    | t f a
-----| -----
date | d    
sym  | s   p
time | p    
exch | s    
side | s    
price| f    
size | i    
q)