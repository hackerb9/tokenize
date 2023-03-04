/* Like cmp, but for .BA files.

   In particular, the two bytes at the beginning of each line (the
   line pointers) are matched, vis-a-vis their base offset.

 */

#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  if (argc<=2) {
    fprintf(stderr, "Usage: bacmp <file1> <file2>\n");
    fprintf(stderr, "\n"
	    "Compares two Tandy BASIC files in tokenized format\n"
	    "but allows for variation of files depending upon\n"
	    "where in memory the file is intended to load.\n"
	    "\n");
    exit(1);
  }

  FILE *fa, *fb;
  if ( (fa = fopen(argv[1], "r")) == NULL)
    fprintf(stderr, "Could not open file: <%s>\n", argv[1]);
  if ( (fb = fopen(argv[2], "r")) == NULL)
    fprintf(stderr, "Could not open file: <%s>\n", argv[2]);
  if (fa == NULL || fb == NULL) {
    exit(1);
  }

  int count=0;			   /* Bytes read so far */
  int ca1, ca2, cb1, cb2;	   /* 2 bytes from file A and 2 from B */
  unsigned int offset_a, offset_b; /* Those bytes seen as little endian 16bit */
  int delta;			   /* Difference between offset_a and b */

  /* Get delta, difference between the offsets at start of each file */
  count+=2;
  ca1=fgetc(fa), ca2=fgetc(fa);
  offset_a = ca1 + (ca2<<8);
  cb1=fgetc(fb), cb2=fgetc(fb);
  offset_b = cb1 + (cb2<<8);
  delta = offset_b - offset_a; 

  //  fprintf(stderr, "ptr from file a: %d (%x %x)\n", offset_a, ca1, ca2);
  //  fprintf(stderr, "ptr from file b: %d (%x %x)\n", offset_b, cb1, cb2);
  //  fprintf(stderr, "difference b - a: %d (%x)\n", delta, delta);

  while (ca1 != EOF && cb1 != EOF) {
    count++;
    ca1 = fgetc(fa);
    cb1 = fgetc(fb);
    if (ca1 == cb1) continue;

    /* Bytes don't match, but maybe it is a lineptr? */
    count++;
    ca2 = fgetc(fa);
    cb2 = fgetc(fb);
    offset_a = ca1 + (ca2<<8);
    offset_b = cb1 + (cb2<<8);
    if (offset_a + delta == offset_b) continue;
 
    fprintf(stderr, "Files differ at byte %d:  0x%02X versus 0x%02X\n", count-1, ca1, cb1);
    exit(1);
  }

  /* Files are identical */
  exit(0);
}
