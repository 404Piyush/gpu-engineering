	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 15, 0
	.file	1 "/Users/piyushutkar/Desktop/gpu-engineering/labs/year-1/week-04/mem-bug" "overflow_no_canary.c"
	.globl	_victim                         ## -- Begin function victim
	.p2align	4, 0x90
_victim:                                ## @victim
Lfunc_begin0:
	.loc	1 12 0                          ## overflow_no_canary.c:12:0
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
Ltmp0:
	.loc	1 14 12 prologue_end            ## overflow_no_canary.c:14:12
	leaq	-16(%rbp), %rdi
	.loc	1 14 17 is_stmt 0               ## overflow_no_canary.c:14:17
	movq	-8(%rbp), %rsi
	.loc	1 14 5                          ## overflow_no_canary.c:14:5
	callq	_strcpy
	.loc	1 15 12 is_stmt 1               ## overflow_no_canary.c:15:12
	movsbl	-16(%rbp), %eax
	.loc	1 15 5 is_stmt 0                ## overflow_no_canary.c:15:5
	addq	$16, %rsp
	popq	%rbp
	retq
Ltmp1:
Lfunc_end0:
	.cfi_endproc
                                        ## -- End function
	.globl	_main                           ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
Lfunc_begin1:
	.loc	1 18 0 is_stmt 1                ## overflow_no_canary.c:18:0
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movl	$0, -4(%rbp)
	movl	%edi, -8(%rbp)
	movq	%rsi, -16(%rbp)
Ltmp2:
	.loc	1 19 14 prologue_end            ## overflow_no_canary.c:19:14
	cmpl	$2, -8(%rbp)
Ltmp3:
	.loc	1 19 9 is_stmt 0                ## overflow_no_canary.c:19:9
	jge	LBB1_2
## %bb.1:
Ltmp4:
	.loc	1 19 19                         ## overflow_no_canary.c:19:19
	movl	$1, -4(%rbp)
	jmp	LBB1_3
Ltmp5:
LBB1_2:
	.loc	1 20 20 is_stmt 1               ## overflow_no_canary.c:20:20
	movq	-16(%rbp), %rax
	movq	8(%rax), %rdi
	.loc	1 20 13 is_stmt 0               ## overflow_no_canary.c:20:13
	callq	_victim
	.loc	1 20 9                          ## overflow_no_canary.c:20:9
	movl	%eax, -20(%rbp)
	.loc	1 21 37 is_stmt 1               ## overflow_no_canary.c:21:37
	movl	-20(%rbp), %esi
	.loc	1 21 5 is_stmt 0                ## overflow_no_canary.c:21:5
	leaq	L_.str(%rip), %rdi
	movb	$0, %al
	callq	_printf
	.loc	1 22 5 is_stmt 1                ## overflow_no_canary.c:22:5
	movl	$0, -4(%rbp)
LBB1_3:
	.loc	1 23 1                          ## overflow_no_canary.c:23:1
	movl	-4(%rbp), %eax
	addq	$32, %rsp
	popq	%rbp
	retq
Ltmp6:
Lfunc_end1:
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"first byte = 0x%02x\n"

	.section	__DWARF,__debug_abbrev,regular,debug
