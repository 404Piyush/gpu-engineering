/* weekend-bug-zoo/01_oob_write.c
 * Bug: write one past the end of a heap buffer.
 * Tool that catches it: ASan.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    char *p = malloc(8);
    strcpy(p, "ABCDEFGH");  /* 8 chars + NUL = 9 bytes, one over */
    free(p);
    return 0;
}
