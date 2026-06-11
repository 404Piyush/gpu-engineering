CC      ?= clang
ARCH    ?= -arch x86_64
CFLAGS  ?= -O2 -Wall

all: trace_target mini_strace

trace_target: trace_target.c
	$(CC) $(ARCH) $(CFLAGS) -o $@ $<

mini_strace: mini_strace.c
	$(CC) $(ARCH) $(CFLAGS) -o $@ $<

run: trace_target mini_strace
	@echo "=== direct: trace_target ==="
	./trace_target /etc/hosts
	@echo
	@echo "=== mini_strace trace_target (only on Linux) ==="
	-uname -s | grep -q Linux && ./mini_strace ./trace_target /etc/hosts || echo "(skipped: mini_strace is Linux-only)"
	@echo
	@echo "=== syscall tracer scripts (sudo for dtruss) ==="
	@echo "  Linux: ./strace_linux.sh"
	@echo "  macOS: sudo ./dtruss_macos.sh"

clean:
	rm -f trace_target mini_strace

.PHONY: all run clean
