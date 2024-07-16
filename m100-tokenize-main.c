/* m100-tokenize-main.c		Front end for Model 100 BASIC tokenizer
 * 
 * This is just the frontend. 
 * For the actual tokenizer, see m100-tokenize.lex.
 */

  /* Usage: m100-tokenize  [ input.ba [ output.ba ] ]

   * Examples:  
   	(a) m100-tokenize  FOO.DO  FOO.BA
   	(b) m100-tokenize  <FOO.DO  >FOO.BA
   	(c) m100-tokenize  FOO.DO | cat > FOO.BA
	
     Note that (a) and (b) are identical, but (c) is slightly different.

     If the output stream cannot be rewound, then the line pointers will 
     not be updated at the end. This does not matter for a genuine 
     Model T computer, but some emulators are known to be persnickety
     and will refuse to load the file.  

   */

/* To be able to write '\n' to stdout as '\n' instead of '\n\r'. */
#ifdef _WIN32
  #include <fcntl.h>
  #include <io.h>
#endif

int main(int argc, char *argv[]) {

  ++argv, --argc; 		/* skip over program name */

  /* First arg (if any) is input file name */
  yyin = (argc>0) ? fopen( argv[0], "r" ) : stdin;
  if (yyin == NULL) { perror(argv[0]); exit(1);  }


  /* Second arg (if any) is output file name */
  ++argv, --argc;
  yyout = (argc>0) ? fopen( argv[0], "wb+" ) : stdout;
  if (yyout == NULL) { perror(argv[0]); exit(1);  }

  /* MS-DOS & Windows prepend a CR before every LF */
#ifdef _WIN32
  if ( _setmode(fileno(stdout), O_BINARY) == -1 ) {
    perror("_setmode to binary failed");
    return(1);
  }
#endif

  while (yylex())
    ;
  return 0;
}


int yywrap() {
  return 1;			/* Always only read one file */
}


int yyput(uint8_t c) {
  /* Like putchar, but send to yyout instead of stdout */
  fputc(c, yyout);
  lastput = c;			/* Save last char for handling EOF */
  return 0;
}

int fixup_ptrs() {
  /* At EOF, rewrite the line pointers in the output file so that each
   * line points to the next. This is not actually necessary.
   */

  /* Offset into RAM for start of the first BASIC program.
     0x8001: Used by Model 100, Tandy 102, Kyocera-85, and Olivetti M10.
     0xA001: Used by Tandy 200 (which has more ROM and less RAM). */
  int offset = 0x8001;

  ptr[nlines++] = ftell(yyout);	/* Pointer to final NULL byte */

  if (fseek(yyout, 0L, SEEK_SET) != 0) {
    perror("fseek");
    fprintf(stderr,
	    "Warning: Could not rewind the output file to fixup pointers.\n"
	    "This will work on genuine hardware but not on some emulators.\n");
    return 1;
  }
  
  for (int n=1; n < nlines; n++) {
    fseek(yyout, ptr[n-1], SEEK_SET);
    yyput( (offset + ptr[n]) & 0xFF);
    yyput( (offset + ptr[n]) >> 8);
  }
    
  return 0;
}
