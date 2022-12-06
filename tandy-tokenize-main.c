/* tandy-tokenize-main.c		Front end for Model 100 BASIC tokenizer
 * 
 * This is just the frontend. 
 * For the actual tokenizer, see tandy-tokenize.lex.
 */

int main(int argv, char *argc[]) {
  /*
   * Usage: ./tandy-tokenize  <FOO.DO  >FOO.BA
   * See also the "tokenize" shell script wrapper.
   */

  while (tokenizelex())
    ;
  return 0;
}


int tokenizewrap() {
  return 1;			/* Always only read one file */
}
