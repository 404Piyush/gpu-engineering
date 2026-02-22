# Week 1: The C Compilation Pipeline

This week, I moved beyond just "hitting the play button" and looked at how the compiler transforms source code into a binary executable.

## The Pipeline Breakdown


### 1. Preprocessing (`-E`)
Using `gcc -E`, I observed how the preprocessor handles header files.
* **What happens:** Macros are expanded, and header content is copy-pasted into the `.i` file.

### 2. Compilation (`-S`)
Using `gcc -S`, the code is translated into **Assembly**.
* **Observation:** This is where C logic becomes CPU instructions (x86_64).

### 3. Assembly (`-c`) — "What is an Object File?"
Using `gcc -c`, the assembly is converted into an **Object File (`.o`)**.
* **Definition:** An object file is a relocatable machine-code file. It contains binary instructions but is incomplete because it hasn't been "addressed" to external functions yet.

### 4. Linking — "What does the Linker do?"
The Linker (`ld`) takes all `.o` files and stitches them together.
* **Symbol Resolution:** I used `nm` to see **Undefined (U)** symbols in `main.o` get resolved by **Text (T)** symbols in `calc.o`. 
* **Final Result:** A standalone `.exe` that includes both my logic and system libraries.

## Symbol Inspection Example
Running `nm artifacts/main.o` showed:
* `U add` (The program knows it needs `add`, but doesn't have the code yet).
* `T main` (The code for `main` is present and ready).