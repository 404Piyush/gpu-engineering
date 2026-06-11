# bst-library

> **The real project lives at the standalone repo:**
> 👉 **[github.com/404Piyush/bst-library](https://github.com/404Piyush/bst-library)**
>
> The source code is **not** mirrored in this folder — go to
> the standalone repo for the full build, tests, benchmarks,
> CI, and docs.

## At a glance

- **What it is:** a generic binary-search tree in C11
- **Curriculum origin:** Week 4 (Month-1 capstone)
- **LOC:** ~500
- **Tests:** 74 assertions, 8 cases — all passing
- **Benchmark:** ~3.5 M insert/s, ~4.8 M find/s (M-series)
- **License:** MIT

## Quick example

```c
#include "bst.h"

int cmp_int(const void *a, const void *b) { return *(int*)a - *(int*)b; }

int main(void) {
    bst *t = bst_create(cmp_int, NULL);
    int keys[] = {5, 3, 7, 1, 4, 6, 8};
    for (int i = 0; i < 7; i++) bst_insert(t, &keys[i], &keys[i]);
    bst_inorder(t, print_int, NULL);
    bst_destroy(t, NULL, NULL);
}
```

## Get the code

```sh
git clone https://github.com/404Piyush/bst-library.git
cd bst-library
make test
```

---

📚 See the top-level [README](../../README.md#-bst-library) and
[PROJECTS.md](../../PROJECTS.md#1-bst-library--generic-binary-search-tree)
for the full deep-dive.
