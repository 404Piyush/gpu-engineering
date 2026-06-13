# week-12 — mini-shell v2 + syscall report

The Month-3 capstone, second half: harden the v1 shell
with arbitrary-length pipelines (already in v1), robust
redirection with **multiple redirects per stage**
(including the new `2>` / `2>>` for stderr), and a
1-page syscall report.

## What changed since week 11

- **Public header** (`include/shell.h`): added `errfile`
  and `err_append` to `shell_stage`.  The shape is
  identical to v1 — no breaking changes to the AST for
  existing users.
- **Parser** (`src/shell.c`): recognises `2>`, `2>>`, and
  the explicit `1>` / `1>>` (which mean the same as `>` /
  `>>`).  Multiple redirects per stage are accepted
  (`cmd < in > out 2> err`).
- **Executor** (`src/shell.c`): opens the errfile (if
  any), `dup2(2)`s it onto fd 2 in the child, and closes
  the source fd.  Same for the explicit `1>` form.
- **Test suite**: 5 new test cases for stderr / multi-redirect.
  Total now **62 assertions, 17 cases, all passing**.

## What I did

| Day | Hours | What |
|-----|------:|------|
| Day 1-2 | 4-6h | `1>`, `1>>`, `2>`, `2>>` in the parser; multiple redirects per stage |
| Day 3-4 | 4-6h | errfile handling in the executor; 5 new test cases |
| Day 5   | 2-3h | Full suite runs; fix 1> edge case in the word tokenizer |
| Weekend | 6-8h | Syscall report (this file's sibling) |

## Build and test

```sh
cd mini-shell
make test
# 62 passed, 0 failed
```

## See also

- `mini-shell/README.md` for the project layout.
- `weekend-report/SHELL-REPORT.md` for the 1-page syscall
  write-up.
- `notes/year-1/week-12.md` for the journal.
- [pipe-shell](https://github.com/404Piyush/pipe-shell) for
  the standalone v1.  v2 features will roll in there next.

## Acceptance criteria (from the roadmap)

- [x] Shell passes script tests (62 assertions, 17 cases)
- [x] README explains syscalls and examples
      (`weekend-report/SHELL-REPORT.md`)
- [x] Multiple redirects per stage (4 max)
- [x] stderr redirect (both truncate and append)
- [x] Edge cases: bare `>` rejected as parse error
