#include <stdio.h>
main() {
  FILE *fp;
  fp = stdout;
  if ( fp = fopen("text", "w") ) {
    fprintf(fp, "foo\nbar\n");
    fprintf(fp, "foo\012bar\012");
  }
  if ( fp = freopen("binary", "wb", fp) ) {
    fprintf(fp, "foo\nbar\n");
    fprintf(fp, "foo\012bar\012");
  }
  if ( fp = freopen("binaryplus", "wb+", fp) ) {
    fprintf(fp, "foo\nbar\n");
    fprintf(fp, "foo\012bar\012");
  }
}
