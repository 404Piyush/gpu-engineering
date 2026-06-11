# Week 10: Pipes, Redirection, Heredocs

A week spent on the three things every Unix shell has to get
right: anonymous pipes for `cmd1 | cmd2`, file redirection for
`<` and `>`, and heredocs for batch input.

## Programs

```
day-1-2-pipes/
    pipe_through.c   one-pipe IPC, parent writes / child reads
    pipe_chain.c     two-process pipeline emulating `ls | wc -l`
    Makefile
    README.md
day-3-4-redirection/
    redir_run.c      CLI wrapper: redir_run "CMD" <IN >OUT
    heredoc.c        interactive heredoc feeding `wc -l`
    Makefile
    README.md
weekend-report/
    IO-REPORT.md     the rollup
```

## Build

```
cd day-1-2-pipes        && make && cd ..
cd day-3-4-redirection  && make && cd ..
```

## Takeaway

- `pipe(2)` is just two fds and a kernel buffer; the protocol
  ends when every write end is closed.
- `dup2(old, new)` is the *only* syscall you need for
  redirection.  It is the heart of every shell.
- A heredoc is a pipe, not a file.  The temp-file approach
  works but is slower and clutters `/tmp`.
- Forgetting to `close()` a pipe fd in the parent is the
  single most common bug.  Symptoms: the consumer hangs.

## See also

- `notes/year-1/week-10.md` for the journal.
- The week-11 project, **mini-shell**, that builds on all of
  the above: it parses a one-line command, handles `<` and `>`,
  and runs the result through a `fork` + `exec` pipeline.
