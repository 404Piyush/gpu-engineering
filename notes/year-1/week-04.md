# Week 4: Month 1 Project + Self-Test

This week is the **capstone** of Month 1. I took the BST (binary search
tree) project from "Day 1–2: 100+ LOC multi-file C" through to a crash
walkthrough and a stack-overflow demonstration, then wrote the
Month-1 report that ties it all together.

---

## 📅 Daily tasks

### Day 1–2 (6h) — 100+ LOC C program
- Built a small BST library in `project/`. Two source files (`student.c`,
  `main.c`) plus a header (`student.h`) — uses **recursion** (`bst_insert`,
  `bst_find`, `bst_height`, `bst_count_leaves`, `bst_inorder`),
  **arrays** (the `sorted[16]` output buffer), **structs** (`Student`,
  `Node`, `Stats`), **pointers** (everywhere), and a `Makefile` that drives
  the full pipeline.
- `make` builds `build/bst_demo`; `make run` runs it. Total LOC = 175.
- Run output (truncated):
  ```
  Dataset size    : 10
  Tree height     : 4
  Leaf count      : 5
  Stats           : count=10 avg=3.56 min=3.00 max=3.95
  In-order (sorted by id):
    id=1   name=Anaya    gpa=3.80
    ...
  Lookups:
    id=1 FOUND -> Anaya (gpa 3.80)
    ...
    id=99 NOT FOUND
  ```

### Day 3 (4h) — `-O0` vs `-O2` asm diff
- Generated `build/main.O0.s`, `build/main.O2.s`, `build/student.O0.s`,
  `build/student.O2.s`. Wrote `asm-diff/README.md` with three concrete
  differences:
  1. `Student` (40 bytes) gets passed in registers at `-O2` (callee-saved
     `%r14`) instead of stack-spilled at `-O0`.
  2. Recursive call boundary gets cheaper: register classification
     means only `%rbx`/`%r14` need to survive, not all locals.
  3. Line count sometimes goes *up* at `-O2` (more `LBB` blocks) while
     dynamic memory ops drop dramatically.

### Day 4 (3h) — Crash walkthrough
- Wrote `crash-debug/crash.c` (off-by-one in `sum_positive`) and
  `crash-debug/crash_null.c` (deterministic null deref). Used `lldb` to
  capture a full transcript: `register read rax` shows `%rax == 0x0`,
  `bt` shows the failure is in `main + 12`, and `frame variable` shows
  `p == NULL`. Root cause: `int *p = NULL; return *p;` — the compiler
  faithfully turns `*p` into a load from address 0, which is unmapped
  on macOS and faults with `EXC_BAD_ACCESS (code=1, address=0x0)`.

### Day 5 (2h) — Intentional stack overflow
- `mem-bug/overflow.c` is a `strcpy` into an 8-byte buffer. With
  Apple's defaults (canary + FORTIFY) it aborts with
  `*** stack smashing detected ***`.
- `mem-bug/overflow_no_canary.c` is the same but built with
  `-fno-stack-protector -D_FORTIFY_SOURCE=0`. The function returns
  `0x41` (the first byte) but the saved `%rbp` and return address are
  corrupted, and the program then dies with SIGSEGV at a random
  address.
- The `README.md` includes a stack frame diagram showing exactly
  which bytes are overwritten in what order.

### Weekend (6–8h) — Month-1 report
- `month1-report/MONTH-1-REPORT.md` is the rollup. It contains:
  1. Compilation pipeline table (recap from Week 1).
  2. Five-step "source to running" for `bst_find`.
  3. Crash analysis from the Day 4 and Day 5 walkthroughs.
  4. Self-test answers (3 theory questions).
  5. Acceptance-criteria checklist.

---

## 🛠️ Project structure
- `labs/year-1/week-04/project/` — multi-file BST program (175 LOC).
- `labs/year-1/week-04/asm-diff/` — `-O0` vs `-O2` writeup.
- `labs/year-1/week-04/crash-debug/` — `crash.c`, `crash_null.c`, lldb transcript.
- `labs/year-1/week-04/mem-bug/` — `overflow.c`, `overflow_no_canary.c`, writeup.
- `labs/year-1/week-04/month1-report/MONTH-1-REPORT.md` — the capstone.

## Acceptance criteria
* [x] Working 100+ LOC C program pushed to GitHub — `project/`, 175 LOC.
* [x] Annotated assembly with stack frame notes — `project/build/*.O0.s` + Week-3 `weekend-annotated/`.
* [x] Crash/root-cause writeup — `crash-debug/README.md` + `mem-bug/README.md`.
* [x] Self-test answers saved — `month1-report/MONTH-1-REPORT.md` §4.
