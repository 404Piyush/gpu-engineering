## **3-Year Systems + Hardware Roadmap** 

_From C Fundamentals to GPU Infrastructure Engineering_ 

**Duration:** 36 Months 

**Daily Commitment:** 2–4h weekdays, 5–8h weekends 

**Progress Loop:** Learn → Build → Measure → Document 

**Monthly Rule:** Ship 1 deliverable + 1 write-up with measurements 

## **Table of Contents** 

1. Overview & Philosophy 

2. Operating Model (How to Execute) 

3. Year 1: Systems Foundations (Months 1–12) 

3.1 Month-by-Month Overview 

3.2 Week-by-Week Detailed Calendar (Weeks 1–52) 

4. Year 2: Infrastructure + Hardware Awareness (Months 13–24) 

5. Year 3: GPU Specialization (Months 25–36) 

6. Must-Finish Projects & Acceptance Criteria 

7. Self-Testing & Grading 

8. Job Search Timeline & Strategy 

9. Resources & Tools Checklist 

10. Quick Start: First 30 Days (Day-by-Day) 

## **1. Overview & Philosophy** 

**Core Principle:** Think like the machine. Every abstraction you use has a cost in memory, CPU cycles, and latency. Your advantage is seeing the cost and making tradeoffs intentionally. 

This roadmap is designed so you become someone who can: 

- Read and reason about assembly and memory layout 

- Profile and optimize performance using evidence (not opinions) 

- Build low-latency, high-throughput infrastructure 

- Understand hardware-facing constraints (cache, NUMA, I/O, PCIe) 

- Specialize into GPU systems and orchestration by Year 3 

## **Why this path works** 

|**Most people**<br>**do**|**You will do**|**Result**|
|---|---|---|
|Memorize APIs|Measure, profile, explain bottlenecks|Performance credibility|
|Build demos|Build systems with benchmarks +<br>writeups|Portfolio that survives<br>scrutiny|
|Study<br>randomly|Follow weekly calendar + monthly<br>deliverables|Consistent progress|



## **2. Operating Model (How to Execute)** 

## **Daily time commitment** 

|**Day Type**|**Learning Time**|**What to do**|
|---|---|---|
|Weekdays|2–4 hours|Reading + exercises. Do it before paid work.|
|Weekends|5–8 hours|Project work, profiling sessions, report writing.|



## **Progress loop (every week)** 

1. **Learn:** read + summarize; collect “confusions” 

2. **Build:** produce runnable code 

3. **Measure:** benchmark + profile; capture logs 

4. **Document:** README with decisions + results 

## **Monthly validation** 

- **Deliverable:** one public repo update with reproducible scripts 

- **Write-up:** 1–3 pages (what you built, what was slow, what you changed) **Self-test:** theory + practical (timed) 

## **3. Year 1: Systems Foundations (Months** 

## **1–12)** 

**Goal:** think like the machine. Write safe C, understand memory and processes, profile and optimize with evidence, and ship a high-performance capstone. 

## **Core resources (Year 1)** 

- CS:APP — primary spine 

- OSTEP — OS foundations 

- Brendan Gregg — performance tooling and mindset 

## **3.1 Year 1: Month-by-Month Overview** 

|**Month**|**Theme**|**Deliverable**|**Proof**|
|---|---|---|---|
|1|Source→assembly<br>→binary→process|Annotated assembly +<br>debugging report|Explain stack frames<br>and crash root cause|
|2|Memory is real|Custom allocator +<br>benchmark graphs|Leak/UAF detection<br>logs + fragmentation<br>story|
|3|Syscalls and<br>processes|Mini shell (pipes +<br>redirection)|Script test suite +<br>syscall write-up|
|4|Profiling|Performance<br>optimization report|Before/after<br>flamegraphs + metrics<br>table|
|5|Concurrency|Thread pool +<br>contention study|Scaling curves + race<br>fixes|
|6|Cache and micro-<br>optimizations|Optimized matrix<br>multiplication|Cache-miss counters<br>and speedup graphs|
|7–12|Consolidation +<br>capstone|High-performance KV<br>server + interview<br>material|Reproducible<br>benchmarks + report +<br>talk|



## **3.2 Year 1: Week-by-Week Detailed Calendar (Weeks 1–52)** 

## **MONTH 1: From Source to Process** 

_Reading: CS:APP Chapters 1–3_ 

## **Week 1: Source → Running Process (Toolchain + Build Basics)** 

Total Time: 12–16 hours 

## **Learning goals** 

Understand the compilation pipeline (preprocess → compile → assemble → link) 

Set up a repeatable build + debug workflow 

Write and debug small C programs quickly 

## **Daily tasks** 

O **Day 1 (2h):** Install toolchain and debugger. Verify `cc --version` and basic compile/run. Create repo and push initial structure ( `src/` , `notes/` , `Makefile` ). 

O **Day 2 (2–3h):** Read CS:APP Ch.1. Write 2 tiny C programs. Compile with `-Wall -Wextra -O0 -g` . Step through in debugger. 

O **Day 3 (2–3h):** Learn Make targets: `all` , `run` , `debug` , `clean` . Use it for your programs. 

O **Day 4 (2h):** Inspect compilation stages: `-E` , `-S` , `-c` . Save outputs into `artifacts/` . 

O **Day 5 (2–3h):** Create a multi-file program (.h + multiple .c). Link it. Inspect symbols with `nm` (or `otool` on macOS). 

O **Weekend (6–8h):** Write `notes/week-01.md` explaining the build pipeline using your own artifacts, including “what is an object file?” and “what does the linker do?” 

## **Deliverable** 

Repo with 5+ working C programs, Makefile, and a written explanation of the pipeline. 

## **Week 2: Data Representation (Integers, Floats, Bits)** 

Total Time: 12–16 hours 

## **Learning goals** 

Understand signed vs unsigned, overflow, and two’s complement Understand floating point precision and surprising behavior Get comfortable with bitwise operations as tools (not trivia) 

## **Daily tasks** 

O **Day 1 (2–3h):** Read CS:APP Ch.2. Write overflow demos for signed/unsigned. Add assertions and explain results. 

O **Day 2 (2–3h):** Implement bit utilities: set/clear/toggle bit, nth-bit, popcount. Add a minimal test runner. 

O **Day 3 (2h):** Floating point demos: `0.1 + 0.2` , epsilon, catastrophic cancellation. Write short notes. 

O **Day 4 (2–3h):** Implement hex dump tool (mini `hexdump` ): reads file, prints offsets + hex + ASCII. 

O **Weekend (6–8h):** Package utilities into `libbits` + tests. Add a README: “gotchas” you can explain in interviews. 

## **Deliverable** 

Bit utility library + hex dump tool + write-up on integer/float gotchas. 

## **Week 3: Machine-Level Programs (Reading Assembly)** 

Total Time: 14–18 hours 

## **Learning goals** 

Map C constructs to assembly patterns (loops, calls, conditionals) 

Understand stack frames, calling conventions, and registers Use disassemblers to explain what code does 

## **Daily tasks** 

O **Day 1 (3h):** Read CS:APP Ch.3 basics. Learn prologue/epilogue and “where locals live”. 

O **Day 2 (2–3h):** Compile with `-S` , study loops and if/else output. Compare `-O0` vs `-O2` . 

O **Day 3 (2–3h):** Disassemble a binary ( `objdump -d` on Linux, `otool - tv` on macOS). Label what each block does. 

**Day 4 (2h):** Practice: “given assembly, reconstruct C-like pseudocode”. 

O **Weekend (8–10h):** Take a 100–150 line C program and produce a fully annotated assembly listing with stack frame diagrams. 

## **Deliverable** 

Annotated assembly (with stack frame explanation) you can show to anyone. 

## **Week 4: Month 1 Project + Self-Test** 

Total Time: 14–20 hours 

## **Project** 

- O **Day 1–2 (6h):** Write a C program (100+ LOC) using recursion, arrays, structs, pointers, multiple files. 

- O **Day 3 (4h):** Generate assembly for `-O0` and `-O2` . Create a “what changed and why” comparison. 

- O **Day 4 (3h):** Debug a crash end-to-end with debugger. Capture steps and the root cause. 

- O **Day 5 (2h):** Create an intentional memory bug (overflow) and explain failure at machine level. 

- O **Weekend (6–8h):** Write the Month-1 report: compilation pipeline + assembly notes + crash analysis. 

## **Self-test (theory)** 

1. Explain what happens when you run a C program from source to execution. 

2. Draw a stack frame for a function call with local variables. 

3. Explain how a buffer overflow can corrupt a return address. 

## **Acceptance criteria** 

- Working 100+ LOC C program pushed to GitHub Annotated assembly with stack frame notes Crash/root-cause writeup Self-test answers saved 

## **MONTH 2: Memory Is Real** 

_Reading: CS:APP memory/performance + OSTEP virtual memory_ 

