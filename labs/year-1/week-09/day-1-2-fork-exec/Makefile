CC      ?= clang
ARCH    ?= -arch x86_64
CFLAGS  ?= -O2 -Wall

PROGRAMS := fork_demo fork_loop exit_codes

all: $(PROGRAMS)

%: %.c
	$(CC) $(ARCH) $(CFLAGS) -o $@ $<

run: $(PROGRAMS)
	@echo "=== fork_demo /bin/echo hi ==="
	./fork_demo /bin/echo hi
	@echo
	@echo "=== fork_demo /bin/ls /tmp | head -3 ==="
	./fork_demo /bin/ls /tmp
	@echo
	@echo "=== fork_loop 4 ==="
	./fork_loop 4
	@echo
	@echo "=== exit_codes 0, 1, 42, 130 (SIGINT) ==="
	@for c in 0 1 42 130; do \
	    ./exit_codes $$c ; echo "  -> parent sees $$?"; \
	done

clean:
	rm -f $(PROGRAMS)

.PHONY: all run clean
