/* day-1-layout/layout.c
 *
 * Prints the addresses of:
 *   - a global (data segment)
 *   - a string literal (rodata)
 *   - a stack local
 *   - a heap allocation
 *   - a function
 *
 * Run a few times — the addresses shift (ASLR), but the *order* of
 * regions on macOS / Linux is always the same.
 */
#include <stdio.h>
#include <stdlib.h>

int    g_init   = 42;          /* .data */
int    g_zero;                 /* .bss  */
const char *g_msg = "hello";   /* .rodata (via pointer in .data) */

__attribute__((noinline))
static void marker(void) {
    int local = 1;
    printf("function marker()     : %p\n", (void *)&marker);
    printf("stack local (in marker): %p\n", (void *)&local);
    printf("global g_init (.data)  : %p\n", (void *)&g_init);
    printf("global g_zero  (.bss)  : %p\n", (void *)&g_zero);
    printf("string literal         : %p\n", (void *)g_msg);
    printf("heap malloc(64)        : %p\n", (void *)malloc(64));
    fflush(stdout);
}

int main(void) {
    int local = 0;
    printf("stack local (in main)  : %p\n", (void *)&local);
    printf("heap   malloc(64)      : %p\n", (void *)malloc(64));
    fflush(stdout);
    marker();
    return 0;
}