## **Week 5: Stack vs Heap (Memory Layout + Common Bugs)** 

Total Time: 12–16 hours 

O **Day 1 (2–3h):** Print addresses of globals, stack locals, heap allocations; document layout. 

O **Day 2 (2–3h):** Create leaks, double-free, and use-after-free examples; explain symptoms. 

O **Day 3 (2h):** Add sanitizers (ASan/UBSan) where available; run and record output. 

**Day 4 (2h):** Study stack growth via recursion depth experiment. 

O **Weekend (6–8h):** Write `notes/week-05.md` that teaches memory layout with your own screenshots/logs. 

## **Week 6: Memory Debugging Tooling** 

Total Time: 12–16 hours 

**Day 1–2 (4–6h):** Run valgrind (Linux) or sanitizers (macOS) on intentionally buggy programs. Fix bugs and re-run. 

**Day 3 (2–3h):** Write a malloc wrapper that tracks allocations and prints a report at exit. 

**Weekend (6–8h):** Create a “bug zoo”: 6 small programs, each demonstrating a specific memory bug and its fix. 

## **Week 7: Virtual Memory (Working Sets + Page Faults)** 

Total Time: 12–16 hours 

**Day 1–2 (4–6h):** Read VM chapters. Write a stride-based array walk that changes locality. **Day 3–4 (4–6h):** Measure impact: runtime changes as array size grows; record system counters if available. 

**Weekend (6–8h):** Write a VM experiment report explaining TLB, page faults, and your measurements. 

## **Week 8: Project — Custom Allocator v1** 

Total Time: 14–22 hours 

O **Day 1–2 (6h):** Implement a simple free-list allocator (malloc/free equivalents) with coalescing. 

O **Day 3 (3–4h):** Add tests: random allocate/free patterns, fragmentation measurement. 

O **Day 4–5 (4–6h):** Benchmark vs system malloc on a controlled workload. Plot results. 

O **Weekend (6–8h):** Write README: design, tradeoffs, graphs, and what you’d do next. 

## **Acceptance criteria** 

Allocator passes tests Benchmarks vs malloc with graphs 

Fragmentation experiment described and reproducible 

## **MONTH 3: Syscalls & Process Model** 

_Reading: OSTEP processes + signals_ 

**==> picture [259 x 12] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 9: Processes (fork/exec/wait) + Tracing<br>**----- End of picture text -----**<br>


**==> picture [359 x 130] intentionally omitted <==**

**----- Start of picture text -----**<br>
Total Time: 12–16 hours<br>Day 1–2 (4–6h):  Write demos using  fork ,  exec ,  waitpid . Explain exit<br>codes.<br>Day 3–4 (4–6h):  Trace syscalls of common tools ( ls ,  cat ,  cp ).<br>Summarize what you see.<br>Weekend (6–8h):  Write  notes/week-09.md : process lifecycle and<br>syscall patterns.<br>**----- End of picture text -----**<br>


## **Week 10: Pipes + Redirection Building Blocks** 

Total Time: 12–16 hours **Day 1–2 (4–6h):** Build a two-process pipeline using `pipe` and `dup2` . **Day 3–4 (4–6h):** Implement basic redirection ( `>` , `<` ) in a minimal command runner. **Weekend (6–8h):** Write tests as shell scripts and run them automatically. 

## **Week 11: Mini Shell v1** 

**==> picture [360 x 99] intentionally omitted <==**

**----- Start of picture text -----**<br>
Total Time: 12–18 hours<br>Day 1–3 (6–9h):  Prompt loop + parsing + exec. Handle errors cleanly.<br>Day 4–5 (4–6h):  Add builtins:  cd ,  exit . Add minimal job control notes<br>(optional).<br>Weekend (6–8h):  Expand test scripts for correctness.<br>**----- End of picture text -----**<br>


**Week 12: Mini Shell v2 + Write-up** Total Time: 14–22 hours O **Day 1–2 (4–6h):** Implement pipelines of arbitrary length. O **Day 3–4 (4–6h):** Implement redirection robustly (multiple redirects). O **Day 5 (2–3h):** Run full test suite; fix edge cases. O **Weekend (6–8h):** 1-page report: syscalls used and why. **Acceptance criteria** Shell passes script tests README explains syscalls and examples 

## **MONTHS 4–6: Profiling, Concurrency, Cache (Weeks 13–** 

## **24)** 

_Reading: CS:APP optimization + concurrency sections; performance tooling materials_ 

## **Weeks 13–14: Performance Measurement Tools** 

Total Time: 24–30 hours (2 weeks) 

**Week 13:** Baseline benchmarks for allocator/shell. Collect CPU time, RSS, and key counters (if on Linux, use `perf stat` ). 

**Week 14:** Generate flamegraphs (Linux) or sampling profiles (macOS). Identify top hotspots and write hypotheses. 

**Deliverable:** baseline report + profiling artifacts committed. 

## **Weeks 15–16: Optimization Project** 

Total Time: 24–32 hours (2 weeks) 

**Week 15:** Implement 1–2 optimizations with narrow scope. Re-profile and quantify impact. **Week 16:** Write a performance report: methodology, before/after table, and what you learned. 

**Acceptance criteria** Measurable improvement or a correct explanation why not Reproducible benchmark commands 

## **Weeks 17–18: Threads and Synchronization** 

Total Time: 24–30 hours (2 weeks) 

**Week 17:** Create race conditions on purpose, then fix using mutex/atomics. Write “what went wrong” notes. **Week 18:** Implement a thread pool library with a work queue, shutdown, and tests. 

**==> picture [342 x 189] intentionally omitted <==**

**----- Start of picture text -----**<br>
Weeks 19–20: Multithreaded Performance Project<br>Total Time: 24–32 hours (2 weeks)<br>Week 19:  Build a benchmark that exhibits lock contention. Measure<br>throughput vs threads.<br>Week 20:  Improve scaling (sharding/finer locks). Produce scaling<br>curves.<br>Acceptance criteria<br>Thread pool repo<br>Scaling curves and contention story<br>**----- End of picture text -----**<br>


**==> picture [350 x 121] intentionally omitted <==**

**----- Start of picture text -----**<br>
Weeks 21–22: Cache Architecture Deep Dive<br>Total Time: 24–30 hours (2 weeks)<br>Week 21:  Measure cache line size experimentally; implement stride<br>experiments and plot results.<br>Week 22:  Demonstrate false sharing and fix with padding/alignment;<br>measure before/after.<br>**----- End of picture text -----**<br>


**==> picture [353 x 121] intentionally omitted <==**

**----- Start of picture text -----**<br>
Weeks 23–24: Matrix Multiplication Optimization<br>Total Time: 26–34 hours (2 weeks)<br>Week 23:  Implement naive matmul; benchmark across sizes; capture<br>counters if available.<br>Week 24:  Implement blocking/tiling and loop order changes; quantify<br>speedup; write teaching-style report.<br>**----- End of picture text -----**<br>


**Acceptance criteria** 5×+ speedup over naive (or best possible on your system explained) Cache-miss before/after measurements Graphs and reproducible benchmark scripts 

## **MONTHS 7–12: Consolidation + Capstone (Weeks 25–52)** 

**Focus: Build a production-quality portfolio piece** Months 7–12 consolidate everything into a flagship project: a highperformance KV server. You will benchmark it, profile it, optimize it, and write it up like a mini thesis. 

## **Week 25: Sockets Basics (TCP Client/Server)** 

Total Time: 12–16 hours **Day 1–2:** Build TCP echo client/server. Handle partial reads/writes correctly. **Day 3–4:** Add simple protocol framing (length-prefix or line-delimited) and tests. **Weekend:** Benchmark localhost latency and throughput; record baseline. 

**Week 26: HTTP Basics (Build a Minimal HTTP Server)** Total Time: 12–18 hours **Day 1–2:** Learn HTTP request/response parsing; implement GET for static responses. 

**Day 3–4:** Implement header parsing + keep-alive basics; test with `curl` . **Weekend:** Write README describing protocol parsing and correctness constraints. 

**==> picture [348 x 141] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 27: Nonblocking I/O (select/poll)<br>Total Time: 12–18 hours<br>Day 1–3:  Convert server to nonblocking sockets; add  select  or  poll<br>event loop.<br>Day 4–5:  Add connection limits and timeouts; handle slow clients<br>without blocking.<br>Weekend:  Benchmark vs blocking model; record CPU usage.<br>**----- End of picture text -----**<br>


**==> picture [365 x 290] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 28: Event Loop v2 (epoll/kqueue) + Month 7 Report<br>Total Time: 14–22 hours<br>Day 1–3:  Implement  epoll  (Linux) or  kqueue  (macOS/BSD) server<br>loop.<br>Day 4–5:  Benchmark throughput/latency; include tail latency (p99).<br>Weekend:  Write Month 7 report: what model scaled best and why.<br>Week 29: Blocking vs Nonblocking I/O Deep Dive<br>Total Time: 12–18 hours<br>Day 1–2:  Create a load generator (or use  wrk  if HTTP). Define repeatable<br>workload.<br>Day 3–5:  Compare models under load; capture latency percentiles and<br>CPU usage.<br>**----- End of picture text -----**<br>


