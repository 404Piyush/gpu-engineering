/* mem-bug/overflow_no_canary.c
 *
 * Same as overflow.c but compiled with `-fno-stack-protector` so the
 * canary is NOT inserted. Then the overflow can corrupt the saved %rbp
 * and the return address. This is the "machine-level" version: we
 * watch the bytes change in lldb.
 */
#include <stdio.h>
#include <string.h>

__attribute__((noinline))
int victim(const char *in) {
    char buf[8];
    strcpy(buf, in);
    return (int)buf[0];
}

int main(int argc, char **argv) {
    if (argc < 2) return 1;
    int r = victim(argv[1]);
    printf("first byte = 0x%02x\n", r);
    return 0;
}
