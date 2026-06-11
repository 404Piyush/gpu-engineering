CC      ?= clang
ARCH    ?= -arch x86_64
CFLAGS  ?= -O0 -g -Wall

all: scaling faults_alloc page_faults

%: %.c
	$(CC) $(ARCH) $(CFLAGS) -o $@ $<

run: scaling faults_alloc page_faults
	./scaling > scaling.txt
	./faults_alloc 64
	./faults_alloc 256
	./page_faults

clean:
	rm -f scaling faults_alloc page_faults scaling.txt

.PHONY: all run clean
