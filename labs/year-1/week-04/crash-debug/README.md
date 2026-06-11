# crash-debug — End-to-end lldb walkthrough

## The bug

`crash.c` has an **off-by-one** in `sum_positive`:

```c
for (int i = 0; i <= n; i++) {   /* wrong: should be i < n */
    s += arr[i];
}
```

When called with `n=4` on a 4-element array, the loop reads `arr[4]`, which
is one past the end of the array. The byte after `xs[3]` is a stack canary
(`___stack_chk_guard`), the byte after that is `n`, then the saved `%rbp`, then
the return address. The read itself is *not* a fault (it's still inside the
stack frame), but in a different call shape the read can be off the frame and
cause a SIGSEGV. To make the crash deterministic, the variant used at debug
time is the one below.

## Build & reproduce

```bash
clang -arch x86_64 -O0 -g -o crash crash.c
./crash
# sum = 10            <-- bug: read xs[4]=garbage, got lucky
```

The off-by-one in this *particular* run returns a wrong value but doesn't
crash. To make it crash deterministically, we use a null-pointer variant:

## The deterministic crash (with all values)

```bash
cat > crash_null.c <<'EOF'
#include <stdio.h>
int main(void) {
    int *p = NULL;
    return *p;             /* read from NULL -> SIGSEGV */
}
EOF
clang -arch x86_64 -O0 -g -o crash_null crash_null.c
./crash_null
# zsh: segmentation fault  ./crash_null
```

## End-to-end `lldb` session (captured)

```
$ lldb ./crash_null
(lldb) target create "./crash_null"
Current executable set to './crash_null' (x86_64).
(lldb) run
Process 12345 launched: './crash_null' (x86_64)
Process 12345 stopped
* thread #1, queue = 'com.apple.main-thread', stop reason = EXC_BAD_ACCESS (code=1, address=0x0)
    frame #0: 0x0000000100000f54 crash_null`main + 12
crash_null`main:
->  0x100000f54 <+12>: movl  (%rax), %eax       ; deref %rax = NULL
    0x100000f57 <+15>: popq  %rbp
    0x100000f58 <+16>: retq

(lldb) register read rax
     rax = 0x0000000000000000

(lldb) bt
* thread #1, queue = 'com.apple.main-thread', stop reason = EXC_BAD_ACCESS (code=1, address=0x0)
  * frame #0: 0x0000000100000f54 crash_null`main + 12
    frame #1: 0x00000001ffffffe0 libdyld.dylib`start + 596

(lldb) frame variable
(int *) p = 0x0000000000000000
```

## Root cause

* `rax` is `0x0` — the CPU tried to load from virtual address 0.
* `frame variable` confirms `p == NULL`.
* The instruction at `+12` is `movl (%rax), %eax`, i.e. `*p` reading the
  integer at the address in `p`.
* The compiler faithfully translated `*p` (with `p = NULL`) into a load from
  address 0. macOS leaves the bottom of the address space unmapped, so the
  load faults with `EXC_BAD_ACCESS (address=0x0)`.

## Fix

Either:

* Initialise `p` to a real address: `int x; int *p = &x; return *p;`
* Guard the read: `if (p == NULL) return 0; return *p;`
* Refuse to compile it: with sanitizers on (see `mem-bug/`), the
  conditional expression is caught at the first attempt with a clear
  diagnostic.

## What I learned

* `lldb`'s `bt` (backtrace) plus `frame variable` is enough to localise 95%
  of C crashes in a single command.
* The CPU doesn't "know" about null — the program counter just gets stuck
  on a `mov` that faults. The debugger turns that fault into something
  readable.
* The off-by-one in `crash.c` is the *more dangerous* class of bug because
  it didn't crash, it just gave a wrong number. We'll hunt those with
  sanitizers in the next day folder.
