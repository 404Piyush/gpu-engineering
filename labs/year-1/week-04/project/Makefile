CC      ?= clang
ARCH    ?= -arch x86_64
CFLAGS  ?= -O0 -g -Wall -Wextra -fno-omit-frame-pointer
INCLUDE := -Iinclude
SRC_DIR := src
BUILD   := build
ASM     := asm

SRCS    := $(wildcard $(SRC_DIR)/*.c)
OBJS    := $(patsubst $(SRC_DIR)/%.c,$(BUILD)/%.o,$(SRCS))
BIN     := $(BUILD)/bst_demo

all: $(BIN)

$(BUILD):
	@mkdir -p $@

$(BUILD)/%.o: $(SRC_DIR)/%.c | $(BUILD)
	$(CC) $(ARCH) $(CFLAGS) $(INCLUDE) -c $< -o $@

$(BIN): $(OBJS)
	$(CC) $(ARCH) $(CFLAGS) $^ -o $@

asm:
	@mkdir -p $(ASM)
	clang $(ARCH) -O0 -S -o $(ASM)/main.O0.s     $(INCLUDE) $(SRC_DIR)/main.c
	clang $(ARCH) -O0 -S -o $(ASM)/student.O0.s  $(INCLUDE) $(SRC_DIR)/student.c
	clang $(ARCH) -O2 -S -o $(ASM)/main.O2.s     $(INCLUDE) $(SRC_DIR)/main.c
	clang $(ARCH) -O2 -S -o $(ASM)/student.O2.s  $(INCLUDE) $(SRC_DIR)/student.c

run: $(BIN)
	./$(BIN)

clean:
	rm -rf $(BUILD) $(ASM)

.PHONY: all asm run clean
