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
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	subq	$704, %rsp                      ## imm = 0x2C0
	.cfi_offset %rbx, -48
	.cfi_offset %r12, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	_dataset+32(%rip), %rax
	movq	%rax, 32(%rsp)
	movaps	_dataset+16(%rip), %xmm0
	movups	%xmm0, 16(%rsp)
	movaps	_dataset(%rip), %xmm0
	movups	%xmm0, (%rsp)
	xorl	%edi, %edi
	callq	_bst_insert
	movq	_dataset+72(%rip), %rcx
	movq	%rcx, 32(%rsp)
	movups	_dataset+56(%rip), %xmm0
	movups	%xmm0, 16(%rsp)
	movups	_dataset+40(%rip), %xmm0
	movups	%xmm0, (%rsp)
	movq	%rax, %rdi
	callq	_bst_insert
	movq	_dataset+112(%rip), %rcx
	movq	%rcx, 32(%rsp)
	movaps	_dataset+96(%rip), %xmm0
	movups	%xmm0, 16(%rsp)
	movaps	_dataset+80(%rip), %xmm0
	movups	%xmm0, (%rsp)
	movq	%rax, %rdi
	callq	_bst_insert
	movq	_dataset+152(%rip), %rcx
	movq	%rcx, 32(%rsp)
	movups	_dataset+136(%rip), %xmm0
	movups	%xmm0, 16(%rsp)
	movups	_dataset+120(%rip), %xmm0
	movups	%xmm0, (%rsp)
	movq	%rax, %rdi
	callq	_bst_insert
	movq	_dataset+192(%rip), %rcx
	movq	%rcx, 32(%rsp)
	movaps	_dataset+176(%rip), %xmm0
	movups	%xmm0, 16(%rsp)
	movaps	_dataset+160(%rip), %xmm0
	movups	%xmm0, (%rsp)
	movq	%rax, %rdi
	callq	_bst_insert
	movq	_dataset+232(%rip), %rcx
	movq	%rcx, 32(%rsp)
	movups	_dataset+216(%rip), %xmm0
	movups	%xmm0, 16(%rsp)
	movups	_dataset+200(%rip), %xmm0
	movups	%xmm0, (%rsp)
	movq	%rax, %rdi
	callq	_bst_insert
	movq	_dataset+272(%rip), %rcx
	movq	%rcx, 32(%rsp)
	movaps	_dataset+256(%rip), %xmm0
	movups	%xmm0, 16(%rsp)
	movaps	_dataset+240(%rip), %xmm0
	movups	%xmm0, (%rsp)
	movq	%rax, %rdi
	callq	_bst_insert
	movq	_dataset+312(%rip), %rcx
	movq	%rcx, 32(%rsp)
	movups	_dataset+296(%rip), %xmm0
	movups	%xmm0, 16(%rsp)
	movups	_dataset+280(%rip), %xmm0
	movups	%xmm0, (%rsp)
	movq	%rax, %rdi
	callq	_bst_insert
	movq	_dataset+352(%rip), %rcx
	movq	%rcx, 32(%rsp)
	movaps	_dataset+336(%rip), %xmm0
	movups	%xmm0, 16(%rsp)
	movaps	_dataset+320(%rip), %xmm0
	movups	%xmm0, (%rsp)
	movq	%rax, %rdi
	callq	_bst_insert
	movq	_dataset+392(%rip), %rcx
	movq	%rcx, 32(%rsp)
	movups	_dataset+376(%rip), %xmm0
	movups	%xmm0, 16(%rsp)
	movups	_dataset+360(%rip), %xmm0
	movups	%xmm0, (%rsp)
	movq	%rax, %rdi
	callq	_bst_insert
	movq	%rax, %rbx
	leaq	L_.str(%rip), %rdi
	movl	$10, %esi
	xorl	%eax, %eax
	callq	_printf
	movq	%rbx, %rdi
	callq	_bst_height
	leaq	L_.str.1(%rip), %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	_printf
	movq	%rbx, %rdi
	callq	_bst_count_leaves
	leaq	L_.str.2(%rip), %rdi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	_printf
	movq	%rbx, %rdi
	callq	_bst_stats
	movq	%rax, %rcx
	shrq	$32, %rcx
	movd	%ecx, %xmm1
	cvtsi2ss	%eax, %xmm2
	divss	%xmm2, %xmm1
	cvtss2sd	%xmm1, %xmm3
	xorps	%xmm1, %xmm1
	cvtss2sd	%xmm0, %xmm1
	movshdup	%xmm0, %xmm0                    ## xmm0 = xmm0[1,1,3,3]
	xorps	%xmm2, %xmm2
	cvtss2sd	%xmm0, %xmm2
	leaq	L_.str.3(%rip), %rdi
	movl	%eax, %esi
	movaps	%xmm3, %xmm0
	movb	$3, %al
	callq	_printf
	movl	$0, -692(%rbp)
	leaq	-688(%rbp), %r14
	leaq	-692(%rbp), %rdx
	movq	%rbx, %rdi
	movq	%r14, %rsi
	callq	_bst_inorder
	leaq	L_str(%rip), %rdi
	callq	_puts
	cmpl	$0, -692(%rbp)
	jle	LBB0_3
