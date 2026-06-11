CC      ?= clang
ARCH    ?= -arch x86_64
CFLAGS  ?= -O2 -g -Wall -Iinclude

.PHONY: all test run-test bench clean

all: test

build:
	@mkdir -p build

build/myalloc.o: src/myalloc.c include/myalloc.h | build
	$(CC) $(ARCH) $(CFLAGS) -c src/myalloc.c -o $@

build/libmyalloc.a: build/myalloc.o
	ar rcs $@ $^

build/test_myalloc: tests/test_myalloc.c build/libmyalloc.a
	$(CC) $(ARCH) $(CFLAGS) -Itests tests/test_myalloc.c build/libmyalloc.a -o $@

build/bench: bench/bench.c build/libmyalloc.a
	$(CC) $(ARCH) $(CFLAGS) -Ibench bench/bench.c build/libmyalloc.a -o $@

test: build/test_myalloc
	./build/test_myalloc

run-test: build/test_myalloc
	./build/test_myalloc

bench: build/bench
	./build/bench > bench.txt
	cat bench.txt

clean:
	rm -rf build bench.txt

