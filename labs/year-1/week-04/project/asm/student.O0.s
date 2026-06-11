	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 15, 0
	.globl	_bst_insert                     ## -- Begin function bst_insert
	.p2align	4, 0x90
_bst_insert:                            ## @bst_insert
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$64, %rsp
	leaq	16(%rbp), %rax
	movq	%rax, -24(%rbp)                 ## 8-byte Spill
	movq	%rdi, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	LBB0_2
## %bb.1:
	movq	-24(%rbp), %rcx                 ## 8-byte Reload
	movq	32(%rcx), %rdx
	movq	%rsp, %rax
	movq	%rdx, 32(%rax)
	movups	(%rcx), %xmm0
	movups	16(%rcx), %xmm1
	movups	%xmm1, 16(%rax)
	movups	%xmm0, (%rax)
	callq	_node_new
	movq	%rax, -8(%rbp)
	jmp	LBB0_8
LBB0_2:
	movq	-24(%rbp), %rax                 ## 8-byte Reload
	movl	(%rax), %eax
	movq	-16(%rbp), %rcx
	cmpl	(%rcx), %eax
	jge	LBB0_4
## %bb.3:
	movq	-24(%rbp), %rcx                 ## 8-byte Reload
	movq	-16(%rbp), %rax
	movq	40(%rax), %rdi
	movq	32(%rcx), %rdx
	movq	%rsp, %rax
	movq	%rdx, 32(%rax)
	movups	(%rcx), %xmm0
	movups	16(%rcx), %xmm1
	movups	%xmm1, 16(%rax)
	movups	%xmm0, (%rax)
	callq	_bst_insert
	movq	%rax, %rcx
	movq	-16(%rbp), %rax
	movq	%rcx, 40(%rax)
	jmp	LBB0_7
LBB0_4:
	movq	-24(%rbp), %rax                 ## 8-byte Reload
	movl	(%rax), %eax
	movq	-16(%rbp), %rcx
	cmpl	(%rcx), %eax
	jle	LBB0_6
## %bb.5:
	movq	-24(%rbp), %rcx                 ## 8-byte Reload
	movq	-16(%rbp), %rax
	movq	48(%rax), %rdi
	movq	32(%rcx), %rdx
	movq	%rsp, %rax
	movq	%rdx, 32(%rax)
	movups	(%rcx), %xmm0
	movups	16(%rcx), %xmm1
	movups	%xmm1, 16(%rax)
	movups	%xmm0, (%rax)
	callq	_bst_insert
	movq	%rax, %rcx
	movq	-16(%rbp), %rax
	movq	%rcx, 48(%rax)
LBB0_6:
	jmp	LBB0_7
LBB0_7:
	movq	-16(%rbp), %rax
	movq	%rax, -8(%rbp)
LBB0_8:
	movq	-8(%rbp), %rax
	addq	$64, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function node_new
_node_new:                              ## @node_new
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	leaq	16(%rbp), %rax
	movq	%rax, -24(%rbp)                 ## 8-byte Spill
	movl	$56, %edi
	callq	_malloc
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	LBB1_2
## %bb.1:
	movq	$0, -8(%rbp)
	jmp	LBB1_3
LBB1_2:
	movq	-24(%rbp), %rsi                 ## 8-byte Reload
	movq	-16(%rbp), %rdi
	movl	$40, %edx
	callq	_memcpy
	movq	-16(%rbp), %rax
	movq	$0, 40(%rax)
	movq	-16(%rbp), %rax
	movq	$0, 48(%rax)
	movq	-16(%rbp), %rax
	movq	%rax, -8(%rbp)
LBB1_3:
	movq	-8(%rbp), %rax
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_bst_find                       ## -- Begin function bst_find
	.p2align	4, 0x90
_bst_find:                              ## @bst_find
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movq	%rdi, -16(%rbp)
	movl	%esi, -20(%rbp)
	cmpq	$0, -16(%rbp)
	je	LBB2_2
## %bb.1:
	movq	-16(%rbp), %rax
	movl	(%rax), %eax
	cmpl	-20(%rbp), %eax
	jne	LBB2_3
LBB2_2:
	movq	-16(%rbp), %rax
	movq	%rax, -8(%rbp)
	jmp	LBB2_6
LBB2_3:
	movl	-20(%rbp), %eax
	movq	-16(%rbp), %rcx
	cmpl	(%rcx), %eax
	jge	LBB2_5