**==> picture [363 x 531] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 30: I/O Model Comparison (Write the Evidence)<br>Total Time: 12–18 hours<br>Day 1–3:  Create a single benchmark script that runs each server mode<br>identically.<br>Day 4–5:  Write a comparison report with graphs and explanations.<br>Acceptance criteria<br>Benchmark script is reproducible<br>At least 3 I/O models compared<br>Graphs include p50/p95/p99 and throughput<br>Week 31: io_uring (Optional, Linux) or Advanced Event Loop<br>(macOS)<br>Total Time: 10–18 hours<br>Goal:  learn one advanced async I/O mechanism and document tradeoffs.<br>Deliverable:  prototype server + notes.<br>Week 32: Capstone Design Doc<br>Total Time: 10–16 hours<br>Day 1–3:  Write a 2–4 page design doc for the KV server: protocol, data<br>model, concurrency model, metrics.<br>Day 4–5:  Define acceptance criteria (req/s, p99 targets, memory<br>bounds) and a benchmark plan.<br>**----- End of picture text -----**<br>


## **Capstone: High-Performance KV Server (Weeks 33–44)** 

**Week 33: Core Data Structure** Total Time: 12–18 hours 

**Day 1–3:** Implement hash table (chaining or open addressing). Add correctness tests. 

**Day 4–5:** Add basic operations: GET/SET/DEL. Add fuzz-like random test. 

**Week 34: Protocol + Parser** Total Time: 12–18 hours **Day 1–2:** Define protocol framing (text or binary). Document it. **Day 3–5:** Implement parser and request validation; add negative tests. 

## **Week 35: Server v1 (Single-thread Baseline)** 

Total Time: 12–20 hours **Day 1–3:** Implement event loop server handling multiple clients. **Day 4–5:** Add instrumentation: ops/sec, p50/p99, RSS. 

## **Week 36: Benchmark Harness** 

Total Time: 12–18 hours **Day 1–2:** Build load generator (or adapt one). Define workloads: readheavy, write-heavy, mixed. **Day 3–5:** Capture baseline graphs: throughput vs concurrency, p99 vs load. 

**==> picture [179 x 35] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 37: Profiling the Baseline<br>Total Time: 12–18 hours<br>**----- End of picture text -----**<br>


**==> picture [353 x 64] intentionally omitted <==**

**----- Start of picture text -----**<br>
Day 1–3:  Profile hotspots (CPU + allocation). Identify top 2 bottlenecks<br>with evidence.<br>Day 4–5:  Write “bottleneck memo” describing hypotheses and next<br>experiments.<br>**----- End of picture text -----**<br>


**==> picture [365 x 104] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 38: Optimization Round 1 (Parsing + Allocation)<br>Total Time: 12–20 hours<br>Day 1–3:  Reduce allocations (buffer reuse, arena, pooling). Keep changes<br>measurable.<br>Day 4–5:  Re-benchmark and update graphs.<br>**----- End of picture text -----**<br>


**==> picture [356 x 251] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 39: Concurrency Model Choice<br>Total Time: 12–18 hours<br>Day 1–2:  Decide model: sharded maps, thread pool, or single-thread +<br>batching.<br>Day 3–5:  Implement and test correctness under load.<br>Week 40: Contention + Tail Latency<br>Total Time: 12–20 hours<br>Day 1–3:  Measure contention and tail latency under load (p99/p999).<br>Day 4–5:  Apply one mitigation (sharding, backpressure, batching). Re-<br>measure.<br>**----- End of picture text -----**<br>


**==> picture [389 x 581] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 41: Hardening (Limits, Timeouts, Failure Behavior)<br>Total Time: 10–18 hours<br>Day 1–3:  Add connection limits, timeouts, graceful shutdown, error<br>handling.<br>Day 4–5:  Write overload behavior spec (what happens at 2× intended<br>load?).<br>Week 42: Benchmark Reproducibility<br>Total Time: 10–16 hours<br>Day 1–2:  Make benchmarks one-command reproducible (scripts +<br>documented env).<br>Day 3–5:  Add a results folder with raw logs and plotted charts.<br>Week 43: Final Optimization Round<br>Total Time: 12–20 hours<br>Goal:  pick one “big win” optimization and validate across multiple runs<br>(variance).<br>Deliverable:  final performance table (throughput + p50/p99 +<br>CPU/mem).<br>Week 44: Final Report Draft (Design + Performance)<br>Total Time: 10–16 hours<br>Write:  a clear report: architecture, constraints, bottlenecks found, what<br>worked, what didn’t.<br>a<br>**----- End of picture text -----**<br>


**Month 12: Packaging + Job Prep (Weeks 45–52)** 

**==> picture [390 x 580] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 45: README + Architecture Notes<br>Total Time: 10–16 hours<br>Write:  comprehensive README: architecture, API, build, benchmarks,<br>results.<br>—<br>Week 46: Performance Report + Graphs<br>Total Time: 10–16 hours<br>Create:  graphs + optimization journey narrative; include flamegraphs.<br>a<br>Week 47: Release v1.0 + Cleanup<br>Total Time: 10–16 hours<br>Do:  code cleanup, testing pass, tag release, and freeze benchmarks.<br>—<br>Week 48: Resume + Interview Talk<br>Total Time: 10–16 hours<br>Write:  one-page resume with quantified bullets; prepare a 10–12 minute<br>talk.<br>—<br>Week 49: Catch-up / Fix Weak Spots<br>Total Time: 8–16 hours<br>Goal:  close gaps from Months 1–11 without adding new scope.<br>a<br>**----- End of picture text -----**<br>


**Week 50: Deepen OS Knowledge (Self-Exam)** Total Time: 8–16 hours **Create:** 10-question OS/perf exam; answer without notes; fix weak topics. ~~—~~ **Week 51: Small Bonus Project (Optional)** Total Time: 8–16 hours **Pick one:** tracer, log analyzer, small profiler, or load generator improvements. ~~—~~ **Week 52: Portfolio Packaging** Total Time: 8–16 hours **Deliver:** a portfolio index: top 2–3 repos, quick summaries, how to run, results. ~~—~~ **Year 1 capstone acceptance criteria** KV server with reproducible benchmark scripts Latency percentiles (p50/p95/p99) reported under load At least one documented optimization with measured impact README and performance report suitable for interview discussion 

## **4. Year 2: Infrastructure + Hardware Awareness (Months 13–24)** 

**Goal:** learn networking/storage/distributed systems deeply enough to build and measure real systems, while becoming hardware-aware (NUMA, PCIe/DMA concepts). 

|**Months**|**Theme**|**Project**|**Proof**|
|---|---|---|---|
|13–15|Networking<br>internals|High-performance echo<br>server<br>(epoll/kqueue/io_uring)|Latency/throughput +<br>traces|
|16–18|Storage<br>systems|Append-only engine +<br>compaction + fsync strategy|Write latency and<br>amplification report|
|19–21|Distributed<br>systems|Replicated KV<br>(leader/follower or raft-<br>backed)|Failure injection +<br>correctness story|
|22–24|Hardware<br>interface +<br>NUMA|NUMA-aware tool or data<br>structure|Placement report +<br>improvements|



**Year 2: Month-by-Month Plan (Months 13–24)** 

|**Month**|**Focus**|**Build**|**Measure**|**Deliverable**|
|---|---|---|---|---|
|13|TCP<br>fundamentals<br>+ sockets<br>mastery|TCP echo<br>server/client +<br>robust framing|Throughput/latency<br>baselines + packet<br>capture|Networking<br>repo v1 +<br>write-up|
|14|High-<br>performance<br>I/O<br>(epoll/kqueue)|Event-loop<br>server with<br>backpressure|p50/p95/p99 under<br>load + CPU/req|I/O server v2<br>+ benchmark<br>report|
|15|Zero-copy +<br>advanced<br>tuning|sendfile/zero-<br>copy<br>experiments<br>(where<br>available)|Tail latency study +<br>mitigation|Networking<br>phase report<br>+ graphs|
|16|Storage<br>fundamentals<br>(fsync,<br>durability)|Append-only<br>log writer +<br>checksums|Write latency vs<br>durability settings|Storage repo<br>v1|
|17|Compaction +<br>LSM-style<br>design|Compaction<br>prototype +<br>index strategy|Write amplification<br>measurement|Storage repo<br>v2 + report|
|18|IO<br>benchmarking<br>discipline|Benchmark<br>harness +<br>workload<br>generator|fio/blktrace/iostat<br>experiments|Storage<br>phase paper<br>(2–3 pages)|
|19|Replication<br>basics|Leader/follower<br>KV replication|Failover correctness<br>tests|Distributed<br>KV v1|
|20|Consistency +<br>partitions|Partitioning +<br>membership<br>changes|Latency under<br>failure injection|Distributed<br>KV v2 +<br>experiments|
|21|Operational<br>behaviors|Backpressure +<br>load shedding +<br>retries|Tail latency<br>mitigation under<br>chaos|Distributed<br>phase report|



