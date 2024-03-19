# Use bash syntax for all shell commands
export SHELL := /bin/bash

$(info ${SHELL})
$(info ${PATH})
$(info $(shell which gcc))
$(info $(shell which cc))
CC="cc"

# Where to install.
prefix ?= /usr/local

targets := m100-tokenize m100-decomment m100-jumps m100-crunch
scripts := tokenize m100-sanity

# By default, create m100-tokenize and friends (implicitly compiled from .lex)
all: $(targets) bacmp

# Use 'make debug' to compile with debugging and catch pointer errors.
debug : CFLAGS+=-g -fsanitize=address -Wall -Wno-unused-function
debug : LDLIBS+=-lasan
debug : all

flex := flex
ifeq (${OS},Windows_NT)
	PATH := ${PATH}:"/c/Program Files/Git/usr/bin"
	$(info which ${CC})
	flex := win_flex
endif

# Rule to automatically run flex to create .c files from .lex.
.SUFFIXES: .lex
.lex.c:
	$(flex) -o $@ $<

# Utility targets are "PHONY" so they'll run even if a file exists
# with the same name.
.PHONY: install uninstall clean test check distcheck cfiles artifacts

install: ${targets} bacmp
	cp -p $^ ${prefix}/bin/
	cp -p ${scripts} ${prefix}/bin/

uninstall: 
	for f in ${targets} bacmp ${scripts}; do \
		rm ${prefix}/bin/$$f 2>/dev/null || true; \
	done

clean:
	rm ${targets} \
	   $(addsuffix .c, ${targets}) \
	   bacmp \
	   *.tar.gz \
	   *.o *~ core \
	   input.do output.do output.ba \
						2>/dev/null || true
# Check that the program is building and running correctly
check: all test-m100-tokenize test-m100-decomment test-m100-crunch  test-tokenize-script

# Check that the distribution will actually install, uninstall.
distcheck: all
	@echo Not implemented yet

# Quick test
test: test-tokenize-script

test-tokenize-script:	all
	@echo "Testing tokenize script"
	@for f in samples/*.BA; do \
	    src="$${f%.BA}.DO"; \
	    [ -r "$$src" ] || continue; \
	    ./tokenize "$$src" output.ba >/dev/null; \
	    echo -n "    tokenize $$src: "; \
	    if ./bacmp output.ba "$$f"; then echo "(pass)"; else exit 1; fi \
	done
	@for f in samples/*-d.BA; do \
	    src="$${f%-d.BA}.DO"; \
	    ./tokenize -d "$$src" output.ba >/dev/null; \
	    echo -n "    tokenize -d $$src:"; \
	    if ./bacmp "$$f" output.ba; then echo "(pass)"; else exit 1; fi; \
	done
	@for f in samples/*-c.BA; do \
	    src="$${f%-c.BA}.DO"; \
	    ./tokenize -c "$$src" output.ba >/dev/null; \
	    echo -n "    tokenize -c $$src:"; \
	    if ./bacmp "$$f" output.ba; then echo "(pass)"; else exit 1; fi; \
	    rm output.ba; \
	done

test-m100-tokenize:	m100-tokenize bacmp
	@echo "Testing m100-tokenize"
	@for f in samples/*.BA; do \
	    src="$${f%.BA}.DO"; \
	    [ -r "$$src" ] || continue; \
	    ./m100-sanity "$$src" | ./m100-tokenize >output.ba; \
	    echo -n "    m100-tokenize $$src: "; \
	    if ./bacmp output.ba "$$f"; then echo "(pass)"; else exit 1; fi; \
	    rm output.ba; \
	done

test-m100-decomment:	m100-decomment m100-jumps
	@echo "Testing m100-decomment and m100-jumps"
	@for f in samples/*-decommented.DO; do \
	    src="$${f%-decommented.DO}.DO"; \
	    [ -r "$$src" ] || continue; \
	    ./m100-sanity "$$src" input.do; \
	    jumps=`./m100-jumps input.do`; \
	    ./m100-decomment input.do output.do $$jumps; \
	    echo -n "    m100-decomment $$src - $$jumps:"; \
	    if diff -q "$$f" output.do; then echo "(pass)"; else exit 1; fi; \
	    rm input.do output.do; \
	done

test-m100-crunch: m100-crunch
	@echo "Testing m100-crunch"
	@for f in samples/*-crunched.DO; do \
	    src="$${f%-crunched.DO}.DO"; \
	    [ -r "$$src" ] || continue; \
	    ./m100-crunch "$$src" output.do; \
	    echo -n "    m100-crunch $$src:"; \
	    if diff -q "$$f" output.do; then echo "(pass)"; else exit 1; fi; \
	    rm output.do; \
	done


# Create the intermediate .c files from *.lex.
# Maybe useful for copying to projects without requiring a dependency on flex.
cfiles: $(addsuffix .c, ${targets})


################################################################
# Machine dependent jank

# GNU tar lets us easily store files into a subdirectory in the archive.
# Unfortunately, MacOS is recalcitrant.
UNAME := $(shell uname)
ifeq ($(UNAME), Darwin)
        export PATH := /usr/local/opt/gawk/libexec/gnubin:$(PATH)
        export PATH := /usr/local/opt/gnu-tar/libexec/gnubin:$(PATH)
endif

# thisdir, used to create tar files that unpack into a directory
thisdir := $(notdir $(shell pwd))
xform := --xform "s%^%${thisdir}/%"
# platform, specify the machine os and architecture in the .tar.gz filename
platform := $(shell uname -s)-$(shell uname -m)

artifacts: all cfiles
	tar -C .. -zcf ../tokenize-source.tar.gz \
		--exclude='*reference*' --exclude='.git*' --exclude='*.tar.gz' \
		${thisdir}
	mv ../tokenize-source.tar.gz .
	tar ${xform} -acf tokenize-${platform}.tar.gz \
		${targets} ${scripts} bacmp
	tar ${xform} -acf tokenize-cfiles.tar.gz \
		$(addsuffix .c, ${targets}) \
		m100-tokenize-main.c bacmp.c \
		${scripts}
