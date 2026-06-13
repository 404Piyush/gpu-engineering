# vector_add — Makefile
#
# Targets:
#   make cuda     build with nvcc (requires NVIDIA GPU + CUDA)
#   make stub     build a CPU stub for local smoke testing
#                 (no GPU, just compiles a host-only C++ stub)
#   make verify   run the CPU vs GPU check (requires numpy)
#   make bench    run the bandwidth benchmark
#   make clean    remove build artefacts

NVCC      ?= nvcc
CXX       ?= g++

CUDA_ARCH ?= -arch=sm_70       # safe default: V100
# Override for newer GPUs:
#   A100  -> -arch=sm_80
#   A10G  -> -arch=sm_86
#   H100  -> -arch=sm_90

CXXFLAGS  ?= -O2 -Wall -Wextra -Wpedantic
NVCCFLAGS ?= -O2 -Wall -Wextra -Wpedantic -std=c++17

BIN       := vector_add
STUB_BIN  := vector_add_stub

.PHONY: all cuda stub bench verify clean

all: cuda

cuda: $(BIN)

$(BIN): vector_add.cu
	$(NVCC) $(NVCCFLAGS) $(CUDA_ARCH) -o $@ $<

# Local CPU stub: same algorithm, runs on host.  Used to
# sanity-check the build on machines without an NVIDIA GPU
# (e.g. the Apple Silicon dev box).
stub: $(STUB_BIN)

$(STUB_BIN): vector_add.cu
	$(CXX) $(CXXFLAGS) -D__STUB__=1 -o $@ $<

bench: $(BIN)
	./bench/bench_vector_add.sh

verify: $(BIN)
	python3 verify.py

clean:
	rm -f $(BIN) $(STUB_BIN)
