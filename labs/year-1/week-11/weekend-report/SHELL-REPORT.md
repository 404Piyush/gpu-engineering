# Shell Report — the mini-shell build

A four-day build of `mini-shell`, a POSIX-ish command
interpreter in ~500 lines of C11.

## 1. What it does

- Simple commands:        `ls -la`
- Pipelines:              `ls | grep foo | wc -l`
- Input redirection:      `wc -l < README.md`
- Output redirection:     `ls > out.txt`     (truncate)
                          `ls >> out.txt`    (append)
- Background:             `sleep 5 &`
- Built-ins:              `exit [N]`, `cd [DIR]`

## 2. What it doesn't do

The following are *intentionally* missing to keep the
codebase small:

- No glob expansion (`*`).
- No variable expansion (`$HOME`).
- No quoting of any kind.
- No `;`, `&&`, `||`.  A line is a single pipeline.
- No job control: background jobs are fire-and-forget.

## 3. The recipe

The entire executor is 30 lines of code.  The key shape is:

```c
int prev_fd = -1;
for (i = 0; i < n_stages; i++) {
    int pipe_fd[2] = {-1, -1};
    if (i + 1 < n_stages) pipe(pipe_fd);
    pid_t pid = fork();
    if (pid == 0) {
        run_stage(&stages[i], prev_fd, pipe_fd[1]);
    }
    if (prev_fd >= 0) close(prev_fd);
    prev_fd = pipe_fd[0];
    if (pipe_fd[1] >= 0) close(pipe_fd[1]);
}
if (!background) wait for every child;
```

The three fds to remember:

- `prev_fd` — the read end of the *previous* pipe (or -1).
- `pipe_fd[0]` — read end of *this* pipe, becomes
  `prev_fd` for the next iteration.
- `pipe_fd[1]` — write end of *this* pipe, gets dup2'd
  in the child, must be closed in the parent.

## 4. The bug that bit me

The first time I forgot `close(prev_fd)` in the parent, my
`cat | head` test hung forever.  The kernel sends EOF only
when *all* references to the write end are gone, and the
parent was holding one open.  The fix is one line; the
diagnosis took 10 minutes.

## 5. The parser

`shell_parse()` does three passes:

1. **Strip a trailing `&`** and record it.
2. **Split on `|`** using `strchr`, *not* `strtok_r`.
   The reason: `strtok_r` silently drops empty trailing
   fields, which is exactly the syntax error we want to
   catch.
3. **Tokenize each stage** on whitespace, treating
   `<`, `>`, and `>>` as single-character metacharacters.

The parser is non-allocating: it stores pointers into a
local copy of the input line.

## 6. Built-ins

`try_builtin()` runs *after* redirection, inside the child.
This is a slightly unusual design (most shells do built-ins
in the parent for `cd` so the change persists), but it
makes the code uniform: every command, built-in or
external, is handled by the same `fork()+exec()` path.

## 7. Tests

`make test` runs 56 assertions across 13 test cases (8
parser, 5 executor).  All pass.

## 8. References

- `man 2 fork`, `man 2 pipe`, `man 2 dup2`, `man 3 exec`
- CS:APP §8.4 *Process control*
- Kerrisk, *The Linux Programming Interface*, Ch. 24–28
- The source code of `hoc` (Kernighan and Pike, *The Unix
  Programming Environment*, Ch. 1)
