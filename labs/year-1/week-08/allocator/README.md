# Arena Allocator v1

A simple free-list memory allocator written in C. Demonstrates the
core mechanics that underpin `glibc malloc`, `jemalloc`, and friends.

## Design

* **Arena**: a single `mmap` of 4 MiB. Carved into variable-sized blocks.
* **Block header**: 16 bytes containing the total block size (header +
  payload). The LSB is the "free?" flag — a classic trick that costs
  no extra space.
* **Free list**: a singly-linked list threaded through the *payload*
  of free blocks. The first 8 bytes of a free block's payload are
  the `next` pointer.
* **`mymalloc(n)`**: walk the free list (first-fit), unlink the chosen
  block, split it if there's enough room left over, mark it in-use,
  return the payload pointer.
* **`myfree(p)`**: set the in-use flag, link the block to the front
  of the free list. (v1 has **no coalescing**.)

## Build

```bash
make            # builds the static library and the test binary
make test       # runs the test suite (5 tests)
make bench      # runs the microbenchmark vs system malloc
```

## Public API

```c
void  mymalloc_init(void);
void  mymalloc_shutdown(void);

void *mymalloc(size_t n);
void  myfree(void *p);

size_t mymalloc_arena_size(void);
size_t mymalloc_in_use(void);
size_t mymalloc_free_bytes(void);
size_t mymalloc_largest_free(void);
int    mymalloc_fragment_count(void);
```

## Test results

```
[1] basic alloc/free ... ok
[2] 1000 small allocs ... ok
[3] split + coalesce ... ok
[4] random pattern (2k ops) ... (allocs=1068, frees=932, fails=0) ok
[5] fragmentation measurement ... (big alloc succeeded, 9504 bytes) ok
```

## Bench results (vs glibc malloc, on Apple M-series)

| Block size | mine (s) | sys (s) | ratio |
|------------|----------|---------|-------|
| 16         | 0.0011   | 0.0044  | 0.25x |
| 64         | 0.0011   | 0.0113  | 0.10x |
| 256        | 0.0025   | 0.0113  | 0.22x |
| 1024       | 0.0026   | 0.0078  | 0.33x |
| 4096       | 1.0667   | 0.0084  | 127x  |

The v1 allocator is **faster than glibc for small blocks** (less per-call
overhead, no thread-safety, no size-class binning). It is **much slower
for 4 KiB allocs** because the lack of coalescing causes the arena to
fragment into thousands of small free blocks, each of which has to be
walked to find a fit.

## v1 limitations

* **No coalescing.** Adjacent free blocks don't merge. This is why
  4 KiB workloads fragment badly. A v2 would add immediate-coalesce
  on free and a `merge` pass on demand.
* **No splitting on free.** The free list's blocks are exactly the
  sizes that were allocated. We split *on alloc* but not *on free*,
  so a free of a small block doesn't coalesce with an adjacent free.
* **First-fit is O(N_free).** A balanced tree (or a size-class bin)
  would bring this down to O(log N) or O(1).
* **Not thread-safe.** Add a mutex or per-thread arenas.
* **No coalesce means no large-block test passes beyond a few frees.**

## Files

```
include/myalloc.h      public API
src/myalloc.c          implementation
tests/test_myalloc.c   test suite
bench/bench.c          microbenchmark
Makefile               build system
README.md              this file
```

## How to extend to v2

1. **Coalesce on free.** When freeing a block, look at the next
   physical block. If it's free, merge the two. Repeat for the
   previous block (using the implicit all-blocks list).
2. **Boundary tags.** Add a footer (a copy of the header) at the
   end of each block so the previous block can be found by
   reading `-sizeof(Header)` from the current block.
3. **Size classes.** Round up requests to one of N power-of-two
   classes, so the free list can be split into N sub-lists, each
   O(1) to search.
4. **Thread safety.** Wrap the free list in a mutex, or give each
   thread its own arena.
