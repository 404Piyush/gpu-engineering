# mini-shell

A POSIX-ish command interpreter in ~500 lines of C11.  Born
during week 11 of the gpu-engineering curriculum, this is the
capstone for the month-3 unit on the process model.

## Features

- Simple commands:        `ls -la`
- Pipelines:              `ls /usr/include | grep stdio | wc -l`
- Input redirection:      `wc -l < README.md`
- Output redirection:     `ls > out.txt`     (truncate)
                          `ls >> out.txt`    (append)
- Background:             `sleep 5 &`
- Built-in commands:      `exit [N]`, `cd [DIR]`

## Limitations (intentional, to keep it small)

- No glob expansion (`*`).
- No variable expansion (`$HOME`).
- No quoting of any kind (no `'`, `"`, `\`).
- No `;`, `&&`, `||`.  A line is a single pipeline.
- No job control: background jobs are fire-and-forget; you
  cannot `fg` or `bg` them.

## Build

```
make
```

This produces a single binary `mini-shell`.

## Run

Interactive:

```
./mini-shell
mini-shell$ echo hello world
hello world
mini-shell$ ls | head -3
Makefile
build
docs
mini-shell$ exit
```

One-shot:

```
./mini-shell --run "ls /etc | grep hosts"
./mini-shell --run "wc -l < Makefile" --show
```

The `--show` flag prints the parsed AST to stderr before
running the command (handy when debugging the parser).

## Test

```
make test
```

The test suite covers the parser (8 cases) and the executor
(5 cases) for a total of 46 assertions.

## Source layout

```
include/shell.h     public API (shell_parse, shell_run, etc.)
src/shell.c         parser + executor (library portion)
src/main.c          CLI entry point
tests/test_shell.c  test cases
tests/test_util.h   tiny zero-dependency test framework
```

## References

- `man 3 exec` (execvp), `man 2 fork`, `man 2 pipe`, `man 2 dup2`
- CS:APP §8.4 *Process control* and §10.9 *Other I/O topics*
- Kerrisk, *The Linux Programming Interface*, Ch. 24–28
- L.  Rosemblum and J. Ousterhout, *The Design and Implementation
  of a Log-Structured File System* — not directly relevant but
  the inspiration for the read-eval-print architecture
