# Day 1–2 — Memory-debugging tools on intentionally buggy programs

The curriculum calls this "valgrind on Linux, sanitizers on macOS".
On macOS the *practical* equivalent of `valgrind` for memory errors
is **ASan** (built into Apple Clang). `valgrind` exists in Homebrew
but is broken on Apple Silicon and very slow on Intel. The system
`leaks` tool handles leak detection.

## Build

```bash
make        # builds buggy and buggy_asan
make run    # runs both
make leaks  # runs the system `leaks` tool against ./buggy
```

## What I observed (truncated)

### Plain `./buggy`

```
* p (after free) = 0
x was small or negative
```

It "works" — except it doesn't. The leak lost 16×4 = 64 bytes; the
double-free is silently swallowed by Apple libc only because it's
*not* the most-recently-freed chunk; the heap-overflow wrote into
the redzone (visible only with ASan); the uninit-read used whatever
happened to be at that stack offset.

### `./buggy_asan` (with `-fsanitize=address`)

```
==NNNN==ERROR: AddressSanitizer: attempting double-free on 0x602000000090
    #0 wrap_free+0xa9
    #1 main buggy.c:24
freed by thread T0 here:
    #0 wrap_free+0xa9
    #1 main buggy.c:23
previously allocated by thread T0 here:
    #0 wrap_malloc+0xa0
    #1 main buggy.c:21
```

ASan aborts on the first bug (double-free) and gives you the **two
free sites** and the **original allocation** in one shot. With
`ASAN_OPTIONS=halt_on_error=0` it would keep going and catch the
others too, but in production you want to fix one bug at a time.

### `leaks --atExit -- ./buggy`

```
Process NNNNN: 1 leak for 64 total leaked bytes.
STACK OF 1 INSTANCE OF 'ROOT LEAK: <malloc in bug_leak>':
  0   libsystem_malloc.dylib    0x...  _malloc_zone_malloc_instrumented_or_legacy + 114
  1   buggy                     0x...  bug_leak + 18   buggy.c:14
  2   buggy                     0x...  main + 20       buggy.c:50
  3   dyld                      0x...  start + 1909
```

The `leaks` tool gives the **allocation site** with a full stack
trace — exactly what you need to find the leak.

## Fix

I rewrote `buggy_fixed.c` showing the fixes:

| Bug              | Fix |
|------------------|-----|
| leak             | `free(p)` before return |
| double-free      | `p = NULL` after free, or restructure |
| use-after-free   | don't use the pointer after free |
| heap-of          | allocate one more byte, or check the size |
| uninit-read      | `int x = 0;` |

`make asan` also runs the *fixed* binary under ASan to prove there
are no more reports.

## Takeaway

* **ASan** is the workhorse. Compile with `-fsanitize=address` during
  dev. It catches heap/stack/global overflows, UAF, double-free.
* **`leaks`** is the macOS leak detector. Run it in CI on every
  test binary. It gives a stack per leaked allocation.
* **`valgrind`** is fine on Linux, broken on Apple Silicon.
* **UBSan** (from Week 5) catches the *non-memory* UB family:
  signed overflow, null deref, shift, etc.
* Combine them: `-fsanitize=address,undefined` in dev, but in CI
  separate the runs because the two abort on the first error.