|22|NUMA +<br>bandwidth<br>awareness|NUMA<br>experiment<br>harness|Bandwidth/latency<br>measurements|NUMA notes<br>+ baseline<br>report|
|---|---|---|---|---|
|23|Tracing and<br>profiling<br>(eBPF<br>optional)|Tracing scripts<br>+ profiling<br>playbook|Find and explain 2<br>real bottlenecks|Tracing<br>toolkit repo|
|24|Year-2<br>portfolio<br>polish|Reproducible<br>benchmarks +<br>docs pass|Re-run full<br>benchmark suite|Year-2<br>portfolio<br>index +<br>resume<br>update|



## **Year 2: Execution Calendar (Weeks 53–104)** 

Year 2 is detailed week-by-week for Months 13–24 (networking, storage, distribution, and hardware awareness). 

## **Months 13–15: Networking Internals (Weeks 53–64)** 

## **Week 53: TCP Echo Server v1 (Correctness First)** 

Total Time: 12–18 hours 

O **Goal:** a correct TCP client/server with robust I/O handling. O **Day 1 (2–3h):** Implement server accept loop + per-connection read/write loop. Log errors and disconnect cleanly. 

O **Day 2 (2–3h):** Implement client. Validate multi-message exchanges and multiple clients. 

O **Day 3 (2–3h):** Fix partial read/write correctness (don’t assume full buffers). Add “slow client” test. 

O **Weekend (6–8h):** Add framing (newline-delimited or length-prefix). Add tests that send fragmented messages. 

**Deliverable:** runnable echo server/client + framing + tests. 

**==> picture [244 x 12] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 54: Measuring Networking Baselines<br>**----- End of picture text -----**<br>


Total Time: 10–16 hours O **Goal:** create a repeatable benchmark and learn what “good measurement” looks like. O **Day 1 (2–3h):** Build a small load generator (N clients, fixed request size, fixed duration). O **Day 2 (2–3h):** Capture throughput and latency percentiles (p50/p95/p99). Record environment. O **Weekend (6–8h):** Run 5–10 repeated trials. Document variance and the chosen benchmark protocol. O **Deliverable:** `bench/` scripts + baseline metrics table. 

**==> picture [348 x 200] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 55: Packet-Level Understanding (Trace + Explain)<br>Total Time: 10–16 hours<br>O Goal:  explain what happens on the wire and tie it back to your code.<br>O Day 1 (2–3h):  Capture a trace during a benchmark<br>(Wireshark/tcpdump). Identify handshake and data packets.<br>O Day 2 (2–3h):  Map trace events to your code path (accept, read loop,<br>write loop, close).<br>O Weekend (6–8h):  Write a 1–2 page note explaining the connection<br>lifecycle and common pitfalls (Nagle, buffering, timeouts).<br>O Deliverable:  trace artifacts + explanation note.<br>**----- End of picture text -----**<br>


**==> picture [352 x 247] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 56: Hardening (Timeouts, Limits, Failure Modes)<br>Total Time: 12–18 hours<br>Day 1–2 (4–6h):  Add timeouts, connection limits, and graceful<br>shutdown.<br>Day 3 (2–3h):  Add “abuse tests” (slowloris-style, malformed frames,<br>disconnect mid-frame).<br>Weekend (6–8h):  Re-run baselines and document changed behavior<br>under overload.<br>Month 13 acceptance criteria<br>Correct echo server with framing and tests<br>Benchmark harness + baseline table<br>Trace + written explanation<br>**----- End of picture text -----**<br>


**==> picture [356 x 142] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 57: Nonblocking I/O Baseline (select/poll)<br>Total Time: 12–18 hours<br>Day 1–3 (6–9h):  Convert server to nonblocking sockets. Implement<br>`select` or `poll` loop.<br>Day 4–5 (4–6h):  Handle partial writes and output buffering correctly.<br>Add tests for slow receivers.<br>Deliverable:  nonblocking server mode + tests.<br>**----- End of picture text -----**<br>


**==> picture [349 x 141] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 58: High-Performance Event Loop (epoll/kqueue)<br>Total Time: 12–20 hours<br>Day 1–3 (6–10h):  Implement epoll (Linux) or kqueue (macOS/BSD)<br>event loop.<br>Day 4–5 (4–6h):  Add per-connection state machine and bounded<br>buffers.<br>Deliverable:  event-loop server mode + correctness tests.<br>**----- End of picture text -----**<br>


## **Week 59: Backpressure + Tail Latency** 

Total Time: 10–18 hours 

**Day 1–2 (4–6h):** Implement backpressure (drop/limit/queue) when buffers grow. **Day 3–5 (4–8h):** Benchmark tail latency (p99/p999) under bursty load. Document what improves or worsens. **Deliverable:** tail latency note + graphs. 

## **Week 60: Comparative Benchmark Report (Blocking vs Nonblocking vs Event Loop)** Total Time: 10–16 hours 

**Day 1–2 (4–6h):** Create a single benchmark script that tests each I/O model identically. **Weekend (6–8h):** Write the report: metrics table, graphs, and explanations. 

**Month 14 acceptance criteria** At least 3 I/O models implemented Reproducible benchmark script Graphs showing throughput + p50/p95/p99 

## **Week 61: Zero-Copy Experiment Setup** 

Total Time: 10–16 hours 

**Goal:** understand where copies happen and how to measure them. **Day 1–2 (4–6h):** Identify a workload that transfers data (file → socket). Build baseline buffered path. **Day 3–5 (4–8h):** Implement sendfile-like path if supported; otherwise do “copy reduction” (larger buffers, fewer syscalls) and document limitations. 

**==> picture [362 x 502] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 62: Measure and Explain Copy Costs<br>Total Time: 10–16 hours<br>Day 1–2 (4–6h):  Benchmark throughput and CPU usage for baseline vs<br>improved path.<br>Weekend (6–8h):  Write a short “where copies happen” explanation<br>tied to your results.<br>Week 63: Burst Handling + Queueing<br>Total Time: 10–18 hours<br>Day 1–3 (6–9h):  Add bursty load scenario and observe<br>queues/backpressure behavior.<br>Day 4–5 (4–6h):  Add one mitigation (bounded queues, early drop,<br>prioritization) and re-measure.<br>Week 64: Networking Phase Paper<br>Total Time: 10–16 hours<br>Write:  2–4 pages: architecture, I/O models, results, tail latency story,<br>what you’d do next.<br>Month 15 acceptance criteria<br>Zero-copy or copy-reduction experiment documented<br>Tail latency improvements with graphs<br>Networking phase paper shipped<br>**----- End of picture text -----**<br>


## **Months 16–18: Storage Systems (Weeks 65–76)** 

## **Week 65: Record Format + Append-Only Log** 

Total Time: 12–18 hours 

**Day 1–2 (4–6h):** Define record format (header, key, value, checksum). Document it. 

**Day 3–5 (4–8h):** Implement append-only writer and reader, verify checksums, handle corruption cases. **Deliverable:** storage engine v1: log writer/reader + tests. 

## **Week 66: Durability Controls (fsync, batching)** 

Total Time: 10–18 hours 

**Day 1–2 (4–6h):** Add durability modes (fsync per op, per batch, periodic). 

**Weekend (6–8h):** Benchmark write latency across durability modes and record results. 

## **Week 67: Index Strategy v1** 

Total Time: 10–16 hours **Day 1–3 (6–9h):** Add an index (in-memory hash map from key → latest offset). **Day 4–5 (4–6h):** Support rebuild index from log on startup and test crash recovery. 

**==> picture [345 x 172] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 68: Month 16 Report (Durability Tradeoffs)<br>Total Time: 8–14 hours<br>Write:  1–2 pages explaining fsync semantics, batching tradeoffs, and<br>your measured results.<br>Month 16 acceptance criteria<br>Append-only store with record format + checksums<br>Durability modes implemented and benchmarked<br>Crash recovery story (index rebuild) documented<br>**----- End of picture text -----**<br>


**==> picture [363 x 286] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 69: Compaction Design (What to Keep, What to Drop)<br>Total Time: 10–16 hours<br>Day 1–2 (4–6h):  Define compaction goals: reduce log size, remove stale<br>records, preserve correctness.<br>Day 3–5 (4–8h):  Implement a compaction pass that rewrites live keys<br>into a new segment.<br>Week 70: Write Amplification Measurement<br>Total Time: 10–16 hours<br>Day 1–2 (4–6h):  Create workloads (update-heavy, append-heavy,<br>mixed) and run compaction.<br>Weekend (6–8h):  Measure amplification: bytes written / bytes of<br>logical writes. Plot it.<br>**----- End of picture text -----**<br>


