# Day 3 — A malloc wrapper that tracks allocations and prints a report

## Files

| File | What it is |
|---|---|
| `mymalloc.h` | Public API of the tracker. |
| `mymalloc.c` | Implementation. Stores {ptr, size, file, line} per allocation in a flat array. |
| `usage.c`    | A small program that calls the wrapper directly and prints the report. |

## Build & run

```bash
make           # builds `usage`
make run       # runs ./usage 0 (no leak) and ./usage 100 (one leak)
make leak      # runs ./usage 4096 (a larger leak)
```

## What I observed

### No leak (`./usage 0`)

```
  buf = 0x6000020dc1c0, "hello"
=== mymalloc report ===
  0 live allocations, 0 bytes
```

`myfree` removed the entry from the table, so the report is empty.

### One small leak (`./usage 100`)

```
  buf = 0x6000018b81c0, "hello"
=== mymalloc report ===
  2 live allocations, 164 bytes
  0x6000018b81c0      64 bytes   usage.c:14
  0x6000026b8000     100 bytes   usage.c:21
```

Two live entries, **with the file and line of each allocation site**.
The 64-byte buffer at line 14 is the `buf` we never freed; the 100-byte
allocation at line 21 is the intentional leak.

### Bigger leak (`./usage 4096`)

```
  2 live allocations, 4160 bytes
  0x600002cc81c0      64 bytes   usage.c:14
  0x7f92e980ce00    4096 bytes   usage.c:21
```

Same shape — just the heap address is different (libc returned a chunk
from the `mmap` pool for the 4 KiB request, hence the `0x7f92…` "far"
address). The wrapper is oblivious to the allocator's internals; it
just records the pointer it got back.

## The design

`mymalloc.c` keeps a flat array `Entry table[MAX_LIVE]`. Every call to
`mymalloc` stores the next entry and returns the pointer; every call to
`myfree` looks up the entry by pointer and marks it freed. The
`mymalloc_report` function walks the table once and prints everything
still live.

Tradeoffs:

| Decision | Why |
|---|---|
| Flat array, not linked list | O(1) `mymalloc`, O(N) `myfree` (we need to look up by ptr), cache-friendly. |
| `MAX_LIVE = 4096` | Deliberately small so the demo aborts loudly if you have a real leak. Real allocators are unbounded. |
| No real-time accuracy | The wrapper doesn't catch memory that *escapes* (e.g. `void *p = malloc(64); (void)p;`) — it just reports what it knows. |
| Double-free detection | `myfree` checks both "unknown pointer" and "already freed" cases. |

## Why a true drop-in is hard on macOS

The "obvious" way to make `malloc` route through `mymalloc` is:

```c
#define malloc(s)  mymalloc((s), __FILE__, __LINE__)
```

You then `#include "mymalloc.h"` and `#include <stdlib.h>` and the
preprocessor rewrites every `malloc(64)` to `mymalloc(64, "file", 17)`.
On Linux this works. On macOS, the system `<stdlib.h>` uses
`__sized_by(N)` annotations on `malloc` and those macros use
parenthesised names that *also* match `malloc`, causing a cascade of
redefinition errors.

The workarounds are:

1. **`-D` flags on the compile line** (the first Makefile I wrote did
   this) — they apply the rewrite *before* any header is parsed, but
   the system header still has a `__sized_by` macro that resolves to
   `malloc` and re-triggers our rewrite.
2. **Wrap the system `malloc` in our own `__wrap_malloc` and link
   with `--wrap=malloc`**. That works for static linking but not for
   shared libraries.
3. **Use `LD_PRELOAD` to inject our own `malloc` into the binary at
   load time.** Works for any program. We don't show this here
   because it's overkill for the demo.
4. **Use `DYLD_INTERPOSE`** on macOS — the Apple-blessed equivalent
   of `LD_PRELOAD`. Same story.

For learning purposes I went with approach **direct call**: every
allocation site writes `mymalloc(64, __FILE__, __LINE__)` explicitly.
That loses the "no source change" property but is the most legible
and works on every compiler/standard library.

## Takeaway

* A malloc wrapper is a small fixed-size table plus a few functions.
* It detects three things ASan doesn't: leaks (at exit), double-free
  (at free time), and free-of-unknown (at free time).
* The exit-time report is *exactly* what Apple's `leaks` tool does —
  ours is just shorter and tells you the call site of every live
  allocation.
* Real tools (`valgrind`, ASan, `leaks`, LSan) use clever tricks to
  intercept malloc without source modification. Those tricks are
  more code than the table itself; the table is the part you write.
