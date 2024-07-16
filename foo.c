#include <stdio.h>
#ifdef _WIN32
  #include <io.h>
#endif
main() {
  FILE *fp = stdout;
#ifdef _WIN32
  if ( _setmode(fileno(stdout), O_BINARY) == -1 ) {
    perror("_setmode to binary failed");
    exit(1);
  }
#endif
  fprintf(fp, "foo\nbar\n");
  fprintf(fp, "foo\012bar\012");
  if ( fp = freopen(NULL, "wb", stdout) ) {
    fprintf(fp, "foo\nbar\n");
    fprintf(fp, "foo\012bar\012");
  } else perror("stdout");
  if ( fp = freopen("text", "w", fp) ) {
    fprintf(fp, "foo\nbar\n");
    fprintf(fp, "foo\012bar\012");
  } else perror("text");
  if ( fp = freopen("binary", "wb", fp) ) {
    fprintf(fp, "foo\nbar\n");
    fprintf(fp, "foo\012bar\012");
  } else perror("binary");
}
