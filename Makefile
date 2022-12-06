# Where to install.
prefix ?= /usr/local

# By default, create tandy-tokenize binary. 
all: lex.yy.c tandy-tokenize 

# When the .lex file change, recreate lex.yy.c. 
lex.yy.c: tandy-tokenize.lex
	flex tandy-tokenize.lex


# Compile tandy-decomment.lex
tandy-decomment: 	tandy-decomment.yy.c

tandy-decomment.yy.c: tandy-decomment.lex
	flex  -o tandy-decomment.yy.c  tandy-decomment.lex


# Utility targets
clean:
	rm tandy-tokenize lex.yy.c bacmp output *~ 2>/dev/null || true
	rm tandy-decomment tandy-decomment.yy.c *~ 2>/dev/null || true

run:	tandy-tokenize
	./tandy-tokenize < samples/M100LE.DO | tee output | hd

test:	lex.yy.c tandy-tokenize bacmp
	./tandy-tokenize < samples/M100LE+comments.DO > output
	@if ./bacmp output samples/M100LE+comments.BA; then echo Success; fi
	./tandy-tokenize < samples/TREK.DO > output
	@if ./bacmp output samples/TREK.BA; then echo Success; fi
	./tandy-tokenize < samples/LEGACY.DO > output
	@if ./bacmp output samples/LEGACY.BA; then echo Success; fi
	./tandy-tokenize < samples/olivetti/M100LE.DO > output
	@if ./bacmp output samples/olivetti/M100LE.BA.M10; then echo Success;fi
	./tandy-tokenize < samples/NOQUOT.DO > output
	@if ./bacmp output samples/NOQUOT.BA; then echo Success; fi
	./tandy-tokenize < samples/QUOQUO.DO > output
	@if ./bacmp output samples/QUOQUO.BA; then echo Success; fi

install: tandy-tokenize
	cp -p tandy-tokenize ${prefix}/bin/
	cp -p tokenize ${prefix}/bin/
