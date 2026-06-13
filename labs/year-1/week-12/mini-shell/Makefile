CC      ?= cc
CFLAGS  ?= -O2 -Wall -Wextra -Wpedantic -std=c11
LDFLAGS ?=

SRCS    := src/shell.c src/main.c
BIN     := mini-shell
TEST    := tests/test_shell.c
TEST_C  := tests/test_counters.c
TESTBIN := build/test_shell

# On macOS, build for the host arch.  On Linux, no -arch.
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    ARCH := -arch $(shell uname -m)
else
    ARCH :=
endif

.PHONY: all test clean

all: $(BIN)

$(BIN): $(SRCS) include/shell.h
	$(CC) $(ARCH) $(CFLAGS) -Iinclude $(SRCS) -o $@ $(LDFLAGS)

$(TESTBIN): $(TEST) $(TEST_C) src/shell.c include/shell.h
	@mkdir -p build
	$(CC) $(ARCH) $(CFLAGS) -Iinclude -Itests $(TEST) $(TEST_C) src/shell.c -o $@ $(LDFLAGS)

test: $(BIN) $(TESTBIN)
	./$(TESTBIN)

clean:
	rm -f $(BIN)
	rm -rf build
