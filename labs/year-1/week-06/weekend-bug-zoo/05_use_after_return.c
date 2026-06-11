/* weekend-bug-zoo/05_use_after_return.c
 * Bug: take the address of a function-local, then call the function
 *      again. The address is now a stack slot that the new call has
 *      overwritten.
 * Tool: ASan with `-fsanitize-address-use-after-return=always`.
 * Note: this requires the runtime to *capture* the locals into a
 *       fake stack. On by default in recent Apple Clang.
 */
#include <stdio.h>

const char *f(void) {
    char buf[16] = "hello";
    return buf;          /* BUG: address of local escapes */
}

int main(void) {
    const char *p = f();
    const char *q = f(); /* overwrites the same stack slot */
    printf("p = %s, q = %s\n", p, q);
    return 0;
}
