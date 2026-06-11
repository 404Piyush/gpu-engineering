# Day 1–2 — Stride-based array walk (locality experiment)

## Build & run

```bash
make        # build with -O2
make run    # 64 MiB array (fits in L3 on most machines)
make big    # 256 MiB array (forces L3 evictions)
```

## What I observed

### 64 MiB array (just barely fits in L3)

```
stride   seconds      ns/elem
1        0.0166       0.99
2        0.0082       0.98
4        0.0041       0.98
8        0.0021       1.02
16       0.0013       1.27
32       0.0026       5.05
64       0.0018       7.00
128      0.0008       6.12
256      0.0004       6.16
512      0.0003       9.09
1024     0.0002       10.25
```

### 256 MiB array (way larger than L3)

```
stride   seconds      ns/elem
1        0.0664       0.99
2        0.0330       0.98
4        0.0169       1.01
8        0.0087       1.03
16       0.0051       1.21
32       0.0102       4.87
64       0.0072       6.85
128      0.0050       9.53
256      0.0018       6.69
512      0.0012       9.31
1024     0.0008       11.81
```

## How to read this

* **ns/elem** is the metric — it tells you the time spent on each
  element. Lower = better.
* The **1.0 ns** floor at small strides (1, 2, 4, 8) is the L1
  cache: at stride=8 we touch 8×4=32 bytes per element, well within
  one cache line. The hardware prefetcher + L1 absorbs everything.
* At **stride=16** we touch exactly one cache line per element (16
  ints × 4 bytes = 64 B). The ns/elem jumps because each new element
  *might* require a new cache line transfer.
* At **stride=32 and above** we're in DRAM territory. The jump from
  ~1 ns to ~5–10 ns/elem is the cost of a DRAM access (~100 ns
  amortised over 16 elements = ~6 ns/elem) versus an L1 hit (~1 ns).

## Why does stride=1 take 0.99 ns even on a 256 MiB array?

The hardware **prefetcher** detects the linear pattern and starts
pulling cache lines *before* we need them. By the time the CPU asks
for `a[0..15]`, the line is already in L1. The "small strides are
fast" result is *prefetching* working, not really "everything fits in
cache" — a 256 MiB array obviously does not fit in L1 (32 KiB) or L2
(1 MiB) or even L3 (12 MiB on Apple M-series).

## Why does stride=1024 take only 0.0002 sec total?

We visit `n/1024` elements instead of `n`. We're processing 1/1024 of
the data. Total time is 1024× less; per-element cost is what the
chart shows.

## Takeaway

* **Cache lines are 64 bytes** (16 ints). Touching ints within the
  same line is free; touching a new line is expensive.
* **The prefetcher** hides linear access patterns. Non-linear access
  (linked lists, tree walks) defeats the prefetcher and you pay the
  DRAM latency.
* **Locality is the #1 thing that matters** in tight loops. Choose
  data structures that put things you use together into the same
  cache line.

The 256 MiB run is saved in `run256MB.txt`; the 64 MiB run is in
`run64MB.txt`. They show the same shape, just scaled.
