# arena-allocator

The real source lives in the standalone repo:

**github.com/404Piyush/arena-allocator**

A bump arena memory allocator in C11. O(1) alloc, O(1)
reset, ~14x faster than malloc for small allocations.

```sh
git clone https://github.com/404Piyush/arena-allocator
cd arena-allocator
make test
make bench
```

See the top-level [README](../../README.md) and
[PROJECTS.md](../../PROJECTS.md) for the full deep-dive.
