# Changelog

All notable changes to this curriculum repo.

## 2026

### June

- Cleaned up top-level docs: simpler README, PROJECTS.md,
  DEPLOY.md, DNS.md, CHANGELOG.md, LICENSE.
- Each standalone project (bst-library, arena-allocator,
  pipe-shell) now has a static site at
  `*.404piyush.me` deployed via Netlify.
- v1.0.0 release on each standalone project.
- Topics, description, and homepage set on each standalone
  repo.

### Week 11 — mini-shell

- `labs/year-1/week-11/mini-shell/`: full POSIX-ish shell
  source tree (parser, executor, tests, docs, CI).
- 404Piyush/pipe-shell standalone repo.

### Week 10 — pipes and redirection

- `labs/year-1/week-10/day-1-2-pipes/`: `pipe_through.c`,
  `pipe_chain.c`.
- `labs/year-1/week-10/day-3-4-redirection/`: `redir_run.c`,
  `heredoc.c`.

### Week 9 — fork / exec / wait

- `labs/year-1/week-09/day-1-2-fork-exec/`: `fork_demo.c`,
  `fork_loop.c`, `exit_codes.c`.
- `labs/year-1/week-09/day-3-4-strace/`: `mini_strace.c`,
  `trace_target.c`, dtruss/strace wrappers.

### Week 8 — custom allocator

- 404Piyush/arena-allocator standalone repo (bump arena).

### Week 7 — virtual memory

- `labs/year-1/week-07/`: working-set and page-fault
  measurement tools.

### Week 6 — memory debugging tooling

- `labs/year-1/week-06/`: valgrind and asan worked examples.

### Week 5 — stack vs heap

- `labs/year-1/week-05/`: layout diagrams, common bugs.

### Week 4 — BST capstone

- 404Piyush/bst-library standalone repo.

### Week 3 — assembly and calling convention

- `labs/year-1/week-03/`: disassembly, calling-conv
  analysis, stack-frame walkthrough.

### Week 2 — structs and lifetimes

- `labs/year-1/week-02/`: struct layout, alignment, padding
  exercises.

### Week 1 — pointers and strings

- `labs/year-1/week-01/`: pointer and string exercises.
