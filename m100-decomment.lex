/* m100-decomment.lex		TRS-80 Model 100 BASIC decommenter 
 *
 * Removes comments (REM, ') from Model 100 BASIC.
 * Uses output from jumps.lex to decide which commented out lines to keep.
 *			
 * Compile with:   flex m100-decomment.lex && gcc lex.decomment.c
 */

 /* Change "yy" prefix to "decomment" for file names */
%option warn
%option prefix="decomment"

    #include <string.h>
    #include <ctype.h>
    int insert(int set[], int n);
    void print_set(int set[]);
    void print_intersection(int seta[], int setb[]);

    int insert(int set[], int n) {
	set[0]++;
	int len=set[0], i=1;
	for (i=1; i<len; i++) {
	    if (set[i] > n) break;
	    if (set[i] == n) { set[0]--; return 0; }
	}
	memmove(set+i+1, set+i, (len-i)*sizeof(set[0]));
	set[i] = n;
    }

 /* Define states that simply copy text instead of lexing */  
%x string

    /* Set of line numbers that should be kept despite only containing a REM statement */
    /* jumps[0] is length of set. */
    int jumps[65537] = {0,};

%%

     /* A line which starts with REM or ' should be removed unless it is in the JUMPS list */
^[ \t:]*[0-9]+[ \t:]*([']|REM)[^\r\n]*[\r\n]+ {
    int n = atoi(yytext);
    int i = 1, len = jumps[0];
    for (i=1; i<=len; i++) {
        if (jumps[i] == n) {
            ECHO;
            break;
        }
    }
}

\"		ECHO; BEGIN(string);
<string>\"	ECHO; BEGIN(INITIAL);

    /* Newline also matches <string> start condition. */
<*>\r?\n		ECHO; BEGIN(INITIAL);

[ \t:]*([']|REM)[^\r\n]*	; 	/* Delete REM and tick comments at end of line. */

%%

int main(int argc, char *argv[]) {

    char *inputfile, *outputfile;
    yyin = stdin; yyout = stdout;

    /* First arg (if any) is input file name */
    if ( (argc>1) && strcmp(argv[1], "-")) {
	inputfile=argv[1];
	yyin = fopen( inputfile, "r" );
	if (yyin == NULL) { perror(inputfile); exit(1);  }
    }

    /* Second arg (if any) is output file name */
    if ( (argc>2) && strcmp(argv[2], "-")) {
	outputfile=argv[2];
	yyout = fopen( outputfile, "w+" );
	if (yyout == NULL) { perror(outputfile); exit(1);  }
    }

    /* Remaining args are line numbers to keep (from m100-jumps.lex) */
    for (int i=3; argc>i; i++) {
	insert(jumps, atoi(argv[i]));
    }

    while (yylex())
	;
    return 0;
}


int yywrap() {
  return 1;			/* Always only read one file */
}
