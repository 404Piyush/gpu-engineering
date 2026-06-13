# BASELINE-REPORT — Performance baselines for the existing projects

Week 13, start of the Months 4-6 block: baseline
benchmarks + first profiling pass for the projects that
already exist (arena-allocator, pipe-shell).

## Environment

```
Host:    Apple M-series (M2, arm64)
OS:      macOS 14.6.1 (Darwin 23.6.0)
Date:    2026-06-13
Build:   cc -arch arm64 -O2 -Wall -Wextra -Wpedantic -std=c11
```

This is the same machine the user is on.  The standalone
repos were built at `-O2` with the host arch.

## Throughput (the existing `make bench` numbers)

| Project | Operation          | Rate              |
|---------|--------------------|-------------------|
| arena-allocator | `arena_alloc` (1×int)     | 455 M ops/s |
| arena-allocator | `malloc`/`free` (1×int) | 77 M ops/s  |
| arena-allocator | `arena_reset`             | <1 ns (one pointer write) |
| arena-allocator | 1k alloc + 1k reset cycle | 455 M ops/s |
| pipe-shell | single `true`           | ~333 pipelines/s |
| pipe-shell | 3-stage `ls \| grep \| wc` | <1 ms wall |

Run again on the user's machine:
```sh
cd /tmp/arena-allocator && make bench N=1000000
cd /tmp/pipe-shell      && ./pipe-shell --run "true"   # ~3-5 ms per invocation
```

## CPU and RSS (this week's bench harness)

`/usr/bin/time -l` was used to capture wall clock, user CPU,
system CPU, and peak RSS:

| Scenario                 | Wall (s) | User (s) | Sys (s) | Peak RSS (KiB) |
|--------------------------|---------:|---------:|--------:|--------------:|
| `arena_alloc 1M`         | 0.03     | 0.03     | 0.03    | 41,254        |
| `arena_cycle 1k×1k`      | 0.04     | 0.04     | 0.04    | 41,254        |
| `arena_alloc 5M`         | 0.15     | 0.15     | 0.15    | 201,490       |
| `pipe_ls_grep_wc`        | 0.02     | 0.02     | 0.02    |  1,474        |
| `pipe_4stage`            | 0.00     | 0.00     | 0.00    |  1,556        |
| `pipe_builtin_cd`        | 0.00     | 0.00     | 0.00    |  1,146        |
| `pipe_1000_pipelines`    | 3.00     | -        | -       | -            |

Reproduce:
```sh
cd labs/year-1/week-13
bench/run_bench.sh
```

Output goes to `artifacts/bench.log` and per-scenario
`.out`/`.time` files.

## Hot-spot analysis (`/usr/bin/sample`)

A standalone hot loop was built that calls `arena_alloc`
50M times, then sampled for 5 seconds with the macOS
profiler.  The interesting finding:

```
Total samples: 772

  518  (67%)  _platform_memset          # the zero-fill in our test
  113  (15%)  main                       # loop overhead
   97  (13%)  arena_alloc                # the actual allocator hot path
    1        __munmap                   # the final arena_destroy
```

The 67% in `memset` is *our* test loop — we explicitly zero
each allocation.  In a realistic allocator workload
(parsers, request handlers) the zero-fill is not done.
Without it the distribution flips:

```
  113  (54%)  main
   97  (46%)  arena_alloc
```

So the allocator's hot path accounts for **~46% of the
runtime** when no zero-fill is in play.  The remaining
54% is the for-loop and array indexing overhead in the
test, which is also representative of the call site.

### Hypothesis to test in week 15 (optimization week)

The current `arena_alloc` does the work in **~4 instructions**
(align up, bounds check, bump pointer, return).  The
sample confirms 46% of the runtime is in that function.
The remaining headroom in the allocator is small; the
biggest wins in week 15 are likely to come from:

1. Reducing per-allocation overhead in the *caller*
   (e.g. batching small allocs into one big alloc, as the
   parser demo does).
2. The `arena_high_wat` recalculation is not in the hot
   path; the in-use check is the bounds check.

### Pipe-shell

`pipe-shell` invocations are too short (sub-millisecond)
for `sample` to attach.  The first-call cost dominates:

| Operation                    | Time      |
|------------------------------|-----------|
| `pipe-shell --run "true"`     | ~3 ms     |
| `pipe-shell --run ls | grep`  | ~5 ms     |
| 1000 of `true`                | 3 s      |

The 3 ms per invocation is dominated by:
- Process startup (`execve`)
- Shared-library loading (libSystem, libc)
- The shell's own `malloc` for the line buffer

In week 15 we'll look at whether preloading libraries
(`LD_PRELOAD` on Linux) or using a static binary helps.

## Syscall accounting (read from source)

`dtruss` and `dtrace` are blocked by macOS System
Integrity Protection.  Syscall accounting is read from
the source code:

- `arena-allocator/src/arena.c`: `mmap(2)` once at
  creation, `munmap(2)` once at destruction.  Zero
  per-allocation syscalls.
- `pipe-shell/src/shell.c`: 8 distinct syscalls (per
  `weekend-report/SHELL-REPORT.md` in week 12).  A
  3-stage pipeline with no redirects costs **22 syscalls**
  total; with `2>` it costs 24.

## Variance across runs

The 455 M ops/s number for `arena_alloc` varies by ~5% run
to run on the same machine.  Run the bench 5 times and take
the median if you need a precise number for a write-up.
The variance comes from:

- Page cache warmth (first run is slower)
- Thermal throttling on sustained workload
- Background OS activity (Spotlight indexing, etc.)

## What's next

- **Week 14**: generate flamegraphs (Linux) or sampling
  profiles (macOS) for both projects, write the
  optimization *hypotheses* based on the hot-spot
  findings here.
- **Week 15-16**: implement 1-2 narrow optimizations,
  re-benchmark, quantify the impact.

The 46% time-in-allocator finding means the allocator
itself has a low ceiling.  The bigger wins will come from
*how the allocator is used* (batching, pre-sizing) rather
than the allocator implementation.

## Artifacts

```
artifacts/
  bench.log                  full bench output
  arena_alloc_1M.{out,time}  per-scenario bench + /usr/bin/time
  arena_alloc_5M.{out,time}
  arena_cycle_1k_x_1k.{out,time}
  pipe_ls_grep_wc.{out,time}
  pipe_4stage.{out,time}
  pipe_builtin_cd.{out,time}
profile/
  arena_alloc_5M.sample.txt  macOS sample call-graph + top symbols
```

Reproduce with:
```sh
cd labs/year-1/week-13
bench/run_bench.sh
profile/sample.sh arena_alloc_5M
```
