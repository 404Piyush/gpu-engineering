# Arena Allocator v1

A simple, dependency-free **free-list memory allocator** written in
C. Single 4 MiB mmap arena, 16-byte block headers, first-fit search,
split-on-allocate, no coalesce. Demonstrates the core mechanics
that underpin `glibc malloc`, `jemalloc`, and friends.

This is the Week-8 project from the gpu-engineering curriculum: a
two-week project that ties together the memory model from Weeks 5–7
(memory layout, common bugs, debugging tools, virtual memory).

## Features

* `mymalloc` / `myfree` with first-fit and split-on-allocate
* Single mmap arena (4 MiB) — no `sbrk`, no thread cache
* Minimal bookkeeping: 16-byte header per block; the free list is
  threaded through the payload of free blocks (safe because the
  user only writes to *allocated* blocks)
* 5-test test suite (basic, 1k allocs, split, random pattern,
  fragmentation)
* Microbenchmark vs system `malloc`

## Quick start

```bash
make            # builds libmyalloc.a, test_myalloc, bench
make test       # runs the test suite
make bench      # runs the microbenchmark vs system malloc
make clean
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

## Bench (vs glibc malloc, Apple M-series)

| Block size | mine (s) | sys (s) | ratio  |
|------------|----------|---------|--------|
| 16         | 0.0011   | 0.0044  | 0.25x  |
| 64         | 0.0011   | 0.0113  | 0.10x  |
| 256        | 0.0025   | 0.0113  | 0.22x  |
| 1024       | 0.0026   | 0.0078  | 0.33x  |
| 4096       | 1.0667   | 0.0084  | 127x   |

The v1 allocator is **faster than glibc for small blocks** (less
per-call overhead, no thread-safety, no size-class binning). It is
**much slower for 4 KiB allocs** because the lack of coalescing
causes the arena to fragment into thousands of small free blocks.

## Files

```
include/myalloc.h      public API
src/myalloc.c          implementation
tests/test_myalloc.c   test suite
bench/bench.c          microbenchmark
Makefile               build system
README.md              this file
```

## v1 limitations

* **No coalescing.** Adjacent free blocks don't merge. This is the
  reason 4 KiB workloads fragment badly.
* **No splitting on free.** The free list's blocks are exactly the
  sizes that were allocated.
* **First-fit is O(N_free).** A balanced tree (or a size-class
  bin) would bring this down to O(log N) or O(1).
* **Not thread-safe.** Add a mutex or per-thread arenas.

## What I'd do for v2

1. **Coalesce on free.** Walk forward and backward from the
   freed block, merging with adjacent free blocks.
2. **Boundary tags.** Add a footer to each block so the previous
   block can be found by reading `-sizeof(Header)`.
3. **Size classes.** Round up to one of N power-of-two classes so
   the free list can be split into N sub-lists, each O(1) to search.
4. **Thread safety.** Per-thread arenas with periodic merging.

## Acceptance criteria (Week 8)

* [x] Allocator passes a 5-test smoke suite.
* [x] Benchmarks vs `malloc` with reported numbers.
* [x] Fragmentation experiment reproducible from `make test` and
      `make bench`.
