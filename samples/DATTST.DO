10 REM A test of DATA statements.
20 '
30 DATA String values do not need to be in double quotes (")
40 DATA except for colons : DATA which end a DATA statement
50 DATA and commas, which separate DATA values.
60 DATA ": and , are legal in quoted-values"
70 DATA The double-quote character ("), is only special at the start of a value.
80 DATA It is impossible to include a literal double quote as the first character of a DATA value.
90 DATA Numeric values can be anything  , accepted by the BASIC VAL function.
100 DATA "For example, -1e+2 is", "VAL", -1e+2, -999
110 DATA Omitted values default to the empty string ""
119 ' This should result in one blank
120 DATA
130 ' This should result in two blanks
140 DATA ,
150 DATA 'Single ticks', REMarks, and other BASIC keywords are not special within a DATA statement.
160 DATA For REMarks on the same line, first
170 DATA end the DATA statement with a colon: 'this is a remark
200 DATA "A string is terminated by newline,
210 DATA "no double-quote required.
220 DATA DATA values can contain keywords
230 DATA SIN PEEK OUT AND RUN ON COM GOSUB 
240 DATA  	Space before a value is discarded
250 DATA but kept  within  or after. 	
290 DATA "Multiple double-quoted strings", "are allowed separated by commas."
295 DATA "Valid characters after a close-quote", "are colon, comma, and whitespace." :
300 ' MAIN
310 ' LOOP
320 PRINT ">";
330 IF numeric THEN READ A ELSE READ A$
340 if A=-999 THEN numeric=0: A=0: GOTO 330
350 if A$="VAL" THEN numeric=1: A$="": GOTO 330
360 IF numeric THEN PRINT A; ELSE PRINT A$;
370 PRINT "<"
380 IF A$="end" THEN END
390 GOTO 310
400 DATA end
