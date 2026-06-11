CC      ?= clang
ARCH    ?= -arch x86_64
CFLAGS  ?= -O0 -g

all: recursion

%: %.c
	$(CC) $(ARCH) $(CFLAGS) -o $@ $<

run: recursion
	./recursion 20000 > stack.txt
	head -5 stack.txt
	tail -5 stack.txt

clean:
	rm -f recursion stack.txt

.PHONY: all run clean
