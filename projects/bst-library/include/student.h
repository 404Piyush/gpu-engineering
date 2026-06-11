#ifndef STUDENT_H
#define STUDENT_H

#include <stddef.h>

typedef struct {
    int   id;
    char  name[32];
    float gpa;
} Student;

typedef struct Node {
    Student          data;
    struct Node     *left;
    struct Node     *right;
} Node;

/* Build / destroy a BST from an array of students. */
Node *bst_insert(Node *root, Student s);
Node *bst_find(Node *root, int id);
void  bst_free(Node *root);

/* Compute aggregate statistics over the tree. */
typedef struct {
    int   count;
    float gpa_sum;
    float gpa_min;
    float gpa_max;
} Stats;

Stats bst_stats(Node *root);

/* Recursive helpers, exported for assembly study. */
int   bst_height(Node *root);
void  bst_inorder(Node *root, Student *out, int *idx);
int   bst_count_leaves(Node *root);

#endif
