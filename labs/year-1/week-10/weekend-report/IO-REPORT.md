# IO Report — pipes, redirection, heredocs

A four-day survey of the three primitives that every Unix
shell builds on.

## 1. `pipe(2)`

Creates a kernel buffer with two file descriptors: a read end
and a write end.  Bytes written to the write end appear on the
read end, in order, until every reference to the write end is
closed.  When that happens, `read(2)` returns 0 — the EOF
signal that lets the reader exit its loop.

Capacity is 64 KiB on Linux by default; writes either block
or fail with `EAGAIN` if `O_NONBLOCK` is set.

## 2. `dup2(2)` and redirection

`dup2(oldfd, newfd)` atomically closes `newfd` and copies
`oldfd` into its slot.  This is the only syscall you need for
`<` and `>`:

1. open the file,
2. fork,
3. child: `dup2(3, 0)` (or `dup2(3, 1)`), close(3), exec,
4. parent: close(3), waitpid.

The fd table is preserved across `exec`, so the new program
inherits the redirected stdin/stdout transparently.

## 3. Heredocs

A heredoc is just a pipe, not a temp file.  Read user input
line-by-line, terminate on a marker, and `write(2)` everything
into the write end.  The consumer sees EOF when the parent
closes.

A temp-file heredoc works but is slower, touches the disk,
and clutters `/tmp` if the script crashes.

## 4. The most common bug

Forgetting `close()` on the parent's copy of a pipe fd makes
the consumer hang forever.  Symptoms: a shell that prints
nothing and never returns.  Cause: the kernel only sends EOF
when **all** references to the write end are gone.

## 5. The full pipeline recipe

```
ls /usr/include | wc -l
```

becomes:

```c
int fd[2]; pipe(fd);
if (fork() == 0) {                /* child 1: ls */
    close(fd[0]);
    dup2(fd[1], 1);
    close(fd[1]);
    execlp("ls", "ls", "/usr/include", NULL);
}
if (fork() == 0) {                /* child 2: wc */
    close(fd[1]);
    dup2(fd[0], 0);
    close(fd[0]);
    execlp("wc", "wc", "-l", NULL);
}
close(fd[0]); close(fd[1]);       /* parent: drop pipe refs */
wait(NULL); wait(NULL);
```

This pattern is repeated for every pipeline the user types.

## 6. References

- `man 2 pipe`, `man 2 dup`, `man 7 pipe`
- OSTEP Ch. 39 *Interlude: Files and Directories*
- CS:APP §10.5–§10.8 *ECF: I/O Multiplexing*
- Kerrisk, *The Linux Programming Interface*, Ch. 5 and 44
