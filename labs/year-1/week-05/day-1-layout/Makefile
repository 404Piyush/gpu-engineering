CC      ?= clang
ARCH    ?= -arch x86_64
CFLAGS  ?= -O0 -g -Wall

all: layout

layout: layout.c
	$(CC) $(ARCH) $(CFLAGS) -o $@ $<

run: layout
	./layout

asm:
	$(CC) $(ARCH) -O0 -S -o layout.s layout.c

clean:
	rm -f layout *.s

.PHONY: all run asm clean
