# Week 9: Processes (fork/exec/wait) + Tracing

This week was about the **process model** — how a Unix process is
born (`fork`), how it becomes a different program (`exec`), and
how its parent reaps it (`wait`). I read OSTEP Ch. 4–5 and CS:APP
§8.1–8.4.

---

## 🚀 Learning goals
- [x] Write demos using fork, exec, waitpid. Explain exit codes.
- [x] Trace syscalls of common tools (ls, cat, cp). Summarize what
      you see.
- [x] Write notes/week-09.md: process lifecycle and syscall patterns.

---

## 📅 Daily tasks

### Day 1–2 — fork / exec / wait
- Wrote `fork_demo.c` (run a child program, wait, report status).
- Wrote `fork_loop.c` (spawn N workers, each `echo`-ing a marker).
- Wrote `exit_codes.c` (reference for `exit` vs `raise` vs 128+N).
- See `day-1-2-fork-exec/README.md` for details.

### Day 3–4 — syscall tracing
- macOS doesn't ship a working `strace`; the canonical alternative
  is `dtruss` (DTrace, requires root) or `fs_usage` (less noisy).
- Wrote `mini_strace.c` — a 100-line `ptrace(2)`-based tracer for
  Linux that walks the child's registers on every syscall stop.
- Wrote `dtruss_macos.sh` and `strace_linux.sh` wrappers.
- See `day-3-4-strace/README.md` for details.

### Weekend — process-lifecycle report
- `weekend-report/PROCESS-REPORT.md` rolls up the four days into
  one document: lifecycle in code, exit codes I observed,
  tracing architecture, macOS vs Linux.

---

## 🛠️ Project structure
- `labs/year-1/week-09/day-1-2-fork-exec/` — three C programs +
  Makefile + README.
- `labs/year-1/week-09/day-3-4-strace/` — trace_target + mini_strace
  + dtruss/strace wrappers + README.
- `labs/year-1/week-09/weekend-report/PROCESS-REPORT.md` — the rollup.
- `notes/year-1/week-09.md` — this file.

## Takeaway

The Unix process model is tiny: `fork`, `exec`, `wait`, and
~5 macros for reading the status. Everything else — shells,
job control, daemons, containers — is built on top of those four.
The most useful debugging tool at this level is *strace* (or
*dtruss*), which uses `ptrace(2)` to intercept every syscall the
tracee makes. Writing a tiny strace clone is a great way to
internalise how it all works.
