/* weekend-bug-zoo/06_signed_overflow.c
 * Bug: signed integer overflow is undefined behaviour.
 * Tool: UBSan.
 */
#include <stdio.h>
#include <limits.h>

int main(void) {
    int x = INT_MAX;
    int y = x + 1;        /* undefined */
    printf("y = %d\n", y);
    return 0;
}
