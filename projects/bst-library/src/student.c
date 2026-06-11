#include "student.h"
#include <stdlib.h>
#include <string.h>

static Node *node_new(Student s) {
    Node *n = (Node *)malloc(sizeof(Node));
    if (!n) return NULL;
    n->data  = s;
    n->left  = NULL;
    n->right = NULL;
    return n;
}

Node *bst_insert(Node *root, Student s) {
    if (root == NULL) return node_new(s);
    if (s.id < root->data.id)
        root->left = bst_insert(root->left, s);
    else if (s.id > root->data.id)
        root->right = bst_insert(root->right, s);
    /* equal ids: ignore (no duplicates) */
    return root;
}

Node *bst_find(Node *root, int id) {
    if (root == NULL || root->data.id == id) return root;
    if (id < root->data.id) return bst_find(root->left,  id);
    return bst_find(root->right, id);
}

void bst_free(Node *root) {
    if (root == NULL) return;
    bst_free(root->left);
    bst_free(root->right);
    free(root);
}

int bst_height(Node *root) {
    if (root == NULL) return 0;
    int lh = bst_height(root->left);
    int rh = bst_height(root->right);
    return 1 + (lh > rh ? lh : rh);
}

void bst_inorder(Node *root, Student *out, int *idx) {
    if (root == NULL) return;
    bst_inorder(root->left,  out, idx);
    out[(*idx)++] = root->data;
    bst_inorder(root->right, out, idx);
}

int bst_count_leaves(Node *root) {
    if (root == NULL) return 0;
    if (root->left == NULL && root->right == NULL) return 1;
    return bst_count_leaves(root->left) + bst_count_leaves(root->right);
}

Stats bst_stats(Node *root) {
    Stats s = {0, 0.0f, 1e9f, -1e9f};
    if (root == NULL) return s;

    Stats l = bst_stats(root->left);
    Stats r = bst_stats(root->right);

    s.count   = 1 + l.count + r.count;
    s.gpa_sum = root->data.gpa + l.gpa_sum + r.gpa_sum;
    s.gpa_min = root->data.gpa;
    if (l.gpa_min < s.gpa_min) s.gpa_min = l.gpa_min;
    if (r.gpa_min < s.gpa_min) s.gpa_min = r.gpa_min;
    s.gpa_max = root->data.gpa;
    if (l.gpa_max > s.gpa_max) s.gpa_max = l.gpa_max;
    if (r.gpa_max > s.gpa_max) s.gpa_max = r.gpa_max;
    return s;
}
