/* day-1-2-fork-exec/fork_loop.c
 *
 * Day 1-2: A parent that forks N children, each running `echo
 * "child <i>"` (or a custom command). Demonstrates the standard
 * "spawn N workers, wait for all" pattern.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>

static void run_child(int i) {
    char arg[32];
    snprintf(arg, sizeof(arg), "child-%d", i);
    printf("[pid=%d ppid=%d] before exec, arg=%s\n",
           getpid(), getppid(), arg);
    execlp("echo", "echo", arg, (char *)NULL);
    perror("execlp");
    _exit(127);
}

int main(int argc, char **argv) {
    int n = (argc > 1) ? atoi(argv[1]) : 4;
    if (n <= 0 || n > 64) { fprintf(stderr, "bad n\n"); return 1; }

    pid_t *kids = calloc((size_t)n, sizeof(pid_t));
    for (int i = 0; i < n; i++) {
        kids[i] = fork();
        if (kids[i] == 0) {
            free(kids);   /* children don't need the array */
            run_child(i);
        } else if (kids[i] < 0) {
            perror("fork");
        }
    }

    /* Reap in the original spawn order. */
    for (int i = 0; i < n; i++) {
        int status = 0;
        pid_t r = waitpid(kids[i], &status, 0);
        if (r > 0 && WIFEXITED(status)) {
            printf("[parent] reaped child %d (pid=%d) status=%d\n",
                   i, (int)r, WEXITSTATUS(status));
        }
    }
    free(kids);
    puts("[parent] all children reaped");
    return 0;
}
