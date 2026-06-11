/* day-3-4-redirection/redir_run.c
 *
 * Day 3-4: dup2(2) — basic redirection
 *
 *  Implements:    redir_run "<CMD> [args...]" <INFILE >OUTFILE
 *
 *  Approach:
 *    1. Parse the command line into argv.
 *    2. open(INFILE)  -> fd 3
 *    3. open(OUTFILE) -> fd 4
 *    4. fork
 *    5. child: dup2(3,0); dup2(4,1); close(3); close(4); execvp(argv[0], argv);
 *    6. parent: waitpid, print exit status
 *
 *  Run:
 *    ./redir_run "wc -l" <README.md >out.txt
 *    cat out.txt
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <errno.h>

static void die(const char *msg) {
    perror(msg);
    exit(1);
}

/* Split a command line into argv.  Trivial tokenizer: whitespace.
   Quoted arguments are NOT supported (intentionally — for now). */
static void split(char *line, char **argv, int max) {
    int n = 0;
    char *p = strtok(line, " \t");
    while (p && n < max - 1) {
        argv[n++] = p;
        p = strtok(NULL, " \t");
    }
    argv[n] = NULL;
}

int main(int argc, char **argv) {
    if (argc < 2) {
        fprintf(stderr, "usage: %s \"CMD [args...]\" <IN >OUT\n", argv[0]);
        return 2;
    }

    /* Find the redirection tokens.  We support at most one < and one >. */
    char *cmd_start = NULL, *cmd_end = NULL;
    char *infile = NULL, *outfile = NULL;
    for (int i = 1; i < argc; i++) {
        if (argv[i][0] == '<' && argv[i][1] == '\0' && i + 1 < argc) {
            infile = argv[i + 1];
        } else if (argv[i][0] == '>' && argv[i][1] == '\0' && i + 1 < argc) {
            outfile = argv[i + 1];
        } else {
            if (!cmd_start) cmd_start = argv[i];
            cmd_end = argv[i] + strlen(argv[i]);
        }
    }
    if (!cmd_start) {
        fprintf(stderr, "no command given\n");
        return 2;
    }

    /* Tokenize the command into a NULL-terminated argv. */
    char buf[1024];
    size_t len = (size_t)(cmd_end - cmd_start) + 1;
    if (len >= sizeof buf) { fprintf(stderr, "command too long\n"); return 2; }
    memcpy(buf, cmd_start, len); buf[len] = '\0';
    char *cargv[64];
    split(buf, cargv, 64);

    int in_fd = -1, out_fd = -1;
    if (infile) {
        in_fd = open(infile, O_RDONLY);
        if (in_fd < 0) die("open input");
    }
    if (outfile) {
        out_fd = open(outfile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
        if (out_fd < 0) die("open output");
    }

    pid_t pid = fork();
    if (pid < 0) die("fork");
    if (pid == 0) {
        if (in_fd >= 0)  { if (dup2(in_fd, STDIN_FILENO)  < 0) die("dup2 in");  close(in_fd); }
        if (out_fd >= 0) { if (dup2(out_fd, STDOUT_FILENO) < 0) die("dup2 out"); close(out_fd); }
        execvp(cargv[0], cargv);
        die("execvp");
    }
    if (in_fd  >= 0) close(in_fd);
    if (out_fd >= 0) close(out_fd);
    int st;
    waitpid(pid, &st, 0);
    if (WIFEXITED(st)) fprintf(stderr, "[parent] exit status = %d\n", WEXITSTATUS(st));
    return WIFEXITED(st) ? WEXITSTATUS(st) : 1;
}
