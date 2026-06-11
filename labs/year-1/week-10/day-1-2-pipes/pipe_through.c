/* day-1-2-pipes/pipe_through.c
 *
 * Day 1-2: pipe(2) — the "through pipe" pattern
 *
 *  parent creates a pipe, forks a child.  Parent writes a long
 *  stream of bytes; child reads them and prints a checksum.
 *  Nothing is exec'd — both processes are still this binary.
 *
 *  Run:    ./pipe_through
 *  Try:    time ./pipe_through  (we're measuring IPC overhead)
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <errno.h>

#define N_CHUNKS 1024
#define CHUNK    1024   /* 1 KiB per write — small enough to see reads */

static void die(const char *msg) {
    perror(msg);
    exit(1);
}

int main(void) {
    int fd[2];
    if (pipe(fd) < 0) die("pipe");

    pid_t pid = fork();
    if (pid < 0) die("fork");

    if (pid == 0) {
        /* child: close write end, read from read end, sum bytes. */
        close(fd[1]);
        unsigned char buf[CHUNK];
        unsigned long long total = 0;
        unsigned long long xor = 0;
        ssize_t n;
        while ((n = read(fd[0], buf, sizeof buf)) > 0) {
            total += (unsigned long long)n;
            for (ssize_t i = 0; i < n; i++) xor = (xor << 1) | (xor >> 63), xor ^= buf[i];
        }
        if (n < 0) die("read");
        fprintf(stderr, "[child pid=%d] read %llu bytes, xor=0x%016llx\n",
                (int)getpid(), total, xor);
        close(fd[0]);
        return 0;
    }

    /* parent: close read end, write N_CHUNKS chunks. */
    close(fd[0]);
    char chunk[CHUNK];
    memset(chunk, 'A', sizeof chunk);
    for (int i = 0; i < N_CHUNKS; i++) {
        ssize_t w = write(fd[1], chunk, sizeof chunk);
        if (w < 0) die("write");
    }
    close(fd[1]);  /* EOF to child */
    int st;
    waitpid(pid, &st, 0);
    fprintf(stderr, "[parent pid=%d] child exited with status %d\n",
            (int)getpid(), WEXITSTATUS(st));
    return 0;
}
