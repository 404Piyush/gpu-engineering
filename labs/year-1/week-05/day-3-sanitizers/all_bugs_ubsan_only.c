/* day-3-sanitizers/all_bugs_ubsan_only.c
 *
 * Same kinds of bugs as all_bugs.c, but ONLY the ones that UBSan can
 * catch (no heap/stack-buffer-overflow, no UAF — those are ASan's job).
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int signed_overflow(int x) {
    return x + 1;          /* undefined when x == INT_MAX */
}

static int shift_too_far(int x) {
    return x << 32;         /* undefined: shift by >= width */
}

static int null_deref(int *p) {
    return *p;              /* null deref — UBSan */
}

static int div_by_zero(int x) {
    return x / 0;           /* undefined: division by zero */
}

int main(int argc, char **argv) {
    (void)argc; (void)argv;
    int big = 2147483647;  /* INT_MAX */
    printf("big+1 = %d\n", signed_overflow(big));
    printf("shift = %d\n", shift_too_far(1));
    int *nullp = NULL;
    printf("null  = %d\n", null_deref(nullp));
    printf("div0  = %d\n", div_by_zero(5));
    return 0;
}
