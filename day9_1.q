jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training$ mkdir seghdb
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training$ mkdir segs
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training$ cd segs
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/segs$ mkdir seg1
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/segs$ mkdir seg2
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/segs$ mkdir seg3
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/segs$ mkdir seg4
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/segs$ ll
total 24
drwxr-sr-x 6 jovyan users 4096 Oct  1 05:12 .
drwxrwsr-x 9 jovyan users 4096 Oct  1 05:12 ..
drwxr-sr-x 2 jovyan users 4096 Oct  1 05:12 seg1
drwxr-sr-x 2 jovyan users 4096 Oct  1 05:12 seg2
drwxr-sr-x 2 jovyan users 4096 Oct  1 05:12 seg3
drwxr-sr-x 2 jovyan users 4096 Oct  1 05:12 seg4
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/segs$ cd ..
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training$ cd seghdb/
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/seghdb$ ll
total 8
drwxr-sr-x 2 jovyan users 4096 Oct  1 05:12 .
drwxrwsr-x 9 jovyan users 4096 Oct  1 05:12 ..
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/seghdb$ pwd
/home/jovyan/developer/workspace/__nouser__/training/seghdb
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/seghdb$ cat > par.txt
/home/jovyan/developer/workspace/__nouser__/training/segs/seg1 
/home/jovyan/developer/workspace/__nouser__/training/segs/seg2
/home/jovyan/developer/workspace/__nouser__/training/segs/seg3
/home/jovyan/developer/workspace/__nouser__/training/segs/seg4
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/seghdb$ ll
total 12
drwxr-sr-x 2 jovyan users 4096 Oct  1 05:13 .
drwxrwsr-x 9 jovyan users 4096 Oct  1 05:12 ..
-rw-r--r-- 1 jovyan users  252 Oct  1 05:14 par.txt
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/seghdb$ ll
total 16
drwxr-sr-x 2 jovyan users 4096 Oct  1 05:15 .
drwxrwsr-x 9 jovyan users 4096 Oct  1 05:12 ..
-rw-r--r-- 1 jovyan users  252 Oct  1 05:14 par.txt
-rw-r--r-- 1 jovyan users   54 Oct  1 05:15 sym
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/seghdb$ cd ..
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training$ ll segs/seg3/
total 12
drwxr-sr-x 3 jovyan users 4096 Oct  1 05:15 .
drwxr-sr-x 6 jovyan users 4096 Oct  1 05:12 ..
drwxr-sr-x 3 jovyan users 4096 Oct  1 05:15 2026.10.01
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training$ ll segs/seg3/2026.10.01/
total 12
drwxr-sr-x 3 jovyan users 4096 Oct  1 05:15 .
drwxr-sr-x 3 jovyan users 4096 Oct  1 05:15 ..
drwxr-sr-x 2 jovyan users 4096 Oct  1 05:15 trades
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training$ ll segs/seg3/2026.10.01/trades/
total 4336
drwxr-sr-x 2 jovyan users   4096 Oct  1 05:15 .
drwxr-sr-x 3 jovyan users   4096 Oct  1 05:15 ..
-rw-r--r-- 1 jovyan users     38 Oct  1 05:15 .d
-rw-r--r-- 1 jovyan users 804096 Oct  1 05:15 exch
-rw-r--r-- 1 jovyan users 800016 Oct  1 05:15 price
-rw-r--r-- 1 jovyan users 804096 Oct  1 05:15 side
-rw-r--r-- 1 jovyan users 400016 Oct  1 05:15 size
-rw-r--r-- 1 jovyan users 804400 Oct  1 05:15 sym
-rw-r--r-- 1 jovyan users 800016 Oct  1 05:15 time
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training$ cd seghdb/
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/seghdb$ q .
KDB-X 5.0 2026.05.01 Copyright (C) 1993-2026 Kx Systems
l64/ 8()core 64307MB jovyan jupyter-kdbguru-40gmail-2ecom 10.33.243.192 EXPIRE 2027.01.19    localkod 00000000-0000-0000-0000-000000000000

