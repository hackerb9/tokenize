tokenize:	lex.yy.c
	gcc -o tokenize lex.yy.c -lfl

lex.yy.c:	tokenize.lex
	flex tokenize.lex

clean:
	rm tokenize lex.yy.c mycmp output *~ 2>/dev/null || true

run:	tokenize
	./tokenize < samples/M100LE.DO | tee output

mycmp:	mycmp.c

test:	mycmp tokenize
	./tokenize < samples/M100LE.DO > output
	if ./mycmp output samples/M100LE.BA; then echo Success; fi
	./tokenize < samples/TREK.DO > output
	if ./mycmp output samples/TREK.BA; then echo Success; fi
