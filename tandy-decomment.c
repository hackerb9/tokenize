/* tandy-decomment.c		Front end for Model 100 BASIC decommenter
 * 
 * This is just the frontend. 
 * For the actual decommenter, see tandy-decomment.lex.
 */

/* Compile with:
 *   flex -o tandy-decomment.yy.c tandy-decomment.lex
 *   gcc tandy-decomment.yy.c tandy-decomment.c -o tandy-decomment
*/

int main(int argv, char *argc[]) {
  /*
   * Usage: ./tandy-decomment  <FOO.DO  >FOO.BA
   */

  while (yylex())
    ;
  return 0;
}


int yywrap() {
  return 1;			/* Always only read one file */
}
