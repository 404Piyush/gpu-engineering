# Week 2: Data Representation (Integers, Floats, Bits)

This week was all about moving away from "abstract" math and seeing how computers actually store data at the hardware level.

## 🚀 Learning Goals
- [x] Understand signed vs unsigned, overflow, and two’s complement.
- [x] Understand floating point precision and surprising behavior.
- [x] Get comfortable with bitwise operations as tools (not trivia).

---

## 📅 Daily Breakdown

### Day 1: Integer Overflow & Two's Complement
- Explored how `unsigned` and `signed` integers behave at their limits.
- **Key Takeaway:** When a signed integer overflows, it wraps around to a negative number because of the Most Significant Bit (MSB).

### Day 2: Bit Manipulation Utilities
- Implemented core bitwise functions: `set`, `clear`, `toggle`, `get`, and `popcount`.
- Used bitmasks (`1 << n`) to target specific bits without affecting others.

### Day 3: Floating Point Weirdness
- Proved that `0.1 + 0.2 != 0.3` using C.
- Learned that floats are approximations, not exact values. 
- **The Fix:** Always use an `EPSILON` range check instead of `==`.

### Day 4: Mini Hexdump Tool
- Built a tool that reads raw bytes from any file using `rb` mode.
- Prints the memory offset, the hex values, and the ASCII representation side-by-side.

---

## 🧠 Interview "Gotchas" (The Hard Stuff)

### 1. The 0.1 + 0.2 Paradox
Computers use Base-2 (Binary). Some decimals, like 0.1, are repeating fractions in binary (like 1/3 is in decimal). Since the CPU has limited bits, it truncates the number, causing a tiny rounding error that accumulates.


### 2. Catastrophic Cancellation
When subtracting two nearly identical large floating-point numbers, the significant digits cancel out, leaving only the "rounding noise" behind. This can completely ruin the accuracy of a physics engine or a GPU shader.

### 3. Bit Shift Overflow
Shifting a 32-bit integer by 32 or more positions is **Undefined Behavior**. The CPU might return the original number, zero, or a random value. Always bound your shifts.

### 4. Sign Extension
When working with bits, always use `unsigned int`. If you use a `signed` type, right-shifting (`>>`) might fill the new bits with the sign bit (1s for negative numbers) instead of 0s, which breaks your logic.


---

## 🛠️ Project Structure
- `/day-2-bits`: Bit utility functions and test runner.
- `/day-3-floats`: Demos for precision loss and epsilon fixes.
- `/day-4-hex`: Custom hexdump implementation.