**==> picture [352 x 525] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 71: Read Path and Latency<br>Total Time: 10–18 hours<br>Day 1–3 (6–9h):  Optimize read path (index lookups, buffering, fewer<br>syscalls).<br>Day 4–5 (4–6h):  Benchmark read latency before/after and record<br>results.<br>Week 72: Month 17 Report (Compaction Tradeoffs)<br>Total Time: 8–14 hours<br>Write:  compaction design note + amplification graphs + correctness<br>constraints.<br>Month 17 acceptance criteria<br>Compaction implemented and tested<br>Write amplification measured and explained<br>Read latency benchmarks documented<br>Week 73: Benchmark Harness (Reproducibility)<br>Total Time: 10–16 hours<br>Day 1–2 (4–6h):  Create benchmark scripts: workloads, durations,<br>warmup, output format.<br>Day 3–4 (4–6h):  Save raw logs and produce a simple summary table.<br>Record environment in every run.<br>**----- End of picture text -----**<br>


**==> picture [361 x 502] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 74: System Tools Study (fio/iostat/blktrace)<br>Total Time: 8–14 hours<br>Day 1–2 (4–6h):  Run fio workloads to understand latency vs queue<br>depth; document results.<br>Weekend (4–8h):  Use iostat and (if available) blktrace to interpret I/O<br>behavior.<br>Week 75: Strategy Comparison (sync/async, batching, fsync)<br>Total Time: 10–16 hours<br>Day 1–3 (6–9h):  Run controlled comparisons across durability and<br>batching strategies.<br>Day 4–5 (4–6h):  Summarize results into 2–3 key takeaways tied to<br>evidence.<br>Week 76: Storage Phase Paper<br>Total Time: 8–14 hours<br>Write:  2–3 page storage report (durability tradeoffs, amplification, and<br>benchmark methodology).<br>Month 18 acceptance criteria<br>Benchmark harness is reproducible<br>System tools used and results interpreted<br>Storage phase paper shipped<br>**----- End of picture text -----**<br>


**==> picture [361 x 448] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 77: Replication Log + Leader Append<br>Total Time: 12–18 hours<br>Build:  replicate writes via an append-only replication log (single leader).<br>Define:  request IDs and an idempotency strategy for retries.<br>Deliverable:  leader that ships a log stream to one follower.<br>Week 78: Follower Apply + Catch-Up<br>Total Time: 12–18 hours<br>Build:  follower apply loop with ordering guarantees and a durable<br>“applied offset”.<br>Test:  crash/restart follower; verify correct catch-up behavior.<br>Deliverable:  follower replays from offset and reaches leader state.<br>Week 79: Client Semantics (Reads, Writes, and Consistency)<br>Total Time: 10–16 hours<br>Define:  read consistency model (leader reads, follower reads with<br>staleness bounds, or explicit “read-your-writes”).<br>Build:  client retry rules + timeouts that don’t break correctness.<br>Deliverable:  client library or CLI that exercises failure/retry paths.<br>**----- End of picture text -----**<br>


**==> picture [255 x 9] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 80: Failover Demo + Correctness Tests<br>**----- End of picture text -----**<br>


**==> picture [362 x 528] intentionally omitted <==**

**----- Start of picture text -----**<br>
Total Time: 12–18 hours<br>Test:  duplicate requests, crash mid-write, follower lag, reconnect storms.<br>Demo:  kill leader, promote follower (manual is fine), and continue<br>serving traffic.<br>Month 19 acceptance criteria<br>Leader/follower replication working end-to-end<br>Correctness tests cover crashes and duplicates<br>Failover demo is repeatable<br>Week 81: Partitioning Strategy + Key Ownership<br>Total Time: 10–16 hours<br>Design:  partitioning approach (hash ring, fixed shards, or range).<br>Build:  routing layer that maps key → owner node.<br>Deliverable:  multi-node routing with one shard per node.<br>Week 82: Membership Changes (Join/Leave)<br>Total Time: 10–16 hours<br>Build:  membership config (static file or coordinator) and a safe update<br>mechanism.<br>Test:  join/leave sequences; verify routing updates without serving wrong<br>data.<br>Deliverable:  membership change demo with logs.<br>**----- End of picture text -----**<br>


**==> picture [360 x 347] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 83: Rebalancing + Data Movement<br>Total Time: 12–18 hours<br>Build:  rebalancing path (copy shard data, cut over ownership, clean up).<br>Test:  rebalancing correctness (no lost keys, no duplicates) under retries.<br>Deliverable:  rebalancing runbook + reproducible script.<br>Week 84: Latency Under Failures + Report<br>Total Time: 10–16 hours<br>Measure:  p50/p95/p99 latency during membership change and node<br>failure.<br>Write:  experiment notes and an interpretation of the bottlenecks.<br>Month 20 acceptance criteria<br>Partition routing and membership updates implemented<br>Rebalancing path demonstrated<br>Failure-injection latency measured and explained<br>**----- End of picture text -----**<br>


**==> picture [305 x 108] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 85: Backpressure + Load Shedding Policies<br>Total Time: 10–16 hours<br>Build:  bounded queues, overload responses, and retry hints.<br>Measure:  throughput and tail latency under bursty load.<br>Deliverable:  overload behaviors documented with graphs.<br>**----- End of picture text -----**<br>


**==> picture [342 x 125] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 86: Chaos Harness (Delay, Drop, Partition)<br>Total Time: 10–16 hours<br>Build:  fault injection controls (request delay, packet loss simulation,<br>node kills).<br>Test:  correctness under chaos (no invalid reads, idempotent writes).<br>Deliverable:  chaos scripts + a repeatable scenario list.<br>**----- End of picture text -----**<br>


**==> picture [336 x 125] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 87: Tail Latency Mitigations<br>Total Time: 10–16 hours<br>Implement:  timeouts, circuit breakers, and at least one mitigation<br>(hedged requests or adaptive batching).<br>Measure:  p99/p999 improvements under a fixed chaos scenario.<br>Deliverable:  before/after results with explanation.<br>**----- End of picture text -----**<br>


**==> picture [340 x 156] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 88: Distributed Phase Report<br>Total Time: 8–14 hours<br>Write:  2–4 pages: failure model, mitigations, and measured results.<br>Month 21 acceptance criteria<br>Chaos harness exists and is repeatable<br>At least one mitigation measurably helps tail latency<br>Distributed phase report shipped<br>**----- End of picture text -----**<br>


**==> picture [348 x 139] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 89: NUMA and Locality Baselines<br>Total Time: 10–16 hours<br>Measure:  memory bandwidth/latency baselines across thread counts<br>and access patterns.<br>Document:  what “local” vs “remote” memory means for your target<br>environment.<br>Deliverable:  baseline results table + notes.<br>**----- End of picture text -----**<br>


**==> picture [357 x 311] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 90: Pinning + Placement Harness<br>Total Time: 10–16 hours<br>Build:  harness to pin threads/cores and control memory allocation<br>where possible.<br>Measure:  performance delta for “good” vs “bad” placement on one<br>workload.<br>Deliverable:  scripts that reproduce the experiment.<br>Week 91: Apply Locality Lessons to Your KV<br>Total Time: 10–16 hours<br>Change:  one structural thing (sharding by thread, per-core queues, or<br>data layout) to improve locality.<br>Measure:  throughput and tail latency before/after at high concurrency.<br>Deliverable:  short note linking change → locality effect.<br>**----- End of picture text -----**<br>


**==> picture [359 x 156] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 92: NUMA Report<br>Total Time: 8–14 hours<br>Write:  experiment design, results, and “what I would do in production”.<br>Month 22 acceptance criteria<br>Locality harness exists and is reproducible<br>One KV change tied to measured locality effect<br>NUMA report shipped<br>**----- End of picture text -----**<br>


**==> picture [190 x 12] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 93: CPU Profiling Playbook<br>**----- End of picture text -----**<br>


**==> picture [328 x 77] intentionally omitted <==**

**----- Start of picture text -----**<br>
Total Time: 10–16 hours<br>Build:  profiling scripts + a repeatable “capture → interpret → act”<br>checklist.<br>Deliverable:  profiling playbook repo folder you can reuse.<br>**----- End of picture text -----**<br>


**==> picture [349 x 125] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 94: Syscall + Network Tracing<br>Total Time: 10–16 hours<br>Capture:  syscall traces and one network trace for your distributed KV<br>under load.<br>Explain:  which syscalls dominate and why (tie back to code paths).<br>Deliverable:  trace artifacts + explanation note.<br>**----- End of picture text -----**<br>


**==> picture [198 x 12] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 95: Bottleneck Case Study #1<br>**----- End of picture text -----**<br>


**==> picture [304 x 83] intentionally omitted <==**

