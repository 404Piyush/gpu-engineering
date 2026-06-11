#ifndef MYMALLOC_H
#define MYMALLOC_H

#include <stddef.h>

void *mymalloc(size_t n, const char *file, int line);
void *mycalloc(size_t nmemb, size_t sz, const char *file, int line);
void *myrealloc(void *p, size_t n, const char *file, int line);
void  myfree(void *p, const char *file, int line);

void  mymalloc_report(void);
void  mymalloc_shutdown(void);

#endif
