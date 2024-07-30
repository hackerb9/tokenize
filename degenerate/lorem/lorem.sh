#!/bin/bash -eu
# Generate BASIC programs as long as necessary. 

# Given a number of bytes, generate a M100 BASIC program that uses up
# exactly that many bytes when tokenized.

# Note maximum line length is 256 characters, but that includes four
# bytes for the line number and pointer to the next line plus a fifth
# byte for the NULL at the end. So, actual number of bytes allowed: 251.

# Peculiar note on tokenizing BASIC from serial port or via EDIT: When
# character 252 is a digit, then tokenization proceeds as if there had
# been a newline and the digit is the start of the next line number!
 
main() {
    if [[ $1 ]]; then targetsize=$(parse_iec "$*"); fi

    # Avoid problem where the last line has less than the minimum # bytes.
    if (( (targetsize % $MAX) > 0 &&
	  (targetsize % $MAX) <= 5 &&
	   targetsize > 5 )); then
	print_next_line 6
	targetsize=$((targetsize - 6))
    fi

    while (( targetsize > 0 )); do
	if (( targetsize < $MAX )); then
	    print_next_line $targetsize
	    targetsize=0
	else
	    print_next_line $MAX
	    targetsize=$((targetsize - $MAX))
	fi
    done
}

parse_iec() {
    # Allow 16384, 16k, 16K, 16KiB, 1 Kbyte, 0.25 Kibibytes, and so on
    local maybeiec=$1
    local suffix
    local rv
    maybeiec=${maybeiec^^}	# uppercase
    maybeiec=${maybeiec// /}	# no spaces
    for suffix in BYTES BYTE B IBI ILO EGA EBI I; do 	# discard suffices
	maybeiec=${maybeiec%$suffix}
    done

    echo $maybeiec | numfmt --from=iec
    return
}

    
print_next_line() {
    local -i incr=${1:-$MAX}

    if (( incr <= 5 )); then
	echo "Error: cannot create a line that uses five or fewer bytes.">&2
	exit 1
    fi

    incr=$((incr - 5))		# 2 line num + 2 ptr + 1 null == 5
    incr=$((incr - 4))		# ?""; == 4
    if (( incr >= 0 )); then
	printf "$linenum ?"
	printf '"'
	printf "${lorem: pos: incr}"
	printf '";\n'
	pos=$(( pos + incr ))
	if (( pos > loremsize )); then
	    pos=$((pos - loremsize))
	fi
    else 
	incr=$((incr + 4))	# Don't use ?"";
	printf "$linenum "
	colons=":::::"
	printf "${colons: 0: incr}\n"
    fi
    linenum=$((linenum + 10))
}

## Initialization

lorem="Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? "

lorem+="At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat. "

loremsize=${#lorem}
lorem+="$lorem"

declare -g -i targetsize=16*1024
declare -g -i linenum=10
declare -g -i pos=0
declare -g -i MAX=256


main "$@"

