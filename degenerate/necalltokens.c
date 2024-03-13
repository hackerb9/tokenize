/* Create a NEC .BA file that has every possible token, one per line.  */
/* The first N82 BASIC program on the machine starts at byte 32769.  */

/* The tokens for N82 BASIC are more similar to other Microsoft BASICs
   in that they allow extended codes by using 0xFF as a prefix.
   In fact, many of the token values are identical to GW-BASIC.
*/

#include <stdio.h>
#include <stdint.h>

void main() {
  unsigned int b;
  uint16_t address=128*256+1; 
  for (b=128; b<255; b++) {
    address+=8;
    putchar(address%256); putchar(address>>8);	/* PL PH pointer to next line of program */
    putchar(b); putchar(0);	/* LL LH BASIC line number, little-endian  */
    putchar(b);			/* B₀, A BASIC keyword tokenized by the value in b */

    putchar('\t');
    printf("%02X", b);

    putchar(0);			/* A NULL marking the end of the BASIC line */
  }
  for (b=128; b<256; b++) {
    address+=11;
    putchar(address%256); putchar(address>>8);	/* PL PH pointer to next line of program */
    uint16_t temp=10000+b;
    putchar(temp%256); putchar(temp/256);	/* LL LH BASIC line number, little-endian  */
    putchar(0xFF);		/* Extended token */
    putchar(b);			/* B₀, A BASIC keyword tokenized by the value in b */

    putchar('\t');
    printf("FF %02X", b);

    putchar(0);			/* A NULL marking the end of the BASIC line */
  }
  putchar(0);
}
