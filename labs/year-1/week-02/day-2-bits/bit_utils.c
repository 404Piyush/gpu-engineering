#include <stdio.h>
#include <assert.h>

// 1. Setting a bit: Using OR (|) to force a 1 at 'pos'
unsigned int set_bit(unsigned int n, int pos) {
    unsigned int mask = 1 << pos; 
    return n | mask;
}

// 2. Clearing a bit: Using AND (&) with a flipped mask (~)
unsigned int clear_bit(unsigned int n, int pos) {
    unsigned int mask = 1 << pos;
    return n & (~mask); // ~mask makes everything 1 except the pos bit
}

// 3. Toggling: Using XOR (^) to flip the state
unsigned int toggle_bit(unsigned int n, int pos) {
    return n ^ (1 << pos);
}

// 4. Getting the bit: Shift it to the start and mask with 1
int get_bit(unsigned int n, int pos) {
    // Move the bit we want to the 0th position
    unsigned int shifted = n >> pos;
    return shifted & 1; 
}

// 5. Popcount: Counting how many 1s are in the number
// I'm using a while loop to check the last bit and shift right
int popcount(unsigned int n) {
    int total = 0;
    while (n > 0) {
        if (n & 1) { // If the last bit is a 1
            total++;
        }
        n = n >> 1; // Move to the next bit
    }
    return total;
}

// --- Test Area ---
int main() {
    printf("--- Running my Bit Utility Tests ---\n");

    unsigned int my_num = 0; // Starts at 0000

    // Test 1: Set the 3rd bit
    my_num = set_bit(my_num, 3); // Should be 8 (1000)
    assert(my_num == 8);
    printf("Test 1 Passed: Set bit 3 -> %u\n", my_num);

    // Test 2: Toggle the 0th bit
    my_num = toggle_bit(my_num, 0); // 1000 becomes 1001 (9)
    assert(my_num == 9);
    printf("Test 2 Passed: Toggle bit 0 -> %u\n", my_num);

    // Test 3: Check bits
    // Fixed: Changed my_bits to my_num
    assert(get_bit(my_num, 3) == 1); 
    assert(get_bit(my_num, 1) == 0);
    printf("Test 3 Passed: Bit checking works\n");

    // Test 4: Popcount
    assert(popcount(my_num) == 2);
    printf("Test 4 Passed: Popcount for 9 is 2\n");

    return 0;
}