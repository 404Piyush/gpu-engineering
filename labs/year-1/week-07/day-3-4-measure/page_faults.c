/* day-3-4-measure/page_faults.c
 *
 * Reports the page-fault and other resource counts for the current
 * process via `getrusage()`. This is the standard POSIX API.
 *
 *   clang page_faults.c -o page_faults
 *   ./page_faults
 *
 * ru_minflt = minor faults (no I/O — already in memory, just mapped)
 * ru_majflt = major faults (had to read from disk)
 * ru_inblock / ru_oublock = block I/O operations
 */
#include <stdio.h>
#include <stdlib.h>
#include <sys/resource.h>

int main(void) {
    struct rusage ru;
    if (getrusage(RUSAGE_SELF, &ru) != 0) {
        perror("getrusage");
        return 1;
    }
    printf("minor page faults  = %ld\n", ru.ru_minflt);
    printf("major page faults  = %ld\n", ru.ru_majflt);
    printf("block input ops    = %ld\n", ru.ru_inblock);
    printf("block output ops   = %ld\n", ru.ru_oublock);
    printf("voluntary ctxsw    = %ld\n", ru.ru_nvcsw);
    printf("involuntary ctxsw  = %ld\n", ru.ru_nivcsw);
    printf("max resident set   = %ld KiB\n", ru.ru_maxrss);
    return 0;
}
