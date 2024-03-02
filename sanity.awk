#!/bin/bash

# Sanitize a BASIC listing so that all lines are in order and no line
# numbers are duplicated.
awk '
/^[ \t]*[0-9]/ {
    n = int($0);
    lines[n] = $0;
}

END {
    asorti(lines, d);
    for (i in d) {
	print lines[d[i]];
    }
}
'  < ${1:-/dev/stdin} > ${2:-/dev/stdout}
