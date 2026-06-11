/* day-3-4-measure/scaling.c
 *
 * Measures how runtime grows as the working set grows.
 *
 * For each N in {1 MiB, 2 MiB, 4 MiB, ..., 256 MiB}, run a fixed
 * amount of work over an array of size N and report the elapsed time.
 * If the array fits in cache the time is constant; once it overflows
 * each cache level, the time jumps.
 *
 * Two patterns:
 *   1. linear scan  — prefetcher-friendly, looks cheap
 *   2. random scan  — defeats the prefetcher, shows the real DRAM cost
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdint.h>

static int64_t now_ns(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int64_t)ts.tv_sec * 1000000000 + ts.tv_nsec;
}

static double scan_linear(int *a, long n) {
    volatile int sink = 0;
    int64_t t0 = now_ns();
    for (long i = 0; i < n; i++) {
        sink += a[i];
    }
    int64_t t1 = now_ns();
    (void)sink;
    return (t1 - t0) / 1e9;
}

static double scan_random(int *a, long n, long *idx, long iters) {
    volatile int sink = 0;
    int64_t t0 = now_ns();
    for (long i = 0; i < iters; i++) {
        sink += a[idx[i]];
    }
    int64_t t1 = now_ns();
    (void)sink;
    return (t1 - t0) / 1e9;
}

int main(void) {
    printf("=== linear scan (prefetcher-friendly) ===\n");
    printf("%-12s %-12s %-12s %-12s\n", "MiB", "ints", "seconds", "ns/int");
    for (int logMiB = 0; logMiB <= 8; logMiB++) {  /* 1, 2, 4, ..., 256 */
        long mib   = 1L << logMiB;
        long nints = (mib << 20) / sizeof(int);
        int *a = (int *)malloc(nints * sizeof(int));
        if (!a) { fprintf(stderr, "malloc failed for %ld MiB\n", mib); break; }
        memset(a, 0, nints * sizeof(int));

        double best = 1e9;
        for (int rep = 0; rep < 5; rep++) {
            double t = scan_linear(a, nints);
            if (t < best) best = t;
        }
        printf("%-12ld %-12ld %-12.4f %-12.2f\n",
               mib, nints, best, best * 1e9 / nints);
        free(a);
    }

    printf("\n=== random scan (prefetcher-defeating) ===\n");
    printf("%-12s %-12s %-12s %-12s\n", "MiB", "iters", "seconds", "ns/iter");
    for (int logMiB = 0; logMiB <= 8; logMiB++) {
        long mib   = 1L << logMiB;
        long nints = (mib << 20) / sizeof(int);
        int *a = (int *)malloc(nints * sizeof(int));
        if (!a) { fprintf(stderr, "malloc failed for %ld MiB\n", mib); break; }
        memset(a, 0, nints * sizeof(int));

        long iters = nints;
        long *idx = (long *)malloc(iters * sizeof(long));
        srand(42);
        for (long i = 0; i < iters; i++) idx[i] = (long)((double)rand() / RAND_MAX * nints);

        double best = 1e9;
        for (int rep = 0; rep < 3; rep++) {
            double t = scan_random(a, nints, idx, iters);
            if (t < best) best = t;
        }
        printf("%-12ld %-12ld %-12.4f %-12.2f\n",
               mib, iters, best, best * 1e9 / iters);
        free(a);
        free(idx);
    }
    return 0;
}
