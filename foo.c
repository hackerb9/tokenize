#include <stdio.h>
main() {
  FILE *fp;
  fp = stdout;
  fprintf(fp, "foo\nbar\n");
  fprintf(fp, "foo\012bar\012");
  if ( fp = freopen(NULL, "wb", stdout) ) {
    printf("foo\nbar\n");
    printf("foo\012bar\012");
  }
  if ( fp = freopen("text", "w", fp) ) {
    fprintf(fp, "foo\nbar\n");
    fprintf(fp, "foo\012bar\012");
  }
  if ( fp = freopen("binary", "wb", fp) ) {
    fprintf(fp, "foo\nbar\n");
    fprintf(fp, "foo\012bar\012");
  }
}
