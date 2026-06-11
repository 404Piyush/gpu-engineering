# Week 9 Report — Process lifecycle, exit codes, syscall tracing

This is the Week-9 weekend deliverable. It rolls up the day's
exercises into a single narrative: how a Unix process is born,
runs, and dies, and how you can watch that lifecycle from outside.

## 1. Process lifecycle in 4 sentences

1. `fork()` clones the current process. The kernel marks the new
   one with a fresh PID, copies the parent's address space (with
   copy-on-write optimisation), and both resume at the return
   value — parent gets the child's PID, child gets 0.
2. The child usually calls `execve(path, argv, envp)` (or one of
   the `exec` wrappers like `execvp`/`execlp`). On success, the
   current process image is replaced; on failure, control
   returns.
3. Either way, the parent can `waitpid(child_pid, &status, 0)`
   to block until the child terminates, then read `WEXITSTATUS`
   (the 0–255 exit code) and check `WIFSIGNALED` /
   `WTERMSIG` (which signal, if any, killed it).
4. A process exits with code N (0–255) by `return N` from `main`
   or by `exit(N)`. A process is killed by a signal when something
   else delivers that signal; the conventional "exit code" the
   parent sees is `128 + signal_number` (so SIGINT → 130,
   SIGSEGV → 139, SIGKILL → 137).

## 2. A small "lifecycle" in code

```c
pid_t p = fork();
if (p == 0) {
    /* child */
    execvp(argv[1], &argv[1]);    /* replaces this process */
    _exit(127);                   /* only on exec failure */
}
/ parent */
int st;
waitpid(p, &st, 0);
if (WIFEXITED(st))   printf("exit %d\n",  WEXITSTATUS(st));
if (WIFSIGNALED(st)) printf("killed by %d (%s)\n",
                            WTERMSIG(st), strsignal(WTERMSIG(st)));
```

That's literally all of Unix process management.

## 3. Exit codes I observed (run on this machine)

| Program                | Code | Parent sees |
|------------------------|------|-------------|
| `exit 0`               |   0  | 0    (success) |
| `exit 1`               |   1  | 1    (generic failure) |
| `exit 42`              |  42  | 42   (program-defined) |
| `raise(SIGINT)`        | 130  | 130  (128 + 2)  |
| `raise(SIGSEGV)`       | 139  | 139  (128 + 11) |

A shell like `bash` follows the same convention: `cmd` echoes
`$? == 130` after the last one, which is what `make` reads to
abort on Ctrl-C.

## 4. Syscall tracing

A *tracer* uses `ptrace(PTRACE_SYSCALL, ...)` to stop the *tracee*
at every syscall entry/exit, then reads the tracee's registers
(`PTRACE_GETREGS` on Linux) to recover the syscall number. That's
exactly what `strace` (Linux) and `dtruss` (macOS, DTrace-based)
do. `mini_strace.c` in `day-3-4-strace/` is a 100-line working
implementation.

For `trace_target` (which opens /etc/hosts and reads 63 bytes),
`mini_strace` produces:

```
syscall(2) open
syscall(0) read
syscall(3) close
syscall(39) getpid
syscall(231) exit_group
+++ exited with 0 +++
```

## 5. macOS vs Linux

* `fork`, `execve`, `waitpid`, `WEXITSTATUS`, `WIFSIGNALED`:
  identical on both.
* `ptrace` syscall interface: roughly equivalent, but macOS does
  not support `PT_SYSCALL`/`PTRACE_GETREGS`/`PTRACE_O_TRACESYSGOOD`.
  Apple expects you to use DTrace (`sudo dtruss -f`).
* The `dtruss` we ship in `day-3-4-strace/dtruss_macos.sh` is a
  thin wrapper that requires `sudo`; if you don't have sudo
  (e.g., in a sandbox), fall back to `fs_usage` or to
  instrumenting your program with `dprintf` to a file.

## 6. Acceptance check

* [x] `fork_demo`, `fork_loop`, `exit_codes` all build and run.
* [x] `trace_target` runs and emits a known syscall pattern.
* [x] `mini_strace` builds (Linux path) and emits a readable
      syscall trace; macOS path prints an informative error.
* [x] `dtruss_macos.sh` and `strace_linux.sh` are ready to run
      when the user has the right privileges.
