/* jumps.lex
 *
 * given a M100 BASIC file, output all the line numbers that consist
 * of only a comment (for example, "10 REM FOO") and are referenced by
 * any part of the program (for example, "20 GOTO 10").
 *
 * All comments can be removed from a program _except_ those lines.

 * Compile with:   flex jumps.lex && gcc yy.lex.c 
 *
 * Side note: Technically, "jumps" is misnamed. Although the vast
 * majority of references will be via GOTO and GOSUB, it is possible
 * to refer to a line number using RESTORE, ERL, LIST, and EDIT.

 * For best results, sanitize the source code first using sanity.awk
 * which prevents an obscure and highly improbable condition where the
 * BASIC program source code might have two lines with the same line
 * number like so:
			
    222 PRINT "The next line 222 replaces this one.": GOTO 222
    222 REM A decommenter should keep neither line 222, despite the GOTO.

 */

%option warn

%x string
%x remark

LINENUM		[0-9]+
LINELIST	([ \t,]*{LINENUM})+
LINERANGE	{LINENUM}?[ \t]*-[ \t]*{LINENUM}?

    #include <string.h>
    #include <ctype.h>
    int parse_linenumber(char *);
    int parse_linelist(char *);
    int parse_linerange(char *);
    int parse_erl(char *);
    int insert(int set[], int n);
    void print_set(int set[]);
    void print_intersection(int seta[], int setb[]);

    /* An array to insert line numbers as a sorted & unique set. */
    /* First entry, jumps[0], is length of array. */
    int jumps[65537] = {0,};

    /* A set to store lines which contain only a REM statement */
    int remarks[65537] = {0, };

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

%%

  /* A line which starts with REM or ' should be noted */
^{LINENUM}[ \t:]*([']|REM) {
    insert(remarks, atoi(yytext));
}

  /* Skip over remarks and strings  */
(REM|\')	BEGIN(remark);
\"		BEGIN(string);
<string>\"      BEGIN(INITIAL);

   /* Newline ends <string> and <remark> conditions. */
<*>\r?\n	BEGIN(INITIAL);


  /* GOTO & GOSUB take a line number list:
     Need to handle commas, eg
       ON var GOTO 10, 20, 30.
     Q: Can list be empty? E.g., ON KEY GOSUB ,,,, ? 
  */

(GO[ \t]*TO|GOSUB)([ \t,]*[0-9]+)+		{ parse_linelist(yytext); }

RESTORE[ \t]*{LINENUM}		parse_linenumber(yytext);
RESUME[ \t]*{LINENUM}		parse_linenumber(yytext);
RUN[ \t]*{LINENUM}		parse_linenumber(yytext);
 
THEN[ \t]*{LINENUM}		parse_linenumber(yytext);
ELSE[ \t]*{LINENUM}		parse_linenumber(yytext);

  /* LIST and EDIT take a line number range:
    Must handle dash. The numbers do not need to refer to actual lines.
	    LIST -300
	    EDIT 99-201
	    LLIST 9000-
  */
LIST[ \t]*{LINERANGE}		parse_linerange(yytext);
LLIST[ \t]*{LINERANGE}		parse_linerange(yytext);
EDIT[ \t]*{LINERANGE}		parse_linerange(yytext);

  /* ERL is a variable used to compare against a line number */
ERL[ \t]*[<=>]+[ \t]*{LINENUM}	parse_erl(yytext);
{LINENUM}[ \t]*[<=>]+[ \t]*ERL	parse_erl(yytext);

   /* Delete all else */
<*>.|\r|\n		;

%%

    int parse_linenumber(char *p) {       /* Example input: "RESTORE 1000" */
	while (*p && !isdigit(*p))       /* Skip over BASIC keyword */
	    p++;

	if (p && *p) {
	    int n = atoi(p);
	    insert(jumps, n);
	}
    }

    int parse_linelist(char *linelist) {
	/* Skip over "GO TO" or "GOSUB" */
	while (*linelist && !isdigit(*linelist))
	    linelist++;

	char *p = strtok(linelist, " \t,");
	while (p && *p) {
	    int n = atoi(p);
	    insert(jumps, n);
	    p = strtok(NULL, " \t,");
	}
    }

    int parse_linerange(char *linerange) {

	ECHO;
	/*xxx*/

    }

    int parse_erl(char *comparison) {

	ECHO;
	/*xxx*/

    }


    void print_set(int set[]) {
        for (int j=1; j<=set[0]; j++) {
	    printf("%6d\n", set[j]);
	}
    }

    void print_intersection(int a[], int b[]) {
	int alen=a[0], blen=b[0];
	int i=1, j=1;
	while( (i <= alen) && (j <= blen) ) {
	    if ( a[i] == b[j] ) {
		printf("%d\n", a[i]);
		i++; j++;
	    }
	    else if ( a[i] > b[j] ) { j++; }
	    else { i++; }
	}
    }


int main(int argc, char *argv[]) {

  ++argv, --argc; 		/* skip over program name */

  /* -j flags shows all jumps, not just purely commented out lines */
  int printalljumps = 0;
  if (argc>0 && argv[0][0]=='-' && argv[0][1]=='j') {
      printalljumps = 1;
      ++argv, --argc;
  }

  /* First arg (if any) is input file name */
  yyin = (argc>0) ? fopen( argv[0], "r" ) : stdin;
  if (yyin == NULL) { perror(argv[0]); exit(1);  }

  /* Second arg (if any) is output file name */
  ++argv, --argc;
  yyout = (argc>0) ? fopen( argv[0], "w+" ) : stdout;
  if (yyout == NULL) { perror(argv[0]); exit(1);  }
 
  while (yylex())
    ;

  if (printalljumps)
      print_set(jumps);				/* -j flag */
  else
      print_intersection(jumps, remarks); 	/* Default */

  return 0;
}


int yywrap() {
  return 1;			/* Always only read one file */
}

