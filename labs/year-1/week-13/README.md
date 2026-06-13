# week-13 — performance baseline

The first of the Months 4-6 block: profile what we have
before trying to make it faster.

## What I did

- Built a bench harness (`bench/run_bench.sh`) that runs
  the existing projects with `/usr/bin/time -l` and
  captures wall clock, user/sys CPU, and peak RSS.
- Used Apple's `sample` to capture a call graph of the
  hot path in the arena allocator.
- Wrote `weekend-report/BASELINE-REPORT.md` with the
  numbers, the hot-spot analysis, and the next steps.

## Key findings

| Project | Headline number | Hot spot |
|---|---|---|
| arena-allocator | 455 M alloc/s, 77 M malloc/s (5.9× ratio) | 46% of runtime in `arena_alloc` (the 4-instruction hot path) |
| pipe-shell | 333 pipelines/s of `true` | process startup dominates (~3 ms / invocation) |

The 46% time-in-allocator is the ceiling.  The bigger
optimization wins in week 15 will be from *how the
allocator is used* (batching, pre-sizing) rather than
the allocator implementation itself.

Pipe-shell is bottlenecked by process startup; sub-ms
invocations are dominated by `execve` and library
loading, not the shell's own work.  A static build or
`LD_PRELOAD` might help — that's a week 14 question.

## What I learned

- `dtruss` and `dtrace` are blocked by macOS System
  Integrity Protection.  `sample` works as an
  unprivileged user.  The benchmark harness is
  syscalls-agnostic on macOS; syscall accounting is read
  from source.
- The arena-allocator at -O2 has the call site (`main` /
  for-loop) as the *larger* hot spot, not the allocator
  itself.  This inverts the usual expectation that the
  library is the bottleneck.
- Variance on Apple M-series for a tight alloc loop is
  ~5% run to run, dominated by page cache warmth and
  thermal effects.

## Files

- `bench/run_bench.sh` — bench harness
- `profile/sample.sh` — sampler (Apple `sample` on macOS)
- `artifacts/` — bench output, one folder per scenario
- `profile/arena_alloc_5M.sample.txt` — sample call-graph
- `weekend-report/BASELINE-REPORT.md` — the full report

## Acceptance criteria (from the roadmap)

- [x] Baseline benchmarks for allocator/shell
- [x] Collect CPU time, RSS, and key counters (`/usr/bin/time -l`)
- [x] Sampling profile (macOS `sample` — flamegraphs come
      in week 14 on Linux)
- [x] Hypotheses for the hot spots
- [x] Report + profiling artifacts committed

## Next

- **Week 14**: flamegraphs (Linux) or extended sampling
  (macOS), write optimization *hypotheses*.
- **Week 15-16**: implement 1-2 narrow optimizations,
  re-measure.
