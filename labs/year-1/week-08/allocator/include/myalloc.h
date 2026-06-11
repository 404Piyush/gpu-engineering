#ifndef MYALLOC_H
#define MYALLOC_H

#include <stddef.h>

/* mymalloc / myfree: a free-list allocator with coalescing.
 *
 * Memory model:
 *   - On first call, the allocator asks the OS for a single large
 *     arena via sbrk() / mmap.  Subsequent allocations are carved
 *     out of that arena.
 *   - Free blocks are kept in a *free list*, a singly-linked list
 *     threaded through the free blocks themselves.
 *   - When a block is freed, it is coalesced with adjacent free
 *     blocks to fight fragmentation.
 *
 * The header struct lives at the start of every block (allocated
 * or free):
 *
 *     +--------+-----------------------------+
 *     | Header | payload (size - sizeof Hdr)  |
 *     +--------+-----------------------------+
 *
 * On 64-bit, sizeof(Header) = 16 bytes. The minimum block size is
 * 32 bytes so a free block can hold a header and two pointers.
 */

void  mymalloc_init(void);
void  mymalloc_shutdown(void);

void *mymalloc(size_t n);
void  myfree(void *p);

size_t mymalloc_arena_size(void);     /* bytes requested from the OS */
size_t mymalloc_in_use(void);         /* bytes currently handed out  */
size_t mymalloc_free_bytes(void);     /* bytes in the free list      */
size_t mymalloc_largest_free(void);   /* biggest contiguous free run */
int    mymalloc_fragment_count(void); /* how many free blocks        */

#endif