q).Q.PV
2026.09.30 2026.10.01
q)\\
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/seghdb$ cd ..
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training$ cd segs
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/segs$ ll
total 24
drwxr-sr-x 6 jovyan users 4096 Oct  1 05:12 .
drwxrwsr-x 9 jovyan users 4096 Oct  1 05:12 ..
drwxr-sr-x 2 jovyan users 4096 Oct  1 05:12 seg1
drwxr-sr-x 3 jovyan users 4096 Oct  1 05:24 seg2
drwxr-sr-x 3 jovyan users 4096 Oct  1 05:15 seg3
drwxr-sr-x 2 jovyan users 4096 Oct  1 05:12 seg4
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/segs$ ll seg2/
total 12
drwxr-sr-x 3 jovyan users 4096 Oct  1 05:24 .
drwxr-sr-x 6 jovyan users 4096 Oct  1 05:12 ..
drwxr-sr-x 3 jovyan users 4096 Oct  1 05:24 2026.09.30
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/segs$ 
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/segs$ 
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/segs$ 
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/segs$ ll seg2/2026.09.30/
total 12
drwxr-sr-x 3 jovyan users 4096 Oct  1 05:24 .
drwxr-sr-x 3 jovyan users 4096 Oct  1 05:24 ..
drwxr-sr-x 2 jovyan users 4096 Oct  1 06:04 trades
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/segs$ ll seg2/2026.09.30/trades/
total 5120
drwxr-sr-x 2 jovyan users   4096 Oct  1 06:04 .
drwxr-sr-x 3 jovyan users   4096 Oct  1 05:24 ..
-rw-r--r-- 1 jovyan users     38 Oct  1 05:24 .d
-rw-r--r-- 1 jovyan users 804096 Oct  1 05:24 exch
-rw-r--r-- 1 jovyan users 800016 Oct  1 05:24 price
-rw-r--r-- 1 jovyan users 804096 Oct  1 05:24 side
-rw-r--r-- 1 jovyan users 400016 Oct  1 05:24 size
-rw-r--r-- 1 jovyan users 804400 Oct  1 05:24 sym
-rw-r--r-- 1 jovyan users 800016 Oct  1 05:24 time
-rw-r--r-- 1 jovyan users 800016 Oct  1 06:04 tradecost
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/segs$ cd ..
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training$ cd seghdb/
jovyan@jupyter-kdbguru-40gmail-2ecom:~/developer/workspace/__nouser__/training/seghdb$ q .
KDB-X 5.0 2026.05.01 Copyright (C) 1993-2026 Kx Systems
l64/ 8()core 64307MB jovyan jupyter-kdbguru-40gmail-2ecom 10.33.243.192 EXPIRE 2027.01.19    localkod 00000000-0000-0000-0000-000000000000

q)\a
,`trades
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
q)trades
date       sym  time                          exch side price    size
---------------------------------------------------------------------
2026.09.30 AAPL 2026.09.30D09:00:01.545183733 N    B    90.71555 6032
2026.09.30 AAPL 2026.09.30D09:00:02.227799221 Q    B    8.770055 7494
2026.09.30 AAPL 2026.09.30D09:00:05.099952220 N    B    12.09083 9442
2026.09.30 AAPL 2026.09.30D09:00:06.590982154 N    S    83.21645 7670
2026.09.30 AAPL 2026.09.30D09:00:06.987836770 O    S    53.06392 5075
2026.09.30 AAPL 2026.09.30D09:00:08.983727172 Q    B    17.04701 1318
2026.09.30 AAPL 2026.09.30D09:00:09.805725328 Q    B    62.30201 380 
2026.09.30 AAPL 2026.09.30D09:00:09.906242787 Q    B    60.03675 9175
2026.09.30 AAPL 2026.09.30D09:00:11.576169356 L    B    4.413415 9760
2026.09.30 AAPL 2026.09.30D09:00:13.828299567 O    S    26.82611 3171
2026.09.30 AAPL 2026.09.30D09:00:15.996925905 N    B    59.46924 4742
2026.09.30 AAPL 2026.09.30D09:00:19.725582003 Q    B    25.82062 2047
2026.09.30 AAPL 2026.09.30D09:00:20.504339598 N    B    56.0386  6009
2026.09.30 AAPL 2026.09.30D09:00:22.183202952 N    B    23.49705 3599
2026.09.30 AAPL 2026.09.30D09:00:24.192832969 N    B    38.83952 7899
2026.09.30 AAPL 2026.09.30D09:00:28.134342469 N    S    11.10019 6738
2026.09.30 AAPL 2026.09.30D09:00:28.466808982 L    B    30.6943  3930
2026.09.30 AAPL 2026.09.30D09:00:28.619413264 O    S    18.11149 7764
2026.09.30 AAPL 2026.09.30D09:00:28.919155150 Q    B    29.44273 6055
2026.09.30 AAPL 2026.09.30D09:00:29.804766923 Q    B    3.582367 3177
2026.09.30 AAPL 2026.09.30D09:00:30.651116184 L    B    24.29956 3676
2026.09.30 AAPL 2026.09.30D09:00:31.645543500 O    B    27.11528 267 
..
q)\pwd
"/home/jovyan/developer/workspace/__nouser__/training/seghdb"
q).Q.par[`:.;.z.d-1;`trades]
`:/home/jovyan/developer/workspace/__nouser__/training/segs/seg2/2026.09.30/trades
q).Q.dd[.Q.par[`:.;.z.d-1;`trades];`.d]
`:/home/jovyan/developer/workspace/__nouser__/training/segs/seg2/2026.09.30/trades/.d
q)get .Q.dd[.Q.par[`:.;.z.d-1;`trades];`.d]
`sym`time`exch`side`price`size
q)key .Q.par[`:.;.z.d-1;`trades]
`s#`.d`exch`price`side`size`sym`time`tradecost
q)key .Q.par[`:.;.z.d-2;`trades]
q).Q.PV
2026.09.30 2026.10.01
q)key .Q.par[`:.;.z.d;`trades]
`s#`.d`exch`price`side`size`sym`time`tradecost