Lsection_abbrev:
	.byte	1                               ## Abbreviation Code
	.byte	17                              ## DW_TAG_compile_unit
	.byte	1                               ## DW_CHILDREN_yes
	.byte	37                              ## DW_AT_producer
	.byte	14                              ## DW_FORM_strp
	.byte	19                              ## DW_AT_language
	.byte	5                               ## DW_FORM_data2
	.byte	3                               ## DW_AT_name
	.byte	14                              ## DW_FORM_strp
	.ascii	"\202|"                         ## DW_AT_LLVM_sysroot
	.byte	14                              ## DW_FORM_strp
	.ascii	"\357\177"                      ## DW_AT_APPLE_sdk
	.byte	14                              ## DW_FORM_strp
	.byte	16                              ## DW_AT_stmt_list
	.byte	23                              ## DW_FORM_sec_offset
	.byte	27                              ## DW_AT_comp_dir
	.byte	14                              ## DW_FORM_strp
	.byte	17                              ## DW_AT_low_pc
	.byte	1                               ## DW_FORM_addr
	.byte	18                              ## DW_AT_high_pc
	.byte	6                               ## DW_FORM_data4
	.byte	0                               ## EOM(1)
	.byte	0                               ## EOM(2)
	.byte	2                               ## Abbreviation Code
	.byte	52                              ## DW_TAG_variable
	.byte	0                               ## DW_CHILDREN_no
	.byte	73                              ## DW_AT_type
	.byte	19                              ## DW_FORM_ref4
	.byte	58                              ## DW_AT_decl_file
	.byte	11                              ## DW_FORM_data1
	.byte	59                              ## DW_AT_decl_line
	.byte	11                              ## DW_FORM_data1
	.byte	2                               ## DW_AT_location
	.byte	24                              ## DW_FORM_exprloc
	.byte	0                               ## EOM(1)
	.byte	0                               ## EOM(2)
	.byte	3                               ## Abbreviation Code
	.byte	1                               ## DW_TAG_array_type
	.byte	1                               ## DW_CHILDREN_yes
	.byte	73                              ## DW_AT_type
	.byte	19                              ## DW_FORM_ref4
	.byte	0                               ## EOM(1)
	.byte	0                               ## EOM(2)
	.byte	4                               ## Abbreviation Code
	.byte	33                              ## DW_TAG_subrange_type
	.byte	0                               ## DW_CHILDREN_no
	.byte	73                              ## DW_AT_type
	.byte	19                              ## DW_FORM_ref4
	.byte	55                              ## DW_AT_count
	.byte	11                              ## DW_FORM_data1
	.byte	0                               ## EOM(1)
	.byte	0                               ## EOM(2)
	.byte	5                               ## Abbreviation Code
	.byte	36                              ## DW_TAG_base_type
	.byte	0                               ## DW_CHILDREN_no
	.byte	3                               ## DW_AT_name
	.byte	14                              ## DW_FORM_strp
	.byte	62                              ## DW_AT_encoding
	.byte	11                              ## DW_FORM_data1
	.byte	11                              ## DW_AT_byte_size
	.byte	11                              ## DW_FORM_data1
	.byte	0                               ## EOM(1)
	.byte	0                               ## EOM(2)
	.byte	6                               ## Abbreviation Code
	.byte	36                              ## DW_TAG_base_type
	.byte	0                               ## DW_CHILDREN_no
	.byte	3                               ## DW_AT_name
	.byte	14                              ## DW_FORM_strp
	.byte	11                              ## DW_AT_byte_size
	.byte	11                              ## DW_FORM_data1
	.byte	62                              ## DW_AT_encoding
	.byte	11                              ## DW_FORM_data1
	.byte	0                               ## EOM(1)
	.byte	0                               ## EOM(2)
	.byte	7                               ## Abbreviation Code
	.byte	46                              ## DW_TAG_subprogram
	.byte	1                               ## DW_CHILDREN_yes
	.byte	17                              ## DW_AT_low_pc
	.byte	1                               ## DW_FORM_addr
	.byte	18                              ## DW_AT_high_pc
	.byte	6                               ## DW_FORM_data4
	.byte	64                              ## DW_AT_frame_base
	.byte	24                              ## DW_FORM_exprloc
	.byte	3                               ## DW_AT_name
	.byte	14                              ## DW_FORM_strp
	.byte	58                              ## DW_AT_decl_file
	.byte	11                              ## DW_FORM_data1
	.byte	59                              ## DW_AT_decl_line
	.byte	11                              ## DW_FORM_data1
	.byte	39                              ## DW_AT_prototyped
	.byte	25                              ## DW_FORM_flag_present
	.byte	73                              ## DW_AT_type
	.byte	19                              ## DW_FORM_ref4
	.byte	63                              ## DW_AT_external
	.byte	25                              ## DW_FORM_flag_present
	.byte	0                               ## EOM(1)
	.byte	0                               ## EOM(2)
	.byte	8                               ## Abbreviation Code
	.byte	5                               ## DW_TAG_formal_parameter
	.byte	0                               ## DW_CHILDREN_no
	.byte	2                               ## DW_AT_location
	.byte	24                              ## DW_FORM_exprloc
	.byte	3                               ## DW_AT_name
	.byte	14                              ## DW_FORM_strp
	.byte	58                              ## DW_AT_decl_file
	.byte	11                              ## DW_FORM_data1
	.byte	59                              ## DW_AT_decl_line
	.byte	11                              ## DW_FORM_data1
	.byte	73                              ## DW_AT_type
	.byte	19                              ## DW_FORM_ref4
	.byte	0                               ## EOM(1)
	.byte	0                               ## EOM(2)
	.byte	9                               ## Abbreviation Code
	.byte	52                              ## DW_TAG_variable
	.byte	0                               ## DW_CHILDREN_no
	.byte	2                               ## DW_AT_location
	.byte	24                              ## DW_FORM_exprloc
	.byte	3                               ## DW_AT_name
	.byte	14                              ## DW_FORM_strp
	.byte	58                              ## DW_AT_decl_file
	.byte	11                              ## DW_FORM_data1
	.byte	59                              ## DW_AT_decl_line
	.byte	11                              ## DW_FORM_data1
	.byte	73                              ## DW_AT_type
	.byte	19                              ## DW_FORM_ref4
	.byte	0                               ## EOM(1)
	.byte	0                               ## EOM(2)
	.byte	10                              ## Abbreviation Code
	.byte	15                              ## DW_TAG_pointer_type
	.byte	0                               ## DW_CHILDREN_no
	.byte	73                              ## DW_AT_type
	.byte	19                              ## DW_FORM_ref4
	.byte	0                               ## EOM(1)
	.byte	0                               ## EOM(2)
	.byte	11                              ## Abbreviation Code
	.byte	38                              ## DW_TAG_const_type
	.byte	0                               ## DW_CHILDREN_no
	.byte	73                              ## DW_AT_type
	.byte	19                              ## DW_FORM_ref4
	.byte	0                               ## EOM(1)
	.byte	0                               ## EOM(2)
	.byte	0                               ## EOM(3)
	.section	__DWARF,__debug_info,regular,debug
