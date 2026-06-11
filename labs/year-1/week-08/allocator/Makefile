CC      ?= clang
ARCH    ?= -arch x86_64
CFLAGS  ?= -O2 -g -Wall -Iinclude

ALLOBC := build/myalloc.o
LIB    := build/libmyalloc.a

.PHONY: all test run-test bench clean

all: test

build:
	@mkdir -p build

$(ALLOBC): src/myalloc.c include/myalloc.h | build
	$(CC) $(ARCH) $(CFLAGS) -c src/myalloc.c -o $@

$(LIB): $(ALLOBC)
	ar rcs $@ $^

test: $(LIB) tests/test_myalloc.c
	$(CC) $(ARCH) $(CFLAGS) -Itests tests/test_myalloc.c $(LIB) -o build/test_myalloc

run-test: test
	./build/test_myalloc

bench: $(LIB) bench/bench.c
	$(CC) $(ARCH) $(CFLAGS) -Ibench bench/bench.c $(LIB) -o build/bench
	./build/bench > bench.txt
	cat bench.txt
	@echo "captured to bench.txt"

bench: $(LIB) bench/bench.c
	$(CC) $(ARCH) $(CFLAGS) -Ibench bench/bench.c $(LIB) -o build/bench
	./build/bench > bench.txt
	cat bench.txt

clean:
	rm -rf build bench.txt
