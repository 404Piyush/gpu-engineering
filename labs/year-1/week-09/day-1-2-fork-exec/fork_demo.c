/* day-1-2-fork-exec/fork_demo.c
 *
 * Day 1-2: fork / exec / waitpid
 *
 * fork() creates a near-identical child process.  Both parent and
 * child continue from the return value: parent gets the child's PID,
 * child gets 0, and on failure the parent gets -1.
 *
 * execve() (or its library wrappers execvp / execlp) replaces the
 * current process image with a new program.  It does NOT return on
 * success.
 *
 * waitpid() blocks the parent until a specific child (or any child)
 * terminates, and reports the exit status via WEXITSTATUS, etc.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <errno.h>

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "usage: %s <prog> [args...]\n", argv[0]);
        return 1;
    }

    printf("[parent pid=%d] about to fork, child will run: %s\n",
           getpid(), argv[1]);

    pid_t pid = fork();
    if (pid < 0) {
        perror("fork");
        return 1;
    }

    if (pid == 0) {
        /* CHILD: replace our process image with the requested program. */
        printf("[child  pid=%d ppid=%d] exec %s\n",
               getpid(), getppid(), argv[1]);
        execvp(argv[1], &argv[1]);
        /* execvp only returns on failure. */
        fprintf(stderr, "[child] execvp failed: %s\n", strerror(errno));
        _exit(127);
    }

    /* PARENT: wait for the child. */
    int status = 0;
    pid_t r = waitpid(pid, &status, 0);
    if (r < 0) {
        perror("waitpid");
        return 1;
    }

    if (WIFEXITED(status)) {
        printf("[parent pid=%d] child %d exited normally, status=%d\n",
               getpid(), (int)pid, WEXITSTATUS(status));
    } else if (WIFSIGNALED(status)) {
        printf("[parent pid=%d] child %d killed by signal %d (%s)\n",
               getpid(), (int)pid, WTERMSIG(status),
               strsignal(WTERMSIG(status)));
    } else {
        printf("[parent pid=%d] child %d ended in some other way (status=0x%x)\n",
               getpid(), (int)pid, status);
    }
    return 0;
}
