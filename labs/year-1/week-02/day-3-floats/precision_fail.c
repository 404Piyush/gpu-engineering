#include <stdio.h>
#include <stdbool.h>
#include <math.h>    
#include <float.h>   // Required for FLT_EPSILON


int main() {
    // --- 1. THE CLASSIC 0.1 + 0.2 TRAP ---
    float a = 0.1f;
    float b = 0.2f;
    float sum = a + b;

    printf("--- Part 1: The 0.1 + 0.2 Paradox ---\n");
    // Printing to 10 decimal places to see the "hidden" error
    printf("Computed Sum: %.10f\n", sum);
    printf("Expected Sum: %.10f\n", 0.3f);

    if (sum == 0.3f) {
        printf("Result: They are exactly equal (Unlikely!)\n");
    } else {
        printf("Result: NOT equal. Welcome to Floating Point math.\n");
    }

    // --- 2. THE SOLUTION: EPSILON ---
    printf("\n--- Part 2: Fixing Equality with Epsilon ---\n");
    
    // We check if the difference is smaller than a tiny "tolerance"
    float difference = fabs(sum - 0.3f);
    printf("Difference is: %.10f\n", difference);
    printf("FLT_EPSILON is: %.10f\n", FLT_EPSILON);

    if (difference < FLT_EPSILON) {
        printf("Result: Close enough! We treat them as equal.\n");
    }

    // --- 3. CATASTROPHIC CANCELLATION ---
    printf("\n--- Part 3: Catastrophic Cancellation ---\n");
    
    // Subtracting two very close, very large numbers
    double big_num1 = 1.23456789012345;
    double big_num2 = 1.23456789012344;
    double result = big_num1 - big_num2;

    printf("Big Num 1: %.15f\n", big_num1);
    printf("Big Num 2: %.15f\n", big_num2);
    printf("Result of subtraction: %.20f\n", result);
    printf("Expected (Pure Math):  0.00000000000001\n");

    return 0;
}