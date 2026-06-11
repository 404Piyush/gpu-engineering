/* day-3-malloc-wrapper/usage.c
 *
 * Uses the tracker with direct calls to mymalloc/myfree. The header
 * gymnastics needed to make a true drop-in replacement work is
 * explained in README.md; here we just use the wrappers directly
 * to show the report.
 */
#include "mymalloc.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void do_work(int leak_count) {
    char *buf = mymalloc(64, __FILE__, __LINE__);
    if (!buf) return;
    strcpy(buf, "hello");
    printf("  buf = %p, \"%s\"\n", (void *)buf, buf);

    if (leak_count > 0) {
        /* Intentionally leak. */
        (void)mymalloc(leak_count, __FILE__, __LINE__);
    } else {
        myfree(buf, __FILE__, __LINE__);
    }
}

int main(int argc, char **argv) {
    int leak = (argc > 1) ? atoi(argv[1]) : 0;
    do_work(leak);
    mymalloc_report();
    return 0;
}
