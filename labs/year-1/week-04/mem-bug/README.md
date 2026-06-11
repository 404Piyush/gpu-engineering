# mem-bug — Stack overflow at the machine level

## Files

| File | What it does |
|---|---|
| `overflow.c`            | 8-byte stack buffer, 32-byte input → `strcpy` overflow. Compiled *with* the canary. |
| `overflow_no_canary.c`  | Same, but `__attribute__((noinline))` and we build it with `-fno-stack-protector` to see the corruption in raw form. |

## Build

```bash
cd mem-bug
clang -arch x86_64 -O0 -g -fno-stack-protector -D_FORTIFY_SOURCE=0 -o overflow_no_canary overflow_no_canary.c
clang -arch x86_64 -O0 -g                                             -o overflow            overflow.c
```

The `-D_FORTIFY_SOURCE=0` defeats a second Apple Clang safety net
(`__strcpy_chk` — a hardened libc function that knows the destination size
at compile time and aborts if the source is too long). We disable it here
*only* so the no-canary build still calls plain `strcpy`.

## The canary version (default clang behaviour)

```bash
$ ./overflow AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
*** stack smashing detected ***: terminated
zsh: abort (core dumped)  ./overflow AAAA...
exit 132 (= 128 + SIGILL, raised by the `ud2` after `__stack_chk_fail`)
```

Apple Clang inserts a stack canary: a 8-byte random value placed between the
buffer and the saved `%rbp` / return address. The canary is verified in the
function's epilogue; if it changed, `__stack_chk_fail` aborts the program
with an illegal instruction. This is the safety net that almost all modern
toolchains give you for free.

## The no-canary version

```bash
$ ./overflow_no_canary AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
first byte = 0x41
exit 139 (= 128 + SIGSEGV)
```

The function returns `0x41` because `buf[0]` is `'A'`, but its saved
`%rbp` and return address are corrupted. `ret` jumps to garbage and the
process is killed by SIGSEGV at a totally different instruction — a
classic "return address corruption". With a 16-byte input it can
sometimes limp through (the high bytes of the return address still
look like a valid address), but with 32 bytes the corruption is total.

## What the overflow looks like in memory

The `victim` stack frame (no canary build):

```
high address
  +----------------------------+
  | main's frame               |
  |    ...                     |
  +----------------------------+
  | return address (8 bytes)   |   <-- pushed by `callq _victim`
  +----------------------------+
  | saved %rbp (8 bytes)       |
  +----------------------------+
  | buf[0..7]  (8 bytes)       |   <-- our buffer
  +----------------------------+
low address (stack grows down)
```

`strcpy(buf, in)` writes left-to-right, low-to-high. So a 32-byte input
overflows `buf`, then the **saved `%rbp`**, then the **return address**, then
**main's locals**.

## Disassembly of the unsafe `strcpy` (no canary)

```asm
_victim:
    pushq   %rbp
    movq    %rsp, %rbp
    subq    $0x20, %rsp                ; 32 bytes of locals (only 8 used by buf!)
    movq    %rdi, -0x8(%rbp)           ; arg `in` at -8
    movq    -0x8(%rbp), %rdi           ; rdi = in
    leaq    -0x10(%rbp), %rsi          ; rsi = &buf[0]
    callq   _strcpy
    movsbl  -0x10(%rbp), %eax          ; return buf[0]
    addq    $0x20, %rsp
    popq    %rbp
    retq
```

Note `subq $0x20, %rsp` — clang reserved 32 bytes even though `buf` is only
8. That's a side effect of stack alignment + locals packing, not a real
defence. The first 8 of those 32 are `buf`; the next 8 are the saved `%rbp`;
the next 8 are the return address. `strcpy` happily writes past byte 8 and
into both of them.

## Takeaway

1. **With the canary** (default), the program self-aborts on overflow. You get
   a clear "stack smashing detected" message and a backtrace.
2. **Without the canary**, the program "works" until the return, then
   crashes at a random address — the worst kind of bug to debug.
3. **The fix at the C level is to never use `strcpy`.** Use `strlcpy`,
   `snprintf`, or copy with a known length. At the *machine* level, the
   fix is `-fstack-protector-strong` (Apple's default) or hardware shadow
   stacks on newer Intel/ARM CPUs.
