# Where to install.
prefix ?= /usr/local

# By default, create tandy-tokenize binary (implicitly compiled from .lex)
all: tandy-tokenize tandy-decomment bacmp

tandy-tokenize.o: tandy-tokenize-main.c

# Automatically run flex to create .c files from .lex.
.SUFFIXES: .lex
.lex.c:
	flex -o $@ $<

# Utility targets are "PHONY" so they'll run even if a file exists
# with the same name.
.PHONY: clean run test install

install: tandy-tokenize
	cp -p tandy-tokenize ${prefix}/bin/
	cp -p tokenize ${prefix}/bin/

clean:
	rm tandy-tokenize lex.tokenize.c bacmp output *~ 2>/dev/null || true
	rm tandy-decomment tandy-decomment.c *.o 2>/dev/null || true

run:	tandy-tokenize
	./tandy-tokenize samples/M100LE.DO output.ba && hd output.ba | less

test:	tandy-tokenize bacmp
	./tandy-tokenize samples/M100LE+comments.DO output.ba
	@if ./bacmp output.ba samples/M100LE+comments.BA; then echo Success; fi
	./tandy-tokenize samples/TREK.DO output.ba
	@if ./bacmp output.ba samples/TREK.BA; then echo Success; fi
	./tandy-tokenize samples/LEGACY.DO output.ba
	@if ./bacmp output.ba samples/LEGACY.BA; then echo Success; fi
	./tandy-tokenize samples/NOQUOT.DO output.ba
	@if ./bacmp output.ba samples/NOQUOT.BA; then echo Success; fi
	./tandy-tokenize samples/QUOQUO.DO output.ba
	@if ./bacmp output.ba samples/QUOQUO.BA; then echo Success; fi
	./tandy-tokenize samples/TSWEEP.DO output.ba
	@if ./bacmp output.ba samples/TSWEEP.BA; then echo Success; fi

