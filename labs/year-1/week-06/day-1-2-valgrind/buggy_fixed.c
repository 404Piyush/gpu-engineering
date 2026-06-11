/* day-1-2-valgrind/buggy_fixed.c
 *
 * Same five bugs as buggy.c, with the fixes applied.
 * Built with `-fsanitize=address,undefined`, this binary is silent.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void bug_leak_fixed(void) {
    int *p = malloc(16 * sizeof(int));
    if (!p) return;
    p[0] = 1;
    free(p);
}

static void bug_double_free_fixed(void) {
    int *p = malloc(sizeof(int));
    if (!p) return;
    free(p);
    p = NULL;
    free(p);            /* free(NULL) is a no-op */
}

static void bug_use_after_free_fixed(void) {
    int *p = malloc(sizeof(int));
    if (!p) return;
    *p = 7;
    free(p);
    p = NULL;
    if (p) printf("*p = %d\n", *p);    /* guarded */
}

static void bug_heap_overflow_fixed(void) {
    char *p = malloc(9);
    if (!p) return;
    p[8] = 'X';
    free(p);
}

static void bug_uninit_read_fixed(void) {
    int x = 0;
    if (x > 100) printf("x was big\n");
    else         printf("x was small or negative\n");
}

int main(void) {
    bug_leak_fixed();
    bug_double_free_fixed();
    bug_use_after_free_fixed();
    bug_heap_overflow_fixed();
    bug_uninit_read_fixed();
    puts("all fixes ran cleanly");
    return 0;
}
