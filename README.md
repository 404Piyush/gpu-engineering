# gpu-engineering

A three-year systems and hardware roadmap aimed at becoming
a GPU engineer. The repo tracks the journey: every week,
every program, every reference, every mistake.

## Standalone projects

Three weeks so far produced projects polished enough to
ship as standalone public repos. More projects incoming.

## Standalone projects

Three of the weeks produced projects polished enough to ship
as standalone public repos. More projects incoming.

| Project | Source | Live site | What it is |
|---|---|---|---|
| `bst-library` | [github.com/404Piyush/bst-library](https://github.com/404Piyush/bst-library) | [bst-library.404piyush.me](https://bst-library.404piyush.me) | Generic binary-search tree in C11 (Week 4 capstone) |
| `arena-allocator` | [github.com/404Piyush/arena-allocator](https://github.com/404Piyush/arena-allocator) | [arena-allocator.404piyush.me](https://arena-allocator.404piyush.me) | Bump arena memory allocator in C11 (Week 8 project) |
| `pipe-shell` | [github.com/404Piyush/pipe-shell](https://github.com/404Piyush/pipe-shell) | [pipe-shell.404piyush.me](https://pipe-shell.404piyush.me) | POSIX-ish command interpreter in C11 (Week 11 capstone) |

Each project ships with a 100%-passing test suite, a microbenchmark,
architecture and API documentation, and CI on Linux + macOS.

## Curriculum map

| Year | Theme | Status |
|---|---|---|
| 1 | The C machine, memory, and the process model (weeks 1 to 11) | in progress |
| 2 | Systems programming, networking, parallelism (planned) | upcoming |
| 3 | GPU engineering (planned) | upcoming |

Year 1 is broken into three months:

| Month | Theme | Weeks |
|---|---|---|
| 1 | The C machine | 1 to 4 |
| 2 | Memory is real | 5 to 8 |
| 3 | Syscalls and the process model | 9 to 11 |

## Per-week content

```
projects/                          thin READMEs that point to the standalone repos
labs/year-1/week-NN/               per-week day-N-* sub-folders
notes/year-1/week-NN.md            per-week journal
```

| Week | Topic | Status | Note |
|---:|---|---|---|
| 1 | Pointers and strings | done | notes/year-1/week-01.md |
| 2 | Structs and lifetimes | done | notes/year-1/week-02.md |
| 3 | Assembly and calling convention | done | notes/year-1/week-03.md |
| 4 | BST capstone | done | standalone: 404Piyush/bst-library |
| 5 | Stack vs heap | done | notes/year-1/week-05.md |
| 6 | Memory debugging tooling | done | notes/year-1/week-06.md |
| 7 | Virtual memory | done | notes/year-1/week-07.md |
| 8 | Custom allocator | done | standalone: 404Piyush/arena-allocator |
| 9 | fork / exec / wait | done | notes/year-1/week-09.md |
| 10 | Pipes and redirection | done | notes/year-1/week-10.md |
| 11 | mini-shell | done | standalone: 404Piyush/pipe-shell |
| 12+ | TBD | planned | |

## Test and benchmark summary

| Project | Tests | Benchmark |
|---|---:|---|
| bst-library | 74 assertions, 8 cases | 3.5 M insert/s, 4.8 M find/s |
| arena-allocator | 143 assertions, 9 cases | 455 M ops/s, ~14x malloc |
| pipe-shell | 56 assertions, 13 cases | end-to-end shell |
| **Total** | **273 assertions, 0 failures** | |

## More pages

- [PROJECTS.md](PROJECTS.md) — full deep-dive on each standalone
  project (architecture, API, benchmarks).
- [CHANGELOG.md](CHANGELOG.md) — what changed in each weekly commit.
- [DEPLOY.md](DEPLOY.md) — Vercel deployment runbook for the
  three live sites.
- [DNS.md](DNS.md) — the three CNAMEs to add at the DNS provider.

## License

[MIT](LICENSE).
