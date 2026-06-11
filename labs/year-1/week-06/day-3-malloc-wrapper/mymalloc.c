/* day-3-malloc-wrapper/mymalloc.c
 *
 * A small malloc/free tracker. Implementation detail:
 *
 *   - We can't `#include <stdlib.h>` *and* use the macros from
 *     myalloc.h, because then the macros would re-expand inside
 *     this file. So we declare the real libc functions manually.
 *   - Real call: directly to libc. Wrapped call: through mymalloc()
 *     which records the call site.
 *
 * Each live allocation is kept in a flat array (`table`) with an
 * {ptr, size, file, line, freed} tuple. myfree looks the tuple up
 * by ptr. mymalloc_report walks the table and prints everything
 * still live.
 */
#include "mymalloc.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Real libc functions (so we don't recursively call ourselves). */
extern void *malloc(size_t);
extern void *calloc(size_t, size_t);
extern void *realloc(void *, size_t);
extern void  free(void *);

#define MAX_LIVE 4096

typedef struct Entry {
    void        *ptr;
    size_t       size;
    const char  *file;
    int          line;
    int          freed;
} Entry;

static Entry  table[MAX_LIVE];
static int    used = 0;
static size_t live_bytes = 0;

void *mymalloc(size_t n, const char *file, int line) {
    if (n == 0) n = 1;
    void *p = malloc(n);
    if (!p) return NULL;
    if (used >= MAX_LIVE) {
        fprintf(stderr, "tracker: table full, %d live entries\n", used);
        abort();
    }
    table[used].ptr   = p;
    table[used].size  = n;
    table[used].file  = file;
    table[used].line  = line;
    table[used].freed = 0;
    used++;
    live_bytes += n;
    return p;
}

void *mycalloc(size_t nmemb, size_t sz, const char *file, int line) {
    size_t total = nmemb * sz;
    void *p = mymalloc(total, file, line);
    if (p) memset(p, 0, total);
    return p;
}

void *myrealloc(void *p, size_t n, const char *file, int line) {
    if (p == NULL) return mymalloc(n, file, line);
    if (n == 0)    { myfree(p, file, line); return NULL; }
    for (int i = 0; i < used; i++) {
        if (table[i].ptr == p && !table[i].freed) {
            void *q = realloc(p, n);
            if (!q) return NULL;
            live_bytes -= table[i].size;
            live_bytes += n;
            table[i].ptr  = q;
            table[i].size = n;
            return q;
        }
    }
    fprintf(stderr, "tracker: realloc of unknown pointer %p at %s:%d\n",
            p, file, line);
    return NULL;
}

void myfree(void *p, const char *file, int line) {
    if (p == NULL) return;
    for (int i = 0; i < used; i++) {
        if (table[i].ptr == p && !table[i].freed) {
            live_bytes -= table[i].size;
            table[i].freed = 1;
            free(p);
            return;
        }
    }
    for (int i = 0; i < used; i++) {
        if (table[i].ptr == p && table[i].freed) {
            fprintf(stderr, "tracker: DOUBLE FREE of %p at %s:%d "
                            "(originally allocated at %s:%d)\n",
                    p, file, line, table[i].file, table[i].line);
            return;
        }
    }
    fprintf(stderr, "tracker: free of unknown pointer %p at %s:%d\n",
            p, file, line);
}

void mymalloc_report(void) {
    int live_count = 0;
    for (int i = 0; i < used; i++) if (!table[i].freed) live_count++;
    printf("=== mymalloc report ===\n");
    printf("  %d live allocations, %zu bytes\n", live_count, live_bytes);
    for (int i = 0; i < used; i++) {
        if (table[i].freed) continue;
        printf("  %p  %6zu bytes   %s:%d\n",
               table[i].ptr, table[i].size, table[i].file, table[i].line);
    }
}

void mymalloc_shutdown(void) {
    mymalloc_report();
}
