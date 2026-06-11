/* weekend-bug-zoo/02_uaf_read.c
 * Bug: read from freed memory.
 * Tool: ASan.
 */
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *p = malloc(sizeof(int));
    *p = 42;
    free(p);
    printf("*p after free = %d\n", *p);
    return 0;
}
