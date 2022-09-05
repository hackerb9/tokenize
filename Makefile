tandy-tokenize:	lex.yy.c
	gcc -o tandy-tokenize lex.yy.c -lfl

lex.yy.c:	tandy-tokenize.lex
	flex tandy-tokenize.lex

clean:
	rm tandy-tokenize lex.yy.c bacmp output *~ 2>/dev/null || true

run:	tandy-tokenize
	./tandy-tokenize < samples/M100LE.DO | tee output

bacmp:	bacmp.c

test:	bacmp tandy-tokenize
	./tandy-tokenize < samples/M100LE.DO > output
	if ./bacmp output samples/M100LE.BA; then echo Success; fi
	./tandy-tokenize < samples/TREK.DO > output
	if ./bacmp output samples/TREK.BA; then echo Success; fi
	./tandy-tokenize < samples/LEGACY.DO > output
	if ./bacmp output samples/LEGACY.BA; then echo Success; fi
