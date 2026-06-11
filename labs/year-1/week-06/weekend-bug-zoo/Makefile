CC      ?= clang
ARCH    ?= -arch x86_64
CFLAGS  ?= -O0 -g -Wall
UBSAN   := signed-integer-overflow,shift,null,unreachable,vla-bound,object-size,float-divide-by-zero,integer-divide-by-zero

PROGRAMS := 01_oob_write 02_uaf_read 03_double_free 04_leak 05_use_after_return 06_signed_overflow

.PHONY: all
all: $(PROGRAMS)

%: %.c
	$(CC) $(ARCH) $(CFLAGS) -o $@ $<

# Build with ASan, run, capture the diagnostic.
asan: $(PROGRAMS)
	@for p in 01_oob_write 02_uaf_read 03_double_free 05_use_after_return; do \
	    echo "============================================================"; \
	    echo "ASAN: $$p"; \
	    echo "============================================================"; \
	    $(CC) $(ARCH) -O0 -g -fsanitize=address -o $$p.asan $$p.c; \
	    ASAN_OPTIONS=halt_on_error=0 ./$$p.asan 2>&1 | head -15 || true; \
	done
	@echo "============================================================"
	@echo "ASAN: 04_leak (no diagnostic; use macOS 'leaks')"
	@echo "============================================================"

ubsan: $(PROGRAMS)
	@for p in 06_signed_overflow; do \
	    echo "============================================================"; \
	    echo "UBSAN: $$p"; \
	    echo "============================================================"; \
	    $(CC) $(ARCH) -O0 -g -fsanitize=$(UBSAN) -o $$p.ubsan $$p.c; \
	    UBSAN_OPTIONS=print_stacktrace=1 ./$$p.ubsan 2>&1 | head -10 || true; \
	done

leaks: 04_leak
	-leaks --atExit -- ./04_leak 2>&1 | grep -A 6 "ROOT LEAK" | head -25

run: all
	@for p in $(PROGRAMS); do \
	    echo "--- ./$$p (no tool) ---"; \
	    ./$$p || true; \
	done

clean:
	rm -f $(PROGRAMS) *.asan *.ubsan
