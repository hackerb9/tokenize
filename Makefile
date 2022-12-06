# Where to install.
prefix ?= /usr/local

# By default, create tandy-tokenize binary (implicitly compiled from .lex)
all: tandy-tokenize tandy-decomment

# Automatically run flex to create .c files from .lex.
.SUFFIXES: .lex
.lex.c:
	flex -o $@ $<

# Utility targets
.PHONY: clean run test install

clean:
	rm tandy-tokenize lex.yy.c bacmp output *~ 2>/dev/null || true
	rm tandy-decomment tandy-decomment.c *.o 2>/dev/null || true

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