## %bb.4:
	movq	-16(%rbp), %rax
	movq	40(%rax), %rdi
	movl	-20(%rbp), %esi
	callq	_bst_find
	movq	%rax, -8(%rbp)
	jmp	LBB2_6
LBB2_5:
	movq	-16(%rbp), %rax
	movq	48(%rax), %rdi
	movl	-20(%rbp), %esi
	callq	_bst_find
	movq	%rax, -8(%rbp)
LBB2_6:
	movq	-8(%rbp), %rax
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_bst_free                       ## -- Begin function bst_free
	.p2align	4, 0x90
_bst_free:                              ## @bst_free
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	LBB3_2
## %bb.1:
	jmp	LBB3_3
LBB3_2:
	movq	-8(%rbp), %rax
	movq	40(%rax), %rdi
	callq	_bst_free
	movq	-8(%rbp), %rax
	movq	48(%rax), %rdi
	callq	_bst_free
	movq	-8(%rbp), %rdi
	callq	_free
LBB3_3:
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_bst_height                     ## -- Begin function bst_height
	.p2align	4, 0x90
_bst_height:                            ## @bst_height
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movq	%rdi, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	LBB4_2
## %bb.1:
	movl	$0, -4(%rbp)
	jmp	LBB4_6
LBB4_2:
	movq	-16(%rbp), %rax
	movq	40(%rax), %rdi
	callq	_bst_height
	movl	%eax, -20(%rbp)
	movq	-16(%rbp), %rax
	movq	48(%rax), %rdi
	callq	_bst_height
	movl	%eax, -24(%rbp)
	movl	-20(%rbp), %eax
	cmpl	-24(%rbp), %eax
	jle	LBB4_4
## %bb.3:
	movl	-20(%rbp), %eax
	movl	%eax, -28(%rbp)                 ## 4-byte Spill
	jmp	LBB4_5
LBB4_4:
	movl	-24(%rbp), %eax
	movl	%eax, -28(%rbp)                 ## 4-byte Spill
LBB4_5:
	movl	-28(%rbp), %eax                 ## 4-byte Reload
	addl	$1, %eax
	movl	%eax, -4(%rbp)
LBB4_6:
	movl	-4(%rbp), %eax
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_bst_inorder                    ## -- Begin function bst_inorder
	.p2align	4, 0x90
_bst_inorder:                           ## @bst_inorder
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movq	%rdi, -8(%rbp)
	movq	%rsi, -16(%rbp)
	movq	%rdx, -24(%rbp)
	cmpq	$0, -8(%rbp)
	jne	LBB5_2
## %bb.1:
	jmp	LBB5_3
LBB5_2:
	movq	-8(%rbp), %rax
	movq	40(%rax), %rdi
	movq	-16(%rbp), %rsi
	movq	-24(%rbp), %rdx
	callq	_bst_inorder
	movq	-16(%rbp), %rdi
	movq	-24(%rbp), %rcx
	movl	(%rcx), %eax
	movl	%eax, %edx
	addl	$1, %edx
	movl	%edx, (%rcx)
	cltq
	imulq	$40, %rax, %rax
	addq	%rax, %rdi
	movq	-8(%rbp), %rsi
	movl	$40, %edx
	callq	_memcpy
	movq	-8(%rbp), %rax
	movq	48(%rax), %rdi
	movq	-16(%rbp), %rsi
	movq	-24(%rbp), %rdx
	callq	_bst_inorder
LBB5_3:
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_bst_count_leaves               ## -- Begin function bst_count_leaves
	.p2align	4, 0x90
_bst_count_leaves:                      ## @bst_count_leaves
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movq	%rdi, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	LBB6_2
## %bb.1:
	movl	$0, -4(%rbp)
	jmp	LBB6_6
LBB6_2:
	movq	-16(%rbp), %rax
	cmpq	$0, 40(%rax)
	jne	LBB6_5
## %bb.3:
	movq	-16(%rbp), %rax
	cmpq	$0, 48(%rax)
	jne	LBB6_5
## %bb.4:
	movl	$1, -4(%rbp)
	jmp	LBB6_6
