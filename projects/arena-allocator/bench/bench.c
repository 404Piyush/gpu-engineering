/* allocator/bench/bench.c
 *
 * Microbenchmark: mymalloc/mymalloc-free vs system malloc/free
 * on a controlled workload. Reports per-op time and total time.
 *
 *   make bench
 */
#include "myalloc.h"
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

enum { OPS = 200000, N = 1024 };

static double bench_mine(int sz) {
    void *ps[N];
    memset(ps, 0, sizeof(ps));
    int64_t t0 = now_ns();
    for (int i = 0; i < OPS; i++) {
        int idx = i % N;
        if (ps[idx]) myfree(ps[idx]);
        ps[idx] = mymalloc(sz);
    }
    for (int i = 0; i < N; i++) if (ps[i]) myfree(ps[i]);
    int64_t t1 = now_ns();
    return (t1 - t0) / 1e9;
}

static double bench_sys(int sz) {
    void *ps[N];
    memset(ps, 0, sizeof(ps));
    int64_t t0 = now_ns();
    for (int i = 0; i < OPS; i++) {
        int idx = i % N;
        if (ps[idx]) free(ps[idx]);
        ps[idx] = malloc(sz);
    }
    for (int i = 0; i < N; i++) if (ps[i]) free(ps[i]);
    int64_t t1 = now_ns();
    return (t1 - t0) / 1e9;
}

int main(void) {
    mymalloc_init();
    int sizes[] = {16, 64, 256, 1024, 4096};
    int nsizes = sizeof(sizes) / sizeof(sizes[0]);

    printf("%-10s %-14s %-14s %-10s\n", "bytes", "mine (sec)", "sys (sec)", "ratio");
    for (int s = 0; s < nsizes; s++) {
        double t_mine = bench_mine(sizes[s]);
        double t_sys  = bench_sys(sizes[s]);
        printf("%-10d %-14.4f %-14.4f %-10.2fx\n",
               sizes[s], t_mine, t_sys, t_sys > 0 ? t_mine / t_sys : 0);
    }

    printf("\nArena = %zu bytes, in-use = %zu, free = %zu, "
           "largest free = %zu, fragments = %d\n",
           mymalloc_arena_size(), mymalloc_in_use(),
           mymalloc_free_bytes(), mymalloc_largest_free(),
           mymalloc_fragment_count());

    mymalloc_shutdown();
    return 0;
}
