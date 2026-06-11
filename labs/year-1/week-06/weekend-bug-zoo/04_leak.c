/* weekend-bug-zoo/04_leak.c
 * Bug: allocate, lose the pointer, exit.
 * Tool: macOS `leaks` (or LSan on Linux).
 */
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    for (int i = 0; i < 3; i++) {
        (void)malloc(64);
    }
    return 0;
}
