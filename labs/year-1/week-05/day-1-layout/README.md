# Day 1 — Memory layout: stack, heap, .data, .bss, .rodata, .text

## Build & run

```bash
make run       # run once
./layout       # raw
```

I ran it three times (saved in `run1.txt`, `run2.txt`, `run3.txt`).

## What I observed

Sample run (your numbers will differ every time — that's **ASLR**):

```
stack local (in main)  : 0x3052bb278
heap   malloc(64)      : 0x600003da01c0
function marker()      : 0x1007b5e00
stack local (in marker): 0x3052bb25c
global g_init (.data)  : 0x1007b7000
global g_zero  (.bss)  : 0x1007b7010
string literal         : 0x1007b5eb7
heap malloc(64)        : 0x600003da0200
```

### The 5 regions

| Region   | Where this run put it | Notes |
|----------|-----------------------|-------|
| **.text** (machine code)        | `0x1007b5e00` (function), `0x1007b5eb7` (literal) | Read-only, executable. `string literal` is in `.rodata` part of `__TEXT`. |
| **.data** (initialised globals) | `0x1007b7000` (`g_init`)   | Read-write, fixed size. |
| **.bss**  (zero-initialised)    | `0x1007b7010` (`g_zero`)   | Read-write, "Block Started by Symbol" — zero-filled by the loader. |
| **heap**  (malloc)              | `0x600003da01c0`, `…0200`   | Grows **upward**. Consecutive mallocs are 0x40 bytes apart — exactly 64. |
| **stack** (locals)              | `0x3052bb278` (in main), `0x3052bb25c` (in marker) | Grows **downward**. Marker's local is 0x1C bytes below main's local. |

### Why the order is what it is

On a 64-bit process (macOS / Linux), the virtual address space is divided:

```
low  0x0000_0000_0000  ─ unused (NULL-pointer guard page)
     ...
     0x0100_0000_0000  ─ .text / .data / .bss / .rodata
     ...
     0x6000_0000_0000  ─ heap (managed by malloc)
     ...
     0x3000_0000_0000  ─ stack (varies per ASLR)
     ...
     0x7FFF_FFFF_FFFF  ─ kernel / vsyscall
high
```

(Specifics vary by OS — on Linux the stack can be above the heap; on
macOS the heap is below the stack. The key invariant: text+data is in
the executable, heap and stack are per-process and ASLR-randomised.)

### Stack vs heap: how to recognise them

* **Stack**: addresses are very high (close to `0x7FFF...`), change by
  small amounts between functions, and go **down** as you call deeper.
* **Heap**: addresses are very different from the stack, allocated
  regions go **up** (the next `malloc` returns a higher address).
* The gap between them (often 0x9000_0000_0000 bytes = hundreds of GB
  on a 64-bit system) is unmapped — a stack overflow that jumps into
  the heap's region will SIGSEGV.

## What I want to internalise

* **`.data` and `.bss` live in the binary.** They have a fixed address
  modulo ASLR; their contents are initialised *once* when the process
  starts.
* **The stack is reset to zero on every function call.** Locals are
  uninitialised garbage (just whatever the previous frame had at that
  offset).
* **The heap survives across function calls** — that's why `malloc` /
  `free` exist. The price is fragmentation and the cost of `free` /
  bookkeeping.
* **`string literals` are in `.rodata`**. They are read-only. Writing to
  one (`char *p = "abc"; p[0] = 'X';`) is a runtime trap on macOS and
  a SIGSEGV on Linux.

## Why ASLR makes the exact numbers change

Each run, the kernel randomises the base of the stack and the heap.
`./layout` gives you different `0x30…` and `0x6000…` numbers each time,
but the **relative order** is invariant. ASLR is what stops a remote
attacker from hard-coding the address of your shellcode.
