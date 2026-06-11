# Month 1 Report — Compilation Pipeline + Assembly + Crash Analysis

This is the Week 4 weekend deliverable. It rolls up everything from
Week 1 (compilation pipeline) and Week 3 (assembly) into a single
narrative, anchored by the BST project in `project/`.

## 1. Compilation pipeline (recap from Week 1)

| Stage | Tool | Output | What it does |
|---|---|---|---|
| Preprocess | `clang -E`        | `.i`  | Expands macros, copy-pastes headers |
| Compile    | `clang -S`        | `.s`  | C → target assembly (text) |
| Assemble   | `clang -c`        | `.o`  | Assembly → relocatable object |
| Link       | `clang` (no flag) | `a.out` / named binary | Resolves symbols across `.o` files and dylibs |

The Month-1 project uses all four stages:

```bash
cd project
make            # preprocess+compile+assemble+link    -> build/bst_demo
make asm        # stop after the "compile" stage      -> build/*.O0.s, build/*.O2.s
```

Look at `build/student.O0.s` vs `build/student.O2.s`. Same C, *very*
different assembly — the asm-diff README walks through three concrete
differences.

## 2. From C to running: a 5-step picture for `bst_find`

1. **Preprocess** `student.c` and `main.c` together. `student.h` is
   textually included. The preprocessor output is a single translation
   unit of ~10 000 lines.
2. **Compile** that translation unit to x86_64 assembly. Each C function
   becomes a labelled basic-block list with a prologue and an epilogue.
3. **Assemble** the two `.s` files into `main.o` and `student.o`. Each
   is a Mach-O relocatable object — its external references (`printf`,
   `malloc`, `free`) are still `U` (undefined).
4. **Link** them with `clang main.o student.o` (and the C runtime). The
   linker resolves `printf` to `libSystem.B.dylib` and `malloc` to the
   same. We get a single executable.
5. **Load + run**: `dyld` maps the executable into the process's address
   space, jumps to `main`, and the program starts executing. Stack is
   empty, heap is empty, the first `malloc` in `node_new` triggers the
   first `sbrk`/`mmap` from the OS.

## 3. Crash analysis: from `lldb` to root cause

The `crash-debug/` folder contains a step-by-step transcript of a
deterministic SIGSEGV (`*p` with `p = NULL`). The `mem-bug/` folder
shows what happens with a stack buffer overflow:

| Build | Input | Result |
|---|---|---|
| `overflow` (canary, FORTIFY on) | 32 bytes | `*** stack smashing detected ***`, exit 132 |
| `overflow_no_canary` (no canary, FORTIFY off) | 32 bytes | Return value `0x41` then SIGSEGV at random address, exit 139 |
| `overflow_no_canary` (no canary, FORTIFY off) | 8 bytes | Returns correctly, exit 0 |

The two together teach the layered defence: even if you forget to enable
the canary, FORTIFY_SOURCE catches the `strcpy` at the libc layer. Even
if you defeat both, the **return address is corrupted** and the program
crashes far from the bug — the worst kind of memory error to track down.

## 4. Self-test (theory) answers

> 1. Explain what happens when you run a C program from source to execution.

The source is preprocessed (macros and headers expanded), compiled to
assembly for the target architecture, assembled into a relocatable object
file, and linked with the C runtime and any other object files / libraries
into an executable. When you launch the executable, the dynamic linker
(`dyld` on macOS) maps it into a new process address space, transfers
control to the entry point (`start` in the C runtime), which initialises
the runtime, calls `main`, and exits via `exit` when `main` returns.

> 2. Draw a stack frame for a function call with local variables.

```
high address
  +---------------------------+
  | caller's frame            |
  |   ...callers' locals...   |
  +---------------------------+
  | return address            |  <-- pushed by `callq`
  +---------------------------+
  | saved %rbp                |  <-- callee's %rbp points here
  | callee's locals:          |
  |   int x   at -4           |
  |   int y   at -8           |
  |   ...                     |
  +---------------------------+  <-- callee's %rsp
low address
```

> 3. Explain how a buffer overflow can corrupt a return address.

The stack frame places the local buffer *below* the saved `%rbp` and
return address (because the stack grows down and the buffer is at the
lowest addresses of the frame). A write past the end of the buffer —
e.g. `strcpy(buf, too_long_string)` — overwrites first the canary (if
present), then the saved `%rbp`, then the return address. When the
function executes `retq`, the CPU pops the *corrupted* return address
and jumps to it. With a canary, the program aborts before `retq`. Without
a canary, the program transfers control to an attacker-chosen address.

## 5. Acceptance check

* [x] Working 100+ LOC C program pushed to GitHub. (`project/` = 175 LOC)
* [x] Annotated assembly with stack frame notes. (`project/build/*.O0.s`
      and `weekend-annotated/weekend.s` from Week 3.)
* [x] Crash/root-cause writeup. (`crash-debug/README.md`, `mem-bug/README.md`.)
* [x] Self-test answers saved. (Section 4 above.)
