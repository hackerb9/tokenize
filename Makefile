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

install: tandy-tokenize tandy-decomment
	cp -p tandy-tokenize ${prefix}/bin/
	cp -p tandy-decomment ${prefix}/bin/
	cp -p tokenize ${prefix}/bin/

clean:
	rm tandy-tokenize lex.tokenize.c bacmp output *~ 2>/dev/null || true
	rm tandy-decomment tandy-decomment.c *.o 2>/dev/null || true

run:	tandy-tokenize
	./tandy-tokenize samples/M100LE.DO output.ba && hd output.ba | less

test:	tandy-tokenize bacmp
	@for f in samples/*.BA; do \
	    ./tandy-tokenize "$${f%.BA}.DO" output.ba; \
	    echo -n "$$f: "; \
	    if ./bacmp output.ba "$$f"; then echo "(pass)"; fi; \
	done
	@rm output.ba

test-decomment:	tandy-decomment bacmp
	@for f in samples-decomment/*.BA; do \
	    ./tandy-decomment "$${f%.BA}.DO" output.ba; \
	    echo -n "$$f: "; \
	    if ./bacmp output.ba "$$f"; then echo "(pass)"; fi; \
	done
	@rm output.ba
