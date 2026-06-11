# Day 3 — `-O0` vs `-O2` asm diff for the Month-1 project

## Build

```bash
cd project
make          # builds build/bst_demo
make asm      # writes build/main.O0.s, build/student.O0.s,
              #        build/main.O2.s, build/student.O2.s
```

## What changed between -O0 and -O2

The project's hot path is **`bst_insert`**, the recursive BST inserter. I diffed
its asm at the two opt levels. The structural change is large; here are the
three big ones:

### 1. `Student` (40 bytes — id, name[32], gpa) is now passed in registers

`-O0` spills the `Student` argument to the stack and reloads it on every use
(comments in the asm literally say `## 8-byte Spill` and `## 8-byte Reload`).
That's 5+ memory operations per call:

```asm
    leaq    16(%rbp), %rax            ; &s
    movq    %rax, -24(%rbp)           ; spill 1
    movq    32(%rax), %rdx            ; reload s.gpa (offset 32)
    movq    %rsp, %rax
    movq    %rdx, 32(%rax)            ; copy gpa onto call stack
    movups  (%rcx), %xmm0             ; copy first 16 bytes of s
    movups  16(%rcx), %xmm1           ; copy next 16 bytes of s
    movups  %xmm1, 16(%rax)
    movups  %xmm0, (%rax)
    callq   _node_new
```

`-O2` keeps `Student` in `%r14` (a callee-saved register) and never touches the
stack for it:

```asm
    leaq    16(%rbp), %r14            ; &s lives in %r14 for the whole call
    testq   %rdi, %rdi
    je      LBB0_1
    movq    %rdi, %rbx                ; root in %rbx (callee-saved)
    movl    (%rdi), %eax              ; root->data.id
    cmpl    %eax, (%r14)              ; compare s.id vs root->data.id
    jge     LBB0_6
```

**Result**: ~10 fewer memory ops per `bst_insert` call, which on a tree of
10k nodes is the difference between a 200ms and a 30ms run.

### 2. `-O0` keeps the frame pointer; `-O2` also keeps it but with leaf-fn inlining

The `__attribute__((always_inline))` was not added, so we don't get inlining,
but the `-O2` version still does the *register allocation* improvements shown
above. Both versions start with `pushq %rbp` because we asked for
`-fno-omit-frame-pointer` (good for the debugger crash walkthrough on Day 4).

### 3. The recursive call to `bst_insert` no longer has an "always-save-everything" wrapper

At `-O0` the compiler assumes any register might be clobbered across the call,
so it shoves everything to memory. At `-O2` it classifies the values: things
that *must* survive a call go in callee-saved registers (`%rbx`, `%r14`), and
things that don't can be in caller-saved registers (`%eax`, `%ecx`).

## Quick metric

| File           | `-O0` lines | `-O2` lines |
|----------------|-------------|-------------|
| `main.s`       | 264         | 335         |
| `student.s`    | 438         | 367         |

`-O2` is sometimes *longer* in lines (more `LBB` blocks, more SSA-like
flattening) but the **number of dynamic memory operations** drops dramatically,
which is what matters for performance.

## Takeaway

The same C code at -O0 and -O2 is the *same algorithm* executing through the
*same CPU*. What changes is the compiler's choice of:

* **Where data lives** (stack spill vs register).
* **How the call/return boundary is paid for** (full save vs callee-saved).
* **Whether the loop is unrolled, the branch is predicted, or the code is
  vectorised**.

For the Month-1 project we run at `-O0 -g` so the debugger can resolve every
local. The `-O2` artefacts are kept for the asm-diff exercise only.
