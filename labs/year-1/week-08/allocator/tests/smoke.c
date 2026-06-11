#include "myalloc.h"
#include <stdio.h>
#include <stdlib.h>
int main(void) {
    setvbuf(stdout, NULL, 2, 0);
    setvbuf(stderr, NULL, 2, 0);
    mymalloc_init();
    fprintf(stderr, "after init: in_use=%zu, fragments=%d, largest=%zu\n",
            mymalloc_in_use(), mymalloc_fragment_count(), mymalloc_largest_free());
    void *p = mymalloc(100);
    fprintf(stderr, "after mymalloc(100): p=%p, in_use=%zu, fragments=%d\n",
            p, mymalloc_in_use(), mymalloc_fragment_count());
    void *q = mymalloc(200);
    fprintf(stderr, "after mymalloc(200): q=%p, in_use=%zu, fragments=%d\n",
            q, mymalloc_in_use(), mymalloc_fragment_count());
    myfree(p);
    fprintf(stderr, "after myfree(p): in_use=%zu, fragments=%d\n",
            mymalloc_in_use(), mymalloc_fragment_count());
    myfree(q);
    fprintf(stderr, "after myfree(q): in_use=%zu, fragments=%d\n",
            mymalloc_in_use(), mymalloc_fragment_count());
    mymalloc_shutdown();
    fprintf(stderr, "done\n");
    return 0;
}
