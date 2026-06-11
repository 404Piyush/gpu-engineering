/* allocator/src/myalloc.c
 *
 * A simple K&R-style free-list allocator.
 *
 * Design:
 *   - One big mmap arena (4 MiB).
 *   - Each block has a 16-byte header: { size, padding }.
 *     The "size" field stores the *total* block size (header + payload).
 *     The LSB is the "free?" flag.
 *   - Free blocks are threaded into a singly-linked free list via
 *     a `next` pointer stored at the start of the payload.
 *   - mymalloc: walk the free list (first-fit), unlink the block,
 *     clear the free bit, return the payload.
 *   - myfree: set the free bit, link the block to the front of
 *     the free list. No coalescing in v1.
 *
 * v1 limitations:
 *   - No coalescing — adjacent frees don't merge.
 *   - No splitting — the returned block is always exactly a free block.
 *   - First-fit is O(N_free).
 *   - The "next" pointer of a free block lives in the user payload
 *     area; the user can clobber it ONLY after a block is allocated.
 *     When the block is free, we control the bytes.
 *
 * Public API: see include/myalloc.h.
 */
#include "myalloc.h"
#include <stdint.h>
#include <stddef.h>
#include <unistd.h>
#include <sys/mman.h>
#include <stdio.h>
#include <string.h>

#define ALIGN          16
#define HEADER_SIZE    16
#define MIN_BLOCK_SIZE (HEADER_SIZE + 16)   /* header + 16 payload for the fl_next */
#define ARENA_BYTES    (4u * 1024u * 1024u)

typedef struct Header {
    size_t   size;        /* total block size (header + payload); LSB = free flag */
} Header;

#define HDR_FREE_BIT  ((size_t)1)
#define HDR_TOTAL(h) ((h)->size & HDR_SIZE_MASK)
#define HDR_SIZE_MASK (~(size_t)1)

static Header *arena_base = NULL;
static Header *free_list = NULL;
static void    *arena_end = NULL;
static size_t   arena_size = 0;
static size_t   in_use = 0;
static int      inited = 0;

static int    is_free(Header *h) { return h->size & HDR_FREE_BIT; }
static size_t payload_of(Header *h) { return HDR_TOTAL(h) - HEADER_SIZE; }

static void set_free(Header *h, int f) {
    if (f) h->size |=  HDR_FREE_BIT;
    else   h->size &= ~HDR_FREE_BIT;
}

static Header **fl_next_ptr(Header *h) {
    return (Header **)((char *)h + HEADER_SIZE);
}

static Header *next_block(Header *h) {
    char *next = (char *)h + HDR_TOTAL(h);
    if (next >= (char *)arena_end) return NULL;
    return (Header *)next;
}

void mymalloc_init(void) {
    if (inited) return;
    arena_base = (Header *)mmap(NULL, ARENA_BYTES, PROT_READ | PROT_WRITE,
                              MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (arena_base == MAP_FAILED) { write(2, "mmap failed\n", 12); _exit(1); }
    arena_size = ARENA_BYTES;
    arena_end  = (char *)arena_base + ARENA_BYTES;

    /* One big free block covering the whole arena. */
    Header *h = arena_base;
    h->size = ARENA_BYTES | HDR_FREE_BIT;
    *fl_next_ptr(h) = NULL;
    free_list = h;
    inited = 1;
    in_use = 0;
}

void mymalloc_shutdown(void) {
    if (arena_base) munmap(arena_base, ARENA_BYTES);
    arena_base = NULL;
    free_list = NULL;
    arena_end = NULL;
    inited = 0;
    in_use = 0;
}

/* First-fit search. */
static Header *find_fit(size_t need) {
    for (Header *h = free_list; h; h = *fl_next_ptr(h)) {
        if (payload_of(h) >= need) return h;
    }
    return NULL;
}

/* Unlink `h` from the free list. */
static void fl_remove(Header *h) {
    Header **pp = &free_list;
    while (*pp && *pp != h) pp = fl_next_ptr(*pp);
    if (*pp == h) {
        *pp = *fl_next_ptr(h);
        *fl_next_ptr(h) = NULL;
    }
}

/* Split `h` so that the first part has `need` payload and the rest
 * becomes a new free block. The caller has already removed `h` from
 * the free list. */
static void split_block(Header *h, size_t need) {
    size_t total = HDR_TOTAL(h);
    size_t want  = HEADER_SIZE + need;
    if (total < want + MIN_BLOCK_SIZE) return;  /* not enough to split */
    size_t rest_size = total - want;

    Header *split = (Header *)((char *)h + want);
    split->size = rest_size | HDR_FREE_BIT;
    *fl_next_ptr(split) = free_list;
    free_list = split;

    h->size = want;            /* clear free bit */
}

void *mymalloc(size_t n) {
    if (!inited) mymalloc_init();
    if (n == 0) n = 1;
    n = (n + (ALIGN - 1)) & ~(size_t)(ALIGN - 1);

    Header *h = find_fit(n);
    if (!h) return NULL;
    fl_remove(h);
    split_block(h, n);
    set_free(h, 0);
    in_use += payload_of(h);
    return (char *)h + HEADER_SIZE;
}

void myfree(void *p) {
    if (!p) return;
    Header *h = (Header *)((char *)p - HEADER_SIZE);
    if (is_free(h)) return;        /* double-free guard */
    in_use -= payload_of(h);
    set_free(h, 1);
    *fl_next_ptr(h) = free_list;
    free_list = h;
}

size_t mymalloc_arena_size(void)  { return arena_size; }
size_t mymalloc_in_use(void)      { return in_use; }
size_t mymalloc_free_bytes(void) {
    size_t total = 0;
    for (Header *h = free_list; h; h = *fl_next_ptr(h)) {
        total += payload_of(h);
    }
    return total;
}
size_t mymalloc_largest_free(void) {
    size_t big = 0;
    for (Header *h = free_list; h; h = *fl_next_ptr(h)) {
        if (payload_of(h) > big) big = payload_of(h);
    }
    return big;
}
int mymalloc_fragment_count(void) {
    int n = 0;
    for (Header *h = free_list; h; h = *fl_next_ptr(h)) n++;
    return n;
}
