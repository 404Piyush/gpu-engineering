# Weekend Lab: Bank System Disassembly & Stack Analysis
**Author:** Piyush  
**Date:** March 2026  
**Subject:** CS:APP Week 3 - Machine-Level Programs

## 1. The Stack Frame Diagram (Main Function)
When `main` runs, it carves out space on the stack for our variables. Based on the `sub rsp, 0x...` instruction at the top of the function, here is the "Desk Layout":

| Memory Address (Offset) | Size | Variable Name | Human Interpretation |
| :--- | :--- | :--- | :--- |
| `[rbp - 0x04]` | 4 bytes | `activeAccounts` | A simple integer counter for the loop. |
| `[rbp - 0x08]` | 4 bytes | `totalLiquidity` | A decimal (float) holding the total bank cash. |
| `[rbp - 0x10]` | 8 bytes | `bank` pointer | A 64-bit address pointing to our list of accounts. |
| `[rbp - 0xA0]` | 140+ bytes | `Account` data | The actual storage for the names and IDs. |



## 2. Assembly "Translation" (Key Discoveries)

### Finding the Balance
In the C code, I wrote `acc->balance`. In the assembly file (`bank_annotated.txt`), I found this line:
`movss xmm0, DWORD PTR [rax+0x1c]`
* **Aha! Moment:** `0x1c` is 28 in decimal. This means the "Balance" is always exactly 28 bytes away from the start of an Account. The CPU skips the `ID` and `Name` to find the money.

### Passing by Reference
When calling `applyInterest(&bank[i])`, I saw the `lea` instruction:
`lea rax, [rbp-0x100]`
* **Aha! Moment:** `lea` stands for "Load Effective Address." The CPU isn't copying the whole bank; it's just grabbing the "address" (the location) to hand it over to the function. It's much faster than copying data!