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

  int ca=0, cb=0, count=0;

  /* Get difference between the offsets */
  int fa1=fgetc(fa), fa2=fgetc(fa);
  unsigned int offset_a = fa1 + (fa2<<8);
  int fb1=fgetc(fb), fb2=fgetc(fb);
  unsigned int offset_b = fb1 + (fb2<<8);
  int delta = offset_b - offset_a; 

  fprintf(stderr, "ptr from file a: %d (%x %x)\n", offset_a, fa1, fa2);
  fprintf(stderr, "ptr from file b: %d (%x %x)\n", offset_b, fb1, fb2);
  fprintf(stderr, "difference b - a: %d (%x)\n", delta, delta);
  count+=2;

  while (ca != EOF && cb != EOF) {
    count++;
    ca = fgetc(fa);
    cb = fgetc(fb);
    if (ca == '*') continue;
    if (ca == cb) continue;
    fprintf(stderr, "Files differ at byte %d:  0x%02X versus 0x%02X\n", count, ca, cb);
    exit(1);
  }
  /* Files are identical */
  exit(0);
}
