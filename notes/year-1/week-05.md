# Week 5: Stack vs Heap (Memory Layout + Common Bugs)

This week was about **where memory actually lives** — `.text` / `.data`
/ `.bss` / `.rodata` / stack / heap — and the three classic bugs you
hit when you get them wrong: leak, double-free, use-after-free. I read
CS:APP §3.10–3.12 and skimmed §9.9.

---

## 🚀 Learning goals
- [x] Print addresses of globals, stack locals, heap allocations; document layout.
- [x] Create leaks, double-free, and use-after-free examples; explain symptoms.
- [x] Add sanitizers (ASan / UBSan) where available; run and record output.
- [x] Study stack growth via recursion depth experiment.
- [x] Write `notes/week-05.md` that teaches memory layout with my own logs.

---

## 📅 Daily tasks

### Day 1 — Memory layout
- Wrote `day-1-layout/layout.c` and ran it three times (captured in
  `run1.txt`, `run2.txt`, `run3.txt`).
- Confirmed:
  - `.text` and string literals at `~0x10…`
  - `.data` and `.bss` next to `.text` in the binary
  - `malloc` chunks in the `~0x6000…` range
  - stack locals in the `~0x30…` range, going **down** as we recurse
- README has a 5-region table and the layout diagram.

### Day 2 — Common heap bugs
- Wrote `leak.c`, `double_free.c`, `use_after_free.c`. Without tools,
  only the double-free was visible (Apple libc aborted). Leak and UAF
  ran "successfully" with silently-wrong behaviour.
- Added the macOS `leaks` tool — it found the leak with a full stack
  trace (`make leaks`).
- Added ASan to the same programs — it caught all three with exact
  line numbers.

### Day 3 — Sanitizers
- Wrote `day-3-sanitizers/all_bugs.c` (mixed) and `all_bugs_ubsan_only.c`
  (just the UBSan-detectable ones).
- ASan caught the heap-buffer-overflow at `all_bugs.c:14` with full
  shadow-byte report. UBSan caught signed integer overflow, shift
  too far, and null deref with one-line-per-bug diagnostics.
- The Makefile uses a narrower UBSan set
  (`signed-integer-overflow,shift,null,unreachable,vla-bound,object-size,…`)
  because the full `-fsanitize=undefined` enables `bounds`, which
  clashes with ASan's shadow memory.

### Day 4 — Stack growth via recursion
- Wrote `day-4-stack-growth/recursion.c` with two recursion knobs:
  `argc[1]` (the "show addresses" depth) and `argc[2]` (the "find
  the stack limit" depth).
- Observed the address going *down* by ~192 bytes per level on
  average (128-byte local + saved `%rbp` + return address).
- Found the failure boundary: depth=30 000 succeeds, depth=50 000
  crashes with SIGSEGV. macOS default main-thread stack is 8 MiB.

---

## 🛠️ Project structure
- `labs/year-1/week-05/day-1-layout/` — `layout.c`, `Makefile`, three `run*.txt` captures, `README.md`.
- `labs/year-1/week-05/day-2-bugs/` — `leak.c`, `double_free.c`, `use_after_free.c`, `Makefile`, `*.asan.txt`, `*.leaks.txt`, `README.md`.
- `labs/year-1/week-05/day-3-sanitizers/` — `all_bugs.c`, `all_bugs_ubsan_only.c`, `Makefile`, `*.asan.txt`, `*.ubsan.txt`, `*.both.txt`, `README.md`.
- `labs/year-1/week-05/day-4-stack-growth/` — `recursion.c`, `Makefile`, `stack.txt`, `out*.txt` crash captures, `README.md`.

## Deliverable
`week-05.md` (this file) + the per-day READMEs together teach the
memory layout with my own logs.
