# arena-allocator

> **The real project lives at the standalone repo:**
> 👉 **[github.com/404Piyush/arena-allocator](https://github.com/404Piyush/arena-allocator)**
>
> The source code is **not** mirrored in this folder — go to
> the standalone repo for the full build, tests, benchmarks,
> CI, and docs.

## At a glance

- **What it is:** a bump arena memory allocator in C11
- **Curriculum origin:** Week 8 (Month-2 project)
- **LOC:** ~300
- **Tests:** 143 assertions, 9 cases — all passing
- **Benchmark:** ~14× faster than `malloc` for small allocs
- **License:** MIT

## Quick example

```c
#include "arena.h"

arena *a = arena_create(64 * 1024);
char  *s = arena_alloc(a, 32);   /* O(1) */
char  *t = arena_alloc(a, 64);
arena_reset(a);                  /* O(1) */
arena_destroy(a);                /* munmap */
```

## Get the code

```sh
git clone https://github.com/404Piyush/arena-allocator.git
cd arena-allocator
make test
make bench N=1000000
```

---

📚 See the top-level [README](../../README.md#-arena-allocator) and
[PROJECTS.md](../../PROJECTS.md#2-arena-allocator--bump-arena)
for the full deep-dive.
