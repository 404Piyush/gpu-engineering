/* crash-debug/crash.c
 *
 * Intentionally buggy: this program reads from a pointer we never set,
 * causing a SIGSEGV. We will debug it end-to-end with lldb.
 *
 *   clang -arch x86_64 -O0 -g -o crash crash.c
 *   ./crash                      # -> Segmentation fault (core dumped) on macOS
 *   lldb ./crash                 # interactive debug
 *
 * Symptom: a *deliberate* null deref hidden by a length-mismatch loop.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int sum_positive(const int *arr, int n) {
    int s = 0;
    for (int i = 0; i <= n; i++) {     /* BUG: off-by-one (i <= n) */
        s += arr[i];
    }
    return s;
}

int main(int argc, char **argv) {
    int xs[4] = {1, 2, 3, 4};
    int n = 4;                          /* but if we passed 4 into n=4, */
    int r = sum_positive(xs, n);
    printf("sum = %d\n", r);
    (void)argc; (void)argv;
    return 0;
}
