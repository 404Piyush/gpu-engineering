#include "student.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Hard-coded dataset for the demo. In real code this would come from a file. */
static Student dataset[] = {
    { 7,  "Aarav",  3.6f },
    { 3,  "Diya",   3.9f },
    { 11, "Vihaan", 3.2f },
    { 1,  "Anaya",  3.8f },
    { 5,  "Ishaan", 3.5f },
    { 9,  "Kavya",  3.7f },
    { 13, "Rohan",  3.1f },
    { 2,  "Mira",   3.95f },
    { 4,  "Arjun",  3.0f },
    { 6,  "Sneha",  3.85f },
};
static const int N = sizeof(dataset) / sizeof(dataset[0]);

static void print_student(const Student *s) {
    printf("  id=%-3d name=%-8s gpa=%.2f\n", s->id, s->name, s->gpa);
}

int main(int argc, char **argv) {
    (void)argc; (void)argv;

    /* Build BST */
    Node *root = NULL;
    for (int i = 0; i < N; i++) {
        root = bst_insert(root, dataset[i]);
    }

    printf("Dataset size    : %d\n", N);
    printf("Tree height     : %d\n", bst_height(root));
    printf("Leaf count      : %d\n", bst_count_leaves(root));

    Stats s = bst_stats(root);
    printf("Stats           : count=%d avg=%.2f min=%.2f max=%.2f\n",
           s.count, s.gpa_sum / s.count, s.gpa_min, s.gpa_max);

    /* In-order traversal — yields sorted ids */
    Student sorted[16];
    int    idx = 0;
    bst_inorder(root, sorted, &idx);
    printf("In-order (sorted by id):\n");
    for (int i = 0; i < idx; i++) print_student(&sorted[i]);

    /* Lookups */
    int ids[] = { 1, 6, 99, 13 };
    printf("Lookups:\n");
    for (int i = 0; i < 4; i++) {
        Node *hit = bst_find(root, ids[i]);
        if (hit) {
            printf("  id=%d FOUND -> %s (gpa %.2f)\n",
                   ids[i], hit->data.name, hit->data.gpa);
        } else {
            printf("  id=%d NOT FOUND\n", ids[i]);
        }
    }

    bst_free(root);
    return 0;
}
