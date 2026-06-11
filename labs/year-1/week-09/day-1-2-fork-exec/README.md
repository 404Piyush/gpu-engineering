# Day 1–2 — fork / exec / wait

## Build & run

```bash
make
make run
```

## What's in here

* `fork_demo.c` — minimal "run a child program, wait for it, print
  its exit status".  Try: `./fork_demo /bin/echo hi`,
  `./fork_demo /bin/ls /tmp`, `./fork_demo /bin/false`.
* `fork_loop.c` — fork N children, each `echo`-ing "child-i", then
  reap them in order.  Demonstrates the "spawn N workers, wait for
  all" pattern.
* `exit_codes.c` — reference for what POSIX exit codes mean and
  how they show up in the parent (WEXITSTATUS, WIFSIGNALED, etc).

## Things to try

```bash
./fork_demo /bin/sleep 2
./fork_demo /bin/sh -c 'exit 42'
./fork_demo ./exit_codes 130
```

The last one exits with `128+2 = 130`, which is the conventional
"killed by SIGINT" code, even though we used `raise(SIGINT)`
internally rather than actually receiving the signal from a
terminal.

## Key syscalls

| Syscall   | What it does |
|-----------|--------------|
| `fork()`  | Create a child process. Returns child PID in parent, 0 in child. |
| `execvp()`| Replace current process image with a new program. Only returns on failure. |
| `waitpid()`| Block until a specific child (or any) terminates. Reports status. |
| `WEXITSTATUS(s)` | Extract the exit code (0–255) from a `wait()` status. |
| `WIFSIGNALED(s)` | Did the child die from a signal? |
| `WTERMSIG(s)`     | Which signal killed it? |
