/* day-3-4-measure/faults_alloc.c
 *
 * Allocates a big array (without touching it), then touches each
 * page. Uses getrusage() to count the minor page faults.
 *
 *   clang -O0 -o faults_alloc faults_alloc.c
 *   ./faults_alloc 64        # 64 MiB
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h>

static long faults(void) {
    struct rusage ru;
    getrusage(RUSAGE_SELF, &ru);
    return ru.ru_minflt;
}

int main(int argc, char **argv) {
    long mib = (argc > 1) ? atol(argv[1]) : 64;
    long nints = (mib << 20) / sizeof(int);
    int *a = (int *)malloc(nints * sizeof(int));
    if (!a) return 1;

    long before_alloc = faults();
    long after_alloc  = faults();
    printf("after malloc(%ld MiB)        : minor faults = %ld  (delta %ld)\n",
           mib, after_alloc, after_alloc - before_alloc);

    long before_touch = faults();
    /* Touch one int per page. Page size is 4 KiB = 1024 ints. */
    for (long i = 0; i < nints; i += 1024) {
        a[i] = 0;
    }
    long after_touch = faults();
    printf("after touching every 4 KiB  : minor faults = %ld  (delta %ld)\n",
           after_touch, after_touch - before_touch);
    printf("expected = %ld pages of 4 KiB\n", nints / 1024);

    free(a);
    return 0;
}
