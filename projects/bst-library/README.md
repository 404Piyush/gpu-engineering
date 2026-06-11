# bst-library

A small, dependency-free **binary search tree** library written in C,
with a small driver program that loads a fixed dataset of student
records and exercises the API.

This is the Month-1 capstone project from the gpu-engineering
curriculum: it ties together everything from Weeks 1–4 (compilation
pipeline, data representation, machine-level code, and debugging).

## Features

* `bst_insert`, `bst_find`, `bst_free` — basic BST operations
* `bst_height`, `bst_inorder`, `bst_count_leaves` — recursive
  tree-walking helpers
* `bst_stats` — aggregates count + GPA min / max / sum in one pass
* Recursive implementation; no global state
* Configurable per-request optimisation flags via the standard
  C compiler (`-O0` for debugging, `-O2` for benchmarks)

## Quick start

```bash
make           # build the static library + demo
make run       # run the demo
make asm       # emit -O0 / -O2 assembly for the demo
make clean
```

## Files

```
include/student.h    public API
src/student.c        implementation
src/main.c           demo driver
asm/                 generated -O0 / -O2 assembly (committed for reference)
Makefile             build system
```

## API

```c
typedef struct {
    int   id;
    char  name[32];
    float gpa;
} Student;

Node *bst_insert(Node *root, Student s);
Node *bst_find  (Node *root, int id);
void  bst_free  (Node *root);

int    bst_height        (Node *root);
void   bst_inorder       (Node *root, Student *out, int *idx);
int    bst_count_leaves  (Node *root);

typedef struct {
    int   count;
    float gpa_sum;
    float gpa_min;
    float gpa_max;
} Stats;

Stats bst_stats(Node *root);
```

## Demo output

```
Dataset size    : 10
Tree height     : 4
Leaf count      : 5
Stats           : count=10 avg=3.56 min=3.00 max=3.95
In-order (sorted by id):
  id=1   name=Anaya    gpa=3.80
  ...
Lookups:
  id=1  FOUND -> Anaya (gpa 3.80)
  id=6  FOUND -> Sneha (gpa 3.85)
  id=99 NOT FOUND
  id=13 FOUND -> Rohan (gpa 3.10)
```

## What I learned

See [`asm-diff/README.md`](./asm-diff/README.md) for a walkthrough of
the `-O0` vs `-O2` differences in the generated x86_64 assembly.

## Acceptance criteria (Month 1)

* [x] Working 100+ LOC C program pushed to GitHub.
* [x] Annotated assembly with stack frame notes.
* [x] Crash / root-cause writeup.
* [x] Self-test answers saved.
