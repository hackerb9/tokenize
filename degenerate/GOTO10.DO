1 I=-1
10 I=I+1: IF I MOD 1000 THEN 10 ELSE I=0
10 PRINT: PRINT
10 PRINT "This is line ten. "; 
10 PRINT "This is also line ten."
5  PRINT "Line five runs after line ten."
10 PRINT "Where would 7 GOTO 10 go?"
7 GOTO 10
8 ERROR "Line 8 is skipped by GOTO 10."
10 PRINT: PRINT "    It goes to the *next* line ten!"
10 FOR T=0 TO 1000: NEXT T
10 PRINT
10 PRINT "However, it searches from the top when"
10 PRINT " A) 10 GOTO 10, or"
10 PRINT " B) a line number > 10 is seen."
10 FOR T=0 TO 1000: NEXT T
10 PRINT
10 PRINT "This is peculiar because it means"
10 PRINT "10 GOTO 10 may be needlessly slower."
10 FOR T=0 TO 1000: NEXT T
10 PRINT
10 PRINT "Maybe it's a bug in Tandy BASIC?"
10 PRINT "Perhaps it checks for (line >= 10)"
10 PRINT "before it checks for (line == 10)?"
10 FOR T=0 TO 1000: NEXT T
10 PRINT
10 PRINT "BTW, >= is one less 8085 op than >."
10 PRINT "  >= is CMP then check CY==0, but"
10 PRINT "  >  also requires checking Z==0."
10 FOR T=0 TO 1000: NEXT T
10 PRINT
10 PRINT "The next line is 9 GOTO 10. This time"
10 PRINT "it goes to the FIRST line ten, because"
10 PRINT "line 20 comes before the next line ten.";
9 GOTO 10
20 ERROR "Line 20 is never reached, but it has an effect because 20>10."
10 ERROR "This is the final line ten. The previous GOTO 10 won't find it because line 20 comes first."
10 '
0 PRINT "This program examines how Model T com-"
1 PRINT "puters run degenerate tokenized BASIC."
2 PRINT
3 PRINT "Loading it as a .DO file will not work."
4 PRINT "Tandy BASIC corrects issues such as"
5 PRINT "out of order or duplicate line numbers."
6 PRINT
7 PRINT "Please create GOTO10.BA:"
8 PRINT "   m100-tokenize GOTO10.DO >GOTO10.BA"
9 PRINT  
10 PRINT "Or use the pre-tokenized GOTO10.BA at:"
15 PRINT "  github.com/hackerb9/tokenize/"
20 PRINT "    raw/main/degenerate/GOTO10.BA"
