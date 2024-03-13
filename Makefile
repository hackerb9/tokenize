# Where to install.
prefix ?= /usr/local

targets := m100-tokenize m100-decomment m100-jumps m100-crunch bacmp
scripts := tokenize m100-sanity

# By default, create m100-tokenize and friends (implicitly compiled from .lex)
all: $(targets)

# Use 'make debug' to compile with debugging and catch pointer errors.
debug : CFLAGS+=-g -fsanitize=address
debug : LDLIBS+=-lasan
debug : all

# Rule to automatically run flex to create .c files from .lex.
.SUFFIXES: .lex
.lex.c:
	flex -o $@ $<

# Utility targets are "PHONY" so they'll run even if a file exists
# with the same name.
.PHONY: install uninstall clean test check distcheck

install: ${targets}
	cp -p $^ ${prefix}/bin/
	cp -p ${scripts} ${prefix}/bin/

uninstall: 
	for f in ${targets} ${scripts}; do \
		rm ${prefix}/bin/$$f 2>/dev/null || true; \
	done

clean:
	rm m100-tokenize m100-tokenize.c bacmp output *~ \
	   m100-decomment m100-decomment.c *.o \
	   rm m100-crunch m100-crunch.c \
	   rm m100-jumps m100-jumps.c *.o \
	   rm core \
					2>/dev/null || true

test:	m100-tokenize bacmp
	@echo "Testing m100-tokenize"
	@for f in samples/*.BA; do \
	    ./m100-sanity "$${f%.BA}.DO" | ./m100-tokenize >output.ba; \
	    echo -n "    $$f: "; \
	    if ./bacmp output.ba "$$f"; then echo "(pass)"; fi \
	done
	@rm output.ba

test-decomment:	m100-decomment m100-jumps
	@echo "Testing m100-decomment and m100-jumps"
	@for f in samples/*-decommented.DO; do \
	    src="$${f%-decommented.DO}.DO"; \
	    ./m100-sanity "$$src" input.do; \
	    jumps=`./m100-jumps input.do`; \
	    ./m100-decomment input.do output.do $$jumps; \
	    echo -n "    $$f: $$jumps:"; \
	    if diff -q "$$f" output.do; then echo "(pass)"; else exit 1; fi; \
	done
	@rm input.do output.do

# Check that the program is building and running correctly
check: all test test-decomment

# Check that the distribution will actually install, uninstall.
distcheck: all
	@echo Not implemented yet