**----- Start of picture text -----**<br>
Total Time: 12–18 hours<br>Find:  a real bottleneck in a prior project using your playbook.<br>Fix:  implement an improvement and measure before/after.<br>Deliverable:  case study write-up with numbers.<br>**----- End of picture text -----**<br>


## **Week 96: Bottleneck Case Study #2 + Toolkit Release** 

Total Time: 12–18 hours 

**Repeat:** a second case study with a different bottleneck class (CPU, I/O, contention, network). 

**==> picture [359 x 27] intentionally omitted <==**

**----- Start of picture text -----**<br>
Package:  tracing/profiling toolkit into a clean repo directory with scripts<br>and example outputs.<br>**----- End of picture text -----**<br>


## **Month 23 acceptance criteria** 

Profiling playbook exists and is reusable Two bottlenecks found and explained with evidence Toolkit packaged for reuse 

## **Week 97: Benchmark Audit + Reproducibility Checklist** 

Total Time: 8–14 hours 

**==> picture [356 x 85] intentionally omitted <==**

**----- Start of picture text -----**<br>
Audit:  benchmark scripts and configs; ensure they capture environment<br>and raw logs.<br>Fix:  one reproducibility issue (nondeterminism, missing flags, missing<br>warmup).<br>Deliverable:  reproducibility checklist applied to all projects.<br>**----- End of picture text -----**<br>


**==> picture [311 x 104] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 98: Documentation and Script Cleanup<br>Total Time: 8–14 hours<br>Do:  tighten project entrypoints, add clear run commands, and<br>standardize output locations.<br>Deliverable:  consistent repo structure across projects.<br>**----- End of picture text -----**<br>


**==> picture [317 x 125] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 99: Full Benchmark Re-Run<br>Total Time: 10–16 hours<br>Run:  a clean end-to-end benchmark pass (networking, storage,<br>distributed, locality).<br>Summarize:  key metrics in a portfolio table.<br>Deliverable:  locked benchmark snapshots.<br>**----- End of picture text -----**<br>


**==> picture [360 x 104] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 100: Portfolio Index v1<br>Total Time: 8–14 hours<br>Build:  a single “portfolio index” page listing projects and results (links +<br>numbers).<br>Deliverable:  portfolio index v1.<br>**----- End of picture text -----**<br>


**==> picture [350 x 221] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 101: Resume Rewrite With Quantified Bullets<br>Total Time: 6–12 hours<br>Do:  rewrite bullets to include metrics, scale, and evidence links.<br>Deliverable:  resume v1 + bullet bank.<br>Week 102: Project Talk Outline + Deep Dive Prep<br>Total Time: 8–14 hours<br>Prepare:  10–15 minute tech talk outline and 2 deep-dive storyboards.<br>Deliverable:  talk deck draft + deep dive notes.<br>**----- End of picture text -----**<br>


## **Week 103: Application Sprint + Tracking** 

Total Time: 6–12 hours 

**Do:** apply to roles and keep a structured log (company, role, links, followups). **Deliverable:** application log with weekly targets. 

## **Week 104: Year 2 Retrospective + Final Package** 

Total Time: 6–12 hours 

**Write:** a short retrospective: biggest wins, lessons, and what you’d rebuild. **Deliverable:** year-2 portfolio index + interview prep pack. 

**Month 24 acceptance criteria** Benchmarks rerun and results locked Portfolio index and resume refreshed Interview prep materials drafted 

## **5. Year 3: GPU Specialization (Months 25–36)** 

**Goal:** become a credible candidate for GPU performance / runtime / infra roles. You’ll ship 1–2 “industry-grade” projects with profiling and design docs. 

|**Months**|**Theme**|**Project**|**Proof**|
|---|---|---|---|
|25–28|CUDA<br>fundamentals +<br>profiling|Kernel suite (matmul,<br>reduction, convolution)|Nsight before/after<br>metrics|
|29–31|CPU↔GPU<br>orchestration +<br>scheduling|Scheduler/orchestrator<br>simulator|Utilization + tail<br>latency<br>improvements|
|32–34|Production<br>plumbing|Containerized GPU<br>workload + telemetry|E2E latency/cost<br>report|
|35–36|Final packaging +<br>interviews|Polish 2–3 flagship repos +<br>talk|Demo, scripts, and<br>documentation|



**Year 3: Month-by-Month Plan (Months 25–36)** 

|**Month**|**Focus**|**Build**|**Measure**|**Deliverable**|
|---|---|---|---|---|
|25|CUDA setup +<br>fundamentals|Kernel<br>sandbox<br>(vector add,<br>reduce)|Nsight:<br>occupancy +<br>memory<br>throughput|GPU repo v1|
|26|Memory<br>hierarchy|Tiled matmul<br>baseline +<br>shared<br>memory|Before/after<br>metrics + roofline<br>thinking|Matmul<br>report v1|
|27|Optimization<br>patterns|Reduce + scan<br>+ convolution<br>kernels|Register pressure<br>+ achieved<br>bandwidth|Kernel suite<br>report|
|28|Packaging project<br>A|Benchmark<br>harness +<br>reproducibility|Variance across<br>runs and configs|Project A<br>polished|
|29|CPU↔GPU<br>transfers +<br>orchestration|Pinned vs<br>pageable<br>benchmarks|Transfer<br>overhead and<br>batching curves|Orchestration<br>notes|
|30|Scheduling basics|Workload<br>generator +<br>queueing<br>model|Utilization vs tail<br>latency tradeoffs|Scheduler<br>sim v1|
|31|Scheduler<br>improvements|Policies (fair,<br>priority, SLO-<br>aware)|Demonstrate<br>improvement<br>under mixed<br>workloads|Project B<br>design doc +<br>results|
|32|Production<br>plumbing|Containerized<br>GPU workload|End-to-end<br>latency baseline|Deployable<br>demo v1|
|33|Observability|Metrics +<br>tracing +<br>dashboards|Explain<br>bottlenecks end-<br>to-end|Telemetry<br>report|
|34|Cost/performance<br>tuning|Batching +<br>caching<br>strategies|Cost per<br>request/inference<br>(if applicable)|Project C<br>report|



|35|Portfolio<br>polishing|READMEs,<br>scripts,<br>Dockerfiles|Re-run and lock<br>benchmark<br>results|Portfolio pack|
|---|---|---|---|---|
|36|Interviews|10–15 min<br>tech talk +<br>resume|Mock interviews<br>+ deep dives|Job-ready<br>package|



## **Year 3: Execution Calendar (Weeks 105–156)** 

_Reality rule:_ Year 3 is where you prove impact. Every month must end with a measurable profile report. 

## **Week 105: CUDA Setup + Benchmark Harness Skeleton** 

Total Time: 12–18 hours **Setup:** build toolchain and a minimal “run benchmarks” entrypoint. **Build:** timing harness (warmup, repeats, percentile reporting). **Deliverable:** GPU sandbox repo with reproducible benchmark runner. **Week 106: Vector Add + Memory Bandwidth Baseline** Total Time: 10–16 hours **Build:** vector add kernel with correctness tests and parameterized sizes. **Measure:** bandwidth vs size; record baseline metrics and variance. **Deliverable:** baseline chart + notes on memory-bound behavior. **Week 107: Reduction Baseline + Validation** Total Time: 12–18 hours **Build:** reduction kernel baseline (multiple variants allowed). **Test:** randomized tests and edge cases; ensure deterministic results. **Deliverable:** reduction baseline integrated into harness. 

## **Week 108: First Nsight Profile + Month 25 Report** 

Total Time: 10–16 hours 

**Profile:** capture occupancy, memory throughput, and kernel timeline for vector add and reduction. 

**Write:** a short “baseline profile” report with screenshots and interpretation. 

## **Month 25 acceptance criteria** 

Benchmark harness exists and is reproducible 

At least 2 kernels implemented with correctness tests Nsight baseline profile captured and explained 

**Week 109: Matmul Baseline (Naive)** Total Time: 12–18 hours **Build:** naive matmul kernel with correctness tests and multiple shapes. **Measure:** throughput across sizes; record baseline kernel time. **Deliverable:** baseline matmul integrated into harness. 

**Week 110: Shared-Memory Tiling** Total Time: 12–18 hours **Build:** tiled matmul variant using shared memory. **Measure:** before/after performance and a first-pass explanation. **Deliverable:** tiled version + comparison table. 

**==> picture [340 x 522] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 111: Parameter Sweeps + Micro-Optimizations<br>Total Time: 10–16 hours<br>Experiment:  block sizes, unrolling, and memory access patterns.<br>Profile:  collect Nsight metrics for top candidates and pick a winner.<br>Deliverable:  sweep script + chosen configuration justified.<br>Week 112: Roofline-Style Reasoning + Month 26 Report<br>Total Time: 10–16 hours<br>Write:  a matmul report tying kernel time to memory<br>throughput/compute utilization.<br>Deliverable:  “why it helped” notes per optimization with evidence.<br>Month 26 acceptance criteria<br>Matmul baseline and optimized variant implemented<br>Nsight metrics captured for baseline and best variant<br>Report explains improvements with evidence<br>Week 113: Convolution Baseline<br>Total Time: 12–18 hours<br>Build:  convolution baseline (direct or transformed) with tests.<br>Measure:  performance across input sizes and kernel sizes.<br>Deliverable:  baseline conv integrated into harness.<br>**----- End of picture text -----**<br>


