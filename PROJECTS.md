# Projects

Deep-dive on each of the three standalone projects. The
source code lives in the standalone repos; the links below
jump straight to each.

| # | Project | Repo | Live site |
|---:|---|---|---|
| 1 | `bst-library` (generic binary-search tree) | [404Piyush/bst-library](https://github.com/404Piyush/bst-library) | [bst-library.404piyush.me](https://bst-library.404piyush.me) |
| 2 | `arena-allocator` (bump arena) | [404Piyush/arena-allocator](https://github.com/404Piyush/arena-allocator) | [arena-allocator.404piyush.me](https://arena-allocator.404piyush.me) |
| 3 | `pipe-shell` (POSIX-ish command interpreter) | [404Piyush/pipe-shell](https://github.com/404Piyush/pipe-shell) | [pipe-shell.404piyush.me](https://pipe-shell.404piyush.me) |

## 1. `bst-library` — generic binary-search tree

Week 4 capstone. The first C project polished enough to
be shown off.

### What it does

- Generic: stores `void*` payloads, accepts a user-supplied
  comparator.
- Operations: insert, find, remove, min, max, in-order walk.
- Memory: caller-supplied allocator hook; the library itself
  never calls `malloc`.

### Public API

```c
bst  *bst_create   (bst_cmp_fn cmp, bst_free_fn free_key);
void  bst_destroy  (bst *t, bst_free_fn free_key, bst_free_fn free_payload);
int   bst_insert   (bst *t, const void *key, void *payload);
void *bst_find     (const bst *t, const void *key);
int   bst_remove   (bst *t, const void *key);
void  bst_inorder  (const bst *t, bst_visit_fn visit, void *ctx);
```

### Worked example

```c
#include "bst.h"

int cmp_int(const void *a, const void *b) { return *(int*)a - *(int*)b; }

int main(void) {
    bst *t = bst_create(cmp_int, NULL);
    int keys[] = {5, 3, 7, 1, 4, 6, 8};
    for (int i = 0; i < 7; i++) bst_insert(t, &keys[i], &keys[i]);
    bst_inorder(t, print_int, NULL);
    bst_destroy(t, NULL, NULL);
}
```

### Tests and benchmark

- 74 assertions, 8 test cases, all passing.
- Microbenchmark (`bench/bench_bst.c`):
  - 3.5 M insert/s
  - 4.8 M find/s
  - 2.8 M remove/s
- Run on Apple M-series, single thread, `-O2`.

### Why a BST and not a hash table

A BST keeps keys in sorted order, so `in-order` is free.
Insertion order is deterministic, which makes it easier to
test. It is the simplest dynamic data structure that is not
a list.

### Source

github.com/404Piyush/bst-library

---

## 2. `arena-allocator` — bump arena

Week 8 project. The simplest correct memory allocator
there is.

### What it does

- One contiguous `mmap`'d region, a single bump pointer.
- `arena_alloc(a, n)`: O(1), returns a 16-byte-aligned slice.
- `arena_reset(a)`: O(1), rewinds the bump pointer to 0.
- `arena_destroy(a)`: `munmap`s the whole region.
- High-watermark tracking for memory budgeting.

### Public API

```c
arena *arena_create (size_t capacity);
void  *arena_alloc   (arena *a, size_t size);
void   arena_reset   (arena *a);
void   arena_destroy (arena *a);
size_t arena_in_use  (const arena *a);
size_t arena_high_wat(const arena *a);
```

### Why a bump arena

- O(1) every operation: no per-allocation bookkeeping.
- No fragmentation: used memory is always contiguous.
- Cheap to reset: one pointer write, not N frees.
- Perfect for the *phase* pattern: parsers, request
  handlers, compilers, frame allocators.

### The phase pattern

```c
arena *a = arena_create(64 * 1024);
for (;;) {
    arena_reset(a);
    request_t *r = arena_alloc(a, sizeof *r);
    r->method = arena_alloc(a, strlen(line) + 1);
    r->body   = arena_alloc(a, body_len);
    handle(r);
}
arena_destroy(a);
```

The cost of memory management per request collapses from
N frees to one reset.

### Tests and benchmark

- 143 assertions, 9 test cases, all passing.
- Microbenchmark (`bench/bench_arena.c`):
  - `arena_alloc`: ~450 M ops/s
  - `malloc`/`free`: ~75 M ops/s
  - ~5–7x faster than the system allocator
- Run on Apple M-series, single thread, `-O2`.

### Source

github.com/404Piyush/arena-allocator

---

## 3. `pipe-shell` — POSIX-ish command interpreter

Week 11 capstone. The reason this curriculum exists.

### What it does

- Recursive parser: line to AST (`shell_cmd`).
- Pipelines: `cmd1 | cmd2 | cmd3`.
- Redirection: `<`, `>`, `>>`.
- Background: trailing `&`.
- Built-ins: `exit [N]`, `cd [DIR]`.
- Interactive REPL and one-shot `--run` CLI.

### Public API

```c
bool shell_parse    (const char *line, shell_cmd *out);
int  shell_run      (const shell_cmd *cmd);
void shell_cmd_print(const shell_cmd *cmd, FILE *f);
```

### The pipeline recipe

The executor is 30 lines of C. The shape is:

```c
int prev_fd = -1;
for (i = 0; i < n_stages; i++) {
    int pipe_fd[2] = {-1, -1};
    if (i + 1 < n_stages) pipe(pipe_fd);
    pid_t pid = fork();
    if (pid == 0) {
        run_stage(&stages[i], prev_fd, pipe_fd[1]);
    }
    if (prev_fd >= 0) close(prev_fd);
    prev_fd = pipe_fd[0];
    if (pipe_fd[1] >= 0) close(pipe_fd[1]);
}
if (!background) wait for every child;
```

The crucial detail: every pipe fd the parent has a copy
of must be closed, or the consumer's `read(2)` will block
forever. Get that wrong and the user sees a shell that
prints nothing and never returns.

### Worked example

```sh
$ ./pipe-shell --run "ls /etc | grep hosts | wc -l"
       3
$ ./pipe-shell --run "echo hi > /tmp/out.txt; cat /tmp/out.txt"
hi
$ ./pipe-shell --run "wc -l < Makefile"
      25
```

### Tests

- 56 assertions, 13 test cases, all passing.
- Covers the parser (8 cases) and the executor (5 cases).

### Limitations

- No glob (`*`) or variable (`$HOME`) expansion.
- No quoting of any kind.
- No `;`, `&&`, `||`. A line is one pipeline.
- No job control. Background jobs are fire-and-forget.

### Source

github.com/404Piyush/pipe-shell
