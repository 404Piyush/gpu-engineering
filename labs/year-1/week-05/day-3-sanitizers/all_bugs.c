/* day-3-sanitizers/all_bugs.c
 *
 * A kitchen-sink file with one of each: a heap-buffer-overflow,
 * a stack-buffer-overflow, a use-after-free, a leak, and a
 * signed-integer-overflow UBSan bug. Run with `-fsanitize=address,undefined`
 * and watch each tool fire.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void heap_overflow(void) {
    char *p = malloc(8);
    p[8] = 'X';            /* one past the end */
    free(p);
}

static void stack_overflow(void) {
    char buf[8];
    memset(buf, 'A', 16);  /* writes 8 bytes past the end */
    printf("buf[0]=%c\n", buf[0]);
}

static void use_after_free(void) {
    int *p = malloc(sizeof(int));
    *p = 42;
    free(p);
    printf("*p after free = %d\n", *p);   /* dangling read */
}

static int signed_overflow(int x) {
    return x + 1;          /* undefined when x == INT_MAX */
}

int main(int argc, char **argv) {
    (void)argc; (void)argv;
    heap_overflow();
    stack_overflow();
    use_after_free();
    int big = 2147483647;  /* INT_MAX */
    printf("big+1 = %d\n", signed_overflow(big));
    return 0;
}
