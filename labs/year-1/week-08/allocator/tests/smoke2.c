#include "myalloc.h"
#include <stdio.h>
#include <stdlib.h>
int main(void) {
    setvbuf(stdout, NULL, 2, 0);
    setvbuf(stderr, NULL, 2, 0);
    mymalloc_init();
    void *ps[100] = {0};
    for (int i = 0; i < 100; i++) {
        ps[i] = mymalloc(16);
        if (!ps[i]) { fprintf(stderr, "alloc %d failed\n", i); break; }
        *(int*)ps[i] = i;
    }
    fprintf(stderr, "after 100 allocs: in_use=%zu, fragments=%d\n",
            mymalloc_in_use(), mymalloc_fragment_count());
    for (int i = 0; i < 100; i += 2) {
        myfree(ps[i]);
        ps[i] = NULL;
    }
    fprintf(stderr, "after 50 frees: in_use=%zu, fragments=%d\n",
            mymalloc_in_use(), mymalloc_fragment_count());
    for (int i = 0; i < 100; i++) if (ps[i]) myfree(ps[i]);
    fprintf(stderr, "after cleanup: in_use=%zu, fragments=%d\n",
            mymalloc_in_use(), mymalloc_fragment_count());
    mymalloc_shutdown();
    fprintf(stderr, "done\n");
    return 0;
}
