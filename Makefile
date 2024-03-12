# Where to install.
prefix ?= /usr/local

# By default, create m100-tokenize binary (implicitly compiled from .lex)
all: m100-tokenize m100-decomment bacmp m100-jumps m100-crunch

m100-tokenize.o: m100-tokenize-main.c

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

install: m100-tokenize m100-decomment m100-jumps m100-crunch
	cp -p $^ ${prefix}/bin/
	cp -p tokenize ${prefix}/bin/

clean:
	rm m100-tokenize m100-tokenize.c bacmp output *~ \
	   m100-decomment m100-decomment.c *.o \
	   rm m100-crunch m100-crunch.c \
	   rm m100-jumps m100-jumps.c *.o \
	   rm core \
					2>/dev/null || true

run:	m100-tokenize
	./m100-tokenize samples/M100LE.DO output.ba && hd output.ba | less

test:	m100-tokenize bacmp
	@for f in samples/*.BA; do \
	    ./m100-sanity "$${f%.BA}.DO" | ./m100-tokenize >output.ba; \
	    echo -n "$$f: "; \
	    if ./bacmp output.ba "$$f"; then echo "(pass)"; fi; \
	done
	@rm output.ba

test-decomment:	m100-tokenize m100-decomment m100-jumps bacmp
	@for f in samples-decomment/*.BA; do \
	    jumps=$(./m100-sanity "$${f%.BA}.DO" | \
		./m100-jumps) \
	    ./m100-sanity "$${f%.BA}.DO" | \
	        ./m100-decomment /dev/stdin /dev/stdout $jumps | \
	        ./m100-tokenize >output.ba; \
	    echo -n "$$f: "; \
	    if ./bacmp output.ba "$$f"; then echo "(pass)"; fi; \
	done
	@rm output.ba
