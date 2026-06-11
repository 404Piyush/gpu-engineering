/* day-3-4-strace/dtruss_demo.sh
 *
 * Day 3-4: syscall tracing on macOS.
 *
 * Linux has `strace` (out of the box). macOS doesn't have a
 * user-space `strace` equivalent by default, but the kernel
 * exposes a DTrace-based tool: `dtruss`.  Run it as root:
 *
 *   sudo dtruss -n <pid>          # trace a running PID
 *   sudo dtruss <command> ...     # run and trace a command
 *   sudo dtruss -f <command>      # follow forks
 *
 * `dtruss` shows raw syscall entries/exits. It's noisy and
 * powerful.  For a less noisy view of just file activity, use:
 *
 *   sudo fs_usage -w -f filesys   # watch filesystem syscalls
 *
 * For *one-shot* tracing of a single command, the simplest path
 * is to wrap the program in a tiny C program that uses
 * `dtrace`-style probes — but that's overkill for this course.
 * Instead, this folder has:
 *
 *   - trace_target.c   a tiny program with identifiable syscalls
 *   - strace_linux.sh  the Linux equivalent of dtruss
 *   - dtruss_macos.sh  the macOS equivalent of strace
 *
 * Run the .sh scripts to see the syscall traces.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

int main(int argc, char **argv) {
    /* Distinct, traceable syscalls. */
    const char *path = (argc > 1) ? argv[1] : "/etc/hosts";
    printf("[trace_target pid=%d] open(%s)\n", getpid(), path);
    int fd = open(path, O_RDONLY);
    if (fd < 0) { perror("open"); return 1; }

    char buf[64];
    ssize_t n = read(fd, buf, sizeof(buf) - 1);
    if (n > 0) {
        buf[n] = '\0';
        printf("[trace_target] read %zd bytes: %.40s...\n", n, buf);
    }
    close(fd);
    printf("[trace_target] getpid() = %d, exiting\n", getpid());
    return 0;
}
