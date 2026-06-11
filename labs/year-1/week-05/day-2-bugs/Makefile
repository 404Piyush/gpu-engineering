CC      ?= clang
ARCH    ?= -arch x86_64
CFLAGS  ?= -O0 -g -Wall

all: leak double_free use_after_free

%: %.c
	$(CC) $(ARCH) $(CFLAGS) -o $@ $<

# Build everything with ASan and UBSan and run them.
# The output goes to the matching .asan.txt file.
asan:
	clang $(ARCH) -O0 -g -fsanitize=address,undefined -o leak_asan            leak.c
	clang $(ARCH) -O0 -g -fsanitize=address,undefined -o double_free_asan     double_free.c
	clang $(ARCH) -O0 -g -fsanitize=address,undefined -o use_after_free_asan  use_after_free.c
	./leak_asan            > leak.asan.txt            2>&1 || true
	./double_free_asan     > double_free.asan.txt     2>&1 || true
	./use_after_free_asan  > use_after_free.asan.txt  2>&1 || true
	@echo "captured ASan output to *.asan.txt"

# macOS doesn't ship LeakSan in Apple's ASan; we use the system `leaks` tool.
leaks:
	@echo "--- leaks ./leak ---"
	-leaks --atExit -- ./leak           > leak.leaks.txt      2>&1
	@cat leak.leaks.txt

run: all
	@echo "--- leak (no tool) ---";       ./leak
	@echo "--- double_free (no tool) ---"; ./double_free || true
	@echo "--- use_after_free (no tool) ---"; ./use_after_free || true

clean:
	rm -f leak double_free use_after_free leak_asan double_free_asan use_after_free_asan *.asan.txt *.leaks.txt

.PHONY: all run asan leaks clean
