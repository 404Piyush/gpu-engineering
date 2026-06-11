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
	pushq	%r14
	pushq	%rbx
	subq	$48, %rsp
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	leaq	16(%rbp), %r14
	testq	%rdi, %rdi
	je	LBB0_1
## %bb.5:
	movq	%rdi, %rbx
	movl	(%rdi), %eax
	cmpl	%eax, (%r14)
	jge	LBB0_6
## %bb.4:
	movq	40(%rbx), %rdi
	movq	32(%r14), %rax
	movq	%rax, 32(%rsp)
	movups	(%r14), %xmm0
	movups	16(%r14), %xmm1
	movups	%xmm1, 16(%rsp)
	movups	%xmm0, (%rsp)
	callq	_bst_insert
	movq	%rax, 40(%rbx)
	jmp	LBB0_3
LBB0_1:
	movl	$56, %edi
	callq	_malloc
	movq	%rax, %rbx
	testq	%rax, %rax
	je	LBB0_3
## %bb.2:
	movq	32(%r14), %rax
	movq	%rax, 32(%rbx)
	movups	(%r14), %xmm0
	movups	16(%r14), %xmm1
	movups	%xmm1, 16(%rbx)
	movups	%xmm0, (%rbx)
	xorps	%xmm0, %xmm0
	movups	%xmm0, 40(%rbx)
	jmp	LBB0_3
LBB0_6:
	jle	LBB0_3
## %bb.7:
	movq	48(%rbx), %rdi
	movq	32(%r14), %rax
	movq	%rax, 32(%rsp)
	movups	(%r14), %xmm0
	movups	16(%r14), %xmm1
	movups	%xmm1, 16(%rsp)
	movups	%xmm0, (%rsp)
	callq	_bst_insert
	movq	%rax, 48(%rbx)
LBB0_3:
	movq	%rbx, %rax
	addq	$48, %rsp
	popq	%rbx
	popq	%r14
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
	testq	%rdi, %rdi
	je	LBB1_4
## %bb.1:
	movq	%rdi, %rax
	.p2align	4, 0x90
LBB1_2:                                 ## =>This Inner Loop Header: Depth=1
	cmpl	%esi, (%rax)
	je	LBB1_5
## %bb.3:                               ##   in Loop: Header=BB1_2 Depth=1
	setle	%cl
	movzbl	%cl, %ecx
	movq	40(%rax,%rcx,8), %rax
	testq	%rax, %rax
	jne	LBB1_2
LBB1_4:
	xorl	%eax, %eax
LBB1_5:
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_bst_free                       ## -- Begin function bst_free
	.p2align	4, 0x90
_bst_free:                              ## @bst_free
	.cfi_startproc
## %bb.0:
	testq	%rdi, %rdi
	je	LBB2_1
## %bb.2:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%rbx
	pushq	%rax
	.cfi_offset %rbx, -24
	movq	%rdi, %rbx
	movq	40(%rdi), %rdi
	callq	_bst_free
	movq	48(%rbx), %rdi
	callq	_bst_free
	movq	%rbx, %rdi
	addq	$8, %rsp
	popq	%rbx
	popq	%rbp
	jmp	_free                           ## TAILCALL
LBB2_1:
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_bst_height                     ## -- Begin function bst_height
	.p2align	4, 0x90
_bst_height:                            ## @bst_height
	.cfi_startproc
## %bb.0:
	testq	%rdi, %rdi
	je	LBB3_1
## %bb.3:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r14
	pushq	%rbx
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	movq	%rdi, %rbx
	movq	40(%rdi), %rdi
	callq	_bst_height
	movl	%eax, %r14d
	movq	48(%rbx), %rdi
	callq	_bst_height
	cmpl	%eax, %r14d
	cmovgl	%r14d, %eax
	incl	%eax
	popq	%rbx
	popq	%r14
	popq	%rbp
	retq
LBB3_1:
	xorl	%eax, %eax
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
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	pushq	%rax
	.cfi_offset %rbx, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	testq	%rdi, %rdi
	je	LBB4_3
## %bb.1:
	movq	%rdx, %rbx
	movq	%rsi, %r14
	movq	%rdi, %r15
	.p2align	4, 0x90
LBB4_2:                                 ## =>This Inner Loop Header: Depth=1
	movq	40(%r15), %rdi
	movq	%r14, %rsi
	movq	%rbx, %rdx
	callq	_bst_inorder
	movslq	(%rbx), %rax
	leal	1(%rax), %ecx
	movl	%ecx, (%rbx)
	leaq	(%rax,%rax,4), %rax
	movq	32(%r15), %rcx
	movq	%rcx, 32(%r14,%rax,8)
	movups	(%r15), %xmm0
	movups	16(%r15), %xmm1
	movups	%xmm1, 16(%r14,%rax,8)
	movups	%xmm0, (%r14,%rax,8)
	movq	48(%r15), %r15
	testq	%r15, %r15
	jne	LBB4_2
