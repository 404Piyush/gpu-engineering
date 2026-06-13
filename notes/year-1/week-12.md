# Week 12: Mini Shell v2 + Write-up

The Month-3 capstone, second half.  V1 was a clean parser +
executor for `<`, `>`, `>>`, and arbitrary-length pipelines.
V2 adds:

- `2> FILE` and `2>> FILE` for stderr redirect.
- Multiple redirects per stage: `cmd < in > out 2> err`.
- Explicit `1>` / `1>>` (semantically same as `>` / `>>`).
- 5 new test cases for the new behaviour.

The lab lives at `labs/year-1/week-12/mini-shell/`.  The
v2 features are independent of v1's design — same executor
shape, same AST, same pipeline recipe.  The new code is
~40 lines.

## The syscall report

Per the roadmap, week 12 ends with "1-page report: syscalls
used and why."  The report is in
`weekend-report/SHELL-REPORT.md`.  It enumerates the 8
distinct syscalls the shell makes and counts the per-stage
overhead: a 3-stage pipeline costs **22 syscalls** in the
parent and children combined, before the children's
programs even start.

## Files

- `mini-shell/include/shell.h` — public API
- `mini-shell/src/shell.c` — parser + executor
- `mini-shell/src/main.c` — CLI entry point
- `mini-shell/tests/test_shell.c` — 17 test cases
- `mini-shell/tests/test_util.h`, `test_counters.c` — test framework
- `weekend-report/SHELL-REPORT.md` — the syscall write-up

## Takeaway

The shell is now a complete-enough mini-bash.  The four
redirect kinds (`<`, `>`, `>>`, `2>`, plus the `1` prefix
forms) cover the common cases; missing pieces (globbing,
quoting, job control, `;`/`&&`/`||`) are 100-200 line
features on top, not architectural changes.

Week 13 starts the Months 4-6 block: profiling, concurrency,
cache.
