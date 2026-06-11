/* day-1-2-pipes/pipe_chain.c
 *
 * Day 1-2: pipe(2) — the shell pipe pattern
 *
 *  Real shell pipeline:  ls /usr/include | wc -l
 *
 *  We exec *two children* through one pipe:
 *      child1: ls /usr/include
 *      child2: wc -l
 *  Parent doesn't read or write — it just wires fds and reaps.
 *
 *  Run:    ./pipe_chain
 *  Source: man 2 pipe
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <errno.h>

static void die(const char *msg) {
    perror(msg);
    exit(1);
}

int main(void) {
    int fd[2];
    if (pipe(fd) < 0) die("pipe");

    pid_t c1 = fork();
    if (c1 < 0) die("fork c1");
    if (c1 == 0) {
        /* child 1: ls /usr/include.  stdout -> pipe write end. */
        close(fd[0]);
        if (dup2(fd[1], STDOUT_FILENO) < 0) die("dup2 c1");
        close(fd[1]);
        execlp("ls", "ls", "/usr/include", (char *)NULL);
        die("execlp ls");
    }

    pid_t c2 = fork();
    if (c2 < 0) die("fork c2");
    if (c2 == 0) {
        /* child 2: wc -l.  stdin <- pipe read end. */
        close(fd[1]);
        if (dup2(fd[0], STDIN_FILENO) < 0) die("dup2 c2");
        close(fd[0]);
        execlp("wc", "wc", "-l", (char *)NULL);
        die("execlp wc");
    }

    /* parent: close both ends, reap both children. */
    close(fd[0]);
    close(fd[1]);
    int s1, s2;
    waitpid(c1, &s1, 0);
    waitpid(c2, &s2, 0);
    fprintf(stderr, "[parent] c1 exit=%d  c2 exit=%d\n",
            WIFEXITED(s1) ? WEXITSTATUS(s1) : -1,
            WIFEXITED(s2) ? WEXITSTATUS(s2) : -1);
    return 0;
}
