CC      ?= clang
ARCH    ?= -arch x86_64
CFLAGS  ?= -O2 -Wall

all: stride

%: %.c
	$(CC) $(ARCH) $(CFLAGS) -o $@ $<

run: stride
	./stride 16777216

# Run with the array sized larger than L2/L3 to *force* evictions.
# L1 is ~32 KiB, L2 ~1 MiB, L3 ~12+ MiB on Apple M-series.
big: stride
	./stride 67108864       # 256 MiB — way bigger than L3

asm:
	$(CC) $(ARCH) -O0 -S -o stride.s stride.c

clean:
	rm -f stride stride.s

.PHONY: all run big asm clean
