# Weekend — Bug Zoo (6 small programs, 1 bug each)

## Files

| # | File | Bug | Tool that catches it |
|---|---|---|---|
| 1 | `01_oob_write.c`        | one-past-end heap write        | ASan |
| 2 | `02_uaf_read.c`         | use-after-free read            | ASan |
| 3 | `03_double_free.c`      | free twice                     | ASan |
| 4 | `04_leak.c`             | three leaks                    | macOS `leaks` |
| 5 | `05_use_after_return.c` | return address of stack local  | ASan use-after-return |
| 6 | `06_signed_overflow.c`  | `INT_MAX + 1`                  | UBSan |

## Build

```bash
make           # builds all six programs
make asan      # runs each through ASan, captures diagnostics
make ubsan     # runs #6 through UBSan
make leaks     # runs #4 through macOS `leaks`
make run       # runs all six with no tool
```

## What I observed

### ASan catches 1, 2, 3, 5

Sample from `01_oob_write`:
```
==NNNN==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x602000000098
WRITE of size 9 at 0x602000000098 thread T0
    #0 wrap_strcpy+0x4c4
    #1 main 01_oob_write.c:11
0x602000000098 is located 0 bytes after 8-byte region [0x602000000090,0x602000000098)
allocated by thread T0 here:
    #0 wrap_malloc+0xa0
    #1 main 01_oob_write.c:10
SUMMARY: AddressSanitizer: heap-buffer-overflow
```

### macOS `leaks` catches 4

```
Process 58043: 3 leaks for 240 total leaked bytes.
STACK OF 3 INSTANCES OF 'ROOT LEAK: <malloc in main>':
    1   04_leak  0x102449f8a  main + 42  04_leak.c:9
    0   libsystem_malloc.dylib ...
====
    3 (240 bytes) << TOTAL >>
      1 (80 bytes) ROOT LEAK: <malloc in main 0x7fcdb70040f0>
      1 (80 bytes) ROOT LEAK: <malloc in main 0x7fcdb7004140>
      1 (80 bytes) ROOT LEAK: <malloc in main 0x7fcdb7004190)
```

### UBSan catches 6

```
06_signed_overflow.c:10:15: runtime error: signed integer overflow: 2147483647 + 1 cannot be represented in type 'int'
    #0 0x100abdf45 in main 06_signed_overflow.c:10
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior
y = -2147483648
```

The diagnostic tells you the *expression* (line 10 col 15) and the
*type* (`int`). The actual run continues — `INT_MAX + 1` on a two's-
complement CPU is `-2147483648`, which is what the standard says you
must NOT rely on.

### 5 — use-after-return

`05_use_after_return.c` returns the address of a stack buffer. ASan
has a special mode for this: when enabled, the compiler saves the
local to a "fake stack" so subsequent use trips an error. The
`-Wreturn-stack-address` warning already catches it at compile time
— you don't even need to run the program to see the bug.

## Why a "zoo"?

A real codebase is a *combination* of these. The "bug zoo" pattern
(small focused programs, one bug each) is how the LLVM/Clang test
suite is organised: you can bisect regressions, add new test cases,
and confirm that a tool fires on the shape you expect. The same
pattern works in your own code: when you find a bug, write a
zoo-style reproducer for it, and your test suite will catch it
forever.
