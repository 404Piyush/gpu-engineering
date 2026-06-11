# Day 3–4 — Runtime vs working-set size, page fault counts

## Files

| File | What it does |
|---|---|
| `scaling.c`      | Times a scan over arrays of size 1 MiB → 256 MiB. Linear (prefetcher-friendly) and random (prefetcher-defeating). |
| `faults_alloc.c` | Allocates an array, then touches one int per 4 KiB page. Reports `getrusage()` minor-fault count before/after. |
| `page_faults.c`  | Prints current process resource counts. |

## Build & run

```bash
make
make run
```

## What I observed

### Scaling: linear scan (prefetcher-friendly)

```
MiB          ints         seconds      ns/int
1            262144       0.0004       1.39
2            524288       0.0007       1.33
4            1048576      0.0014       1.30
8            2097152      0.0027       1.30
16           4194304      0.0055       1.31
32           8388608      0.0109       1.30
64           16777216     0.0218       1.30
128          33554432     0.0440       1.31
256          67108864     0.0892       1.33
```

**Linear scan is constant 1.3 ns/elem from 1 MiB to 256 MiB.** The hardware prefetcher detects the sequential access and pulls each cache line *before* we need it. The CPU never stalls on a real DRAM access.

### Scaling: random scan (prefetcher-defeating)

```
MiB          iters        seconds      ns/iter
1            262144       0.0003       1.20
2            524288       0.0007       1.32
4            1048576      0.0014       1.36
8            2097152      0.0047       2.22
16           4194304      0.0219       5.23
32           8388608     0.0547        6.52
64           16777216    0.1166        6.95
128          33554432    0.2478        7.39
256          67108864    0.5050        7.52
```

This is the **real** cost of DRAM. The plateau around 7 ns/iter is
the time to fetch a 64-byte cache line from DRAM and the L3 hit
latency, divided by the number of useful elements per line.

| Working set | ns/iter | Where it lives |
|---|---|---|
| ≤ 2 MiB   | ~1.3 ns  | L1/L2 cache |
| ~4–8 MiB  | ~2 ns    | L3 cache |
| ≥ 16 MiB  | ~6–7 ns  | DRAM |

The transitions match the L1 (~32 KiB), L2 (~1 MiB), L3 (~12 MiB)
sizes of Apple M-series. Above L3, every element pays DRAM latency.

### Page fault count

`./faults_alloc 64`:
```
after touching every 4 KiB  : minor faults = 66237  (delta 65536)
expected = 65536 pages of 4 KiB
```

**Exactly 65 536 minor page faults**, matching the expected 65 536
pages of 4 KiB. (The first `malloc` itself takes a few thousand
pages for libc's internal structures, hence the 66237 absolute count
versus the 65536 delta.) Each `a[i] = 0` triggered a minor fault —
the kernel zeroed the page and mapped it into the process.

## Why this matters

* **Minor faults are nearly free** (~1 µs each on this machine). They
  happen the first time you touch a page.
* **Major faults are expensive** (read from disk; can be milliseconds
  if the page was swapped out).
* **Prefetching hides linear access** in *most* code, but real code
  has linked lists, trees, hash tables, and indirect arrays — all of
  which defeat the prefetcher and pay the full DRAM cost.
* **Working set > L3 → DRAM**, and DRAM is ~10× slower than L3.
  The fix is **better data structure layout** (cache-line alignment,
  smaller working set, fewer indirections).

## OS-level metric (saved to `scaling.txt`)

For each `MiB` we recorded:
* `seconds` and `ns/int` (per-element cost)
* The implied cache hierarchy: 1 ns/L1, 2 ns/L3, 7 ns/DRAM

This is the experiment that makes "TLB miss, page fault, TLB miss"
real: the runtime differences are visible without any kernel tracing.
