/* day-3-4-redirection/heredoc.c
 *
 * Day 3-4: heredoc — read from stdin until the marker
 *
 *  This is a tiny stand-alone example.  Shell heredocs are much
 *  more complex (line continuations, parameter expansion, etc.)
 *  but the kernel mechanism is the same: a temporary file or
 *  pipe feeding the child's stdin.
 *
 *  Run:    ./heredoc
 *          Then type a few lines, terminate with a single line
 *          containing exactly "EOF".
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <errno.h>

#define MARKER "EOF"

static void die(const char *m) { perror(m); exit(1); }

int main(void) {
    /* The heredoc body is built by the parent, then handed to
       the child through a pipe.  We could have used a temp
       file, but a pipe is faster and never touches the disk. */
    int fd[2];
    if (pipe(fd) < 0) die("pipe");

    pid_t pid = fork();
    if (pid < 0) die("fork");
    if (pid == 0) {
        close(fd[1]);
        if (dup2(fd[0], STDIN_FILENO) < 0) die("dup2");
        close(fd[0]);
        execlp("wc", "wc", "-l", (char *)NULL);
        die("execlp wc");
    }
    close(fd[0]);

    /* parent: read user lines, push them to the child until marker. */
    char line[1024];
    while (fgets(line, sizeof line, stdin)) {
        /* strip trailing newline */
        size_t n = strlen(line);
        if (n && line[n - 1] == '\n') line[--n] = '\0';
        if (strcmp(line, MARKER) == 0) break;
        line[n++] = '\n';
        if (write(fd[1], line, n) < 0) die("write");
    }
    close(fd[1]);   /* EOF to child */

    int st;
    waitpid(pid, &st, 0);
    return WIFEXITED(st) ? WEXITSTATUS(st) : 1;
}
