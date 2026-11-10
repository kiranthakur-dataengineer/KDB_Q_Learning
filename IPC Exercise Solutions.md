# IPC Exercise Solutions

Before we start the Quiz, let's launch a remote q process that we will start with the `quizScript.q`
q file found in IPC.Scripts: 
```q
EX_SCRIPT:getenv[`AX_WORKSPACE],"/IPC.Scripts/quizScript.q";
system["nohup q ",EX_SCRIPT," -p 5060 >/dev/null 2>&1 &"];
```

The following questions require a connection to this process. The current process can be considered 
to be a "client" connection, and the remote process can be considered to be the "server" process. 

An identifier variable `ID` has been set on both processes to help with understanding where we're 
working. 

```q
ID
```

1. Connect to this newly started process, and store the connection handle in a variable called `h`.
Using this handle retrieve the `ID` variable of the remote process.

```q
//your code here 
```
```q
//ans:
h: hopen 5060
h`ID
```

2. A trade table schema (with columns time, sym, price, size and side) has been defined in our remote
process. Insert a single row from the client, sending the message synchronously from this process 
as a string.

```q
h "meta trade"
//your code here 
```
```q
//ans: 
h "`trade insert (.z.p;`KX;200f;1900;`B)"  
```

3. Insert multiple rows from the client using non-string message syntax. Do this synchronously.

```q
//your code here 
```
```q
//ans:
multiple:100#'(.z.p;`KX;200f;1900;`B)
h (insert;`trade;multiple)
```

4. Repeat question 3 but do it asynchronously
```q
//your code here 
```
```q
//ans: 
neg[h] (insert;`trade;multiple)
```

5. Calculate the time to execute each command 3. and 4. above 10,000 times
```q
//your code here 
```

```q
//ans: 
\t:10000 h (insert;`trade;multiple)
```

```q
//ans:
\t:10000 neg[h] (insert;`trade;multiple)
```

6. A function `pick` has been created on the server to pick an exchange at random from the 
following list \`nyse\`ftse\`cme\`iseq. Use IPC to retrieve this function definition and 
define this on the client process. (Do not explicitly define the function from scratch!)


```q
//your code here 
```
```q
//ans:
pick: h`pick
pick: h (get;`pick) //alternatively using get
```

7. Synchronously send the following string “1+`a". What happens?

```q
//your code here 
```
```q
//ans: 
h "1+`a"        //triggers a type error
```

8. Repeat the previous question, but do it asynchronously. What happens?

```q
//your code here 
```
```q
//ans:
neg[h] "1+`a"   //no error raised - we sent asynchronously so didn't wait for the response
```

9. Select the number of trades per symbol in the trade table.

```q
//your code here 
```
```q
//Client 
h "select count i by sym from trade"
```

10. Return the active connections from the remote process. Where do you think these remote handles 
connect to? 
```q
//your code here 
```
```q
//ans:
h ".z.W"  //this is the handle on the remote connection back to our process! (we're the only one that's
          //connected to this remote process)
```

11. Using the Developer IDE, attach to the remote process. 

13. Using the remote scratchpad, return the value of `ID. 
```q
//run your code in remote scratchpad
```
```q
//ans: (remote) 
ID
```

13. Using the handle in question 10. return the value of ID from that connected process. What does 
this tell us? 
```q
//run your code in remote scratchpad
```
```q
//ans: (remote) 
handleBack: first key .z.W
handleBack `ID //this will return the value of client - this tell us that connections are two way 
           // "If you gaze long enough into an abyss, the abyss will gaze back into you.” - Nietzsche
```

14. Using the remote scratchpad (i.e on our remote process), send and define the `trade` table on the 
original client process. 
```q
//run your code in remote scratchpad
```
```q
//ans: (remote) 
handleBack (set;`trade;trade)
```

```q
//Check whether the table has been created
`trade in tables[]
```