**==> picture [364 x 651] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 114: Memory Coalescing + Shared Memory in Convolution<br>Total Time: 12–18 hours<br>Optimize:  improve access patterns and reduce redundant global loads.<br>Profile:  collect before/after metrics and attribute wins to specific<br>changes.<br>Deliverable:  conv optimization notes with evidence.<br>Week 115: Scan/Prefix-Sum Kernel<br>Total Time: 12–18 hours<br>Build:  scan kernel baseline with correctness tests and batch support.<br>Measure:  throughput and scaling as input grows.<br>Deliverable:  scan baseline integrated into harness.<br>Week 116: Kernel Suite Comparative Report (Month 27)<br>Total Time: 10–16 hours<br>Write:  a suite report: baselines, best variants, and Nsight screenshots.<br>Month 27 acceptance criteria<br>At least 3 kernels with optimized variants<br>Nsight evidence captured and explained<br>Comparative report shipped<br>Week 117: Benchmark Standardization + Result Format<br>Total Time: 10–16 hours<br>Build:  unified CLI for running all kernels with consistent flags and<br>outputs.<br>Deliverable:  standardized results schema and saved raw outputs.<br>**----- End of picture text -----**<br>


**==> picture [357 x 141] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 118: Reproducibility Pass (Environment + Variance)<br>Total Time: 8–14 hours<br>Add:  environment capture (GPU model, driver, toolkit version) to every<br>run.<br>Run:  repeated trials and record variance; define your default<br>methodology.<br>Deliverable:  reproducible benchmark methodology note.<br>**----- End of picture text -----**<br>


**==> picture [332 x 87] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 119: Packaging (Docs, Examples, and Plots)<br>Total Time: 8–14 hours<br>Do:  clean docs and examples; ensure a reader can reproduce plots.<br>Deliverable:  polished Project A repo structure.<br>**----- End of picture text -----**<br>


**==> picture [349 x 346] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 120: Project A Release + Month 28 Report<br>Total Time: 10–16 hours<br>Write:  final Project A report with baseline vs optimized summary and<br>Nsight evidence.<br>Month 28 acceptance criteria<br>Kernel suite packaged with reproducible runner<br>Results include variance and environment capture<br>Project A report shipped<br>Week 121: Workload Model + Simulator Skeleton<br>Total Time: 10–16 hours<br>Build:  workload generator (arrivals, service times, priorities).<br>Build:  simulator skeleton that can execute a policy and emit metrics.<br>Deliverable:  runnable simulator baseline.<br>**----- End of picture text -----**<br>


**==> picture [350 x 634] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 122: Baseline Scheduling Policies<br>Total Time: 10–16 hours<br>Implement:  FIFO and round-robin (or fair sharing) policies.<br>Measure:  utilization and p95/p99 latency under mixed load.<br>Deliverable:  baseline policy comparisons.<br>Week 123: Metrics + Tail Latency Instrumentation<br>Total Time: 10–16 hours<br>Add:  queue time breakdown, service time, and tail latency percentiles.<br>Deliverable:  results dashboard output (CSV + plot script is fine).<br>Week 124: Month 29 Report (Baselines)<br>Total Time: 8–14 hours<br>Write:  baseline policy results and bottleneck interpretation.<br>Month 29 acceptance criteria<br>Simulator runs multiple policies and emits metrics<br>Tail latency percentiles computed under load<br>Baseline report shipped<br>Week 125: SLO-Aware Scheduling<br>Total Time: 10–16 hours<br>Implement:  SLO-aware or deadline-aware policy (prioritize near-<br>deadline jobs).<br>Measure:  SLO miss rate vs baseline under bursty load.<br>Deliverable:  policy comparison with SLO metrics.<br>**----- End of picture text -----**<br>


**==> picture [359 x 279] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 126: Admission Control + Backpressure<br>Total Time: 10–16 hours<br>Build:  admission control and queue bounds; define overload behavior.<br>Measure:  tail latency under overload and the tradeoffs you choose.<br>Deliverable:  overload experiments documented.<br>Week 127: Mixed Workloads + Policy Tuning<br>Total Time: 10–16 hours<br>Run:  mixed workload experiments (short/long jobs, priority skew, burst<br>patterns).<br>Tune:  policy parameters based on evidence.<br>Deliverable:  tuning notes + results table.<br>**----- End of picture text -----**<br>


**==> picture [329 x 326] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 128: Month 30 Report (SLO/Tail Latency)<br>Total Time: 8–14 hours<br>Write:  what policy wins and why (tie to queueing effects).<br>Month 30 acceptance criteria<br>SLO-aware policy implemented and evaluated<br>Admission control behavior defined under overload<br>Report explains tail latency tradeoffs<br>Week 129: Multi-Node or Multi-GPU Scheduling Model<br>Total Time: 10–16 hours<br>Extend:  model to multiple workers with heterogeneous speeds or<br>resource limits.<br>Deliverable:  multi-worker simulator mode.<br>**----- End of picture text -----**<br>


**==> picture [341 x 630] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 130: Faults, Stragglers, and Recovery<br>Total Time: 10–16 hours<br>Inject:  worker failures and stragglers; define rescheduling behavior.<br>Measure:  throughput and tail latency under failure scenarios.<br>Deliverable:  failure experiments documented.<br>Week 131: Optimization Pass (Policy + Implementation)<br>Total Time: 10–16 hours<br>Optimize:  one real bottleneck in simulator or policy logic; show<br>measured improvement.<br>Deliverable:  before/after benchmark evidence.<br>Week 132: Design Doc + Project B Release (Month 31)<br>Total Time: 10–16 hours<br>Write:  3–5 page design doc and a results summary.<br>Month 31 acceptance criteria<br>Multi-worker scheduling model supported<br>Failure scenarios evaluated with tail-latency results<br>Design doc and release shipped<br>Week 133: Containerize a GPU Workload<br>Total Time: 10–16 hours<br>Build:  container image and a single command to run workload +<br>benchmarks.<br>Deliverable:  reproducible build/run scripts.<br>**----- End of picture text -----**<br>


**==> picture [266 x 35] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 134: Telemetry (Metrics + Basic Tracing)<br>Total Time: 10–16 hours<br>**----- End of picture text -----**<br>


**==> picture [335 x 48] intentionally omitted <==**

**----- Start of picture text -----**<br>
Add:  metrics for queue times, batch size, GPU time, and end-to-end<br>latency.<br>Deliverable:  metrics outputs with a simple dashboard script.<br>**----- End of picture text -----**<br>


**==> picture [344 x 110] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 135: End-to-End Baseline + Load Generator<br>Total Time: 10–16 hours<br>Build:  load generator with fixed workloads and reproducible configs.<br>Measure:  baseline p50/p95/p99 E2E latency and throughput.<br>Deliverable:  baseline results and environment capture.<br>**----- End of picture text -----**<br>


**==> picture [284 x 156] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 136: Month 32 Report (Baseline Plumbing)<br>Total Time: 8–14 hours<br>Write:  baseline architecture and metrics interpretation.<br>Month 32 acceptance criteria<br>Containerized workload runs reproducibly<br>Metrics and baseline E2E results captured<br>Baseline plumbing report shipped<br>**----- End of picture text -----**<br>


**==> picture [319 x 109] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 137: Batching Strategy<br>Total Time: 10–16 hours<br>Implement:  dynamic or fixed batching policy with clear limits.<br>Measure:  latency vs throughput tradeoff across batch sizes.<br>Deliverable:  batching experiment results.<br>**----- End of picture text -----**<br>


**==> picture [343 x 634] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 138: Caching and Memory Footprint<br>Total Time: 10–16 hours<br>Implement:  one cache (results, weights, or inputs) with measurable<br>impact.<br>Measure:  memory usage and latency impact under realistic load.<br>Deliverable:  cache tradeoff notes with metrics.<br>Week 139: Cost/Performance Measurement Plan<br>Total Time: 8–14 hours<br>Define:  cost model inputs and “cost per request” methodology.<br>Deliverable:  cost/perf worksheet and measurement script hooks.<br>Week 140: Month 33 Report (Batching/Caching/Cost)<br>Total Time: 8–14 hours<br>Write:  batching/caching results and cost/perf interpretation.<br>Month 33 acceptance criteria<br>Batching tradeoffs measured with tail latency<br>Caching impact measured with memory cost<br>Cost/perf methodology documented<br>Week 141: Reliability Behaviors (Retries, Timeouts)<br>Total Time: 10–16 hours<br>Add:  timeouts, retries, and backoff with correctness-safe semantics.<br>Measure:  behavior under injected slowdowns and partial failures.<br>Deliverable:  reliability experiment notes.<br>**----- End of picture text -----**<br>


