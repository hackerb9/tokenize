0 REM A test for Tandy BASIC decommenters.
5 REM Do they properly keep/remove lines?
10 ' This line is referenced elsewhere and must NOT be removed.
15 ' This  line is never referenced and can be removed
20 PRINT "Cut, but not too much."	: REM trailing remark
30 :' What happens to a trailing remark that doesn't follow anything?
35  	: 	: REM Colons and whitespace test. This line should be removed
40 GO TO 10 ' A trailing comment after a tick.
50 '' Two tick marks suggest maybe this comment should not be discarded. (optional)
60 REM Does the decommenter ignore GO TO 60 in a remark?: GOTO 60
65 REM Line 70 has a GOTO in a string that should be ignored.
70 PRINT "Testing strings GOTO 65. This string is terminated by a newline
75 REM This line should be removed despite the previous string not having a second " mark.
80 ' PRINT "Strings within comments are not special: GOTO 80": GOTO 80
85 REM This line is removed by a decommenter. If not, blame line 90.
90 PRINT "REM Comments within strings must be preserved: GOTO 85"
100 PRINT "Make sure 'single ticks' and REMarks are not special within double-quotes." 
200 PRINT "This is the first 'line 200'. The next line 200 replaces this one."
200 REM This is the real line 200, but neither should be kept by a decommenter.
222 PRINT "The next line 222 replaces this one.": GOTO 222
222 REM A decommenter should keep neither line 222, despite the GOTO.
