# Day 2 — Common heap bugs: leak, double-free, use-after-free

## Build

```bash
cd day-2-bugs
make
```

This produces three executables. Run them. They will *appear* to work —
the OS reclaims memory on exit, and double-free / UAF often don't crash
on a clean allocator. **The point of this day is that the bugs are
silent without a tool** — sanitizers will catch them in Day 3.

## 1. Memory leak — `leak.c`

```c
void make_a_leak(void) {
    int *p = malloc(16 * sizeof(int));
    /* never free(p) */
}
```

* **Symptom (no tool)**: nothing visible. The process exits and the
  OS reclaims everything.
* **Detected by macOS `leaks`**: `make leaks` runs Apple's `leaks` tool.
  Truncated output (`leak.leaks.txt`):
  ```
  Process 56772: 185 nodes malloced for 11 KB
  Process 56772: 3 leaks for 240 total leaked bytes.
  STACK OF 1 INSTANCE OF 'ROOT LEAK: <malloc in make_a_leak>':
  3   dyld                                  0x...  start + 1909
  2   leak                                  0x...  main + 20           leak.c:16
  1   leak                                  0x...  make_a_leak + 18    leak.c:9
  0   libsystem_malloc.dylib                 0x...  _malloc_zone_malloc_instrumented_or_legacy + 114
  ====
      1 (80 bytes) ROOT LEAK: <malloc in make_a_leak 0x7fcb670040f0> [80]
  ```
  `leaks` not only tells you the byte count (3 leaks × 80 bytes) but
  gives you the **full call stack** of the allocation site, so you
  can find and fix it.
* **Detected by ASan LeakSan**: `ASan -fsanitize=leak` works on Linux
  and even macOS, but Apple's ASan build does *not* ship with LeakSan
  enabled. Use `leaks` on macOS.
* **Symptom (long-running process)**: RSS grows. `top` shows it.
* **Why it matters in real code**: in a server, the leak is per-request,
  so the process eventually OOMs.
* **Fix**: `free(p)` before return. Better: pass ownership out of the
  function and let the caller `free`.

## 2. Double free — `double_free.c`

```c
free(p);
free(p);   /* BUG */
```

* **Symptom (no tool)**: Apple's libc prints
  `malloc: *** error for object 0x...: double free` and aborts. Other
  libcs silently corrupt the free-list and crash much later with a
  confusing backtrace.
* **Detected by ASan**: `make asan` runs `./double_free_asan` and
  writes `double_free.asan.txt`:
  ```
  ==NNNN==ERROR: AddressSanitizer: attempting double-free on 0x603000001b40
      #0 wrap_free+0xa9    (libclang_rt.asan_osx_dynamic.dylib)
      #1 main double_free.c:17
  freed by thread T0 here:
      #0 wrap_free+0xa9
      #1 main double_free.c:16
  previously allocated by thread T0 here:
      #0 wrap_malloc+0xa0
      #1 main double_free.c:12
  ```
  ASan gives the **second** free's location, the **first** free's
  location, and the **original** allocation's location. Three exact
  line numbers — usually all you need.
* **Root cause**: free-list integrity. The free list is a linked list
  hidden inside the chunk; freeing twice means the same chunk is in
  the list twice, and the next `malloc` may return the same address
  twice, leading to corruption.
* **Fix**: set `p = NULL` after `free`. The C standard says `free(NULL)`
  is a no-op, so a stray second `free` becomes harmless.

## 3. Use-after-free — `use_after_free.c`

```c
free(p);
char *q = malloc(16);
printf("%s\n", p);   /* dangling read */
p[0] = 'X';          /* dangling write */
```

* **Symptom (no tool)**: prints `second allocation` (the heap re-used
  `p`'s slot for `q`), and silently corrupts `q`. The program may
  then crash when `q` is used.
* **Detected by ASan**: `make asan` runs `./use_after_free_asan` and
  writes `use_after_free.asan.txt`:
  ```
  ==NNNN==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x6020000000a0
  WRITE of size 17 at 0x6020000000a0 thread T0
      #0 wrap_strcpy+0x4c4
      #1 main use_after_free.c:13
  0x6020000000a0 is located 0 bytes after 16-byte region
  allocated by thread T0 here:
      #0 wrap_malloc+0xa0
      #1 main use_after_free.c:12
  ```
  ASan re-uses the freed slot for `q`, marks the slot as "freed"
  with shadow bytes `fd fd fd fd`, and trips the moment you write
  past the end of `q`. The message names the line number of the
  write and the line of the original malloc.
* **Fix**: don't keep the pointer. If you need to keep a handle,
  use a small struct that owns the pointer, or move the work before
  `free`.

## The lesson

Three different bugs, three different shapes:

| Bug              | Visible without tool? | Damage |
|------------------|----------------------|--------|
| leak             | only over time       | RSS growth, eventual OOM |
| double-free      | sometimes            | free-list corruption, crash far from bug |
| use-after-free   | rarely               | silent data corruption, crash far from bug |

In all three cases the **fix is at the C level** (don't forget to free,
set to NULL, don't use after free). The tool's job is to *tell you
where the bug is* so you can fix it. Day 3 turns the tools on.
