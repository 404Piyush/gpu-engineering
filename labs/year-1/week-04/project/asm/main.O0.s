	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 15, 0
	.globl	_main                           ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$800, %rsp                      ## imm = 0x320
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
	movl	$0, -676(%rbp)
	movl	%edi, -680(%rbp)
	movq	%rsi, -688(%rbp)
	movq	$0, -696(%rbp)
	movl	$0, -700(%rbp)
LBB0_1:                                 ## =>This Inner Loop Header: Depth=1
	cmpl	$10, -700(%rbp)
	jge	LBB0_4
## %bb.2:                               ##   in Loop: Header=BB0_1 Depth=1
	movq	-696(%rbp), %rdi
	movslq	-700(%rbp), %rax
	leaq	_dataset(%rip), %rcx
	imulq	$40, %rax, %rax
	addq	%rax, %rcx
	movq	32(%rcx), %rdx
	movq	%rsp, %rax
	movq	%rdx, 32(%rax)
	movups	(%rcx), %xmm0
	movups	16(%rcx), %xmm1
	movups	%xmm1, 16(%rax)
	movups	%xmm0, (%rax)
	callq	_bst_insert
	movq	%rax, -696(%rbp)
## %bb.3:                               ##   in Loop: Header=BB0_1 Depth=1
	movl	-700(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -700(%rbp)
	jmp	LBB0_1
LBB0_4:
	leaq	L_.str(%rip), %rdi
	xorl	%eax, %eax
                                        ## kill: def $al killed $al killed $eax
	movb	%al, -745(%rbp)                 ## 1-byte Spill
	movl	$10, %esi
	callq	_printf
	movq	-696(%rbp), %rdi
	callq	_bst_height
	movl	%eax, %esi
	movb	-745(%rbp), %al                 ## 1-byte Reload
	leaq	L_.str.1(%rip), %rdi
	callq	_printf
	movq	-696(%rbp), %rdi
	callq	_bst_count_leaves
	movl	%eax, %esi
	movb	-745(%rbp), %al                 ## 1-byte Reload
	leaq	L_.str.2(%rip), %rdi
	callq	_printf
	movq	-696(%rbp), %rdi
	callq	_bst_stats
	movq	%rax, -720(%rbp)
	movlpd	%xmm0, -712(%rbp)
	movl	-720(%rbp), %esi
	movss	-716(%rbp), %xmm0               ## xmm0 = mem[0],zero,zero,zero
	cvtsi2ssl	-720(%rbp), %xmm1
	divss	%xmm1, %xmm0
	cvtss2sd	%xmm0, %xmm0
	movss	-712(%rbp), %xmm1               ## xmm1 = mem[0],zero,zero,zero
	cvtss2sd	%xmm1, %xmm1
	movss	-708(%rbp), %xmm2               ## xmm2 = mem[0],zero,zero,zero
	cvtss2sd	%xmm2, %xmm2
	leaq	L_.str.3(%rip), %rdi
	movb	$3, %al
	callq	_printf
	movl	$0, -724(%rbp)
	movq	-696(%rbp), %rdi
	leaq	-656(%rbp), %rsi
	leaq	-724(%rbp), %rdx
	callq	_bst_inorder
	leaq	L_.str.4(%rip), %rdi
	movb	$0, %al
	callq	_printf
	movl	$0, -728(%rbp)
LBB0_5:                                 ## =>This Inner Loop Header: Depth=1
	movl	-728(%rbp), %eax
	cmpl	-724(%rbp), %eax
	jge	LBB0_8
## %bb.6:                               ##   in Loop: Header=BB0_5 Depth=1
	movslq	-728(%rbp), %rax
	leaq	-656(%rbp), %rdi
	imulq	$40, %rax, %rax
	addq	%rax, %rdi
	callq	_print_student
## %bb.7:                               ##   in Loop: Header=BB0_5 Depth=1
	movl	-728(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -728(%rbp)
	jmp	LBB0_5
LBB0_8:
	movq	L___const.main.ids(%rip), %rax
	movq	%rax, -672(%rbp)
	movq	L___const.main.ids+8(%rip), %rax
	movq	%rax, -664(%rbp)
	leaq	L_.str.5(%rip), %rdi
	movb	$0, %al
	callq	_printf
	movl	$0, -732(%rbp)
LBB0_9:                                 ## =>This Inner Loop Header: Depth=1
	cmpl	$4, -732(%rbp)
	jge	LBB0_15
## %bb.10:                              ##   in Loop: Header=BB0_9 Depth=1
	movq	-696(%rbp), %rdi
	movslq	-732(%rbp), %rax
	movl	-672(%rbp,%rax,4), %esi
	callq	_bst_find
	movq	%rax, -744(%rbp)
	cmpq	$0, -744(%rbp)
	je	LBB0_12
## %bb.11:                              ##   in Loop: Header=BB0_9 Depth=1
	movslq	-732(%rbp), %rax
	movl	-672(%rbp,%rax,4), %esi
	movq	-744(%rbp), %rdx
	addq	$4, %rdx
	movq	-744(%rbp), %rax
	movss	36(%rax), %xmm0                 ## xmm0 = mem[0],zero,zero,zero
	cvtss2sd	%xmm0, %xmm0
	leaq	L_.str.6(%rip), %rdi
	movb	$1, %al
	callq	_printf
	jmp	LBB0_13
LBB0_12:                                ##   in Loop: Header=BB0_9 Depth=1
	movslq	-732(%rbp), %rax
	movl	-672(%rbp,%rax,4), %esi
	leaq	L_.str.7(%rip), %rdi
	movb	$0, %al
	callq	_printf
LBB0_13:                                ##   in Loop: Header=BB0_9 Depth=1
	jmp	LBB0_14
LBB0_14:                                ##   in Loop: Header=BB0_9 Depth=1
	movl	-732(%rbp), %eax
	addl	$1, %eax
	movl	%eax, -732(%rbp)
	jmp	LBB0_9
LBB0_15:
	movq	-696(%rbp), %rdi
	callq	_bst_free
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	-8(%rbp), %rcx
	cmpq	%rcx, %rax
	jne	LBB0_17
## %bb.16:
	xorl	%eax, %eax
	addq	$800, %rsp                      ## imm = 0x320
	popq	%rbp
	retq
LBB0_17:
	callq	___stack_chk_fail
	ud2
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function print_student
_print_student:                         ## @print_student
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movl	(%rax), %esi
	movq	-8(%rbp), %rdx
	addq	$4, %rdx
	movq	-8(%rbp), %rax
	movss	36(%rax), %xmm0                 ## xmm0 = mem[0],zero,zero,zero
	cvtss2sd	%xmm0, %xmm0
	leaq	L_.str.8(%rip), %rdi
	movb	$1, %al
	callq	_printf
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__DATA,__data
	.p2align	4, 0x0                          ## @dataset
_dataset:
	.long	7                               ## 0x7
	.asciz	"Aarav\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.long	0x40666666                      ## float 3.5999999
	.long	3                               ## 0x3
	.asciz	"Diya\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.long	0x4079999a                      ## float 3.9000001
	.long	11                              ## 0xb
	.asciz	"Vihaan\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.long	0x404ccccd                      ## float 3.20000005
	.long	1                               ## 0x1
	.asciz	"Anaya\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.long	0x40733333                      ## float 3.79999995
	.long	5                               ## 0x5
	.asciz	"Ishaan\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.long	0x40600000                      ## float 3.5
	.long	9                               ## 0x9
	.asciz	"Kavya\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.long	0x406ccccd                      ## float 3.70000005
	.long	13                              ## 0xd
	.asciz	"Rohan\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.long	0x40466666                      ## float 3.0999999
	.long	2                               ## 0x2
	.asciz	"Mira\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.long	0x407ccccd                      ## float 3.95000005
	.long	4                               ## 0x4
	.asciz	"Arjun\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.long	0x40400000                      ## float 3
	.long	6                               ## 0x6
	.asciz	"Sneha\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.long	0x40766666                      ## float 3.8499999

	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"Dataset size    : %d\n"

L_.str.1:                               ## @.str.1
	.asciz	"Tree height     : %d\n"

L_.str.2:                               ## @.str.2
	.asciz	"Leaf count      : %d\n"

L_.str.3:                               ## @.str.3
	.asciz	"Stats           : count=%d avg=%.2f min=%.2f max=%.2f\n"

L_.str.4:                               ## @.str.4
	.asciz	"In-order (sorted by id):\n"

	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ## @__const.main.ids
L___const.main.ids:
	.long	1                               ## 0x1
	.long	6                               ## 0x6
	.long	99                              ## 0x63
	.long	13                              ## 0xd

	.section	__TEXT,__cstring,cstring_literals
L_.str.5:                               ## @.str.5
	.asciz	"Lookups:\n"

L_.str.6:                               ## @.str.6
	.asciz	"  id=%d FOUND -> %s (gpa %.2f)\n"

L_.str.7:                               ## @.str.7
	.asciz	"  id=%d NOT FOUND\n"

L_.str.8:                               ## @.str.8
	.asciz	"  id=%-3d name=%-8s gpa=%.2f\n"

.subsections_via_symbols
