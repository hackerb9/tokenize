# Where to install.
prefix ?= /usr/local


#### Kludge for MacOS HomeBrew ####
# MacOS squirrels libfl away somewhere, so we have to hunt for it.
ifndef LIBFL
    # If a pkg-config file exists for libfl, use that to get -L... -lfl
    LIBFL != pkg-config --libs libfl 2>/dev/null 
endif
ifndef LIBFL
    # If a MacOS brew package exists, use that to get -L... -lfl
    LIBFL != brew --prefix libfl 2>/dev/null 
    ifdef LIBFL
	LIBFL := -L${LIBFL}/lib -lfl
    endif
endif
ifdef LIBFL
    # If LIBFL got detected use it.
    LDFLAGS := ${LDFLAGS} ${LIBFL}
else
    # If not detected, it's likely fine, but toss in /usr/local just in case.
    LDFLAGS := ${LDFLAGS} -L${prefix}/lib -lfl
endif
####


tandy-tokenize: tandy-tokenize.c lex.yy.c

lex.yy.c: tandy-tokenize.lex
	flex tandy-tokenize.lex

clean:
	rm tandy-tokenize lex.yy.c bacmp output *~ 2>/dev/null || true

run:	tandy-tokenize
	./tandy-tokenize < samples/M100LE.DO | tee output | hd

bacmp:	bacmp.c lex.yy.c

test:	bacmp tandy-tokenize lex.yy.c
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
