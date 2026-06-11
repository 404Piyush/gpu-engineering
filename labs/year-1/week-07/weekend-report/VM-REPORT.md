# VM experiment report — TLB, page faults, working set

This is the Week-7 weekend deliverable. It ties together the
stride walk, the scaling experiment, and the `getrusage()` page
fault count into a single narrative.

## 1. TLB and page faults in 4 sentences

* The **MMU** translates virtual addresses to physical addresses via
  a per-process page table. macOS / Linux use 4 KiB pages.
* The **TLB** (translation lookaside buffer) is a small, fast cache
  of recent virtual→physical mappings. A *TLB miss* triggers a
  page-table walk in software (slow: 10s of cycles).
* A *minor page fault* happens the first time you touch a page that
  is allocated to your process but not yet resident. The kernel
  zeros the page, maps it, and the CPU retries the load.
* A *major page fault* happens when the page is on disk (e.g. swapped
  out or a `mmap`ed file). The kernel reads the page from disk, then
  maps it.

## 2. Working-set sizes (Day 1–2)

From the stride walk (256 MiB array):

| Stride | ns/elem | What dominates |
|--------|---------|----------------|
| 1      | 0.99    | L1 + prefetcher |
| 8      | 1.03    | L1 + prefetcher |
| 32     | 4.87    | L1 misses, L2 hits |
| 128    | 9.53    | L2/L3 misses, DRAM |

The pattern: at small strides the prefetcher is perfect. Past a
stride of ~16 ints (one cache line = 64 B) we start missing L1.
Past a stride of ~1024 ints (16 KiB / 4 cache lines) we start
missing L2. Past a working set of ~12 MiB we miss L3.

## 3. Runtime vs working set (Day 3–4)

The scaling experiment scanned arrays of increasing size. The
random-scan column shows the step-function:

| Working set | Where it lives | ns/iter |
|-------------|----------------|---------|
| 1–2 MiB     | L1 + L2        | ~1.2    |
| 4–8 MiB     | L3             | ~2.0    |
| ≥ 16 MiB    | DRAM           | ~7.0    |

The 5× jump between 8 MiB and 16 MiB is the **L3-to-DRAM** cliff.
Below L3, the CPU is fed at L3 bandwidth (~50 GB/s on Apple
M-series). Above L3, the CPU is fed at DRAM bandwidth (~25 GB/s)
*and* pays higher latency for each new line.

## 4. Counting the faults

`faults_alloc 64` reports exactly **65 536** minor faults when we
touch one int per 4 KiB page of a 64 MiB allocation. That's one
fault per page, as expected:

```
$ ./faults_alloc 64
after malloc(64 MiB)        : minor faults = 701  (delta 0)
after touching every 4 KiB  : minor faults = 66237  (delta 65536)
expected = 65536 pages of 4 KiB
```

(`malloc` itself doesn't fault — the kernel hands out virtual
addresses that are not yet backed by physical pages. The OS uses
*demand paging*: the page is only allocated/zeroed on first touch.)

## 5. How I'd use this in real code

* **Measure first.** Use Instruments (`xctrace`) on macOS or
  `perf stat` on Linux to find what *actually* limits performance.
  Don't guess.
* **Layout matters more than algorithm.** A linear scan over a
  flat array beats a "clever" pointer-chasing tree by 5–10× on
  modern hardware.
* **Pre-fault when latency matters.** If you `malloc` 1 GiB and
  then start serving requests, the first request after the
  allocation will be ~1 ms slower (page-fault latency). Touch the
  pages during initialisation to amortise.
* **Watch the resident set.** `getrusage().ru_maxrss` (KB on macOS)
  tells you the high-water resident memory. If it grows unboundedly
  you have a leak. If it grows larger than L3 you will get the
  5–10× slowdown.
* **mmap vs malloc for big allocations.** `mmap` lets you map a
  file directly. Pages are loaded *only* when you touch them, and
  the kernel can evict them under memory pressure. `malloc` is
  backed by `mmap` for large allocations and by `brk` for small
  ones, but you have less control.

## 6. Acceptance check

* [x] Stride walk (`stride.c`) shows cache-line and DRAM cliffs.
* [x] Scaling experiment (`scaling.c`) shows L1/L2/L3/DRAM transitions.
* [x] Page-fault counter (`faults_alloc.c`) reports exactly N
      faults for an N-page allocation touched once each.
* [x] `getrusage` data is captured and explained in this report.

## 7. Linux-vs-macOS notes

On Linux, the same experiments can be done with `perf stat -e
cache-misses,cache-references,L1-dcache-load-misses,dTLB-load-misses`
or with `valgrind --tool=cachegrind` for an offline simulation.
On macOS, Instruments → "Counters" template gives you the same
counters visually.
