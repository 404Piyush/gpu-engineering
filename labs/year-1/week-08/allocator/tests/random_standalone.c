#include "myalloc.h"
#include <stdio.h>
#include <stdlib.h>
int main(void) {
    setvbuf(stdout, NULL, 2, 0);
    setvbuf(stderr, NULL, 2, 0);
    mymalloc_init();
    enum { N = 256, OPS = 2000 };
    void *ps[N] = {0};
    srand(42);
    int allocs = 0, frees = 0, fails = 0;
    for (int i = 0; i < OPS; i++) {
        if (i >= 100 && i < 200) fprintf(stderr, "iter %d start\n", i);
        int idx = rand() % N;
        if (ps[idx] == NULL) {
            if (i >= 100 && i < 200) fprintf(stderr, "  alloc\n");
            ps[idx] = mymalloc((rand() % 200) + 8);
            if (i >= 100 && i < 200) fprintf(stderr, "  alloc done\n");
            if (ps[idx] == NULL) { fails++; continue; }
            allocs++;
            *(int *)ps[idx] = idx;
        } else {
            if (i >= 100 && i < 200) fprintf(stderr, "  free\n");
            myfree(ps[idx]);
            ps[idx] = NULL;
            frees++;
            if (i >= 100 && i < 200) fprintf(stderr, "  free done\n");
        }
        if (i % 100 == 0) fprintf(stderr, "iter %d\n", i);
    }
    fprintf(stderr, "after 2000 ops: allocs=%d, frees=%d, fails=%d, in_use=%zu, fragments=%d\n",
            allocs, frees, fails, mymalloc_in_use(), mymalloc_fragment_count());
    for (int i = 0; i < N; i++) if (ps[i]) myfree(ps[i]);
    fprintf(stderr, "after cleanup: in_use=%zu, fragments=%d\n",
            mymalloc_in_use(), mymalloc_fragment_count());
    mymalloc_shutdown();
    fprintf(stderr, "done\n");
    return 0;
}