LBB4_3:
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
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
	pushq	%r14
	pushq	%rbx
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	testq	%rdi, %rdi
	je	LBB5_1
## %bb.2:
	movq	%rdi, %r14
	xorl	%ebx, %ebx
	jmp	LBB5_3
	.p2align	4, 0x90
LBB5_6:                                 ##   in Loop: Header=BB5_3 Depth=1
	callq	_bst_count_leaves
	movq	48(%r14), %r14
	addl	%eax, %ebx
	testq	%r14, %r14
	je	LBB5_7
LBB5_3:                                 ## =>This Inner Loop Header: Depth=1
	movq	40(%r14), %rdi
	testq	%rdi, %rdi
	jne	LBB5_6
## %bb.4:                               ##   in Loop: Header=BB5_3 Depth=1
	cmpq	$0, 48(%r14)
	jne	LBB5_6
## %bb.5:
	movl	$1, %eax
	jmp	LBB5_8
LBB5_7:
	xorl	%eax, %eax
LBB5_8:
	addl	%eax, %ebx
	jmp	LBB5_9
LBB5_1:
	xorl	%ebx, %ebx
LBB5_9:
	movl	%ebx, %eax
	popq	%rbx
	popq	%r14
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__literal16,16byte_literals
	.p2align	4, 0x0                          ## -- Begin function bst_stats
LCPI6_0:
	.long	0x4e6e6b28                      ## float 1.0E+9
	.long	0xce6e6b28                      ## float -1.0E+9
	.space	4
	.space	4
LCPI6_1:
	.space	4
	.long	0xce6e6b28                      ## float -1.0E+9
	.space	4
	.space	4
	.section	__TEXT,__literal4,4byte_literals
	.p2align	2, 0x0
LCPI6_2:
	.long	0xce6e6b28                      ## float -1.0E+9
	.section	__TEXT,__text,regular,pure_instructions
	.globl	_bst_stats
	.p2align	4, 0x90
_bst_stats:                             ## @bst_stats
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r14
	pushq	%rbx
	subq	$32, %rsp
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	testq	%rdi, %rdi
	je	LBB6_1
## %bb.2:
	movq	%rdi, %r14
	movq	40(%rdi), %rdi
	callq	_bst_stats
	movq	%rax, %rbx
	movaps	%xmm0, -48(%rbp)                ## 16-byte Spill
	shrq	$32, %rax
	movl	%eax, -20(%rbp)                 ## 4-byte Spill
	movq	48(%r14), %rdi
	callq	_bst_stats
	movaps	-48(%rbp), %xmm4                ## 16-byte Reload
	movq	%rax, %rcx
	shrq	$32, %rcx
	movd	%ecx, %xmm2
	movss	36(%r14), %xmm1                 ## xmm1 = mem[0],zero,zero,zero
	movss	-20(%rbp), %xmm3                ## 4-byte Reload
                                        ## xmm3 = mem[0],zero,zero,zero
	addss	%xmm1, %xmm3
	addss	%xmm2, %xmm3
	movaps	%xmm3, %xmm2
	ucomiss	%xmm4, %xmm1
	ja	LBB6_3
## %bb.4:
	movaps	LCPI6_1(%rip), %xmm3            ## xmm3 = <u,-1.0E+9,u,u>
	blendps	$1, %xmm1, %xmm3                ## xmm3 = xmm1[0],xmm3[1,2,3]
	jmp	LBB6_5
LBB6_1:
	movaps	LCPI6_0(%rip), %xmm0            ## xmm0 = <1.0E+9,-1.0E+9,u,u>
	xorl	%eax, %eax
	jmp	LBB6_9
LBB6_3:
	movaps	%xmm4, %xmm3
	insertps	$16, LCPI6_2(%rip), %xmm3       ## xmm3 = xmm3[0],mem[0],xmm3[2,3]
LBB6_5:
	addl	%ebx, %eax
	incl	%eax
	movd	%xmm2, %ecx
	movaps	%xmm0, %xmm2
	minps	%xmm3, %xmm2
	movshdup	%xmm4, %xmm3                    ## xmm3 = xmm4[1,1,3,3]
	ucomiss	%xmm1, %xmm3
	ja	LBB6_6
## %bb.7:
	insertps	$16, %xmm1, %xmm2               ## xmm2 = xmm2[0],xmm1[0],xmm2[2,3]
	jmp	LBB6_8
LBB6_6:
	blendps	$2, %xmm4, %xmm2                ## xmm2 = xmm2[0],xmm4[1],xmm2[2,3]
LBB6_8:
	maxps	%xmm2, %xmm0
	blendps	$13, %xmm2, %xmm0               ## xmm0 = xmm2[0],xmm0[1],xmm2[2,3]
	shlq	$32, %rcx
	orq	%rcx, %rax
LBB6_9:
	addq	$32, %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
.subsections_via_symbols
