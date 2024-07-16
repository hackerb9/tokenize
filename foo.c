#include <stdio.h>
#ifdef _WIN32
  #include <fcntl.h>
  #include <io.h>
#endif
int main() {
  FILE *fp = stdout;
#ifdef _WIN32
  if ( _setmode(fileno(stdout), O_BINARY) == -1 ) {
    perror("_setmode to binary failed");
    return(1);
  }
#endif
  printf("foo\nbar\n");
  return 0;
}
