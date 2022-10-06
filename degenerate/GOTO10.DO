1 I=-1
10 I=I+1: IF I MOD 1000 THEN 10 ELSE I=0
10 PRINT: PRINT
10 PRINT "This is line ten."
10 PRINT "This is also line ten."
5  PRINT "Line five runs after line ten."
10 PRINT "Where would GOTO 10 go?"
15 PRINT "  (The following line is 7 GOTO 10)"
7 GOTO 10
8 ERROR "Line 8 is skipped by GOTO 10."
10 PRINT: PRINT "It goes to the *next* line ten!"
10 FOR T=0 TO 1000: NEXT T
10 PRINT "Exceptions: Goes to *first* line ten"
10 PRINT "  if the current line is ten, or"
10 PRINT "  if a line number > 10 is seen."
10
10 'Shouldn't 10 GOTO 10 go to itself?
10 'It shouldn't have to search at all.
10 'Maybe it's a bug in Tandy BASIC?
10 'Perhaps it checks for (line >= 10)
10 'before it checks for (line == 10)?
10
10 'BTW, >= is one less op than >.
10 'On 8085, >= is CMP then check CY==0.
10 'But > also requires checking Z==0.
10
10 PRINT
10 PRINT "The next line is 9 GOTO 10. This time"
10 PRINT "it goes to the FIRST line ten, because"
10 PRINT "line 20 comes before the next line ten."
9 GOTO 10
20 ERROR "Line 20 is never reached, but it has an effect because 20>10."
10 ERROR "This is the final line ten. The previous GOTO 10 won't find it because line 20 comes first."
10
15
20 
0 PRINT "This program examines how"
1 PRINT "Model T computers run"
2 PRINT "degenerate tokenized BASIC."
3 PRINT "Trying to load it as a .DO"
4 PRINT "file will not work as"
5 PRINT "Tandy BASIC corrects issues"
6 PRINT "such as duplicate line numbers"
7 PRINT "and out of order lines."
8 PRINT "Please use hackerb9's"
9 PRINT "pre-tokenized GOTO10.BA."