LBB6_5:
	movq	-16(%rbp), %rax
	movq	40(%rax), %rdi
	callq	_bst_count_leaves
	movl	%eax, -20(%rbp)                 ## 4-byte Spill
	movq	-16(%rbp), %rax
	movq	48(%rax), %rdi
	callq	_bst_count_leaves
	movl	%eax, %ecx
	movl	-20(%rbp), %eax                 ## 4-byte Reload
	addl	%ecx, %eax
	movl	%eax, -4(%rbp)
LBB6_6:
	movl	-4(%rbp), %eax
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_bst_stats                      ## -- Begin function bst_stats
	.p2align	4, 0x90
_bst_stats:                             ## @bst_stats
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$64, %rsp
	movq	%rdi, -24(%rbp)
	movq	L___const.bst_stats.s(%rip), %rax
	movq	%rax, -16(%rbp)
	movq	L___const.bst_stats.s+8(%rip), %rax
	movq	%rax, -8(%rbp)
	cmpq	$0, -24(%rbp)
	jne	LBB7_2
## %bb.1:
	jmp	LBB7_11
LBB7_2:
	movq	-24(%rbp), %rax
	movq	40(%rax), %rdi
	callq	_bst_stats
	movq	%rax, -40(%rbp)
	movlpd	%xmm0, -32(%rbp)
	movq	-24(%rbp), %rax
	movq	48(%rax), %rdi
	callq	_bst_stats
	movq	%rax, -56(%rbp)
	movlpd	%xmm0, -48(%rbp)
	movl	-40(%rbp), %eax
	addl	$1, %eax
	addl	-56(%rbp), %eax
	movl	%eax, -16(%rbp)
	movq	-24(%rbp), %rax
	movss	36(%rax), %xmm0                 ## xmm0 = mem[0],zero,zero,zero
	addss	-36(%rbp), %xmm0
	addss	-52(%rbp), %xmm0
	movss	%xmm0, -12(%rbp)
	movq	-24(%rbp), %rax
	movss	36(%rax), %xmm0                 ## xmm0 = mem[0],zero,zero,zero
	movss	%xmm0, -8(%rbp)
	movss	-32(%rbp), %xmm1                ## xmm1 = mem[0],zero,zero,zero
	movss	-8(%rbp), %xmm0                 ## xmm0 = mem[0],zero,zero,zero
	ucomiss	%xmm1, %xmm0
	jbe	LBB7_4
## %bb.3:
	movss	-32(%rbp), %xmm0                ## xmm0 = mem[0],zero,zero,zero
	movss	%xmm0, -8(%rbp)
LBB7_4:
	movss	-48(%rbp), %xmm1                ## xmm1 = mem[0],zero,zero,zero
	movss	-8(%rbp), %xmm0                 ## xmm0 = mem[0],zero,zero,zero
	ucomiss	%xmm1, %xmm0
	jbe	LBB7_6
## %bb.5:
	movss	-48(%rbp), %xmm0                ## xmm0 = mem[0],zero,zero,zero
	movss	%xmm0, -8(%rbp)
LBB7_6:
	movq	-24(%rbp), %rax
	movss	36(%rax), %xmm0                 ## xmm0 = mem[0],zero,zero,zero
	movss	%xmm0, -4(%rbp)
	movss	-28(%rbp), %xmm0                ## xmm0 = mem[0],zero,zero,zero
	ucomiss	-4(%rbp), %xmm0
	jbe	LBB7_8
## %bb.7:
	movss	-28(%rbp), %xmm0                ## xmm0 = mem[0],zero,zero,zero
	movss	%xmm0, -4(%rbp)
LBB7_8:
	movss	-44(%rbp), %xmm0                ## xmm0 = mem[0],zero,zero,zero
	ucomiss	-4(%rbp), %xmm0
	jbe	LBB7_10
## %bb.9:
	movss	-44(%rbp), %xmm0                ## xmm0 = mem[0],zero,zero,zero
	movss	%xmm0, -4(%rbp)
LBB7_10:
	jmp	LBB7_11
LBB7_11:
	movq	-16(%rbp), %rax
	movsd	-8(%rbp), %xmm0                 ## xmm0 = mem[0],zero
	addq	$64, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	2, 0x0                          ## @__const.bst_stats.s
L___const.bst_stats.s:
	.long	0                               ## 0x0
	.long	0x00000000                      ## float 0
	.long	0x4e6e6b28                      ## float 1.0E+9
	.long	0xce6e6b28                      ## float -1.0E+9

.subsections_via_symbols
