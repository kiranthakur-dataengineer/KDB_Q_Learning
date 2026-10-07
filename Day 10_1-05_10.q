/Historical Database
/DB Maintenance
/IPC - Inter Process Communication
/Synchronous & Asynchronous Communication
h:hopen`:localhost:5000:username:password
h"select from trades" /sync
(neg h)"trades:delete exch from trades"
\p 15000
\pwd
\cd hdb
\ls
\l .
.Q.PV
value "3+5"
d:2026.09.29
value "select from trades where date=",string d
func:{[s;d;st;et] "select from trades where date=",(string d),",sym=",(string s),",time.time within ",(string st)," ",string et}
meta trades
within (st;et)
func:{[s;d;st;et] select from trades where date=d,sym=s,time.time within(st;et)}
func:{[s;d] select from trades where date=d,sym=s,time.time within 09:00 09:01}
func:{[s;d] select from trades where date=d,sym=s}
func[`IBM;2026.09.29;09:00;09:01]
func[`IBM;2026.09.29]
delete func from `.
func

select from trades where date=2026.09.29, sym=`IBM, time.time within 09:00 09:01
value "select from trades where date=2026.09.29,sym=IBM,time.time within 09:00 09:01"
/Functional form of select & update staements
?[t;c;b;a] /t is tablename
           /c is list of constraints
           /b is group by
           /a is aggregation
/select from trades where sym=`IBM
?[trades;enlist(=;`sym;enlist`IBM);0b;()]
/select from trades where date=2026.09.30, sym in `IBM`AAPL
?[trades;((=;`date;2026.09.30);(in;`sym;enlist`IBM`AAPL));0b;()]
/select stock:sym, venue:exch, buysell:side, px:price, sz:size from trades where date=2026.09.30, sym in `IBM`AAPL
?[trades;((=;`date;2026.09.30);(in;`sym;enlist`IBM`AAPL));0b;`stock`venue`buysell`px`sz!`sym`exch`side`price`size]
/select cost:sum size*price by sym from trades
select cost:sum size*price by sym from trades
?[trades;();enlist[`sym]!enlist`sym;enlist[`cost]!enlist(sum;(*;`size;`price))]
parse"select cost:sum size*price by sym from trades"
?[trades;();enlist[`sym]!enlist`sym;enlist[`cost]!enlist(sum;(*;`size;`price))]
/Functional update
/delete from trades where sym=`IBM

memtrades:select from trades
parse"delete from trades where sym=`IBM"
![memtrades;((=;`date;2026.09.30);(=;`sym;enlist`IBM));0b;`symbol$()]
/delete exch, side from memtrades
![memtrades;();0b;`exch`side]
/IPC callback functions
/.z.po - called after the connection is opened successfully
.z.po:{show "User ",(string .z.u)," has connected successfully at time: ",string .z.P}
user:`ram`shyam`mohan`geeta`sita!("ram";"shyam";"mohan";"geeta";"sita")
.z.pw:{[u;p] 
    $[not u in key user;
        [show "user ",(string u)," not authenticated!";:0b];p like user[u];
        [show "user ",(string u)," is authenticated!";:1b];
        [show "user ",(string u)," not authenticated due to wrong username/password!";:0b]]}

/Synch & Asynch queries
.z.pg:{show "The user: ",(string .z.u)," has sent the synch query: ",x;value x}
.z.ps:{show "The user: ",(string .z.u)," has sent the asynch query: ",x;value x}
/.z.w - remote user handle
.z.pc /called on closing a port
.z.pc:{show "user ",(string .z.u)," has closed the connection on the handle: ",string x}
sessions:([sessionid:`guid$()] usernme:`symbol$();logintime:`timestamp$();query:();)