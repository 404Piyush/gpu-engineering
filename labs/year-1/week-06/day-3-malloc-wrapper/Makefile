CC      ?= clang
ARCH    ?= -arch x86_64
CFLAGS  ?= -O0 -g -Wall

# Direct call to mymalloc/myfree — no macro magic. The drop-in
# approach (rewriting `malloc` to `mymalloc` via -D) is described
# in README.md; the system <stdlib.h> on macOS uses `__sized_by`
# annotations on the real `malloc` which clash with macro rewrites.
usage: usage.c mymalloc.c mymalloc.h
	$(CC) $(ARCH) $(CFLAGS) usage.c mymalloc.c -o usage

run: usage
	@echo "--- usage (no leak) ---"
	./usage 0
	@echo "--- usage (leak 100 bytes) ---"
	./usage 100

leak: usage
	@echo "--- usage (leak 4096 bytes) ---"
	./usage 4096

clean:
	rm -f usage

.PHONY: usage run leak clean
