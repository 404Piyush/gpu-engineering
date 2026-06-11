/* day-1-2-valgrind/buggy.c
 *
 * A single file with five classic bugs to exercise the
 * memory-debugging tools (ASan / macOS leaks).
 *
 *   1. leak            — allocate, drop the pointer
 *   2. double-free     — free twice
 *   3. use-after-free  — read after free
 *   4. heap-of        — read past end of allocation
 *   5. uninit-read     — read uninitialised stack memory
 *
 * Build:
 *   clang -arch x86_64 -O0 -g -o buggy buggy.c
 *   ./buggy
 *
 * Or with ASan:
 *   clang -arch x86_64 -O0 -g -fsanitize=address -o buggy_asan buggy.c
 *   ./buggy_asan
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void bug_leak(void) {
    int *p = malloc(16 * sizeof(int));
    p[0] = 1;
    (void)p;
    /* never free(p) */
}

static void bug_double_free(void) {
    int *p = malloc(sizeof(int));
    free(p);
    free(p);
}

static void bug_use_after_free(void) {
    int *p = malloc(sizeof(int));
    *p = 7;
    free(p);
    printf("*p (after free) = %d\n", *p);
}

static void bug_heap_overflow(void) {
    char *p = malloc(8);
    p[8] = 'X';           /* one past the end */
    free(p);
}

static void bug_uninit_read(void) {
    int x;                /* uninitialised */
    if (x > 100) {
        printf("x was big\n");
    } else {
        printf("x was small or negative\n");
    }
}

int main(void) {
    bug_leak();
    bug_double_free();    /* will abort the program on ASan */
    bug_use_after_free(); /* ditto */
    bug_heap_overflow();
    bug_uninit_read();
    return 0;
}
