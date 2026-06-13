# Week 13: Performance Baseline

The first of three weeks in the Months 4-6 block:
"Months 4-6: Profiling, Concurrency, Cache" (weeks 13-24).
The block builds a systematic performance practice on top
of the projects that already exist.

## The 2-week rhythm of this block

- **Week 13** (this week): baseline.  Measure what we have
  *before* trying to make it faster.  Capture hot spots
  with a sampling profiler.
- **Week 14**: flamegraphs (Linux) or extended sampling
  (macOS), write *hypotheses* for what to optimize, in
  priority order.
- **Weeks 15-16**: pick 1-2 of the hypotheses, implement
  them, re-measure, quantify the win, write a report.
- **Weeks 17-18**: threads and synchronization.
- **Weeks 19-20**: multithreaded performance project.
- **Weeks 21-22**: cache architecture deep dive.
- **Weeks 23-24**: matrix multiplication optimization.

## The headline numbers (this week)

- `arena-allocator`: 455 M alloc/s, 77 M malloc/s
- `pipe-shell`: ~333 single-stage pipelines/sec
- Hot spot in `arena-allocator`: 46% of the loop is in
  `arena_alloc` itself; the rest is the call site

## The lab

`labs/year-1/week-13/` has the bench harness, the sample
script, and the raw artifacts.  `weekend-report/BASELINE-REPORT.md`
is the full write-up.

## Takeaway

The "make it faster" weeks will be most effective if we
focus on the *caller* of the allocator, not the allocator
itself.  The allocator's hot path is already as tight as
the C version can reasonably get; the wins will come from
batching and pre-sizing in the call site.