Lsection_info:
Lcu_begin0:
.set Lset0, Ldebug_info_end0-Ldebug_info_start0 ## Length of Unit
	.long	Lset0
Ldebug_info_start0:
	.short	4                               ## DWARF version number
.set Lset1, Lsection_abbrev-Lsection_abbrev ## Offset Into Abbrev. Section
	.long	Lset1
	.byte	8                               ## Address Size (in bytes)
	.byte	1                               ## Abbrev [1] 0xb:0xf4 DW_TAG_compile_unit
	.long	0                               ## DW_AT_producer
	.short	12                              ## DW_AT_language
	.long	46                              ## DW_AT_name
	.long	67                              ## DW_AT_LLVM_sysroot
	.long	123                             ## DW_AT_APPLE_sdk
.set Lset2, Lline_table_start0-Lsection_line ## DW_AT_stmt_list
	.long	Lset2
	.long	138                             ## DW_AT_comp_dir
	.quad	Lfunc_begin0                    ## DW_AT_low_pc
.set Lset3, Lfunc_end1-Lfunc_begin0     ## DW_AT_high_pc
	.long	Lset3
	.byte	2                               ## Abbrev [2] 0x32:0x11 DW_TAG_variable
	.long	67                              ## DW_AT_type
	.byte	1                               ## DW_AT_decl_file
	.byte	21                              ## DW_AT_decl_line
	.byte	9                               ## DW_AT_location
	.byte	3
	.quad	L_.str
	.byte	3                               ## Abbrev [3] 0x43:0xc DW_TAG_array_type
	.long	79                              ## DW_AT_type
	.byte	4                               ## Abbrev [4] 0x48:0x6 DW_TAG_subrange_type
	.long	86                              ## DW_AT_type
	.byte	21                              ## DW_AT_count
	.byte	0                               ## End Of Children Mark
	.byte	5                               ## Abbrev [5] 0x4f:0x7 DW_TAG_base_type
	.long	209                             ## DW_AT_name
	.byte	6                               ## DW_AT_encoding
	.byte	1                               ## DW_AT_byte_size
	.byte	6                               ## Abbrev [6] 0x56:0x7 DW_TAG_base_type
	.long	214                             ## DW_AT_name
	.byte	8                               ## DW_AT_byte_size
	.byte	7                               ## DW_AT_encoding
	.byte	5                               ## Abbrev [5] 0x5d:0x7 DW_TAG_base_type
	.long	235                             ## DW_AT_name
	.byte	5                               ## DW_AT_encoding
	.byte	4                               ## DW_AT_byte_size
	.byte	7                               ## Abbrev [7] 0x64:0x36 DW_TAG_subprogram
	.quad	Lfunc_begin0                    ## DW_AT_low_pc
