/* day-2-bugs/use_after_free.c
 *
 * Frees p, then reads/writes through it. The heap may have
 * re-used the slot for something else, so the read is undefined
 * and the write corrupts another allocation.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    char *p = malloc(16);
    strcpy(p, "first allocation");
    free(p);

    /* BUG: p is now dangling. The malloc below *might* re-use p. */
    char *q = malloc(16);
    strcpy(q, "second allocation");

    printf("p = %p\n", (void *)p);
    printf("q = %p\n", (void *)q);
    printf("p says: %s\n", p);   /* use-after-free READ  */
    p[0] = 'X';                  /* use-after-free WRITE */
    return 0;
}
