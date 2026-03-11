#include <stdio.h>
#include <ctype.h>



int main(int argc, char *argv[]) {
    // Check if the user actually gave us a file
    if (argc < 2) {
        printf("Error: I need a filename. Usage: ./hexdump <file>\n");
        return 1;
    }

    FILE *f = fopen(argv[1], "rb");
    if (f == NULL) {
        printf("Could not open that file, bro.\n");
        return 1;
    }

    unsigned char chunk[16];
    int bytes_in_chunk;
    unsigned int address = 0;

    // Read 16 bytes at a time until we hit the end
    while ((bytes_in_chunk = fread(chunk, 1, 16, f)) > 0) {
        
        // 1. Print the memory address/offset in hex
        printf("%08x: ", address);

        // 2. Print the Hex bytes
        for (int i = 0; i < 16; i++) {
            if (i < bytes_in_chunk) {
                printf("%02x ", chunk[i]);
            } else {
                printf("   "); // Space out the empty spots if line is short
            }
        }

        printf(" | ");

        // 3. Print the ASCII (human readable) part
        for (int i = 0; i < bytes_in_chunk; i++) {
            // If it's a normal character, print it. If it's a weird byte, print a dot.
            if (isprint(chunk[i])) {
                printf("%c", chunk[i]);
            } else {
                printf(".");
            }
        }

        printf("\n");
        address += 16;
    }

    fclose(f);
    return 0;
}