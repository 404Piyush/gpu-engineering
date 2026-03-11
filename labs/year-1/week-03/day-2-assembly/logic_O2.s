	.file	"logic.c"
	.text
	.section	.text.startup,"x"
	.p2align 4
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	subq	$40, %rsp
	.seh_stackalloc	40
	.seh_endprologue
	call	__main
	xorl	%eax, %eax
	xorl	%edx, %edx
	.p2align 4
	.p2align 3
.L5:
	testb	$1, %al
	jne	.L2
.L7:
	addl	%eax, %edx
	addl	$1, %eax
	testb	$1, %al
	je	.L7
.L2:
	addl	$1, %eax
	subl	$1, %edx
	cmpl	$10, %eax
	jne	.L5
	movl	%edx, %eax
	addq	$40, %rsp
	ret
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev11, Built by MSYS2 project) 15.2.0"