## %bb.1:
	xorl	%r12d, %r12d
	leaq	L_.str.8(%rip), %r15
	.p2align	4, 0x90
LBB0_2:                                 ## =>This Inner Loop Header: Depth=1
	movl	(%r14), %esi
	leaq	4(%r14), %rdx
	movss	36(%r14), %xmm0                 ## xmm0 = mem[0],zero,zero,zero
	cvtss2sd	%xmm0, %xmm0
	movq	%r15, %rdi
	movb	$1, %al
	callq	_printf
	incq	%r12
	movslq	-692(%rbp), %rax
	addq	$40, %r14
	cmpq	%rax, %r12
	jl	LBB0_2
LBB0_3:
	leaq	L_str.9(%rip), %rdi
	callq	_puts
	movq	%rbx, %rdi
	movl	$1, %esi
	callq	_bst_find
	testq	%rax, %rax
	je	LBB0_5
## %bb.4:
	movq	%rax, %rdx
	addq	$4, %rdx
	movss	36(%rax), %xmm0                 ## xmm0 = mem[0],zero,zero,zero
	cvtss2sd	%xmm0, %xmm0
	leaq	L_.str.6(%rip), %rdi
	movl	$1, %esi
	movb	$1, %al
	callq	_printf
	jmp	LBB0_6
LBB0_5:
	leaq	L_.str.7(%rip), %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	_printf
LBB0_6:
	movq	%rbx, %rdi
	movl	$6, %esi
	callq	_bst_find
	testq	%rax, %rax
	je	LBB0_8
## %bb.7:
	movq	%rax, %rdx
	addq	$4, %rdx
	movss	36(%rax), %xmm0                 ## xmm0 = mem[0],zero,zero,zero
	cvtss2sd	%xmm0, %xmm0
	leaq	L_.str.6(%rip), %rdi
	movl	$6, %esi
	movb	$1, %al
	callq	_printf
	jmp	LBB0_9
LBB0_8:
	leaq	L_.str.7(%rip), %rdi
	movl	$6, %esi
	xorl	%eax, %eax
	callq	_printf
LBB0_9:
	movq	%rbx, %rdi
	movl	$99, %esi
	callq	_bst_find
	testq	%rax, %rax
	je	LBB0_11
## %bb.10:
	movq	%rax, %rdx
	addq	$4, %rdx
	movss	36(%rax), %xmm0                 ## xmm0 = mem[0],zero,zero,zero
	cvtss2sd	%xmm0, %xmm0
	leaq	L_.str.6(%rip), %rdi
	movl	$99, %esi
	movb	$1, %al
	callq	_printf
	jmp	LBB0_12
LBB0_11:
	leaq	L_.str.7(%rip), %rdi
	movl	$99, %esi
	xorl	%eax, %eax
	callq	_printf
LBB0_12:
	movq	%rbx, %rdi
	movl	$13, %esi
	callq	_bst_find
	testq	%rax, %rax
	je	LBB0_14
## %bb.13:
	movq	%rax, %rdx
	addq	$4, %rdx
	movss	36(%rax), %xmm0                 ## xmm0 = mem[0],zero,zero,zero
	cvtss2sd	%xmm0, %xmm0
	leaq	L_.str.6(%rip), %rdi
	movl	$13, %esi
	movb	$1, %al
	callq	_printf
	jmp	LBB0_15
LBB0_14:
	leaq	L_.str.7(%rip), %rdi
	movl	$13, %esi
	xorl	%eax, %eax
	callq	_printf
LBB0_15:
	movq	%rbx, %rdi
	callq	_bst_free
	movq	___stack_chk_guard@GOTPCREL(%rip), %rax
	movq	(%rax), %rax
	cmpq	-40(%rbp), %rax
	jne	LBB0_17
## %bb.16:
	xorl	%eax, %eax
	addq	$704, %rsp                      ## imm = 0x2C0
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
LBB0_17:
	callq	___stack_chk_fail
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

L_.str.6:                               ## @.str.6
	.asciz	"  id=%d FOUND -> %s (gpa %.2f)\n"

L_.str.7:                               ## @.str.7
	.asciz	"  id=%d NOT FOUND\n"

L_.str.8:                               ## @.str.8
	.asciz	"  id=%-3d name=%-8s gpa=%.2f\n"

L_str:                                  ## @str
	.asciz	"In-order (sorted by id):"

L_str.9:                                ## @str.9
	.asciz	"Lookups:"

.subsections_via_symbols
