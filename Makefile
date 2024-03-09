# Where to install.
prefix ?= /usr/local

# By default, create tandy-tokenize binary (implicitly compiled from .lex)
all: tandy-tokenize tandy-decomment bacmp tandy-jumps tandy-crunch

tandy-tokenize.o: tandy-tokenize-main.c

# Use 'make debug' to compile with debugging and catch pointer errors.
debug : CFLAGS+=-g -fsanitize=address
debug : LDLIBS+=-lasan
debug : all

# Automatically run flex to create .c files from .lex.
.SUFFIXES: .lex
.lex.c:
	flex -o $@ $<

# Utility targets are "PHONY" so they'll run even if a file exists
# with the same name.
.PHONY: clean run test install

install: tandy-tokenize tandy-decomment tandy-jumps tandy-crunch
	cp -p $^ ${prefix}/bin/
	cp -p tokenize ${prefix}/bin/

clean:
	rm tandy-tokenize tandy-tokenize.c bacmp output *~ \
	   tandy-decomment tandy-decomment.c *.o \
	   rm tandy-crunch tandy-crunch.c \
	   rm tandy-jumps tandy-jumps.c *.o \
	   rm core \
					2>/dev/null || true

run:	tandy-tokenize
	./tandy-tokenize samples/M100LE.DO output.ba && hd output.ba | less

test:	tandy-tokenize bacmp
	@for f in samples/*.BA; do \
	    ./tandy-sanity "$${f%.BA}.DO" | ./tandy-tokenize >output.ba; \
	    echo -n "$$f: "; \
	    if ./bacmp output.ba "$$f"; then echo "(pass)"; fi; \
	done
	@rm output.ba

test-decomment:	tandy-tokenize tandy-decomment tandy-jumps bacmp
	@for f in samples-decomment/*.BA; do \
	    jumps=$(./tandy-sanity "$${f%.BA}.DO" | \
		./tandy-jumps) \
	    ./tandy-sanity "$${f%.BA}.DO" | \
	        ./tandy-decomment /dev/stdin /dev/stdout $jumps | \
	        ./tandy-tokenize >output.ba; \
	    echo -n "$$f: "; \
	    if ./bacmp output.ba "$$f"; then echo "(pass)"; fi; \
	done
	@rm output.ba