.set Lset4, Lfunc_end0-Lfunc_begin0     ## DW_AT_high_pc
	.long	Lset4
	.byte	1                               ## DW_AT_frame_base
	.byte	86
	.long	239                             ## DW_AT_name
	.byte	1                               ## DW_AT_decl_file
	.byte	12                              ## DW_AT_decl_line
                                        ## DW_AT_prototyped
	.long	93                              ## DW_AT_type
                                        ## DW_AT_external
	.byte	8                               ## Abbrev [8] 0x7d:0xe DW_TAG_formal_parameter
	.byte	2                               ## DW_AT_location
	.byte	145
	.byte	120
	.long	251                             ## DW_AT_name
	.byte	1                               ## DW_AT_decl_file
	.byte	12                              ## DW_AT_decl_line
	.long	222                             ## DW_AT_type
	.byte	9                               ## Abbrev [9] 0x8b:0xe DW_TAG_variable
	.byte	2                               ## DW_AT_location
	.byte	145
	.byte	112
	.long	254                             ## DW_AT_name
	.byte	1                               ## DW_AT_decl_file
	.byte	13                              ## DW_AT_decl_line
	.long	232                             ## DW_AT_type
	.byte	0                               ## End Of Children Mark
	.byte	7                               ## Abbrev [7] 0x9a:0x44 DW_TAG_subprogram
	.quad	Lfunc_begin1                    ## DW_AT_low_pc
.set Lset5, Lfunc_end1-Lfunc_begin1     ## DW_AT_high_pc
	.long	Lset5
	.byte	1                               ## DW_AT_frame_base
	.byte	86
	.long	246                             ## DW_AT_name
	.byte	1                               ## DW_AT_decl_file
	.byte	18                              ## DW_AT_decl_line
                                        ## DW_AT_prototyped
	.long	93                              ## DW_AT_type
                                        ## DW_AT_external
	.byte	8                               ## Abbrev [8] 0xb3:0xe DW_TAG_formal_parameter
	.byte	2                               ## DW_AT_location
	.byte	145
	.byte	120
	.long	258                             ## DW_AT_name
	.byte	1                               ## DW_AT_decl_file
	.byte	18                              ## DW_AT_decl_line
	.long	93                              ## DW_AT_type
	.byte	8                               ## Abbrev [8] 0xc1:0xe DW_TAG_formal_parameter
	.byte	2                               ## DW_AT_location
	.byte	145
	.byte	112
	.long	263                             ## DW_AT_name
	.byte	1                               ## DW_AT_decl_file
	.byte	18                              ## DW_AT_decl_line
	.long	244                             ## DW_AT_type
	.byte	9                               ## Abbrev [9] 0xcf:0xe DW_TAG_variable
	.byte	2                               ## DW_AT_location
	.byte	145
	.byte	108
	.long	268                             ## DW_AT_name
	.byte	1                               ## DW_AT_decl_file
	.byte	20                              ## DW_AT_decl_line
	.long	93                              ## DW_AT_type
	.byte	0                               ## End Of Children Mark
	.byte	10                              ## Abbrev [10] 0xde:0x5 DW_TAG_pointer_type
	.long	227                             ## DW_AT_type
	.byte	11                              ## Abbrev [11] 0xe3:0x5 DW_TAG_const_type
	.long	79                              ## DW_AT_type
	.byte	3                               ## Abbrev [3] 0xe8:0xc DW_TAG_array_type
	.long	79                              ## DW_AT_type
	.byte	4                               ## Abbrev [4] 0xed:0x6 DW_TAG_subrange_type
	.long	86                              ## DW_AT_type
	.byte	8                               ## DW_AT_count
	.byte	0                               ## End Of Children Mark
	.byte	10                              ## Abbrev [10] 0xf4:0x5 DW_TAG_pointer_type
	.long	249                             ## DW_AT_type
	.byte	10                              ## Abbrev [10] 0xf9:0x5 DW_TAG_pointer_type
	.long	79                              ## DW_AT_type
	.byte	0                               ## End Of Children Mark
Ldebug_info_end0:
	.section	__DWARF,__debug_str,regular,debug
Linfo_string:
	.asciz	"Apple clang version 15.0.0 (clang-1500.3.9.4)" ## string offset=0
	.asciz	"overflow_no_canary.c"          ## string offset=46
	.asciz	"/Library/Developer/CommandLineTools/SDKs/MacOSX15.0.sdk" ## string offset=67
	.asciz	"MacOSX15.0.sdk"                ## string offset=123
	.asciz	"/Users/piyushutkar/Desktop/gpu-engineering/labs/year-1/week-04/mem-bug" ## string offset=138
	.asciz	"char"                          ## string offset=209
	.asciz	"__ARRAY_SIZE_TYPE__"           ## string offset=214
	.byte	0                               ## string offset=234
	.asciz	"int"                           ## string offset=235
	.asciz	"victim"                        ## string offset=239
	.asciz	"main"                          ## string offset=246
	.asciz	"in"                            ## string offset=251
	.asciz	"buf"                           ## string offset=254
	.asciz	"argc"                          ## string offset=258
	.asciz	"argv"                          ## string offset=263
	.asciz	"r"                             ## string offset=268
	.section	__DWARF,__apple_names,regular,debug
