/* tandy-decomment.lex		TRS-80 Model 100 BASIC decommenter 
 *
 * Removes comments (REM, ') from Model 100 BASIC.
 * Uses output from jumps.lex to decide which commented out lines to keep.
 *			
 * Compile with:   flex tandy-decomment.lex && gcc lex.decomment.c
 */

 /* Change "yy" prefix to "decomment" for file names */
%option warn
%option prefix="decomment"

 /* Define states that simply copy text instead of lexing */  
%x string

    /* Set of line numbers that should be kept despite only containing a REM statement */
    /* jumps[0] is length of set. */
    int jumps[65537] = {0,};

 /* XXXXXX Should load jumps[] from jumps.lex XXXXXXX */

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

  ++argv, --argc; 		/* skip over program name */

  /* First arg (if any) is input file name */
  yyin = (argc>0) ? fopen( argv[0], "r" ) : stdin;
  if (yyin == NULL) { perror(argv[0]); exit(1);  }

  /* Second arg (if any) is output file name */
  ++argv, --argc;
  yyout = (argc>0) ? fopen( argv[0], "w+" ) : stdout;
  if (yyout == NULL) { perror(argv[0]); exit(1);  }
  
  while (yylex())
    ;
  return 0;
}


int yywrap() {
  return 1;			/* Always only read one file */
}
