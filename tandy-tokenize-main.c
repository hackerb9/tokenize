/* tandy-tokenize-main.c		Front end for Model 100 BASIC tokenizer
 * 
 * This is just the frontend. 
 * For the actual tokenizer, see tandy-tokenize.lex.
 */

int main(int argc, char *argv[]) {
  /*
   * Usage: ./tandy-tokenize  FOO.DO  FOO.BA
   * See also the "tokenize" shell script wrapper.
   */

  ++argv, --argc; 		/* skip over program name */

  /* First arg (if any) is input file name */
  yyin = (argc>0) ? fopen( argv[0], "r" ) : stdin;
  if (yyin == NULL) { perror(argv[0]); exit(1);  }


  /* Second arg (if any) is output file name */
  ++argv, --argc;
  yyout = (argc>0) ? fopen( argv[0], "w+" ) : stdout;
  if (yyout == NULL) { perror(argv[0]); exit(1);  }
  
  while (tokenizelex())
    ;
  return 0;
}


int tokenizewrap() {
  return 1;			/* Always only read one file */
}


int yyput(uint8_t c) {
  /* Like putchar, but send to yyout instead of stdout */
  fputc(c, yyout);
  lastput = c;			/* Save last char for handling EOF */
  return 0;
}

int fixup_ptrs() {
  /* Rewrite the line pointers in the output file so that each line
     points to the next. */
  int offset = 0xA001;		/* Offset into memory for start of program */

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
