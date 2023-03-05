0 ' Model T BASIC allows lines to
1 ' specified out of order and even
2 ' redundantly with later lines
3 ' overriding previous ones.
4 '
5 ' The Model T will sort the lines 
6 ' and delete redundancies before 
7 ' tokenizing. Hackerb9's tokenizer
8 ' may not (yet) do that.
20 GOTO 10
10 GOTO 10
10 PRINT "!dlroW ,olleH"
