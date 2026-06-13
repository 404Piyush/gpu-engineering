# SHELL-REPORT — Syscalls of the mini-shell

Week 12, month-3 capstone rollup.  One page, per the
roadmap's "1-page report: syscalls used and why".

## How this was measured

The shell source (`src/shell.c`) is the ground truth.  Every
syscall in the executor is named at the call site; this
report reads them off and explains *why* each one is there.

A live trace was attempted with `dtruss` and `dtrace` but
macOS System Integrity Protection blocks both for
unprivileged users.  The accounting below is verified by
reading the source.

## Syscalls, in invocation order, for a 3-stage pipeline

```
$ ./mini-shell --run "ls /tmp | grep Mini | head -1"
```

| # | syscall     | where                | why                                     |
|---|-------------|----------------------|-----------------------------------------|
| 1 | `pipe(2)` × 2 | parent, before fork #1 and #2 | create the two pipes that wire the three children together |
| 2 | `fork(2)`   | parent, 3 times     | spawn one child per pipeline stage      |
| 3 | `open(2)`   | child 0, only if `<` redirect | open the input file for stdin      |
| 4 | `dup2(2)`   | each child          | wire the right pipe end / file fd onto fd 0/1/2 |
| 5 | `close(2)`  | each child          | release the source fds after dup2 (the new fds are duped) |
| 6 | `execve(2)` | each child          | replace the process image with the stage's program |
| 7 | `chdir(2)`  | child, if stage is `cd` | the only built-in that needs a syscall |
| 8 | `wait4(2)`  | parent, 3 times     | reap the children in order; the last wait returns the shell's exit status |

Plus the standard lib C wrappers that the children themselves
make once they start running (`read(2)`, `write(2)`, `close(2)`,
`stat(2)`, `mmap(2)`, `brk(2)`, etc.) — those are not the
shell's, they belong to the spawned program.

## What each syscall does in detail

### `pipe(2)`

Used to create the in-process channels between stages.
The parent calls `pipe(2)` N-1 times before forking, then
forks N times, then closes its own copy of every pipe end.
The kernel allocates an anonymous pipe (4 KiB on Linux,
16 KiB + 64 KiB on macOS) and returns two file descriptors:
the read end and the write end.

### `fork(2)`

One per pipeline stage.  After fork, parent and child are
nearly identical copies; they diverge when the child does
its `dup2`/`execve` dance.  The parent never execs; it
just closes fds and reaps.

### `open(2)`

Only called when the stage has a `< file`, `> file`,
`>> file`, `2> file`, or `2>> file` redirect.  Uses
`O_RDONLY` for stdin and `O_WRONLY|O_CREAT|{O_TRUNC|O_APPEND}`
for stdout/stderr.  Mode `0644` for new files.

### `dup2(2)`

The heart of the pipeline.  Each child does up to three
`dup2(2)` calls (one per redirect target).  The kernel
atomically closes the destination fd and copies the source
fd into its slot.  After `dup2(2)`, the source fd is
no longer needed and is `close(2)`d.

### `close(2)`

After `dup2(2)`, the source fd is dead.  Each child closes
the source fds it duped from, plus any pipe fds it doesn't
need (e.g. the write end of the *previous* pipe that the
parent still holds open).

The parent closes its copy of every pipe fd too — this is
the single most important `close(2)` in the whole shell.
If the parent leaks a write end, the next stage's
`read(2)` blocks forever because the kernel will not
generate EOF until *every* reference to the write end is
gone.

### `execve(2)`

The child's final act: replace the process image with the
program named in `argv[0]`.  The fd table is preserved
across `execve(2)`, which is why the `dup2(2)`s *before*
the exec are the ones that take effect.

If `execve(2)` fails, the child writes an error to stderr
and `_exit(127)`.  The parent sees the 127.

### `chdir(2)`

Only for the `cd` built-in.  We `chdir(2)` in the child
after fork so the parent's CWD is unchanged.

### `wait4(2)`

Foreground pipelines: the parent `wait4(2)`s every child in
order.  The exit status of the *last* child is the shell's
exit status.  Background pipelines (`cmd &`) skip the wait
entirely; the child is reparented to init.

## A 3-stage pipeline in syscalls

The shortest possible count for `cmd1 | cmd2 | cmd3` is
**22 syscalls**:

```
  1 pipe(2)              (parent, before stage 2 fork)
  1 pipe(2)              (parent, before stage 3 fork)
  3 fork(2)              (one per stage)
  3 close(2)             (parent, of pipe write ends it
                           forked with the child holding
                           the read end)
  3 wait4(2)             (parent, one per child)
 11 calls in the parent total

  3 close(2)             (each child, of pipe fds it
                           didn't dup2)
  3 execve(2)             (each child, replaces process)
  1 dup2(2)              (each child, at least once,
                           up to 4 times if all redirects
                           are file targets)
  3 dup2(2)              (each child, of the pipe read
                           end onto stdin)
  3 dup2(2)              (each child, of the pipe write
                           end onto stdout)
  3 close(2)             (each child, of the source fds)
  1 chdir(2)             (if a built-in)
 11 calls in the children total
```

Plus the child's own syscalls once it starts running
(`read`, `write`, `mmap`, `brk`, `stat`, etc.).  Those are
the child's program, not the shell.

## Per-stage close pattern (the v2 invariant)

Every child follows this five-step fd cleanup before
`execve(2)`:

1. `dup2(2)` the input source onto `STDIN_FILENO`
2. `dup2(2)` the output source onto `STDOUT_FILENO`
3. `dup2(2)` the stderr source onto `STDERR_FILENO` (if a
   redirect is specified)
4. `close(2)` every source fd that was dup2'd from
5. `close(2)` the previous pipe's write end (the parent
   still holds the read end; if we don't close our copy,
   the parent can never EOF)

After step 5, the only fds left open in the child are
0/1/2 (and any inherited fds the parent did not have the
FD_CLOEXEC flag on, which we don't set anywhere).

## What v2 adds over v1

v1 had 3 redirect kinds per stage (`<`, `>`, `>>`); v2 adds
two more (`2>`, `2>>`) and accepts up to 4 redirects per
stage.  The new syscalls are:

- `open(2)` for the errfile (when `2>` is specified)
- `dup2(2)` for the errfile onto `STDERR_FILENO`

The number of syscalls per pipeline is therefore up to
`22 + 2 × (number of stages with stderr redirect)`.
For most commands (`ls`, `grep`, `wc`) the increase is
zero — they don't redirect stderr.

## Lessons

- **The parent close is the bug magnet.**  Forgetting
  `close(prev_fd)` after fork is the single most common
  shell bug; the consumer's `read(2)` blocks forever.
- **`dup2(2)` is the atomic primitive.**  Doing `close +
  dup` is racy if the child runs between the two; `dup2`
  does it atomically.
- **`execve(2)` preserves fds.**  This is what makes the
  whole design work — the parent doesn't have to do
  anything special, the kernel keeps the table.

## References

- Kerrisk, *The Linux Programming Interface*, Ch. 44-46.
- McKusick & Neville-Neil, *The Design and Implementation
  of the FreeBSD Operating System*, Ch. 5 (process
  lifecycle).
- `man 2 fork`, `man 2 pipe`, `man 2 dup2`, `man 2 execve`.
