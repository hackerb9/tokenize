/* Create a Model 100 .BA file that has every possible token, one per line.  */
#include <stdio.h>

void main() {
  unsigned int b;
  for (b=128; b<256; b++) {
    putchar(42); putchar(42);	/* PL PH pointer to next line of program */
    putchar(b); putchar(0);	/* LL LH BASIC line number, little-endian  */
    putchar(b);			/* B₀, A BASIC keyword tokenized by the value in b */
    putchar(0);			/* A NULL marking the end of the BASIC line */
  }
}
