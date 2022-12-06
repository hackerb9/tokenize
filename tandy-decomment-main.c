/* tandy-decomment.c		Front end for Model 100 BASIC decommenter
 * 
 * This is just the frontend. 
 * For the actual decommenter, see tandy-decomment.lex.
 */

/* Compile with:
 *   flex -o tandy-decomment.yy.c tandy-decomment.lex
 *   gcc tandy-decomment.yy.c tandy-decomment-main.c -o tandy-decomment
*/


/* Note: using "%option prefix=decomment" in tandy-decomment.lex  */
int decommentlex(void);
void decommenterror (const char *);


int main(int argv, char *argc[]) {
  /*
   * Usage: ./tandy-decomment  <FOO.DO  >FOO.BA
   */

  while (decommentlex())
    ;
  return 0;
}


int decommentwrap() {
  return 1;			/* Always only read one file */
}
