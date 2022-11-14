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
	./tandy-tokenize < samples/olivetti/M100LE.DO > output
	if ./bacmp output samples/olivetti/M100LE.BA.M10; then echo Success; fi
	./tandy-tokenize < samples/NOQUOT.DO > output
	if ./bacmp output samples/NOQUOT.BA; then echo Success; fi
	./tandy-tokenize < samples/QUOQUO.DO > output
	if ./bacmp output samples/QUOQUO.BA; then echo Success; fi

install: tandy-tokenize
	cp -p tandy-tokenize /usr/local/bin/
	cp -p tokenize /usr/local/bin/
