# Day 3 — Sanitizers (ASan, UBSan, macOS leaks)

## What's in this folder

| File | Bug type | Caught by |
|---|---|---|
| `all_bugs.c`            | mixed (heap, stack, UAF, signed overflow) | ASan + UBSan |
| `all_bugs_ubsan_only.c` | signed overflow, shift, null, div-by-zero | UBSan |

## Build

```bash
make asan     # -> all_bugs_asan,    all_bugs.asan.txt
make ubsan    # -> all_bugs_ubsan,   all_bugs.ubsan.txt
make both     # -> all_bugs_both,    all_bugs.both.txt
```

## Tooling primer (macOS)

| Sanitizer | Compiler flag | What it catches |
|---|---|---|
| **ASan**   | `-fsanitize=address` | heap/stack/global buffer overflow, UAF, double-free |
| **UBSan**  | `-fsanitize=undefined` (or a narrower set) | signed overflow, shift, null, alignment, etc. |
| **LeakSan**| (Linux only) | leaks at process exit |
| **macOS leaks** | `leaks --atExit -- ./prog` | leaks, with full backtraces |

On macOS, `LeakSan` is not built into Apple Clang's ASan. Use the system
`leaks` tool instead — it works on any Mach-O binary and gives a
call-stack per leaked allocation (we used it in Day 2).

## What I observed (sample output)

### `make asan` — `all_bugs.asan.txt`

```
==NNNN==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x602000000098
WRITE of size 1 at 0x602000000098 thread T0
    #0 0x102f7fb4b in heap_overflow all_bugs.c:14
    #1 0x102f7faba in main all_bugs.c:37
0x602000000098 is located 0 bytes after 8-byte region [0x602000000090,0x602000000098)
allocated by thread T0 here:
    #0 0x10be8d410 in wrap_malloc+0xa0
    #1 0x102f7fb01 in heap_overflow all_bugs.c:13
```

ASan gives the **write site** (`all_bugs.c:14`), the **buffer bounds**,
and the **allocation site** (`all_bugs.c:13`). The shadow bytes around
the address (`fa fa 00 00 …`) are the redzone that the heap allocator
plants around every allocation so out-of-bounds writes can be caught.

### `make ubsan` — `all_bugs.ubsan.txt`

```
all_bugs_ubsan_only.c:11:14: runtime error: signed integer overflow: 2147483647 + 1 cannot be represented in type 'int'
    #0 0x1046c8e1a in signed_overflow all_bugs_ubsan_only.c:11
    #1 0x1046c8d64 in main                all_bugs_ubsan_only.c:29
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior all_bugs_ubsan_only.c:11:14

all_bugs_ubsan_only.c:15:14: runtime error: shift exponent 32 is too large for 32-bit type 'int'
    #0 0x1046c8e8d in shift_too_far all_bugs_ubsan_only.c:15
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior all_bugs_ubsan_only.c:15:14

all_bugs_ubsan_only.c:19:12: runtime error: load of null pointer of type 'int'
    #0 0x1046c8ecd in null_deref all_bugs_ubsan_only.c:19
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior all_bugs_ubsan_only.c:19:12
```

Three different UBSan checks fired. With `halt_on_error=0` (the default in
the Makefile), UBSan prints *all* of them and continues. With
`-fno-sanitize-recover=all` it would `ud2` on the first one.

### `make both` — `all_bugs.both.txt`

ASan trips on the heap-buffer-overflow at `all_bugs.c:14` and aborts
before UBSan has a chance. That's actually the *right* behaviour: don't
keep running a program that has corrupted memory, even if the next
sanitizer has more bugs to find.

## Why a narrower UBSan set?

`make ubsan` uses:

```
UBSAN_SET := signed-integer-overflow,shift,null,unreachable,vla-bound,object-size,float-divide-by-zero,integer-divide-by-zero
```

`-fsanitize=undefined` *also* enables `bounds`, which inserts array
bounds checks at every load. That conflicts with ASan (both want to
plant shadow memory), so I narrow the set to the checks that don't
overlap with ASan. This is the standard pattern on macOS.

## Takeaway

* Compile with **ASan in dev builds** for any C/C++ project. The
  performance hit is ~2x, the bug-catch hit is enormous.
* Compile with **UBSan** in dev too. The default `-fsanitize=undefined`
  is fine; if you mix it with ASan, narrow the set as above.
* Run with **`leaks --atExit`** (macOS) or `-fsanitize=leak` (Linux) to
  catch memory leaks in CI.
* In production, drop all sanitizers — they make the binary much
  larger and a bit slower. Use them as a development/CI gate, not a
  runtime feature.
