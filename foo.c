#include <stdio.h>
main() {
  FILE *fp;
  if ( fp = fopen("newline", "w") ) {
    fprintf(fp, "foo\nbar\n");
    fprintf(fp, "foo\012bar\012");
    fprintf(fp, "foo\033\012bar\012");
  }
}
