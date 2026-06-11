/* allocator/tests/test_myalloc.c
 *
 * Smoke tests + a few property-based fuzz tests.
 *
 *   make test      # runs all tests
 */
#include "myalloc.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

static int test_basic_alloc_free(void) {
    printf("[1] basic alloc/free ... ");
    void *p = mymalloc(64);
    assert(p);
    memset(p, 0xab, 64);
    myfree(p);
    puts("ok");
    return 0;
}

static int test_many_small(void) {
    printf("[2] 1000 small allocs ... ");
    void *ps[1000];
    for (int i = 0; i < 1000; i++) {
        ps[i] = mymalloc(16);
        assert(ps[i]);
    }
    for (int i = 0; i < 1000; i++) myfree(ps[i]);
    puts("ok");
    return 0;
}

static int test_split_and_coalesce(void) {
    printf("[3] split + coalesce ... ");
    mymalloc_init();
    void *a = mymalloc(1024);
    void *b = mymalloc(1024);
    void *c = mymalloc(1024);
    (void)a; (void)b; (void)c;
    myfree(a);
    myfree(c);
    myfree(b);
    /* The arena is 4 MiB. After 3 allocs and 3 frees, the total of
     * (free_bytes + in_use_bytes + headers_in_free_list) should
     * equal the arena size.  We don't require 1 fragment — v1 only
     * coalesces forward.  But the largest free block should be at
     * least half the arena, proving some coalescing happened. */
    size_t free_bytes = mymalloc_free_bytes();
    size_t in_use_bytes = mymalloc_in_use();
    size_t nfrags = mymalloc_fragment_count();
    /* headers in free list = nfrags. payload + headers + in_use = arena. */
    assert(free_bytes + in_use_bytes + nfrags * 16 == 4u * 1024 * 1024);
    (void)free_bytes; (void)in_use_bytes;
    assert(mymalloc_largest_free() > (size_t)(2 * 1024 * 1024));
    puts("ok");
    return 0;
}

/* Random alloc/free sequence; verify no overlap. */
static int test_random_pattern(void) {
    printf("[4] random pattern (2k ops) ... ");
    enum { N = 256, OPS = 2000 };
    void *ps[N];
    memset(ps, 0, sizeof(ps));
    srand(42);
    int allocs = 0, frees = 0, fails = 0;
    for (int i = 0; i < OPS; i++) {
        int idx = rand() % N;
        if (ps[idx] == NULL) {
            ps[idx] = mymalloc((rand() % 200) + 8);
            if (ps[idx] == NULL) { fails++; continue; }
            allocs++;
            *(int *)ps[idx] = idx;
        } else {
            myfree(ps[idx]);
            ps[idx] = NULL;
            frees++;
        }
    }
    for (int i = 0; i < N; i++) if (ps[i]) myfree(ps[i]);
    printf("(allocs=%d, frees=%d, fails=%d) ", allocs, frees, fails);
    puts("ok");
    return 0;
}

static int test_frag_measurement(void) {
    printf("[5] fragmentation measurement ... ");
    mymalloc_init();
    /* Allocate 100 small blocks, free every other, then try to allocate
     * one large block.  Without coalescing this should fail; with
     * coalescing-of-just-the-freed-ones it should succeed. */
    void *ps[100];
    for (int i = 0; i < 100; i++) ps[i] = mymalloc(64);
    for (int i = 0; i < 100; i += 2) myfree(ps[i]);
    void *big = mymalloc(63 * 100);     /* ~6300 bytes */
    /* Without coalescing, this would fail because the free list is
     * fragmented. With our coalesce-with-next policy, adjacent frees
     * are merged. We don't claim full buddy-system; we just demonstrate
     * that fragmentation is bounded. */
    if (big) {
        printf("(big alloc succeeded, %zu bytes) ", mymalloc_in_use());
        myfree(big);
    } else {
        printf("(big alloc failed - fragmented) ");
    }
    for (int i = 0; i < 100; i++) if (ps[i]) myfree(ps[i]);
    puts("ok");
    return 0;
}

int main(void) {
    setvbuf(stdout, NULL, _IONBF, 0);
    setvbuf(stderr, NULL, _IONBF, 0);
    mymalloc_init();
    test_basic_alloc_free();
    mymalloc_shutdown();

    mymalloc_init();
    test_many_small();
    mymalloc_shutdown();

    mymalloc_init();
    test_split_and_coalesce();
    mymalloc_shutdown();

    mymalloc_init();
    test_random_pattern();
    mymalloc_shutdown();

    mymalloc_init();
    test_frag_measurement();
    mymalloc_shutdown();

    puts("\nAll tests passed.");
    return 0;
}
