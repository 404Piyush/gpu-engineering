# Day 3–4 — Syscall tracing (`strace` / `dtruss`)

## What's in here

| File              | What it is |
|-------------------|------------|
| `trace_target.c`  | A tiny program whose syscalls (`open`, `read`, `close`, `getpid`, `exit`) are easy to identify in a trace. |
| `mini_strace.c`   | A self-contained `strace` clone built on `ptrace(2)`. Linux-only. |
| `strace_linux.sh` | Wrapper: `strace -f -e trace=openat,read,close,exit_group -- ./trace_target`. |
| `dtruss_macos.sh` | Wrapper: `sudo dtruss -f ./trace_target`. dtruss needs root. |

## Build & run

```bash
make
make run
```

## Sample output (Linux, `mini_strace`)

```
syscall(2) open
syscall(0) read
syscall(3) close
syscall(39) getpid
syscall(231) exit_group
+++ exited with 0 +++
```

`mini_strace` uses Linux's `ptrace(PTRACE_SYSCALL, ...)` to stop the
child at every syscall entry/exit, then reads the register state via
`PTRACE_GETREGS` to recover the syscall number. The same technique
is what real `strace` and `dtruss` use under the hood.

## Why macOS ptrace can't do this

macOS's `ptrace(2)` is intentionally limited: there's no
`PT_SYSCALL` request, no `PTRACE_GETREGS`, and no `PTRACE_O_TRACESYSGOOD`.
Apple's recommended path for syscall tracing is the DTrace-based
`dtruss` (in `/usr/bin/dtruss`) which runs as root, or `fs_usage`
for a less noisy view.

## Things to try

```bash
# Linux: see every syscall trace_target makes
strace -f -e trace=openat,read,close,exit_group,getpid -- ./trace_target /etc/hosts

# macOS: dtruss requires sudo
sudo dtruss -f ./trace_target /etc/hosts

# Bonus: profile by syscall count
strace -c ./trace_target /etc/hosts
```
