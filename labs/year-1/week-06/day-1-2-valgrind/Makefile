CC      ?= clang
ARCH    ?= -arch x86_64
CFLAGS  ?= -O0 -g -Wall

PROGRAMS := buggy buggy_fixed

all: $(PROGRAMS)

%: %.c
	$(CC) $(ARCH) $(CFLAGS) -o $@ $<

asan: $(PROGRAMS)
	$(CC) $(ARCH) -O0 -g -fsanitize=address,undefined -o buggy_asan      buggy.c
	$(CC) $(ARCH) -O0 -g -fsanitize=address,undefined -o buggy_fixed_asan buggy_fixed.c
	./buggy_asan      > buggy.asan.txt      2>&1 || true
	./buggy_fixed_asan > buggy_fixed.asan.txt 2>&1 || true
	@echo "--- buggy.asan.txt (should be empty / clean abort) ---"
	@head -25 buggy.asan.txt
	@echo "--- buggy_fixed.asan.txt (should be silent) ---"
	@cat buggy_fixed.asan.txt

run: all
	@echo "--- ./buggy (no tool) ---"
	./buggy
	@echo "--- ./buggy_fixed (no tool) ---"
	./buggy_fixed

leaks: buggy
	-leaks --atExit -- ./buggy > buggy.leaks.txt 2>&1 || true
	@cat buggy.leaks.txt

clean:
	rm -f $(PROGRAMS) buggy_asan buggy_fixed_asan *.txt

.PHONY: all asan run leaks clean
