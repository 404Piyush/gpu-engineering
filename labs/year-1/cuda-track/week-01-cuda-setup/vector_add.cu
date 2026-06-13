/* vector_add.cu — the first CUDA kernel
 *
 * Adds two length-N float arrays element-wise.  Trivial but
 * covers every moving part: device alloc, host<->device
 * copy, kernel launch, error checking.
 *
 * Build:   make cuda          (requires nvcc + an NVIDIA GPU)
 * Run:     ./vector_add 1048576
 *
 * Benchmark:  bench/bench_vector_add.sh
 * Verify:     python3 verify.py
 */
#include <cstdio>
#include <cstdlib>
#include <cuda_runtime.h>

#define CUDA_CHECK(call) do {                                          \
    cudaError_t _e = (call);                                          \
    if (_e != cudaSuccess) {                                          \
        fprintf(stderr, "CUDA error at %s:%d: %s\n",                 \
                __FILE__, __LINE__, cudaGetErrorString(_e));           \
        exit(1);                                                      \
    }                                                                 \
} while (0)

/* The kernel.  Each thread handles one element. */
__global__ void vector_add(const float *a, const float *b, float *c, size_t n) {
    size_t i = (size_t)blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) c[i] = a[i] + b[i];
}

int main(int argc, char **argv) {
    size_t n = (argc > 1) ? (size_t)atol(argv[1]) : (1u << 20);  /* default 1M */
    size_t bytes = n * sizeof(float);

    /* Host buffers. */
    float *h_a = (float*)malloc(bytes);
    float *h_b = (float*)malloc(bytes);
    float *h_c = (float*)malloc(bytes);
    if (!h_a || !h_b || !h_c) { perror("malloc"); return 1; }

    /* Fill with deterministic values. */
    for (size_t i = 0; i < n; i++) { h_a[i] = (float)i; h_b[i] = 1.0f; }
    memset(h_c, 0, bytes);

    /* Device buffers. */
    float *d_a = NULL, *d_b = NULL, *d_c = NULL;
    CUDA_CHECK(cudaMalloc((void**)&d_a, bytes));
    CUDA_CHECK(cudaMalloc((void**)&d_b, bytes));
    CUDA_CHECK(cudaMalloc((void**)&d_c, bytes));

    /* H2D. */
    CUDA_CHECK(cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_b, h_b, bytes, cudaMemcpyHostToDevice));

    /* Launch.  256 threads per block is a reasonable default
       for memory-bound kernels. */
    int threads = 256;
    int blocks  = (int)((n + threads - 1) / threads);
    vector_add<<<blocks, threads>>>(d_a, d_b, d_c, n);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    /* D2H. */
    CUDA_CHECK(cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost));

    /* Spot-check the first 3 and last 3. */
    int ok = 1;
    for (size_t i : {(size_t)0, n/2, n-1}) {
        float want = h_a[i] + h_b[i];
        if (h_c[i] != want) { ok = 0; break; }
    }

    /* Free. */
    CUDA_CHECK(cudaFree(d_a));
    CUDA_CHECK(cudaFree(d_b));
    CUDA_CHECK(cudaFree(d_c));
    free(h_a); free(h_b); free(h_c);

    /* One-line summary. */
    const char *gpu = "<unknown>";
    {
        cudaDeviceProp prop;
        if (cudaGetDeviceProperties(&prop, 0) == cudaSuccess) gpu = prop.name;
    }
    printf("vector_add  n=%zu  gpu=%s  %s\n",
           n, gpu, ok ? "ok" : "FAIL");
    return ok ? 0 : 1;
}
