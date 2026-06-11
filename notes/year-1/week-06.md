# Week 6: Memory Debugging Tooling

This week I went past "ASan catches things" and *built* the tools:
ran a deliberately-buggy program through the macOS equivalents of
`valgrind`, hand-wrote a `malloc` wrapper, and assembled a 6-bug
"zoo" with one focused reproducer per bug class.

---

## 🚀 Learning goals
- [x] Run valgrind (Linux) or sanitizers (macOS) on intentionally
      buggy programs. Fix bugs and re-run.
- [x] Write a malloc wrapper that tracks allocations and prints a
      report at exit.
- [x] Create a "bug zoo": 6 small programs, each demonstrating a
      specific memory bug and its fix.

---

## 📅 Daily tasks

### Day 1–2 — valgrind / sanitizers
- Built `buggy.c` with five distinct bugs (leak, double-free, UAF,
  heap-of, uninit-read) and `buggy_fixed.c` with the fixes.
- `make asan` produces a clean report for each, with line numbers.
- `make leaks` runs the system `leaks` tool and finds the leak with
  a stack trace.
- macOS doesn't have a working `valgrind` on Apple Silicon. ASan +
  leaks together cover the same ground.

### Day 3 — `mymalloc` wrapper
- Wrote `mymalloc.h` / `mymalloc.c` / `usage.c`:
  - Flat array of `{ptr, size, file, line, freed}` tuples.
  - `mymalloc(n, file, line)`, `mycalloc(...)`, `myrealloc(...)`,
    `myfree(p, file, line)`.
  - `mymalloc_report()` walks the table and prints live allocations.
- Tested with `./usage 0` (no leak, report empty) and `./usage 100`
  (one leak, report shows two live entries with the exact file:line).
- README explains why a true drop-in is hard on macOS (system
  `__sized_by` annotations clash with macro rewrites) and lists the
  four workarounds (compile-time `-D`, link-time `--wrap`,
  `LD_PRELOAD`, `DYLD_INTERPOSE`).

### Weekend — Bug zoo
- 6 small programs in `weekend-bug-zoo/`:
  - `01_oob_write.c` — heap-buffer-overflow write (ASan)
  - `02_uaf_read.c`  — use-after-free read (ASan)
  - `03_double_free.c` — free twice (ASan)
  - `04_leak.c` — three leaks (macOS `leaks`)
  - `05_use_after_return.c` — return address of stack local
    (caught at compile time by `-Wreturn-stack-address`, at runtime
    by ASan's use-after-return mode)
  - `06_signed_overflow.c` — `INT_MAX + 1` (UBSan)
- Each program is <15 lines and has one bug. The Makefile has
  `asan`, `ubsan`, `leaks` targets that fire the right tool.

---

## 🛠️ Project structure
- `labs/year-1/week-06/day-1-2-valgrind/` — `buggy.c`, `buggy_fixed.c`, captured diagnostics.
- `labs/year-1/week-06/day-3-malloc-wrapper/` — `mymalloc.{h,c}`, `usage.c`.
- `labs/year-1/week-06/weekend-bug-zoo/` — 6 zoo programs + Makefile.

## Takeaway
The four tools I used this week are complementary:

| Tool | Catches |
|---|---|
| ASan | heap/stack/global OOB, UAF, double-free |
| UBSan | signed overflow, shift, null, alignment, … |
| macOS `leaks` | leaks with full call-stack |
| `mymalloc` (hand-rolled) | same as `leaks`, but in user code |

The bug zoo is the pattern I'll keep using in CI: for every bug
class I find, add a one-line reproducer that the relevant tool must
catch. Then a regression can't sneak in unnoticed.
