/* weekend-bug-zoo/03_double_free.c
 * Bug: free the same pointer twice.
 * Tool: ASan (or Apple's libc, which aborts on this).
 */
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *p = malloc(sizeof(int));
    *p = 7;
    free(p);
    free(p);
    return 0;
}
