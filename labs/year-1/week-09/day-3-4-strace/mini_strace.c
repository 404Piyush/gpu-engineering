/* day-3-4-strace/mini_strace.c
 *
 * A tiny `strace`-clone implemented with ptrace(2).
 *
 * How it works:
 *   1. fork() the child we want to trace.
 *   2. Child: PTRACE_TRACEME, raise(SIGSTOP) to let parent attach.
 *   3. Parent: in a loop, waitpid(child), read the child's
 *      syscall registers, decode the syscall number, then
 *      PTRACE_SYSCALL to step to the next.
 *
 * On macOS ptrace(2) is severely limited (no PT_SYSCALL). We
 * detect this at compile time and bail out gracefully.
 *
 * This file is a self-contained educational tracer. It is NOT
 * a replacement for strace/dtruss. It decodes only the most
 * common syscalls on x86_64.
 */
#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>

#ifdef __APPLE__
int main(int argc, char **argv) {
    (void)argc; (void)argv;
    fprintf(stderr,
        "mini_strace: macOS ptrace(2) does not support PT_SYSCALL;\n"
        "             use `sudo dtruss` or `sudo fs_usage` instead.\n");
    return 1;
}
#else
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/ptrace.h>
#include <sys/user.h>
#include <errno.h>

/* Linux x86_64: syscall numbers we'll print names for. */
static const char *syscall_name(long n) {
    switch (n) {
    case 0:   return "read";
    case 1:   return "write";
    case 2:   return "open";
    case 3:   return "close";
    case 9:   return "mmap";
    case 10:  return "mprotect";
    case 11:  return "munmap";
    case 12:  return "brk";
    case 13:  return "rt_sigaction";
    case 14:  return "rt_sigprocmask";
    case 21:  return "access";
    case 35:  return "nanosleep";
    case 39:  return "getpid";
    case 57:  return "fork";
    case 59:  return "execve";
    case 60:  return "exit";
    case 102: return "getuid";
    case 231: return "exit_group";
    case 257: return "openat";
    case 318: return "getrandom";
    default:  return "?";
    }
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "usage: %s <prog> [args...]\n", argv[0]);
        return 1;
    }

    pid_t child = fork();
    if (child < 0) { perror("fork"); return 1; }

    if (child == 0) {
        if (ptrace(PTRACE_TRACEME, 0, NULL, NULL) < 0) {
            perror("PTRACE_TRACEME");
            _exit(1);
        }
        raise(SIGSTOP);
        execvp(argv[1], &argv[1]);
        perror("execvp");
        _exit(127);
    }

    int status = 0;
    if (waitpid(child, &status, 0) < 0) { perror("waitpid"); return 1; }
    if (!WIFSTOPPED(status)) {
        fprintf(stderr, "child not stopped: 0x%x\n", status);
        return 1;
    }
    ptrace(PTRACE_SETOPTIONS, child, 0, PTRACE_O_TRACESYSGOOD);

    while (1) {
        ptrace(PTRACE_SYSCALL, child, NULL, NULL);
        if (waitpid(child, &status, 0) < 0) break;
        if (WIFEXITED(status)) {
            fprintf(stderr, "+++ exited with %d +++\n",
                    WEXITSTATUS(status));
            break;
        }
        if (!WIFSTOPPED(status)) continue;

        struct user_regs_struct regs;
        ptrace(PTRACE_GETREGS, child, NULL, &regs);
        static int in_syscall = 0;
        if (!in_syscall) {
            fprintf(stderr, "syscall(%ld) %s\n",
                    regs.orig_rax, syscall_name(regs.orig_rax));
        }
        in_syscall = !in_syscall;
    }
    return 0;
}
#endif

