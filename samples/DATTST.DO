10 REM A test of DATA statements.
20 '
30 DATA String values do not need to be in "double quotes"
40 DATA except for colons: DATA which end a DATA statement
50 DATA and commas, which separate DATA values.
60 DATA ": and , are legal in quoted-values."
70 DATA The double-quote character (") is, only special at the start of a value.
80 DATA It appears to be impossible to include a literal double quote as the first character of a DATA value.
90 DATA Numeric values can be anything that, the BASIC VAL function would accept.
100 DATA "For example, -1e+2 is", "VAL", -1e+2, -999
110 DATA "Omitted values--e.g., 'DATA 1,,3'"
115 DATA --are read as the empty string ("").
119 ' This should result in one blank
120 DATA
130 ' This should result in two blanks
140 DATA ,
150 DATA DATA values can contain keywords
160 DATA SIN PEEK OUT AND RUN ON COM GOSUB 
170 DATA 'Single ticks' and REM are allowed.
180 DATA To write REMarks on the same line : REM this is a remark.
190 DATA end the DATA statement with a colon.: 'Yet another remark.
200 DATA "Newline terminates strings,
210 DATA "no closing double-quote required.
240 DATA  	Space before a value is discarded
250 DATA but kept  within  or after. 	
290 DATA "Multiple strings on one line", "are allowed separated by commas."
295 DATA "Valid characters after a close-quote", "are colon, comma, and whitespace." :
300 ' MAIN
310 ' LOOP
320 PRINT ">";
330 IF NUMERIC THEN READ A ELSE READ A$
340 if A=-999 THEN NUMERIC=0: A=0: GOTO 330
350 if A$="VAL" THEN NUMERIC=1: A$="": GOTO 330
360 IF NUMERIC THEN PRINT A; ELSE PRINT A$;
370 PRINT "<"
380 IF A$="end" THEN END
390 GOTO 310
400 DATA end
