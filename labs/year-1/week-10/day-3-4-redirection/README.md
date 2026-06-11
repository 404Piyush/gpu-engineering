# day-3-4 — redirection

`dup2(oldfd, newfd)` atomically closes `newfd` and copies `oldfd`
into its slot in the process's file-descriptor table.  This is
the only thing the shell ever does to implement `<` and `>`.

The recipe is the same every time:

1. `open()` the file (or `pipe()` for `|`).
2. `fork()`.
3. In the child, `dup2(3, 0)` or `dup2(4, 1)` so the new fd
   becomes stdin or stdout, then `close(3)` and `close(4)` to
   keep the fd table tidy.
4. `execvp()` — the new program inherits the redirected fds
   because fd tables are preserved across `exec`.
5. In the parent, `close()` the pipe/file fds you opened and
   `waitpid()` for the child.

If you forget step 5 in the parent, the read end of a pipe
never sees EOF and the consumer hangs forever.  This is the
single most common shell bug.

## Programs

| program       | what it shows                                    |
|---------------|--------------------------------------------------|
| `redir_run`   | run a command with `<` and `>` from the CLI     |
| `heredoc`     | push user-typed lines through a pipe to `wc`    |

## Build & run

```
make
./redir_run "wc -l" <Makefile >out.txt
cat out.txt

printf 'one\ntwo\nEOF\n' | ./heredoc
```

## Further reading

- `man 2 dup`
- `man 2 dup2`
- *The Linux Programming Interface* — Kerrisk, Ch. 5
- POSIX.1-2017 §2.6.1.4 *File Descriptor Redirection*
