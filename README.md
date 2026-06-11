# gpu-engineering

Year-long systems-engineering curriculum aimed at GPU engineering.
Twelve months, twelve deep-dive projects, one capstone.

## Curriculum map

| Month | Theme | Weeks |
|------:|-------|-------|
| 1     | The C machine                     | 1–4   |
| 2     | Memory is real                   | 5–8   |
| 3     | Syscalls & process model          | 9–12  |

## Folder layout

```
labs/         one sub-folder per week; each sub-folder has day-N-* sub-folders
notes/        one .md per week in the style of a personal learning journal
projects/     standalone, non-generic, professional-grade projects (one per major milestone)
vision.pdf    the original curriculum document
```

## Projects (standalone repos, mirrored here)

| Project                              | Origin | What it does |
|--------------------------------------|--------|--------------|
| [`bst-library`](./projects/bst-library)       | Week 4  | 100+ LOC multi-file BST library with recursion, arrays, structs, pointers, asm walkthrough. |
| [`arena-allocator`](./projects/arena-allocator) | Week 8  | First-fit free-list allocator, 5-test suite, microbenchmark vs `malloc`. |
| `pipe-shell` (planned)               | Week 11 | Minimal POSIX shell with prompt, parser, exec, builtins, tests. |

Each `projects/<name>/` is designed to be split out into its own
public repo at a later date.

## Labs & notes (per-week content)

See `notes/` for the per-week journal entries, and `labs/` for the
day-by-day exercises. Both follow the same `year-1/week-NN/` layout.
