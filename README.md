# gpu-engineering

Year-long systems-engineering curriculum aimed at GPU engineering.
Twelve months, twelve deep-dive projects, one capstone.

## Curriculum map

| Month | Theme                          | Weeks |
|------:|-------|-------|
| 1     | The C machine                  | 1–4   |
| 2     | Memory is real                 | 5–8   |
| 3     | Syscalls & process model        | 9–12  |

## Standalone projects

Each major milestone lives in its own public repo. The mirrors
under `projects/` here are kept for archival.

| Project | Curriculum origin | Repo |
|---|---|---|
| `bst-library`     | Week 4 (Month-1 capstone) | https://github.com/404Piyush/bst-library |
| `arena-allocator` | Week 8 (Month-2 project)  | https://github.com/404Piyush/arena-allocator |
| `pipe-shell`      | Week 11 (Month-3 capstone) | https://github.com/404Piyush/pipe-shell |

See each repo for its own test suite, benchmark, docs, and CI.

## Folder layout

```
projects/             one sub-folder per standalone project (mirrors)
labs/                 per-week day-N-* sub-folders
notes/                per-week .md journal entries
vision.pdf            the original curriculum document
```

## Labs & notes (per-week content)

See `notes/` for the per-week journal entries, and `labs/` for
the day-by-day exercises. Both follow the same `year-1/week-NN/`
layout.
