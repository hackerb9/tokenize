/* Like cmp, but match any '*' bytes in the first file as wildcards */
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  if (argc<=2) {
    fprintf(stderr, "Usage: mycmp <file1> <file2>\n");
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
