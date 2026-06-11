CC      ?= cc
CFLAGS  ?= -O2 -Wall -Wextra -Wpedantic -std=c11
PROGRAMS := redir_run heredoc

all: $(PROGRAMS)

%: %.c
	$(CC) $(CFLAGS) -o $@ $<

run: all
	@echo "=== redir_run 'wc -l' <Makefile >out.txt ==="
	./redir_run "wc -l" <Makefile >out.txt
	@cat out.txt
	@rm -f out.txt
	@echo
	@echo "=== heredoc, three lines + marker ==="
	printf 'one\ntwo\nthree\nEOF\n' | ./heredoc

clean:
	rm -f $(PROGRAMS)

.PHONY: all run clean
