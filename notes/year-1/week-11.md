# Week 11: Mini-Shell (Month-3 capstone, week 1)

A four-day build of a small but real command interpreter
in C.  The final binary is `mini-shell`; this week
produces both the source tree and the standalone project
repo `404Piyush/pipe-shell`.

---

## 🚀 Learning goals
- [x] Implement a recursive-descent parser for shell lines.
- [x] Implement the pipeline recipe (pipe+fork+dup2+wait).
- [x] Handle `<`, `>`, `>>` redirection.
- [x] Handle trailing `&` (background).
- [x] Implement at least two built-in commands.
- [x] Write a test suite covering parser and executor.
- [x] Make it interactive (REPL) and one-shot (`--run`).

---

## 📅 Daily tasks

### Day 1-2 — parser
- Designed the AST (`shell_cmd` with N stages of `shell_stage`).
- Implemented `shell_parse()` plus `tokenize_stage()`.
- 8 parser-only test cases (all pass).

### Day 3-4 — executor
- Implemented the general pipeline recipe in `shell_run()`.
- Implemented redirection handling in `run_stage()`.
- Implemented built-ins `exit` and `cd` in `try_builtin()`.
- 5 executor test cases (all pass).

### Weekend
- See `weekend-report/SHELL-REPORT.md` for the rollup.

---

## 🛠️ Project structure
```
labs/year-1/week-11/mini-shell/
  include/shell.h
  src/shell.c
  src/main.c
  tests/test_shell.c
  tests/test_counters.c
  tests/test_util.h
  docs/API.md
  docs/ARCHITECTURE.md
  Makefile
  README.md
notes/year-1/week-11.md     (this file)
```

The same source tree is mirrored to a standalone repo
`404Piyush/pipe-shell` so it can be shown off independently
of the curriculum.

## Takeaway

The most useful thing about this week was the realisation
that **every shell pipeline is the same shape**: a sequence
of `pipe() + fork() + dup2() + exec() + close()` calls.  The
parser is interesting, but the executor is mostly mechanical.
The only non-obvious detail is the rule about closing all
the parent-side pipe fds — get that wrong and the consumer
will hang forever.

`mini-shell` is also a good base to extend: adding job
control, history, or glob expansion is a 100–200 line
change on top of the existing structure.
