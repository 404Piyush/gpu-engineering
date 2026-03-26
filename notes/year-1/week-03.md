# Week 3 Summary: Reading the Machine

### 🛠 Tools & Commands
* `gcc -S -O0`: Compiles C into readable assembly (`.s` file).
* `objdump -S -M intel`: Breaks open a binary and matches the assembly to the original C code.
* `GDB`: Used `info frame` to see exactly what the stack looks like while the program is running.

### 🧠 Core Concepts Learned
1. **The Prologue:** Every function starts with `push rbp` (saving the old desk state) and `mov rbp, rsp` (setting up the new desk).
2. **Registers are Specialized:**
    * `rax`: The "Return" register. If a function returns 5, `rax` will hold 5.
    * `rdi`, `rsi`, `rdx`: These are the "Delivery" trucks that carry data INTO functions.
3. **Control Flow:** `if` statements and `loops` are just `cmp` (Compare) and `jmp` (Jump) instructions. The CPU doesn't know what a "For Loop" is; it just knows "Go back to line 40 until this number is zero."