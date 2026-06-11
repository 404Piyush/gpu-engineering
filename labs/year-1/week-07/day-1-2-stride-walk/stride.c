/* day-1-2-stride-walk/stride.c
 *
 * A stride-based array walk that changes locality.
 *
 *   - For each stride S, walk N/S elements, sum them, and time the walk.
 *   - Cache lines are 64 bytes (16 ints on x86_64) so:
 *       S = 1  -> every int touches a new cache line (very poor locality)
 *       S = 4  -> every 4 ints touches a new cache line
 *       S = 16 -> every 16 ints (one cache line) — perfect locality
 *
 * Build:
 *   clang -O2 -o stride stride.c
 */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdint.h>

static int64_t now_ns(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int64_t)ts.tv_sec * 1000000000 + ts.tv_nsec;
}

static double walk(int *a, long n, long stride) {
    volatile int sink = 0;
    int64_t t0 = now_ns();
    for (long i = 0; i < n; i += stride) {
        sink += a[i];
    }
    int64_t t1 = now_ns();
    (void)sink;
    return (t1 - t0) / 1e9;
}

int main(int argc, char **argv) {
    long n = (argc > 1) ? atol(argv[1]) : (16L * 1024 * 1024);  /* 16M ints = 64 MiB */
    long strides[] = {1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024};
    int nstrides = sizeof(strides) / sizeof(strides[0]);

    int *a = (int *)malloc(n * sizeof(int));
    if (!a) { fprintf(stderr, "malloc failed\n"); return 1; }
    for (long i = 0; i < n; i++) a[i] = (int)(i & 0xff);

    printf("n = %ld ints (%ld MiB), %d cache lines touched (64 B each)\n",
           n, (n * sizeof(int)) >> 20, (int)((n * sizeof(int)) / 64));
    printf("%-8s %-12s %-12s\n", "stride", "seconds", "ns/elem");
    for (int s = 0; s < nstrides; s++) {
        long stride = strides[s];
        /* warm the cache for stride-1 once */
        (void)walk(a, n, 1);
        double sec = walk(a, n, stride);
        double ns_per = sec * 1e9 / (n / stride);
        printf("%-8ld %-12.4f %-12.2f\n", stride, sec, ns_per);
    }
    free(a);
    return 0;
}