**==> picture [356 x 104] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 142: Resource Management + Scaling Model<br>Total Time: 10–16 hours<br>Implement:  one scaling lever (worker count, batch limits, concurrency<br>caps) and measure impact.<br>Deliverable:  scaling experiments with metrics.<br>**----- End of picture text -----**<br>


**==> picture [365 x 125] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 143: Runbook + Incident Drill<br>Total Time: 8–14 hours<br>Write:  runbook: “how to debug latency regression”, “how to reproduce<br>load”.<br>Do:  one incident drill (inject failure, diagnose, mitigate) and record steps.<br>Deliverable:  runbook + incident write-up.<br>**----- End of picture text -----**<br>


**==> picture [328 x 173] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 144: Project C Report + Release (Month 34)<br>Total Time: 10–16 hours<br>Write:  end-to-end report with latency, throughput, and cost/perf<br>summary.<br>Month 34 acceptance criteria<br>Reliability behaviors evaluated with failure injection<br>Scaling lever measured and documented<br>Project C report shipped<br>**----- End of picture text -----**<br>


**==> picture [347 x 104] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 145: Choose Flagship Repos + Gap List<br>Total Time: 6–12 hours<br>Pick:  2–3 flagship repos and list missing pieces (docs, scripts, results,<br>clarity).<br>Deliverable:  prioritized gap list and timeline.<br>**----- End of picture text -----**<br>


**==> picture [365 x 590] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 146: Reproducibility + Benchmark Lock-In<br>Total Time: 8–14 hours<br>Run:  final benchmark suite for Projects A–C and store raw outputs.<br>Deliverable:  locked benchmark snapshots with environment metadata.<br>Week 147: Documentation Polish + Example Walkthroughs<br>Total Time: 8–14 hours<br>Do:  improve docs so a reader can run, reproduce, and understand results.<br>Deliverable:  polished READMEs and example outputs.<br>Week 148: Portfolio Pack v1 (Month 35)<br>Total Time: 8–14 hours<br>Assemble:  one-page portfolio sheet and links to evidence (plots, reports,<br>Nsight screenshots).<br>Month 35 acceptance criteria<br>Flagship repos are reproducible and benchmarked<br>Documentation supports quick evaluation<br>Portfolio pack assembled<br>Week 149: Tech Talk Draft<br>Total Time: 6–12 hours<br>Build:  10–15 minute tech talk deck around one flagship project.<br>Deliverable:  talk deck v1.<br>**----- End of picture text -----**<br>


**==> picture [364 x 550] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 150: Deep Dive Notes (GPU + Systems)<br>Total Time: 6–12 hours<br>Prepare:  deep dives on kernel optimization and one infra component<br>(scheduler or plumbing).<br>Deliverable:  Q&A notes and diagrams.<br>Week 151: Mock Interviews Round 1<br>Total Time: 6–12 hours<br>Do:  mock interviews focused on performance debugging and GPU<br>fundamentals.<br>Deliverable:  weaknesses list and targeted practice plan.<br>Week 152: Iterate on Weak Areas + Re-Measure<br>Total Time: 6–12 hours<br>Fix:  one identified weakness and update artifacts (talk, notes, or a project<br>result).<br>Deliverable:  improved materials + refreshed evidence links.<br>Week 153: Question Bank (Kernel + Orchestration)<br>Total Time: 6–12 hours<br>Build:  question bank for kernels, memory hierarchy, scheduling, and tail<br>latency.<br>Deliverable:  study sheet with short answers.<br>**----- End of picture text -----**<br>


**==> picture [346 x 220] intentionally omitted <==**

**----- Start of picture text -----**<br>
Week 154: Mock Interviews Round 2<br>Total Time: 6–12 hours<br>Do:  second mock round and refine explanations for your top projects.<br>Deliverable:  improved talk + more concise deep dive narratives.<br>Week 155: Application Sprint + Outreach<br>Total Time: 6–12 hours<br>Do:  apply and do targeted outreach; track responses and follow-ups.<br>Deliverable:  application log with weekly targets.<br>**----- End of picture text -----**<br>


## **Week 156: Final Review + Interview-Ready Package (Month 36)** Total Time: 6–12 hours 

**==> picture [354 x 24] intentionally omitted <==**

**----- Start of picture text -----**<br>
Finalize:  portfolio sheet, talk deck, and links to evidence for all flagship<br>work.<br>**----- End of picture text -----**<br>


**Month 36 acceptance criteria** Talk and deep dives are practiced and polished Portfolio evidence links are complete and current Interview-ready package assembled 

## **6. Must-Finish Projects & Acceptance Criteria** 

|**Project**|**Acceptance criteria (minimum)**|
|---|---|
|Mini Shell (Year 1)|fork/exec, pipes, redirection<br>script test suite<br>README explains syscalls|
|Custom Allocator (Year 1)|free-list allocator + tests<br>fragmentation experiment<br>bench vs malloc + graphs|
|Year-1 KV Server (Capstone)|baseline + optimized version<br>p50/p95/p99 latency and throughput under load<br>flamegraphs + reproducible benches<br>design + performance report|
|Storage Engine (Year 2)|append-only + compaction<br>fsync strategies compared<br>latency and write amplification report|
|GPU Kernel Suite (Year 3)|multiple kernels optimized with Nsight evidence<br>writeup per optimization explaining why it helped|



## **Templates** 

## **Weekly checklist template** 

**Week __ (Dates: __ → __)** 

- Reading completed (chapters/sections) 

- Exercises completed (list) 

- Build task finished (what you built) 

- Measurement completed (commands + results) 

- Write-up done (link) 

## **Project template** 

|**Field**|**Fill this in**|
|---|---|
|Problem statement|1 paragraph describing what matters|
|Goals|3 measurable goals|
|Non-goals|what you explicitly will not do|
|Acceptance criteria|numbers: latency, throughput, memory, correctness|
|Environment|CPU/GPU/OS/compiler/tool versions|
|Benchmark plan|workloads, number of runs, variance handling|
|Profiling plan|tools + what you’ll capture|
|Results|before/after + interpretation|



## **7. Self-Testing & Grading** 

**Each month: 2 parts** 

|**Part**|**Duration**|**Rule**|**Pass condition**|
|---|---|---|---|
|Theory<br>quiz|~2 hours|10 questions, no<br>notes|8/10 clear and correct|
|Practical<br>task|4–8 hours|measure/fix a real<br>program|show improvement or correct<br>explanation|



## **8. Job Search Timeline & Strategy** 

|**When**|**What to apply for**|**How to position**|
|---|---|---|
|Months 9–<br>12|Systems/infra internships|Lead with capstone baseline +<br>early perf wins|
|Months 20–<br>24|Entry/junior systems roles|Show storage + distributed KV<br>with failure tests|
|Months 30–<br>36|GPU/performance/compute<br>roles|Bring Nsight evidence + scheduler<br>design doc|



## **Resume rule** 

One page 

- Quantified bullets: “reduced p99 latency by 38% using X; measured across N runs” 

- Link to 2–3 flagship repos with benchmarks 

## **9. Resources & Tools Checklist** 

## **Tools** 

|**Category**|**Tools**|
|---|---|
|Build|gcc/clang,make,cmake|
|Debug|gdb/lldb, sanitizers,valgrind(Linux)|
|Inspect|objdump,nm,readelf(Linux),otool(macOS)|
|Trace|strace/dtruss|
|Profile|perf+ flamegraphs (Linux), Nsight (Year 3)|
|Benchmark|wrk,fio,iperf|



## **Books (recommended)** 

- CS:APP 

- OSTEP 

- DDIA 

- TCP/IP Illustrated 

- Programming Massively Parallel Processors 

## **10. Quick Start: First 30 Days (Day-byDay)** 

|**Days**|**Focus**|**Concrete tasks**|**Output**|
|---|---|---|---|
|1–3|Toolchain +<br>repo setup|Install compiler/debugger; create<br>repo; add Makefile; verify build/debug<br>loop.|Repo skeleton +<br>notes|
|4–10|CS:APP Ch.1|5 small C programs; compile stages;<br>save artifacts; debugger walkthrough.|Week 1<br>deliverable<br>shipped|
|11–17|CS:APP Ch.2|integer/float experiments; bit utilities;<br>basic tests; hexdump tool.|Week 2<br>deliverable<br>shipped|
|18–<br>24|CS:APP Ch.3|annotate assembly; compare-O0vs-<br>O2; disassemble binaries.|Week 3<br>deliverable<br>shipped|
|25–<br>30|Month 1<br>project + self-<br>test|build 100+ LOC program; crash<br>analysis; month report and self-test<br>answers.|Month 1<br>complete|



