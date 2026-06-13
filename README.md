# gpu-engineering

A three-year systems and hardware roadmap aimed at becoming
a GPU engineer. The repo tracks the journey: every week,
every program, every reference, every mistake.

## Standalone projects

Three weeks so far produced projects polished enough to
ship as standalone public repos. More projects incoming.

| Project | Source | Live site | What it is |
|---|---|---|---|
| `bst-library` | [github.com/404Piyush/bst-library](https://github.com/404Piyush/bst-library) | [bst-library.404piyush.me](https://bst-library.404piyush.me) | Generic binary-search tree in C11 (Week 4 capstone) |
| `arena-allocator` | [github.com/404Piyush/arena-allocator](https://github.com/404Piyush/arena-allocator) | [arena-allocator.404piyush.me](https://arena-allocator.404piyush.me) | Bump arena memory allocator in C11 (Week 8 project) |
| `pipe-shell` | [github.com/404Piyush/pipe-shell](https://github.com/404Piyush/pipe-shell) | [pipe-shell.404piyush.me](https://pipe-shell.404piyush.me) | POSIX-ish command interpreter in C11 (Week 11 capstone) |

Each project ships with a 100%-passing test suite, a microbenchmark,
architecture and API documentation, and CI on Linux + macOS.

## Curriculum map

| Year | Months | Theme | Status |
|---|---|---|---|
| 1 | 1 to 12 | Systems foundations: C, memory, processes, profiling, concurrency, cache, capstone (KV server) | in progress (months 1-3 partially done) |
| 2 | 13 to 24 | Infrastructure + hardware awareness: networking, storage, distributed systems, NUMA | upcoming |
| 3 | 25 to 36 | GPU specialization: CUDA, orchestration, production plumbing, interviews | upcoming |

### Year 1 in detail

| Months | Theme | Deliverable | Status |
|---|---|---|---|
| 1 to 3 | The C machine, memory, and the process model (weeks 1 to 12) | 3 month-capstone projects | months 1 and 2 done; month 3 partly done (week 12 pending) |
| 4 to 6 | Profiling, concurrency, cache, and micro-optimization (weeks 13 to 24) | Performance report + optimized matrix multiply | upcoming |
| 7 to 12 | Consolidation + capstone: high-performance KV server (weeks 25 to 52) | KV server with reproducible benchmarks + interview material | upcoming |

## Per-week content

```
projects/                          thin READMEs that point to the standalone repos
labs/year-1/week-NN/               per-week day-N-* sub-folders
notes/year-1/week-NN.md            per-week journal
```

### Year 1, Months 1-3 (weeks 1-12): the C machine, memory, and the process model

| Week | Topic | Status | Note |
|---:|---|---|---|
| 1 | Source → running process (toolchain + build basics) | done | `notes/year-1/week-01.md`, `labs/year-1/week-01/` |
| 2 | Data representation (integers, floats, bits) | done | `notes/year-1/week-02.md`, `labs/year-1/week-02/` |
| 3 | Machine-level programs (reading assembly) | done | `notes/year-1/week-03.md`, `labs/year-1/week-03/` |
| 4 | Month 1 project + self-test | done | standalone: [404Piyush/bst-library](https://github.com/404Piyush/bst-library) |
| 5 | Stack vs heap (memory layout + common bugs) | done | `notes/year-1/week-05.md`, `labs/year-1/week-05/` |
| 6 | Memory debugging tooling (valgrind, asan) | done | `notes/year-1/week-06.md`, `labs/year-1/week-06/` |
| 7 | Virtual memory (working sets + page faults) | done | `notes/year-1/week-07.md`, `labs/year-1/week-07/` |
| 8 | Custom allocator v1 | done | standalone: [404Piyush/arena-allocator](https://github.com/404Piyush/arena-allocator) |
| 9 | Processes (fork / exec / wait) + tracing | done | `notes/year-1/week-09.md`, `labs/year-1/week-09/` |
| 10 | Pipes + redirection building blocks | done | `notes/year-1/week-10.md`, `labs/year-1/week-10/` |
| 11 | Mini shell v1 (parser, executor, tests) | done | standalone: [404Piyush/pipe-shell](https://github.com/404Piyush/pipe-shell) |
| 12 | Mini shell v2 (arbitrary pipelines, redirection hardening) + write-up | upcoming | |

### Year 1, Months 4-6 (weeks 13-24): profiling, concurrency, cache

| Week(s) | Topic | Status |
|---|---|---|
| 13 to 14 | Performance measurement tools (perf, flamegraphs) | upcoming |
| 15 to 16 | Optimization project (narrow scope, before/after) | upcoming |
| 17 to 18 | Threads and synchronization (mutex, atomics, thread pool) | upcoming |
| 19 to 20 | Multithreaded performance project (contention story) | upcoming |
| 21 to 22 | Cache architecture deep dive (false sharing, line size) | upcoming |
| 23 to 24 | Matrix multiplication optimization (5×+ speedup target) | upcoming |

### Year 1, Months 7-12 (weeks 25-52): consolidation + capstone

| Week(s) | Topic | Status |
|---|---|---|
| 25 to 26 | Sockets + HTTP basics | upcoming |
| 27 to 28 | Nonblocking I/O + event loops (epoll/kqueue) | upcoming |
| 29 to 30 | I/O model comparison + zero-copy experiments | upcoming |
| 31 to 32 | Advanced event loop (io_uring) + capstone design doc | upcoming |
| 33 to 44 | High-performance KV server (core data structure, protocol, server, profiling, optimization, hardening, final report) | upcoming |
| 45 to 52 | Packaging, release v1.0, resume, interview prep, portfolio index | upcoming |

### Years 2-3

Detailed week-by-week plans live in [`vision.md`](vision.md) (the
roadmap document this repo is built around).

## Test and benchmark summary

| Project | Tests | Benchmark |
|---|---:|---|
| bst-library | 74 assertions, 8 cases | 3.5 M insert/s, 4.8 M find/s |
| arena-allocator | 143 assertions, 9 cases | 450 M ops/s, ~5–7x malloc |
| pipe-shell | 56 assertions, 13 cases | end-to-end shell |
| **Total** | **273 assertions, 0 failures** | |

## More pages

- [PROJECTS.md](PROJECTS.md) — full deep-dive on each standalone
  project (architecture, API, benchmarks).
- [CHANGELOG.md](CHANGELOG.md) — what changed in each weekly commit.
- [vision.md](vision.md) — the three-year roadmap this repo is
  built around.

Per-project deployment runbooks (Vercel setup, DNS, custom
domain) live in each standalone repo under `DEPLOY.md`.

## License

[MIT](LICENSE).
