/* day-2-bugs/leak.c
 *
 * Allocates 16 bytes, never frees, then exits. Valgrind / ASan
 * will catch this; without a tool, the OS reclaims it on exit.
 */
#include <stdlib.h>

void make_a_leak(void) {
    int *p = malloc(16 * sizeof(int));
    p[0] = 1;
    /* never free(p) */
}

int main(void) {
    make_a_leak();
    make_a_leak();
    make_a_leak();
    return 0;
}
