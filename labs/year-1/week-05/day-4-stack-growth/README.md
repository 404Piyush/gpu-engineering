# Day 4 — Stack growth via recursion

## Build & run

```bash
make recursion
./recursion 20000 > stack.txt 2>&1
head -5 stack.txt
tail -5 stack.txt
```

The program recurses `depth` times, allocating 128 bytes of local
storage per call. At every 1000th level it prints the address of one
local. We can then **watch the address go down** as the stack grows.

## What I observed

```
recursing to depth 20000, ~128 bytes of stack per level
leaf local   = 0x30c1a4990
depth=1000    local = 0x30c1d3790
...
depth=19000   local = 0x30c51f390
depth=20000   local = 0x30c54e190
returned
```

Two things to notice:

1. **The address goes down** as `depth` decreases (i.e. *deeper* calls
   are at *lower* addresses). The stack grows **downward**, toward
   lower addresses. This is the opposite of how a heap grows
   (Day 1: consecutive `malloc` returned *higher* addresses).

2. **The gap between depth=1000 and depth=2000 is 0x30c54e190 - 0x30c51f390
   = 0x2EE00 = 192 512 bytes** — which is 1000 levels × ~192 bytes
   per level. That's the 128-byte buffer plus the saved `%rbp`, the
   return address, and other locals/alignment.

## Why this matters

* **Each thread has a fixed-size stack** (default 8 MB on macOS,
  2 MB on Linux for the main thread). Recurse too deep and you get
  `EXC_BAD_ACCESS` from hitting the guard page.
* **Stack is per-thread, not per-process.** A program that spawns
  1000 threads must multiply its per-thread stack by 1000 to know
  total memory cost.

## Try it

```bash
./recursion 0 30000   # returns OK
./recursion 0 50000   # SIGSEGV
```

The kernel kills it. macOS's default main-thread stack is 8 MiB; with
~192 bytes per frame (128-byte local + overhead) you can recurse on
the order of **30 000 deep** before the guard page triggers. Between
30 000 and 50 000 is the failure boundary on this machine — exactly
the kind of number you only learn by running.
