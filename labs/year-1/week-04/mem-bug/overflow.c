/* mem-bug/overflow.c
 *
 * Intentionally writes past the end of a stack buffer to corrupt the
 * stack canary / saved %rbp / return address. Compiled with `-fstack-protector`
 * (the default on Apple Clang) this trips __stack_chk_fail. Without the
 * canary it would corrupt the return address — and that's the
 * explanation we want at the machine level.
 */
#include <stdio.h>
#include <string.h>

int victim(const char *in) {
    char buf[8];
    /* BUG: copy 32 bytes into an 8-byte buffer. */
    strcpy(buf, in);
    return (int)buf[0];
}

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("usage: %s <long-string>\n", argv[0]);
        return 1;
    }
    return victim(argv[1]);
}
