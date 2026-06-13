# Week 1: CUDA setup + first kernel (vector add)

The first project in the new CUDA track.  This is the
entry point — get the toolchain working, write a kernel,
verify it against a CPU reference, measure throughput.

## Hardware

CUDA only runs on NVIDIA hardware.  The user is on
Apple Silicon, so we need a cloud dev box.  Three options
in order of recommendation:

1. **Lambda Labs** (lambdalabs.com) — A100/H100 by the hour,
   ~$1/hr for an A10G, ~$3/hr for an A100.  Easiest setup.
2. **Vast.ai** (vast.ai) — community GPUs, cheaper than
   Lambda, slower provisioning.
3. **AWS / GCP** — p3/p4 instances, ~$30/hr for an A100.
   Overkill for a single user.

For a student on a budget, the sweet spot is Lambda's A10G
($1/hr, 24GB VRAM, sm_86) or a 3090 on vast.ai.

## Cloud setup (one-time, ~10 min)

```sh
# On Lambda, you get a fresh Ubuntu + CUDA + nvcc.
# Verify:
nvcc --version    # should print 12.x or later
nvidia-smi        # should show your GPU

# Clone your work
git clone https://github.com/404Piyush/gpu-engineering
cd gpu-engineering/labs/year-1/cuda-track/week-01-cuda-setup

# Build + run
make cuda
./vector_add
```

## What this week does

- `vector_add.cu`: a vector-add kernel that adds two
  length-N `float` arrays.  Trivial enough to read in one
  sitting, but covers:
  - Kernel launch syntax (`<<<blocks, threads>>>`)
  - Device memory allocation (`cudaMalloc`/`cudaFree`)
  - Host↔device copy (`cudaMemcpy`)
  - Error checking (`CUDA_CHECK` macro)
- `bench/bench_vector_add.sh`: a tiny benchmark that
  times the kernel at increasing N and reports GB/s.
- `verify.py`: compares GPU output to a CPU reference
  using `numpy`.  Fails the build if there's drift.

## Acceptance criteria

- [ ] `make cuda` builds without warnings under
      `-Wall -Wextra -Wpedantic`
- [ ] `./vector_add` runs and prints a one-line summary
- [ ] `bench/bench_vector_add.sh` produces a table with
      `N` and `GB/s` columns
- [ ] `verify.py` exits 0 (GPU matches CPU within 1e-5)

## Files

- `vector_add.cu` — the kernel + host wrapper
- `Makefile` — build + run
- `bench/bench_vector_add.sh` — the benchmark
- `verify.py` — CPU vs GPU check
- `README.md` — this file

## Next

Week 2 builds a memory-bandwidth baseline (the same kernel
at larger N, with `cudaEventRecord` for proper timing).
Week 3 builds a reduction.  Week 4 runs the first Nsight
profile and writes the Month-25 report.
