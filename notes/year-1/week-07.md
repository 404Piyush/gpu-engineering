# Week 7: Virtual Memory (Working Sets + Page Faults)

This week was about the **memory hierarchy** below the C abstract
machine: how cache lines, TLB, page faults, and DRAM combine to
produce the timings I measure. I read OSTEP Ch. 18–22 (VM) and
CS:APP §9.1–9.8.

---

## 🚀 Learning goals
- [x] Read VM chapters; write a stride-based array walk that changes locality.
- [x] Measure impact: runtime changes as array size grows; record system counters.
- [x] Write a VM experiment report explaining TLB, page faults, and measurements.

---

## 📅 Daily tasks

### Day 1–2 — Stride walk
- `day-1-2-stride-walk/stride.c` walks an array at strides
  {1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024}.
- The chart in the README shows ~1 ns/elem at small strides
  (prefetcher at work) and ~6–10 ns/elem at large strides
  (DRAM access).
- 64 MiB and 256 MiB runs produce the same shape — the prefetcher
  is the *primary* factor, not the cache size, for sequential access.

### Day 3–4 — Runtime vs working set
- `day-3-4-measure/scaling.c` does the same scan for arrays
  1 MiB → 256 MiB, with both **linear** and **random** access.
- The random scan reveals the L1/L2/L3/DRAM transitions: 1.3 ns
  below 2 MiB, 2 ns around L3, ~7 ns once in DRAM.
- `day-3-4-measure/faults_alloc.c` uses `getrusage()` to count
  minor page faults. Touching one int per 4 KiB page of a 64 MiB
  allocation reports **exactly 65 536** faults, matching the
  expected 65 536 pages.

### Weekend — VM report
- `weekend-report/VM-REPORT.md` ties everything together.
  It has 7 sections including a "How I'd use this in real code"
  section that translates the experiment into practical advice.

---

## 🛠️ Project structure
- `labs/year-1/week-07/day-1-2-stride-walk/` — `stride.c`, `Makefile`, `run64MB.txt`, `run256MB.txt`, `README.md`.
- `labs/year-1/week-07/day-3-4-measure/` — `scaling.c`, `faults_alloc.c`, `page_faults.c`, `Makefile`, `scaling.txt`, `README.md`.
- `labs/year-1/week-07/weekend-report/VM-REPORT.md` — the capstone.

## Acceptance check
* [x] Stride walk shows the cache-line / DRAM cliffs.
* [x] Scaling experiment shows L1/L2/L3/DRAM transitions.
* [x] Page-fault counter matches expected N for N pages touched.
* [x] VM report (`VM-REPORT.md`) is written.
