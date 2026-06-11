# Week 10: Pipes, Redirection, Heredocs

The topic this week is **the three primitives every shell
needs**: anonymous pipes, file redirection, and heredocs.
Together they explain `cmd1 | cmd2`, `cmd < infile`,
`cmd > outfile`, and `cmd << EOF`.

I worked through OSTEP §39 and CS:APP §10.5–§10.8 first, then
sat down and wrote the four programs in `labs/`.  Below is the
narrative of what I learned and what surprised me.

---

## 🚀 Learning goals
- [x] Use `pipe(2)` to build a parent/child IPC.
- [x] Use `pipe(2)` + `dup2(2)` to build a 2-process pipeline
      equivalent to `ls /usr/include | wc -l`.
- [x] Use `dup2(2)` to implement `<` and `>` redirection.
- [x] Implement a heredoc with a pipe (not a temp file).
- [x] Write `notes/week-10.md` and a weekend rollup.

---

## 📅 Daily tasks

### Day 1-2 — pipes
- `pipe_through.c` writes 1 MiB through a pipe and reports
  bytes read + XOR checksum in the child.  Verifies the
  kernel is delivering every byte unchanged.
- `pipe_chain.c` is `ls /usr/include | wc -l` in pure C.  Two
  children, one pipe, parent does no I/O of its own.

### Day 3-4 — redirection
- `redir_run.c` is a tiny wrapper: parse a command line, open
  the input and output files, fork, dup2, execvp.  < 80 LOC.
- `heredoc.c` reads user input line-by-line, terminates on a
  marker, and pushes everything to `wc -l` through a pipe.

### Weekend
- See `weekend-report/IO-REPORT.md` for the rollup.

---

## 🛠️ Project structure
```
labs/year-1/week-10/
  day-1-2-pipes/
    pipe_through.c
    pipe_chain.c
    Makefile
    README.md
  day-3-4-redirection/
    redir_run.c
    heredoc.c
    Makefile
    README.md
  weekend-report/
    IO-REPORT.md
notes/year-1/week-10.md     (this file)
```

## Takeaway

`pipe(2)` and `dup2(2)` are the *only* syscalls a shell needs
to wire together processes.  After spending the week with
them, it becomes obvious why POSIX shells do it this way and
why the recipe is so consistent:

1. create the channel (pipe or open),
2. fork,
3. child: dup2 to stdin or stdout, close, exec,
4. parent: close, waitpid.

The 2nd item is non-obvious the first time: if you forget
`close()` in the parent, the consumer's `read(2)` will block
forever because the kernel will not generate EOF until
**every** reference to the write end is gone.  This is the
single most common shell bug, and I made it twice while
writing the demos.

The next step is `mini-shell` in week 11, which combines
parsing, redirection, and pipelines into one program.
