CC      ?= cc
CFLAGS  ?= -O2 -Wall -Wextra -Wpedantic -std=c11
PROGRAMS := pipe_through pipe_chain

all: $(PROGRAMS)

%: %.c
	$(CC) $(CFLAGS) -o $@ $<

run: all
	@echo "=== pipe_through ==="
	./pipe_through
	@echo
	@echo "=== pipe_chain (ls /usr/include | wc -l) ==="
	./pipe_chain

clean:
	rm -f $(PROGRAMS)

.PHONY: all run clean
