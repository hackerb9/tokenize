1 ' Test for m100-jumps.lex which 
2 ' emits all lines which are targets
3 ' of GOTO or similar commands.
4 '
5 ' Line numbers <500 should be printed.                  >= 500 should not.
6 ' 
7 ' When testing m100-decommenter, 
8 ' lines 500--1000 will be removed.
9 '
10 REM ERL Equals
20 REM ERL Less than
30 REM ERL Less than or equal to
40 REM ERL Greater than
50 REM ERL Greater than or equal to
60 REM Equals ERL
70 REM Less than ERL
80 REM Less than or equal to ERL
90 REM Greater than ERL
100 REM Greater than or equal to ERL
110 REM LLIST 110-
120 REM       120-130
130 REM       120-130
140 REM       -140
150 REM ALL CATS ARE GREY
160 REM RUN 160
170 REM GOSUB 170
180 REM ON A GO TO 1,2,3, 180, 4,5,6
190 REM ON COM GOSUB 1,2,3, 190, 7,8,9
200 REM DATA GOTO 530: GOTO 200
500 ' 
510 REM DATA GOTO 510
520 REM DATA "GOTO 520"
530 REM DATA GOTO 530: GOTO 200
1000 '
1010 IF ERL =  10 THEN PRINT "Equals works"
1020 IF ERL <  20 THEN PRINT "Less than works"
1030 IF ERL <= 30 THEN PRINT "Less than or equal works"
1040 IF ERL >  40 THEN PRINT "Greater than works"
1050 IF ERL >= 50 THEN PRINT "Greater than or equal works"
1060 IF ERL =  60 THEN PRINT "Equals works"
1070 IF ERL <  70 THEN PRINT "Less than works"
1080 IF ERL <= 80 THEN PRINT "Less than or equal works"
1090 IF ERL >  90 THEN PRINT "Greater than works"
1100 IF ERL >= 100 THEN PRINT "Greater than or equal works"
1110 LLIST 110 -
1120 LLIST 120 - 130
1130 LLIST -
1140 LLIST - 140
1150 GOTO 150
1160 RUN 160
1170 GOSUB 170
1180 ON A GO TO 1,2,3, 180, 4,5,6
1190 ON COM GOSUB 1,2,3, 190, 7,8,9
1200 DATA GOTO 530: GOTO 200
1500 '
1510 DATA GOTO 510
1520 DATA "GOTO 520"
1530 'See line 1200
