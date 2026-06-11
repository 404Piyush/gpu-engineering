/* day-4-stack-growth/recursion.c
 *
 * Recurse to a chosen depth, print the address of one stack local
 * at each level, and report the bytes between consecutive levels.
 *
 * Build:
 *   clang -arch x86_64 -O0 -g -o recursion recursion.c
 *   ./recursion 20000
 */
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>

static int recurse(int depth) {
    char local[128];                    /* push this many bytes per level */
    if (depth == 0) {
        printf("leaf local   = %p\n", (void *)local);
        return 0;
    }
    void *here = (void *)local;
    int rc = recurse(depth - 1);
    if (depth % 1000 == 0) {
        printf("depth=%-6d  local = %p\n", depth, here);
    }
    return rc + 1;
}

__attribute__((noinline))
static int deep_recurse(int depth) {
    char local[128];
    if (depth == 0) {
        printf("DEEP leaf local = %p\n", (void *)local);
        return 0;
    }
    return deep_recurse(depth - 1);
}

int main(int argc, char **argv) {
    setvbuf(stdout, NULL, _IONBF, 0);   /* unbuffered stdout */
    int depth = argc > 1 ? atoi(argv[1]) : 5000;
    printf("recursing to depth %d, ~%d bytes of stack per level\n",
           depth, 128);
    recurse(depth);
    printf("returned from %d levels\n", depth);

    int deep = argc > 2 ? atoi(argv[2]) : 100000;
    printf("now recursing DEEP to %d levels...\n", deep);
    int rc = deep_recurse(deep);
    printf("deep_recurse returned %d\n", rc);
    return 0;
}
