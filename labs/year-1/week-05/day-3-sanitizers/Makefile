CC      ?= clang
ARCH    ?= -arch x86_64
CFLAGS  ?= -O0 -g -Wall

all: all_bugs

%: %.c
	$(CC) $(ARCH) $(CFLAGS) -o $@ $<

asan:
	$(CC) $(ARCH) -O0 -g -fsanitize=address -o all_bugs_asan all_bugs.c
	ASAN_OPTIONS=halt_on_error=0:print_stats=1 ./all_bugs_asan > all_bugs.asan.txt 2>&1 || true
	@echo "--- captured to all_bugs.asan.txt ---"

# `all_bugs` mixes ASan-detectable (heap, stack, UAF) and UBSan-detectable
# (signed integer overflow) bugs. To get clean output for both, we use
# a narrower UBSan set that doesn't include `bounds` (which clashes with
# ASan's heap-buffer-overflow detector).
UBSAN_SET := signed-integer-overflow,shift,null,unreachable,vla-bound,object-size,float-divide-by-zero,integer-divide-by-zero

ubsan:
	$(CC) $(ARCH) -O0 -g -fsanitize=$(UBSAN_SET) -o all_bugs_ubsan all_bugs_ubsan_only.c
	UBSAN_OPTIONS=print_stacktrace=1:halt_on_error=0 ./all_bugs_ubsan > all_bugs.ubsan.txt 2>&1 || true
	@echo "--- captured to all_bugs.ubsan.txt ---"

both:
	$(CC) $(ARCH) -O0 -g -fsanitize=address,$(UBSAN_SET) -o all_bugs_both all_bugs.c
	ASAN_OPTIONS=halt_on_error=0 \
	UBSAN_OPTIONS=print_stacktrace=1:halt_on_error=0 \
	    ./all_bugs_both > all_bugs.both.txt 2>&1 || true
	@echo "--- captured to all_bugs.both.txt ---"

clean:
	rm -f all_bugs all_bugs_asan all_bugs_ubsan all_bugs_both *.txt

.PHONY: all asan ubsan both clean
