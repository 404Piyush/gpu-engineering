/* day-1-2-fork-exec/exit_codes.c
 *
 * Day 1-2: Exit codes — what they mean and how to inspect them.
 *
 * Convention: 0 = success, 1..125 = program-defined failure,
 * 126 = "found but not executable", 127 = "command not found",
 * 128+N = killed by signal N (e.g., 130 = killed by SIGINT/Ctrl-C).
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/wait.h>

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "usage: %s <exit-code-or-signal>\n", argv[0]);
        return 1;
    }
    int n = atoi(argv[1]);

    if (n >= 128) {
        /* Send ourselves a signal. 0 -> exit(0). */
        int sig = n - 128;
        if (sig == 0) { puts("exit(0)"); return 0; }
        printf("killing self with signal %d (%s)\n", sig,
               (sig < NSIG ? strsignal(sig) : "?"));
        raise(sig);
        /* raise returns only if the signal was handled. */
        return 0;
    }

    printf("exiting with code %d\n", n);
    return n;
}
