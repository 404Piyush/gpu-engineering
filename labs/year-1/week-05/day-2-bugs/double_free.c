/* day-2-bugs/double_free.c
 *
 * Frees the same pointer twice. The second free corrupts the
 * allocator's free-list. The classic symptom: SIGABRT from
 * malloc's internal check, or silent corruption in subsequent
 * malloc/free.
 */
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *p = malloc(8 * sizeof(int));
    if (!p) return 1;

    printf("p = %p\n", (void *)p);
    free(p);
    free(p);   /* BUG: double free */
    return 0;
}