Lnames_begin:
	.long	1212240712                      ## Header Magic
	.short	1                               ## Header Version
	.short	0                               ## Header Hash Function
	.long	3                               ## Header Bucket Count
	.long	3                               ## Header Hash Count
	.long	12                              ## Header Data Length
	.long	0                               ## HeaderData Die Offset Base
	.long	1                               ## HeaderData Atom Count
	.short	1                               ## DW_ATOM_die_offset
	.short	6                               ## DW_FORM_data4
	.long	-1                              ## Bucket 0
	.long	0                               ## Bucket 1
	.long	1                               ## Bucket 2
	.long	2090499946                      ## Hash in Bucket 1
	.long	5381                            ## Hash in Bucket 2
	.long	583274705                       ## Hash in Bucket 2
.set Lset6, LNames1-Lnames_begin        ## Offset in Bucket 1
	.long	Lset6
.set Lset7, LNames2-Lnames_begin        ## Offset in Bucket 2
	.long	Lset7
.set Lset8, LNames0-Lnames_begin        ## Offset in Bucket 2
	.long	Lset8
LNames1:
	.long	246                             ## main
	.long	1                               ## Num DIEs
	.long	154
	.long	0
LNames2:
	.long	234                             ## 
	.long	1                               ## Num DIEs
	.long	50
	.long	0
LNames0:
	.long	239                             ## victim
	.long	1                               ## Num DIEs
	.long	100
	.long	0
	.section	__DWARF,__apple_objc,regular,debug
Lobjc_begin:
	.long	1212240712                      ## Header Magic
	.short	1                               ## Header Version
	.short	0                               ## Header Hash Function
	.long	1                               ## Header Bucket Count
	.long	0                               ## Header Hash Count
	.long	12                              ## Header Data Length
	.long	0                               ## HeaderData Die Offset Base
	.long	1                               ## HeaderData Atom Count
	.short	1                               ## DW_ATOM_die_offset
	.short	6                               ## DW_FORM_data4
	.long	-1                              ## Bucket 0
	.section	__DWARF,__apple_namespac,regular,debug
Lnamespac_begin:
	.long	1212240712                      ## Header Magic
	.short	1                               ## Header Version
	.short	0                               ## Header Hash Function
	.long	1                               ## Header Bucket Count
	.long	0                               ## Header Hash Count
	.long	12                              ## Header Data Length
	.long	0                               ## HeaderData Die Offset Base
	.long	1                               ## HeaderData Atom Count
	.short	1                               ## DW_ATOM_die_offset
	.short	6                               ## DW_FORM_data4
	.long	-1                              ## Bucket 0
	.section	__DWARF,__apple_types,regular,debug
Ltypes_begin:
	.long	1212240712                      ## Header Magic
	.short	1                               ## Header Version
	.short	0                               ## Header Hash Function
	.long	3                               ## Header Bucket Count
	.long	3                               ## Header Hash Count
	.long	20                              ## Header Data Length
	.long	0                               ## HeaderData Die Offset Base
	.long	3                               ## HeaderData Atom Count
	.short	1                               ## DW_ATOM_die_offset
	.short	6                               ## DW_FORM_data4
	.short	3                               ## DW_ATOM_die_tag
	.short	5                               ## DW_FORM_data2
	.short	4                               ## DW_ATOM_type_flags
	.short	11                              ## DW_FORM_data1
	.long	-1                              ## Bucket 0
	.long	-1                              ## Bucket 1
	.long	0                               ## Bucket 2
	.long	193495088                       ## Hash in Bucket 2
	.long	2090147939                      ## Hash in Bucket 2
	.long	-594775205                      ## Hash in Bucket 2
.set Lset9, Ltypes0-Ltypes_begin        ## Offset in Bucket 2
	.long	Lset9
.set Lset10, Ltypes1-Ltypes_begin       ## Offset in Bucket 2
	.long	Lset10
.set Lset11, Ltypes2-Ltypes_begin       ## Offset in Bucket 2
	.long	Lset11
Ltypes0:
	.long	235                             ## int
	.long	1                               ## Num DIEs
	.long	93
	.short	36
	.byte	0
	.long	0
Ltypes1:
	.long	209                             ## char
	.long	1                               ## Num DIEs
	.long	79
	.short	36
	.byte	0
	.long	0
Ltypes2:
	.long	214                             ## __ARRAY_SIZE_TYPE__
	.long	1                               ## Num DIEs
	.long	86
	.short	36
	.byte	0
	.long	0
.subsections_via_symbols
	.section	__DWARF,__debug_line,regular,debug
Lsection_line:
Lline_table_start0:
