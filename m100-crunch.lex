
/* m100-crunch.lex		TRS-80 Model 100 BASIC cruncher 
 *
 * Saves a few bytes by removing whitespace and other extraneous
 * characters but makes programs harder to read. See m100-decommenter
 * for potentially much greater savings by removing all comments. 
 *			
 * Compile with:   flex m100-crunch.lex && gcc lex.crunch.c
 * 		
 * Note: Crunching is not always a good idea as the confusion it
 * causes may not be worth the few bytes saved. For example,
 * 	    100 Z$="          "
 * 	becomes
 * 	    100 Z$="          
 * which runs exactly the same, but isn't understandable at sight.
 */

 /* Change "yy" prefix to "crunch" for file names */
%option warn
%option prefix="crunch"

 /* Define states that simply copy text instead of lexing */  
%x string
%x remark

LINENUM		[0-9]+

%%

\"			ECHO; BEGIN(string);
<string>\"		ECHO; BEGIN(INITIAL);
(REM|['])		ECHO; BEGIN(remark); 
<*>\n			ECHO; BEGIN(INITIAL); /* Newline ends REM or string */
<remark>.*		;		      /* Remove the content of remarks */

    /* Omit close quote on strings at end of line */
<string>\"[ \t]*[\r\n]	fputc(yytext[yyleng-1], yyout) ; BEGIN(INITIAL);

    /* Elide whitespace between tokens (not in strings or remarks). */
[ \t]*			    ;		      

    /* Delete trailing colons */
[: \t]+$		    ;		      

    /* Replace 100 ' with 100 REM as it tokenizes to 1 instead of 2 bytes */
^[ \t]*[0-9]+[ \t:]*['][^\r\n]*  fprintf(yyout, "%d REM", atoi(yytext));

    /* Replace :ELSE with ELSE */
[ \t:]*:[ \t:]*ELSE		fprintf(yyout, "ELSE");

    /* Replace 100 :REM with 100 REM */
^[ \t]*[0-9]+[ \t:]*REM[^\r\n]*  fprintf(yyout, "%d REM", atoi(yytext));

    /* Remove redundant colon in  :'. */
[ \t:]:[']			fprintf(yyout, "'"); 	

    /* Squeeze strings of colons into a single colon. */
[ \t:]*:[ \t:]*:		fprintf(yyout, ":");

    /* MAYBE Delete leading colons.  XXX this could remove a jump target!   */
  /*^[0-9]+[: \t]+		fprintf(yyout, "%d ", atoi(yytext));*/


   /* Ensure line numbers have a single space after them. */
   /* Doesn't matter for tokenization, but standardizes the output */
^[ \t]*[0-9]+[ \t:]		fprintf(yyout, "%d ", atoi(yytext));

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
