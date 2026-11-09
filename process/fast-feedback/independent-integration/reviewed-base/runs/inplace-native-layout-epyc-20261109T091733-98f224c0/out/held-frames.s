# source blake3_servil-9e4037ac4510b2d3.s
_RINvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohortKj1_EB4_:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$1280, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rdi, %r12
	movq	(%rdx), %rdi
	cmpq	%rsi, %rdi
	jae	.LBB26_109
	leaq	(%rdi,%rdi,8), %r15
	shlq	$11, %r15
	movaps	128(%r12,%r15), %xmm0
	movaps	144(%r12,%r15), %xmm1
	movaps	%xmm1, 304(%rsp)
	movaps	%xmm0, 288(%rsp)
	movzbl	106(%r12,%r15), %r14d
	movzbl	107(%r12,%r15), %ebx
	leaq	384(%rsp), %rdi
	movl	$512, %edx
	xorl	%esi, %esi
	callq	*memset@GOTPCREL(%rip)
	movl	$1, 320(%rsp)
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 960(%rsp)
	movaps	%xmm0, 976(%rsp)
	movaps	%xmm0, 992(%rsp)
	movaps	%xmm0, 1008(%rsp)
	movaps	%xmm0, 1024(%rsp)
	movaps	%xmm0, 1040(%rsp)
	movaps	%xmm0, 1056(%rsp)
	movaps	%xmm0, 1072(%rsp)
	movaps	%xmm0, 1088(%rsp)
	movaps	%xmm0, 1104(%rsp)
	movaps	%xmm0, 1120(%rsp)
	movaps	%xmm0, 1136(%rsp)
	movaps	%xmm0, 1152(%rsp)
	movaps	%xmm0, 1168(%rsp)
	movaps	%xmm0, 1184(%rsp)
	movaps	%xmm0, 1200(%rsp)
	movl	$1, 896(%rsp)
	movl	$0, 144(%rsp)
	cmpq	$16384, 18368(%r12,%r15)
	jne	.LBB26_110
	cmpq	$0, 1936(%r12,%r15)
	jne	.LBB26_110
	addq	%r15, %r12
	movabsq	$18014398509481983, %rdx
	leaq	17344(%r12), %rax
	leaq	1984(%r12), %rcx
	movq	%rcx, 152(%rsp)
	leaq	3008(%r12), %rcx
	movq	%rcx, 160(%rsp)
	leaq	4032(%r12), %rcx
	movq	%rcx, 168(%rsp)
	leaq	5056(%r12), %rcx
	movq	%rcx, 176(%rsp)
	leaq	6080(%r12), %rcx
	movq	%rcx, 184(%rsp)
	leaq	7104(%r12), %rcx
	movq	%rcx, 192(%rsp)
	leaq	8128(%r12), %rcx
	movq	%rcx, 200(%rsp)
	leaq	9152(%r12), %rcx
	movq	%rcx, 208(%rsp)
	leaq	10176(%r12), %rcx
	movq	%rcx, 216(%rsp)
	leaq	11200(%r12), %rcx
	movq	%rcx, 224(%rsp)
	leaq	12224(%r12), %rcx
	movq	%rcx, 232(%rsp)
	leaq	13248(%r12), %rcx
	movq	%rcx, 240(%rsp)
	leaq	14272(%r12), %rcx
	movq	%rcx, 248(%rsp)
	leaq	15296(%r12), %rcx
	movq	%rcx, 256(%rsp)
	leaq	16320(%r12), %rcx
	movq	%rcx, 264(%rsp)
	movq	%rax, 272(%rsp)
	movzbl	105(%r12), %eax
	shll	$6, %eax
	movzbl	104(%r12), %r8d
	addl	%eax, %r8d
	leaq	152(%rsp), %rsi
	movl	$1, 144(%rsp)
	shrl	$10, %r8d
	movq	%r12, 280(%rsp)
	addq	96(%r12), %r8
	andq	%rdx, %r8
	leaq	384(%rsp), %r15
	movq	%r15, 16(%rsp)
	movzbl	%r14b, %r14d
	movl	%r14d, (%rsp)
	movq	$512, 24(%rsp)
	movl	$2, 8(%rsp)
	movzbl	%bl, %edi
	leaq	288(%rsp), %rcx
	movl	$16, %edx
	movl	%edi, 84(%rsp)
	xorl	%r9d, %r9d
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj400_EB8_
	movq	%r15, %rcx
	orb	$4, %r14b
	movl	%r14d, 88(%rsp)
	movl	$0, 144(%rsp)
	movl	$512, %edx
	movl	$64, %r12d
	movq	%r15, %r14
	jmp	.LBB26_5
	.p2align	4
.LBB26_4:
	movq	%r14, 88(%rsp,%r12)
	movq	%rsi, 96(%rsp,%r12)
	movq	%rdi, 104(%rsp,%r12)
	movq	%r8, 112(%rsp,%r12)
	movq	%r10, 120(%rsp,%r12)
	movq	%r15, 128(%rsp,%r12)
	movq	%rbx, 136(%rsp,%r12)
	movq	%r13, 144(%rsp,%r12)
	addq	$64, %r12
	movq	%r9, %r14
	cmpq	$128, %r12
	je	.LBB26_28
.LBB26_5:
	cmpq	$64, %rdx
	jae	.LBB26_7
	movq	%r14, %r9
	movq	%rcx, %r8
	movq	%rcx, %rdi
	movq	%rcx, %rsi
	movq	%rcx, %r14
	jmp	.LBB26_15
	.p2align	4
.LBB26_7:
	leaq	64(%r14), %rsi
	leaq	-64(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_9
	movq	%rsi, %r9
	movq	%rax, %rdx
	movq	%rcx, %r8
	movq	%rcx, %rdi
	movq	%rcx, %rsi
	jmp	.LBB26_15
	.p2align	4
.LBB26_9:
	leaq	128(%r14), %rdi
	leaq	-128(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_11
	movq	%rdi, %r9
	movq	%rax, %rdx
	movq	%rcx, %r8
	movq	%rcx, %rdi
	jmp	.LBB26_15
.LBB26_11:
	leaq	192(%r14), %r8
	leaq	-192(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_13
	movq	%r8, %r9
	movq	%rax, %rdx
	movq	%rcx, %r8
	jmp	.LBB26_15
.LBB26_13:
	leaq	256(%r14), %r10
	leaq	-256(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_21
	movq	%r10, %r9
	movq	%rax, %rdx
	.p2align	4
.LBB26_15:
	movq	%rcx, %r10
.LBB26_16:
	movq	%rcx, %r15
.LBB26_17:
	movq	%rcx, %rbx
	movq	%rcx, %r13
	cmpq	$128, %r12
	jne	.LBB26_4
.LBB26_20:
	movq	%rdi, 120(%rsp)
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.45(%rip), %rdi
	movq	%rdx, 136(%rsp)
	movq	%rsi, 128(%rsp)
	movq	%r8, 112(%rsp)
	movq	%r9, 104(%rsp)
	movq	%r10, 96(%rsp)
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	movq	96(%rsp), %r10
	movq	104(%rsp), %r9
	movq	112(%rsp), %r8
	movq	120(%rsp), %rdi
	movq	128(%rsp), %rsi
	movq	136(%rsp), %rdx
	leaq	384(%rsp), %rcx
	jmp	.LBB26_4
.LBB26_21:
	leaq	320(%r14), %r15
	leaq	-320(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_23
	movq	%r15, %r9
	movq	%rax, %rdx
	jmp	.LBB26_16
.LBB26_23:
	leaq	384(%r14), %rbx
	leaq	-384(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_25
	movq	%rbx, %r9
	movq	%rax, %rdx
	jmp	.LBB26_17
.LBB26_25:
	leaq	448(%r14), %r13
	leaq	-448(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_27
	movq	%r13, %r9
	movq	%rax, %rdx
	movq	%rcx, %r13
	cmpq	$128, %r12
	jne	.LBB26_4
	jmp	.LBB26_20
.LBB26_27:
	leaq	512(%r14), %r9
	addq	$-512, %rdx
	cmpq	$128, %r12
	jne	.LBB26_4
	jmp	.LBB26_20
.LBB26_28:
	movl	$1, 144(%rsp)
	movq	$256, (%rsp)
	movzbl	88(%rsp), %r8d
	leaq	288(%rsp), %rcx
	movl	$8, %edx
	movl	84(%rsp), %edi
	leaq	152(%rsp), %rsi
	movl	%r8d, 136(%rsp)
	leaq	960(%rsp), %rbx
	movq	%rbx, %r9
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj40_EB8_
	movq	%rbx, %rcx
	movl	$0, 144(%rsp)
	movl	$256, %edx
	movl	$64, %r12d
	movq	%rbx, %r14
	jmp	.LBB26_30
	.p2align	4
.LBB26_29:
	movq	%r14, 88(%rsp,%r12)
	movq	%rsi, 96(%rsp,%r12)
	movq	%rdi, 104(%rsp,%r12)
	movq	%r8, 112(%rsp,%r12)
	movq	%r10, 120(%rsp,%r12)
	movq	%r15, 128(%rsp,%r12)
	movq	%rbx, 136(%rsp,%r12)
	movq	%r13, 144(%rsp,%r12)
	addq	$64, %r12
	movq	%r9, %r14
	cmpq	$128, %r12
	je	.LBB26_53
.LBB26_30:
	cmpq	$64, %rdx
	jae	.LBB26_32
	movq	%r14, %r9
	movq	%rcx, %r8
	movq	%rcx, %rdi
	movq	%rcx, %rsi
	movq	%rcx, %r14
	jmp	.LBB26_40
	.p2align	4
.LBB26_32:
	leaq	64(%r14), %rsi
	leaq	-64(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_34
	movq	%rsi, %r9
	movq	%rax, %rdx
	movq	%rcx, %r8
	movq	%rcx, %rdi
	movq	%rcx, %rsi
	jmp	.LBB26_40
	.p2align	4
.LBB26_34:
	leaq	128(%r14), %rdi
	leaq	-128(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_36
	movq	%rdi, %r9
	movq	%rax, %rdx
	movq	%rcx, %r8
	movq	%rcx, %rdi
	jmp	.LBB26_40
.LBB26_36:
	leaq	192(%r14), %r8
	leaq	-192(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_38
	movq	%r8, %r9
	movq	%rax, %rdx
	movq	%rcx, %r8
	jmp	.LBB26_40
.LBB26_38:
	leaq	256(%r14), %r10
	leaq	-256(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_46
	movq	%r10, %r9
	movq	%rax, %rdx
	.p2align	4
.LBB26_40:
	movq	%rcx, %r10
.LBB26_41:
	movq	%rcx, %r15
.LBB26_42:
	movq	%rcx, %rbx
	movq	%rcx, %r13
	cmpq	$128, %r12
	jne	.LBB26_29
.LBB26_45:
	movq	%rdi, 112(%rsp)
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.45(%rip), %rdi
	movq	%rdx, 128(%rsp)
	movq	%rsi, 120(%rsp)
	movq	%r8, 104(%rsp)
	movq	%r9, 96(%rsp)
	movq	%r10, 88(%rsp)
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	movq	88(%rsp), %r10
	movq	96(%rsp), %r9
	movq	104(%rsp), %r8
	movq	112(%rsp), %rdi
	movq	120(%rsp), %rsi
	movq	128(%rsp), %rdx
	leaq	960(%rsp), %rcx
	jmp	.LBB26_29
.LBB26_46:
	leaq	320(%r14), %r15
	leaq	-320(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_48
	movq	%r15, %r9
	movq	%rax, %rdx
	jmp	.LBB26_41
.LBB26_48:
	leaq	384(%r14), %rbx
	leaq	-384(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_50
	movq	%rbx, %r9
	movq	%rax, %rdx
	jmp	.LBB26_42
.LBB26_50:
	leaq	448(%r14), %r13
	leaq	-448(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_52
	movq	%r13, %r9
	movq	%rax, %rdx
	movq	%rcx, %r13
	cmpq	$128, %r12
	jne	.LBB26_29
	jmp	.LBB26_45
.LBB26_52:
	leaq	512(%r14), %r9
	addq	$-512, %rdx
	cmpq	$128, %r12
	jne	.LBB26_29
	jmp	.LBB26_45
.LBB26_53:
	movl	$1, 144(%rsp)
	movq	$128, (%rsp)
	leaq	288(%rsp), %rcx
	movl	$4, %edx
	movl	84(%rsp), %edi
	leaq	152(%rsp), %rsi
	movl	136(%rsp), %r8d
	leaq	384(%rsp), %rbx
	movq	%rbx, %r9
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj40_EB8_
	movq	%rbx, %rcx
	movl	$0, 144(%rsp)
	movl	$128, %edx
	movl	$64, %r12d
	movq	%rbx, %r14
	jmp	.LBB26_55
	.p2align	4
.LBB26_54:
	movq	%r14, 88(%rsp,%r12)
	movq	%rsi, 96(%rsp,%r12)
	movq	%rdi, 104(%rsp,%r12)
	movq	%r8, 112(%rsp,%r12)
	movq	%r10, 120(%rsp,%r12)
	movq	%r15, 128(%rsp,%r12)
	movq	%rbx, 136(%rsp,%r12)
	movq	%r13, 144(%rsp,%r12)
	addq	$64, %r12
	movq	%r9, %r14
	cmpq	$128, %r12
	je	.LBB26_78
.LBB26_55:
	cmpq	$64, %rdx
	jae	.LBB26_57
	movq	%r14, %r9
	movq	%rcx, %r8
	movq	%rcx, %rdi
	movq	%rcx, %rsi
	movq	%rcx, %r14
	jmp	.LBB26_65
	.p2align	4
.LBB26_57:
	leaq	64(%r14), %rsi
	leaq	-64(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_59
	movq	%rsi, %r9
	movq	%rax, %rdx
	movq	%rcx, %r8
	movq	%rcx, %rdi
	movq	%rcx, %rsi
	jmp	.LBB26_65
	.p2align	4
.LBB26_59:
	leaq	128(%r14), %rdi
	leaq	-128(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_61
	movq	%rdi, %r9
	movq	%rax, %rdx
	movq	%rcx, %r8
	movq	%rcx, %rdi
	jmp	.LBB26_65
.LBB26_61:
	leaq	192(%r14), %r8
	leaq	-192(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_63
	movq	%r8, %r9
	movq	%rax, %rdx
	movq	%rcx, %r8
	jmp	.LBB26_65
.LBB26_63:
	leaq	256(%r14), %r10
	leaq	-256(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_71
	movq	%r10, %r9
	movq	%rax, %rdx
	.p2align	4
.LBB26_65:
	movq	%rcx, %r10
.LBB26_66:
	movq	%rcx, %r15
.LBB26_67:
	movq	%rcx, %rbx
	movq	%rcx, %r13
	cmpq	$128, %r12
	jne	.LBB26_54
.LBB26_70:
	movq	%rdi, 112(%rsp)
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.45(%rip), %rdi
	movq	%rdx, 128(%rsp)
	movq	%rsi, 120(%rsp)
	movq	%r8, 104(%rsp)
	movq	%r9, 96(%rsp)
	movq	%r10, 88(%rsp)
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	movq	88(%rsp), %r10
	movq	96(%rsp), %r9
	movq	104(%rsp), %r8
	movq	112(%rsp), %rdi
	movq	120(%rsp), %rsi
	movq	128(%rsp), %rdx
	leaq	384(%rsp), %rcx
	jmp	.LBB26_54
.LBB26_71:
	leaq	320(%r14), %r15
	leaq	-320(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_73
	movq	%r15, %r9
	movq	%rax, %rdx
	jmp	.LBB26_66
.LBB26_73:
	leaq	384(%r14), %rbx
	leaq	-384(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_75
	movq	%rbx, %r9
	movq	%rax, %rdx
	jmp	.LBB26_67
.LBB26_75:
	leaq	448(%r14), %r13
	leaq	-448(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_77
	movq	%r13, %r9
	movq	%rax, %rdx
	movq	%rcx, %r13
	cmpq	$128, %r12
	jne	.LBB26_54
	jmp	.LBB26_70
.LBB26_77:
	leaq	512(%r14), %r9
	addq	$-512, %rdx
	cmpq	$128, %r12
	jne	.LBB26_54
	jmp	.LBB26_70
.LBB26_78:
	movl	$1, 144(%rsp)
	movq	$64, (%rsp)
	leaq	288(%rsp), %rcx
	movl	$2, %edx
	movl	84(%rsp), %edi
	leaq	152(%rsp), %rsi
	movl	136(%rsp), %r8d
	leaq	960(%rsp), %rbx
	movq	%rbx, %r9
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj40_EB8_
	movq	%rbx, %rcx
	movl	$0, 144(%rsp)
	movl	$64, %edx
	movl	$64, %r12d
	movq	%rbx, %r14
	jmp	.LBB26_80
	.p2align	4
.LBB26_79:
	movq	%r14, 88(%rsp,%r12)
	movq	%rsi, 96(%rsp,%r12)
	movq	%rdi, 104(%rsp,%r12)
	movq	%r8, 112(%rsp,%r12)
	movq	%r10, 120(%rsp,%r12)
	movq	%r15, 128(%rsp,%r12)
	movq	%rbx, 136(%rsp,%r12)
	movq	%r13, 144(%rsp,%r12)
	addq	$64, %r12
	movq	%r9, %r14
	cmpq	$128, %r12
	je	.LBB26_103
.LBB26_80:
	cmpq	$64, %rdx
	jae	.LBB26_82
	movq	%r14, %r9
	movq	%rcx, %r8
	movq	%rcx, %rdi
	movq	%rcx, %rsi
	movq	%rcx, %r14
	jmp	.LBB26_90
	.p2align	4
.LBB26_82:
	leaq	64(%r14), %rsi
	leaq	-64(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_84
	movq	%rsi, %r9
	movq	%rax, %rdx
	movq	%rcx, %r8
	movq	%rcx, %rdi
	movq	%rcx, %rsi
	jmp	.LBB26_90
	.p2align	4
.LBB26_84:
	leaq	128(%r14), %rdi
	leaq	-128(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_86
	movq	%rdi, %r9
	movq	%rax, %rdx
	movq	%rcx, %r8
	movq	%rcx, %rdi
	jmp	.LBB26_90
.LBB26_86:
	leaq	192(%r14), %r8
	leaq	-192(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_88
	movq	%r8, %r9
	movq	%rax, %rdx
	movq	%rcx, %r8
	jmp	.LBB26_90
.LBB26_88:
	leaq	256(%r14), %r10
	leaq	-256(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_96
	movq	%r10, %r9
	movq	%rax, %rdx
	.p2align	4
.LBB26_90:
	movq	%rcx, %r10
.LBB26_91:
	movq	%rcx, %r15
.LBB26_92:
	movq	%rcx, %rbx
	movq	%rcx, %r13
	cmpq	$128, %r12
	jne	.LBB26_79
.LBB26_95:
	movq	%rdi, 112(%rsp)
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.45(%rip), %rdi
	movq	%rdx, 128(%rsp)
	movq	%rsi, 120(%rsp)
	movq	%r8, 104(%rsp)
	movq	%r9, 96(%rsp)
	movq	%r10, 88(%rsp)
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	movq	88(%rsp), %r10
	movq	96(%rsp), %r9
	movq	104(%rsp), %r8
	movq	112(%rsp), %rdi
	movq	120(%rsp), %rsi
	movq	128(%rsp), %rdx
	leaq	960(%rsp), %rcx
	jmp	.LBB26_79
.LBB26_96:
	leaq	320(%r14), %r15
	leaq	-320(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_98
	movq	%r15, %r9
	movq	%rax, %rdx
	jmp	.LBB26_91
.LBB26_98:
	leaq	384(%r14), %rbx
	leaq	-384(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_100
	movq	%rbx, %r9
	movq	%rax, %rdx
	jmp	.LBB26_92
.LBB26_100:
	leaq	448(%r14), %r13
	leaq	-448(%rdx), %rax
	cmpq	$64, %rax
	jae	.LBB26_102
	movq	%r13, %r9
	movq	%rax, %rdx
	movq	%rcx, %r13
	cmpq	$128, %r12
	jne	.LBB26_79
	jmp	.LBB26_95
.LBB26_102:
	leaq	512(%r14), %r9
	addq	$-512, %rdx
	cmpq	$128, %r12
	jne	.LBB26_79
	jmp	.LBB26_95
.LBB26_103:
	movl	$1, 144(%rsp)
	movq	$32, (%rsp)
	leaq	288(%rsp), %rcx
	movl	$1, %edx
	movl	84(%rsp), %edi
	leaq	152(%rsp), %rsi
	movl	136(%rsp), %r8d
	leaq	384(%rsp), %r9
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj40_EB8_
	movq	280(%rsp), %rdi
	cmpq	$16384, 18368(%rdi)
	jne	.LBB26_111
	cmpq	$0, 1936(%rdi)
	jne	.LBB26_111
	movzbl	105(%rdi), %eax
	shll	$6, %eax
	movzbl	104(%rdi), %ecx
	addl	%eax, %ecx
	shrl	$10, %ecx
	addq	96(%rdi), %rcx
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 192(%rsp)
	movaps	%xmm0, 176(%rsp)
	movaps	%xmm0, 160(%rsp)
	movaps	%xmm0, 144(%rsp)
	movabsq	$18014398509481983, %rax
	testq	%rax, %rcx
	je	.LBB26_107
	leaq	384(%rsp), %rax
	movaps	(%rax), %xmm0
	movaps	16(%rax), %xmm1
	jmp	.LBB26_108
.LBB26_107:
	leaq	960(%rsp), %rax
	movaps	(%rax), %xmm0
	movaps	16(%rax), %xmm1
	movaps	32(%rax), %xmm2
	movaps	48(%rax), %xmm3
	movaps	%xmm3, 192(%rsp)
	movaps	%xmm2, 176(%rsp)
.LBB26_108:
	movaps	%xmm1, 160(%rsp)
	movaps	%xmm0, 144(%rsp)
	movq	$0, 18368(%rdi)
	leaq	144(%rsp), %rsi
	callq	_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore10push_group
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.LBB26_109:
	.cfi_def_cfa %rbp, 16
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.38(%rip), %rdx
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB26_110:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.113(%rip), %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.114(%rip), %rdx
	movl	$12, %esi
	callq	*_RNvNtCskADBYZwJmSU_4core6option13expect_failed@GOTPCREL(%rip)
.LBB26_111:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.42(%rip), %rdi
	callq	*_RNvNtCskADBYZwJmSU_4core6option13unwrap_failed@GOTPCREL(%rip)
.Lfunc_end26:
	.size	_RINvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohortKj1_EB4_, .Lfunc_end26-_RINvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohortKj1_EB4_

# source blake3_servil-9e4037ac4510b2d3.s
_RINvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohortKj80_EB4_:
.Lfunc_begin1:
	.cfi_startproc
	.cfi_personality 155, DW.ref.rust_eh_personality
	.cfi_lsda 27, .Lexception1
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$64, %rsp
	movq	$0, (%rsp)
	movq	%rsp, %r11
	subq	$114688, %r11
.LBB27_1:
	subq	$4096, %rsp
	movq	$0, (%rsp)
	cmpq	%r11, %rsp
	jne	.LBB27_1
	subq	$1472, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rcx, %r14
	movq	%rdi, %rcx
	movq	(%rdx), %rdi
	movq	%rsi, 56(%rsp)
	cmpq	%rsi, %rdi
	jae	.LBB27_84
	movq	%rdx, 104(%rsp)
	leaq	(%rdi,%rdi,8), %rax
	shlq	$11, %rax
	movaps	128(%rcx,%rax), %xmm0
	movaps	144(%rcx,%rax), %xmm1
	movaps	%xmm1, 272(%rsp)
	movaps	%xmm0, 256(%rsp)
	movzbl	106(%rcx,%rax), %edx
	movb	%dl, 39(%rsp)
	movq	%rcx, 88(%rsp)
	movzbl	107(%rcx,%rax), %eax
	movb	%al, 55(%rsp)
	movl	$0, 17728(%rsp)
	movl	$0, 83328(%rsp)
	movq	%r14, 80(%rsp)
	shlq	$9, %r14
	xorl	%r15d, %r15d
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.162(%rip), %rbx
	movq	memset@GOTPCREL(%rip), %r12
	jmp	.LBB27_5
	.p2align	4
.LBB27_4:
	leaq	(%rsp,%r15), %rdi
	addq	$17792, %rdi
	.cfi_escape 0x2e, 0x00
	movl	$512, %edx
	xorl	%esi, %esi
	callq	*%r12
	addq	$512, %r15
	cmpq	%r15, %r14
	je	.LBB27_7
.LBB27_5:
	cmpq	$65536, %r15
	jne	.LBB27_4
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	jmp	.LBB27_4
.LBB27_7:
	movq	80(%rsp), %r13
	movl	%r13d, 17728(%rsp)
	movl	83328(%rsp), %edx
	movq	%rdx, %rax
	shlq	$8, %rax
	movl	$32768, %r15d
	subq	%rax, %r15
	leaq	17728(%rsp), %rcx
	leaq	(%rax,%rcx), %r12
	addq	$65664, %r12
	shlq	$8, %r13
	xorl	%r14d, %r14d
	movq	%rdx, 40(%rsp)
	movl	%edx, %ebx
	jmp	.LBB27_9
	.p2align	4
.LBB27_8:
	leaq	(%r12,%r14), %rax
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 240(%rax)
	movaps	%xmm0, 224(%rax)
	movaps	%xmm0, 208(%rax)
	movaps	%xmm0, 192(%rax)
	movaps	%xmm0, 176(%rax)
	movaps	%xmm0, 160(%rax)
	movaps	%xmm0, 144(%rax)
	movaps	%xmm0, 128(%rax)
	movaps	%xmm0, 112(%rax)
	movaps	%xmm0, 96(%rax)
	movaps	%xmm0, 80(%rax)
	movaps	%xmm0, 64(%rax)
	movaps	%xmm0, 48(%rax)
	movaps	%xmm0, 32(%rax)
	movaps	%xmm0, 16(%rax)
	movaps	%xmm0, (%rax)
	incl	%ebx
	addq	$256, %r14
	cmpq	%r14, %r13
	je	.LBB27_11
.LBB27_9:
	cmpq	%r14, %r15
	jne	.LBB27_8
.Ltmp15:
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.163(%rip), %rdi
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
.Ltmp16:
	jmp	.LBB27_8
.LBB27_11:
	movq	80(%rsp), %rax
	movq	40(%rsp), %rcx
	addl	%eax, %ecx
	movl	%ecx, 83328(%rsp)
	movq	%rax, %rdx
	shlq	$4, %rdx
	movq	%rdx, 216(%rsp)
	leaq	83392(%rsp), %rdx
	movq	%rdx, 136(%rsp)
	shlq	$3, %rcx
	movq	%rcx, 120(%rsp)
	movl	$0, 1328(%rsp)
	leaq	(,%rax,8), %rcx
	movq	%rcx, 112(%rsp)
	movq	104(%rsp), %rbx
	leaq	(%rbx,%rax,8), %rcx
	movq	%rcx, 248(%rsp)
	leaq	-8(,%rax,8), %rdx
	movq	%rdx, 208(%rsp)
	shrq	$3, %rdx
	movq	%rdx, 72(%rsp)
	leaq	1(%rdx), %rcx
	movq	%rcx, 200(%rsp)
	shlq	$7, %rax
	movq	%rax, 176(%rsp)
	xorl	%r13d, %r13d
	movq	88(%rsp), %rdx
	jmp	.LBB27_13
	.p2align	4
.LBB27_12:
	movq	%r15, 1336(%rsp,%r13)
	movq	%r12, 1344(%rsp,%r13)
	movq	%rcx, 1352(%rsp,%r13)
	movq	%rdi, 1360(%rsp,%r13)
	movq	%r8, 1368(%rsp,%r13)
	movq	%r9, 1376(%rsp,%r13)
	movq	%r10, 1384(%rsp,%r13)
	movq	%r11, 1392(%rsp,%r13)
	movq	40(%rsp), %rcx
	movq	%rcx, 1400(%rsp,%r13)
	movq	%rsi, 1408(%rsp,%r13)
	movq	64(%rsp), %rax
	movq	%rax, 1416(%rsp,%r13)
	movq	96(%rsp), %rax
	movq	%rax, 1424(%rsp,%r13)
	movq	128(%rsp), %rax
	movq	%rax, 1432(%rsp,%r13)
	movq	192(%rsp), %rax
	movq	%rax, 1440(%rsp,%r13)
	movq	184(%rsp), %rax
	movq	%rax, 1448(%rsp,%r13)
	movq	%r14, 1456(%rsp,%r13)
	addq	$8, %rbx
	subq	$-128, %r13
	cmpq	%r13, 176(%rsp)
	je	.LBB27_18
.LBB27_13:
	movq	(%rbx), %rdi
	cmpq	56(%rsp), %rdi
	jae	.LBB27_78
	leaq	(%rdi,%rdi,8), %r14
	shlq	$11, %r14
	cmpq	$16384, 18368(%rdx,%r14)
	jne	.LBB27_77
	cmpq	$0, 1936(%rdx,%r14)
	jne	.LBB27_77
	addq	%rdx, %r14
	leaq	1984(%r14), %r15
	leaq	3008(%r14), %r12
	leaq	4032(%r14), %rcx
	leaq	5056(%r14), %rdi
	leaq	6080(%r14), %r8
	leaq	7104(%r14), %r9
	leaq	8128(%r14), %r10
	leaq	9152(%r14), %r11
	leaq	10176(%r14), %rsi
	movq	%rsi, 40(%rsp)
	leaq	11200(%r14), %rsi
	leaq	12224(%r14), %rax
	movq	%rax, 64(%rsp)
	leaq	13248(%r14), %rax
	movq	%rax, 96(%rsp)
	leaq	14272(%r14), %rax
	movq	%rax, 128(%rsp)
	leaq	15296(%r14), %rax
	movq	%rax, 192(%rsp)
	leaq	16320(%r14), %rax
	movq	%rax, 184(%rsp)
	addq	$17344, %r14
	cmpq	$16384, %r13
	jne	.LBB27_12
	.cfi_escape 0x2e, 0x00
	movq	%rdi, 160(%rsp)
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.39(%rip), %rdi
	movq	%rcx, 168(%rsp)
	movq	%r8, 152(%rsp)
	movq	%r9, 144(%rsp)
	movq	%r10, 240(%rsp)
	movq	%r11, 232(%rsp)
	movq	%rsi, 224(%rsp)
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	movq	224(%rsp), %rsi
	movq	232(%rsp), %r11
	movq	240(%rsp), %r10
	movq	144(%rsp), %r9
	movq	152(%rsp), %r8
	movq	160(%rsp), %rdi
	movq	168(%rsp), %rcx
	movq	88(%rsp), %rdx
	jmp	.LBB27_12
.LBB27_18:
	movq	72(%rsp), %rax
	incq	%rax
	movl	%eax, 1328(%rsp)
	leaq	1336(%rsp), %rbx
	xorl	%r14d, %r14d
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.40(%rip), %r15
	movq	104(%rsp), %r13
	jmp	.LBB27_20
	.p2align	4
.LBB27_19:
	movabsq	$18014398509481983, %rax
	andq	%rax, %r12
	movq	%r12, 304(%rsp,%r14)
	addq	$8, %r14
	cmpq	%r14, 112(%rsp)
	je	.LBB27_25
.LBB27_20:
	movq	(%r13,%r14), %rdi
	cmpq	56(%rsp), %rdi
	jae	.LBB27_80
	leaq	(%rdi,%rdi,8), %rax
	shlq	$11, %rax
	cmpq	$16384, 18368(%rdx,%rax)
	jne	.LBB27_79
	cmpq	$0, 1936(%rdx,%rax)
	jne	.LBB27_79
	addq	%rdx, %rax
	movzbl	105(%rax), %ecx
	shll	$6, %ecx
	movzbl	104(%rax), %r12d
	addl	%ecx, %r12d
	shrl	$10, %r12d
	addq	96(%rax), %r12
	cmpq	$1024, %r14
	jne	.LBB27_19
	.cfi_escape 0x2e, 0x00
	movq	%r15, %rdi
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	movq	88(%rsp), %rdx
	jmp	.LBB27_19
.LBB27_25:
	movq	72(%rsp), %rcx
	leaq	1(%rcx), %rax
	movl	%eax, 296(%rsp)
	leaq	304(%rsp), %r14
	shlq	$4, %rcx
	addq	$16, %rcx
	movq	%rcx, 72(%rsp)
	movq	80(%rsp), %r12
	shlq	$4, %r12
	xorl	%r15d, %r15d
	movzbl	39(%rsp), %eax
	movq	%rax, 40(%rsp)
	movzbl	55(%rsp), %eax
	movl	%eax, 112(%rsp)
	leaq	17792(%rsp), %r13
	.p2align	4
.LBB27_26:
	cmpq	%r15, 72(%rsp)
	je	.LBB27_72
	movq	(%r14), %r8
	.cfi_escape 0x2e, 0x20
	movl	$16, %edx
	movl	112(%rsp), %edi
	movq	%rbx, %rsi
	leaq	256(%rsp), %rcx
	xorl	%r9d, %r9d
	pushq	$512
	pushq	%r13
	pushq	$2
	pushq	64(%rsp)
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj400_EB8_
	addq	$32, %rsp
	addq	$8, %r14
	addq	$16, %r15
	addq	$512, %r13
	subq	$-128, %rbx
	cmpq	%r15, %r12
	jne	.LBB27_26
	orb	$4, 39(%rsp)
	movl	$16, %esi
	movq	104(%rsp), %r13
	movq	80(%rsp), %rbx
	leaq	17792(%rsp), %r15
	movq	216(%rsp), %r14
	.p2align	4
.LBB27_29:
	movq	120(%rsp), %rdi
	movq	136(%rsp), %rax
	movq	%rax, 128(%rsp)
	movq	%rsi, 168(%rsp)
	movq	%rsi, %rdx
	imulq	%rbx, %rdx
	movq	%rdx, %r8
	movabsq	$137438953470, %rsi
	andq	%rsi, %r8
	movq	%r14, 120(%rsp)
	cmpq	%r14, %r8
	ja	.LBB27_73
	movq	%r15, %rcx
	movl	$0, 1328(%rsp)
	movq	%rdx, %rax
	shrq	$4, %rax
	xorl	%esi, %esi
	testb	$14, %dl
	setne	%sil
	addq	%rax, %rsi
	movq	%r15, 136(%rsp)
	movq	%rdi, 96(%rsp)
	je	.LBB27_57
	shlq	$5, %r8
	movq	%rsi, %r9
	shlq	$6, %r9
	xorl	%r13d, %r13d
	movq	%rcx, %rbx
	movq	%rdx, 160(%rsp)
	movq	%rsi, 152(%rsp)
	movq	%r9, 144(%rsp)
	jmp	.LBB27_33
	.p2align	4
.LBB27_34:
	movq	%rbx, 40(%rsp)
	movq	%rcx, %rax
	movq	%rcx, %r11
	movq	%rcx, %r10
	movq	%rcx, %rbx
.LBB27_41:
	movq	%rcx, 64(%rsp)
	movq	%rcx, %r14
	movq	%rcx, %r15
	movq	%rcx, %r12
	cmpq	$8192, %r13
	je	.LBB27_42
.LBB27_32:
	movq	%rbx, 1336(%rsp,%r13)
	movq	%r10, 1344(%rsp,%r13)
	movq	%r11, 1352(%rsp,%r13)
	movq	%rax, 1360(%rsp,%r13)
	movq	64(%rsp), %rax
	movq	%rax, 1368(%rsp,%r13)
	movq	%r14, 1376(%rsp,%r13)
	movq	%r15, 1384(%rsp,%r13)
	movq	%r12, 1392(%rsp,%r13)
	addq	$64, %r13
	movq	40(%rsp), %rbx
	cmpq	%r13, %r9
	je	.LBB27_56
.LBB27_33:
	cmpq	$64, %r8
	jb	.LBB27_34
	leaq	64(%rbx), %r10
	leaq	-64(%r8), %rax
	cmpq	$64, %rax
	jae	.LBB27_37
	movq	%r10, 40(%rsp)
	movq	%rax, %r8
	movq	%rcx, %rax
	movq	%rcx, %r11
	movq	%rcx, %r10
	jmp	.LBB27_41
	.p2align	4
.LBB27_37:
	leaq	128(%rbx), %r11
	leaq	-128(%r8), %rax
	cmpq	$64, %rax
	jae	.LBB27_39
	movq	%r11, 40(%rsp)
	movq	%rax, %r8
	movq	%rcx, %rax
	movq	%rcx, %r11
	jmp	.LBB27_41
.LBB27_39:
	leaq	192(%rbx), %r14
	leaq	-192(%r8), %rax
	cmpq	$64, %rax
	jae	.LBB27_43
	movq	%r14, 40(%rsp)
	movq	%rax, %r8
	movq	%rcx, %rax
	jmp	.LBB27_41
.LBB27_43:
	leaq	256(%rbx), %r14
	leaq	-256(%r8), %rax
	cmpq	$64, %rax
	jae	.LBB27_45
	movq	%r14, 40(%rsp)
	movq	%rax, %r8
	movq	%rcx, 64(%rsp)
	jmp	.LBB27_47
.LBB27_45:
	movq	%r14, 64(%rsp)
	leaq	320(%rbx), %r14
	leaq	-320(%r8), %rax
	cmpq	$64, %rax
	jae	.LBB27_51
	movq	%r14, 40(%rsp)
	movq	%rax, %r8
.LBB27_47:
	movq	%rcx, %r14
.LBB27_48:
	movq	%rcx, %r15
.LBB27_49:
	movq	%rcx, %r12
	leaq	192(%rbx), %rax
	cmpq	$8192, %r13
	jne	.LBB27_32
.LBB27_42:
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.45(%rip), %rdi
	movq	%r8, 192(%rsp)
	movq	%r10, 184(%rsp)
	movq	%r11, 72(%rsp)
	movq	%rax, 176(%rsp)
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	movq	176(%rsp), %rax
	movq	72(%rsp), %r11
	movq	184(%rsp), %r10
	movq	144(%rsp), %r9
	movq	192(%rsp), %r8
	movq	152(%rsp), %rsi
	movq	160(%rsp), %rdx
	movq	96(%rsp), %rdi
	movq	136(%rsp), %rcx
	jmp	.LBB27_32
.LBB27_51:
	leaq	384(%rbx), %r15
	leaq	-384(%r8), %rax
	cmpq	$64, %rax
	jae	.LBB27_53
	movq	%r15, 40(%rsp)
	movq	%rax, %r8
	jmp	.LBB27_48
.LBB27_53:
	leaq	448(%rbx), %r12
	leaq	-448(%r8), %rax
	cmpq	$64, %rax
	jae	.LBB27_55
	movq	%r12, 40(%rsp)
	movq	%rax, %r8
	jmp	.LBB27_49
.LBB27_55:
	leaq	512(%rbx), %rax
	movq	%rax, 40(%rsp)
	addq	$-512, %r8
	leaq	192(%rbx), %rax
	cmpq	$8192, %r13
	jne	.LBB27_32
	jmp	.LBB27_42
	.p2align	4
.LBB27_56:
	movq	104(%rsp), %r13
	movq	80(%rsp), %rbx
	jmp	.LBB27_58
	.p2align	4
.LBB27_57:
	xorl	%esi, %esi
.LBB27_58:
	shrq	%rdx
	movl	%esi, 1328(%rsp)
	movl	%esi, %r14d
	shlq	$3, %r14
	cmpq	%r14, %rdx
	ja	.LBB27_74
	cmpq	%rdi, %rdx
	movq	%rdi, %r14
	ja	.LBB27_75
	movq	%rdx, %rax
	shlq	$5, %rax
	.cfi_escape 0x2e, 0x10
	subq	$8, %rsp
	movzbl	47(%rsp), %r8d
	movl	120(%rsp), %edi
	leaq	1344(%rsp), %rsi
	leaq	264(%rsp), %rcx
	movq	136(%rsp), %r15
	movq	%r15, %r9
	pushq	%rax
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj40_EB8_
	addq	$16, %rsp
	movq	168(%rsp), %rcx
	movq	%rcx, %rax
	shrq	%rax
	cmpq	$3, %rcx
	movq	%rax, %rsi
	ja	.LBB27_29
	xorl	%r14d, %r14d
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.41(%rip), %rbx
	leaq	1328(%rsp), %r12
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.44(%rip), %r15
	movq	88(%rsp), %rax
	jmp	.LBB27_65
	.p2align	4
.LBB27_62:
	cmpq	96(%rsp), %r14
	movq	128(%rsp), %rcx
	jae	.LBB27_82
	movq	%r14, %rax
	shlq	$5, %rax
	movups	(%rcx,%rax), %xmm0
	movups	16(%rcx,%rax), %xmm1
.LBB27_64:
	movaps	%xmm1, 1344(%rsp)
	movaps	%xmm0, 1328(%rsp)
	addq	$8, %r13
	incq	%r14
	movq	$0, 18368(%rdi)
	.cfi_escape 0x2e, 0x00
	movq	%r12, %rsi
	callq	_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore10push_group
	cmpq	248(%rsp), %r13
	movq	88(%rsp), %rax
	je	.LBB27_71
.LBB27_65:
	movq	(%r13), %rdi
	cmpq	56(%rsp), %rdi
	jae	.LBB27_83
	leaq	(%rdi,%rdi,8), %rdi
	shlq	$11, %rdi
	cmpq	$16384, 18368(%rax,%rdi)
	jne	.LBB27_81
	cmpq	$0, 1936(%rax,%rdi)
	jne	.LBB27_81
	addq	%rax, %rdi
	movzbl	105(%rdi), %eax
	shll	$6, %eax
	movzbl	104(%rdi), %ecx
	addl	%eax, %ecx
	shrl	$10, %ecx
	addq	96(%rdi), %rcx
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 1376(%rsp)
	movaps	%xmm0, 1360(%rsp)
	movaps	%xmm0, 1344(%rsp)
	movaps	%xmm0, 1328(%rsp)
	movabsq	$18014398509481983, %rax
	testq	%rax, %rcx
	jne	.LBB27_62
	leaq	(%r14,%r14), %rdx
	leaq	1(,%r14,2), %rax
	cmpq	120(%rsp), %rax
	movq	136(%rsp), %rax
	jae	.LBB27_76
	shlq	$5, %rdx
	movups	(%rax,%rdx), %xmm0
	movups	16(%rax,%rdx), %xmm1
	movups	32(%rax,%rdx), %xmm2
	movups	48(%rax,%rdx), %xmm3
	movaps	%xmm3, 1376(%rsp)
	movaps	%xmm2, 1360(%rsp)
	jmp	.LBB27_64
.LBB27_71:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.LBB27_72:
	.cfi_def_cfa %rbp, 16
	movq	208(%rsp), %rax
	leaq	32(,%rax,2), %rsi
	movl	200(%rsp), %edx
	shlq	$4, %rdx
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.49(%rip), %rcx
	movq	%r15, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB27_73:
	xorl	%edx, %edx
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.48(%rip), %rcx
	.cfi_escape 0x2e, 0x00
	movq	%rdx, %rdi
	movq	%r8, %rsi
	movq	120(%rsp), %rdx
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB27_74:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.47(%rip), %rcx
	.cfi_escape 0x2e, 0x00
	xorl	%edi, %edi
	movq	%rdx, %rsi
	movq	%r14, %rdx
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB27_75:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.46(%rip), %rcx
	.cfi_escape 0x2e, 0x00
	xorl	%edi, %edi
	movq	%rdx, %rsi
	movq	%r14, %rdx
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB27_76:
	leaq	2(%rdx), %r8
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.43(%rip), %rcx
	.cfi_escape 0x2e, 0x00
	movq	%rdx, %rdi
	movq	%r8, %rsi
	movq	120(%rsp), %rdx
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB27_77:
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.113(%rip), %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.114(%rip), %rdx
	movl	$12, %esi
	callq	*_RNvNtCskADBYZwJmSU_4core6option13expect_failed@GOTPCREL(%rip)
.LBB27_78:
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.112(%rip), %rdx
	movq	56(%rsp), %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB27_79:
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.116(%rip), %rdi
	callq	*_RNvNtCskADBYZwJmSU_4core6option13unwrap_failed@GOTPCREL(%rip)
.LBB27_80:
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.115(%rip), %rdx
	movq	56(%rsp), %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB27_81:
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.42(%rip), %rdi
	callq	*_RNvNtCskADBYZwJmSU_4core6option13unwrap_failed@GOTPCREL(%rip)
.LBB27_82:
	movq	%r14, %rdi
	movq	96(%rsp), %rax
	movq	%rax, 56(%rsp)
	movq	%r15, %rbx
.LBB27_83:
	.cfi_escape 0x2e, 0x00
	movq	56(%rsp), %rsi
	movq	%rbx, %rdx
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB27_84:
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.38(%rip), %rdx
	movq	56(%rsp), %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB27_85:
.Ltmp17:
	movl	%ebx, 83328(%rsp)
	.cfi_escape 0x2e, 0x00
	movq	%rax, %rdi
	callq	_Unwind_Resume@PLT
.Lfunc_end27:
	.size	_RINvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohortKj80_EB4_, .Lfunc_end27-_RINvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohortKj80_EB4_

# source blake3_servil-9e4037ac4510b2d3.s
_RNvNtCs8b9n3vPMt31_13blake3_servil10ffi_output11held_groups:
.Lfunc_begin63:
	.cfi_startproc
	.cfi_personality 155, DW.ref.rust_eh_personality
	.cfi_lsda 27, .Lexception63
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-64, %rsp
	subq	$64, %rsp
	movq	$0, (%rsp)
	movq	%rsp, %r11
	subq	$98304, %r11
.LBB210_1:
	subq	$4096, %rsp
	movq	$0, (%rsp)
	cmpq	%r11, %rsp
	jne	.LBB210_1
	subq	$1152, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rdx, 64(%rsp)
	movq	%rsi, 24(%rsp)
	movq	%rdi, 96(%rsp)
	movl	%r8d, 140(%rsp)
	movzbl	%r8b, %r14d
	cmpb	$3, %r14b
	je	.LBB210_5
	cmpl	$4, %r14d
	jne	.LBB210_6
	movl	$8, %eax
	movq	%rax, 112(%rsp)
	movl	$0, 32(%rsp)
	movq	$0, 144(%rsp)
	jmp	.LBB210_7
.LBB210_5:
	movb	$1, %al
	movl	%eax, 32(%rsp)
	movq	$0, 144(%rsp)
	movq	$0, 112(%rsp)
	jmp	.LBB210_7
.LBB210_6:
	movl	$16, %eax
	movq	%rax, 112(%rsp)
	movb	$1, %al
	movq	%rax, 144(%rsp)
	movl	$0, 32(%rsp)
.LBB210_7:
	movl	$0, 1024(%rsp)
	movl	$0, 66624(%rsp)
	movq	%rcx, 48(%rsp)
	movq	%rcx, %r15
	shlq	$9, %r15
	xorl	%r12d, %r12d
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.162(%rip), %rbx
	movq	memset@GOTPCREL(%rip), %r13
	jmp	.LBB210_9
	.p2align	4
.LBB210_8:
	leaq	(%rsp,%r12), %rdi
	addq	$1088, %rdi
	.cfi_escape 0x2e, 0x00
	movl	$512, %edx
	xorl	%esi, %esi
	callq	*%r13
	addq	$512, %r12
	cmpq	%r12, %r15
	je	.LBB210_11
.LBB210_9:
	cmpq	$65536, %r12
	jne	.LBB210_8
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	jmp	.LBB210_8
.LBB210_11:
	movq	48(%rsp), %rax
	movl	%eax, 1024(%rsp)
	movl	66624(%rsp), %r12d
	movq	%r12, %r15
	shlq	$8, %r15
	xorl	%r13d, %r13d
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.163(%rip), %rbx
	jmp	.LBB210_13
	.p2align	4
.LBB210_12:
	leaq	66688(%rsp), %rax
	addq	%r15, %rax
	pxor	%xmm0, %xmm0
	movdqa	%xmm0, 240(%rax)
	movdqa	%xmm0, 224(%rax)
	movdqa	%xmm0, 208(%rax)
	movdqa	%xmm0, 192(%rax)
	movdqa	%xmm0, 176(%rax)
	movdqa	%xmm0, 160(%rax)
	movdqa	%xmm0, 144(%rax)
	movdqa	%xmm0, 128(%rax)
	movdqa	%xmm0, 112(%rax)
	movdqa	%xmm0, 96(%rax)
	movdqa	%xmm0, 80(%rax)
	movdqa	%xmm0, 64(%rax)
	movdqa	%xmm0, 48(%rax)
	movdqa	%xmm0, 32(%rax)
	movdqa	%xmm0, 16(%rax)
	movdqa	%xmm0, (%rax)
	addq	$256, %r15
	decq	%r13
	movq	48(%rsp), %rax
	addq	%r13, %rax
	je	.LBB210_15
.LBB210_13:
	cmpq	$32768, %r15
	jne	.LBB210_12
.Ltmp1181:
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
.Ltmp1182:
	jmp	.LBB210_12
.LBB210_15:
	movq	48(%rsp), %rax
	addl	%eax, %r12d
	movl	%r12d, 66624(%rsp)
	leaq	1088(%rsp), %rcx
	movq	%rax, %r15
	shlq	$4, %r15
	shlq	$3, %r12
	movq	%r12, 72(%rsp)
	movq	64(%rsp), %r13
	leaq	(,%rax,8), %rax
	addq	%r13, %rax
	movq	%rax, 592(%rsp)
	xorl	%r12d, %r12d
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.329(%rip), %rax
	movq	%rax, 40(%rsp)
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.331(%rip), %rax
	movq	%rax, 152(%rsp)
	movq	%rcx, %rax
	.p2align	4
.LBB210_16:
	movq	(%r13), %rdi
	cmpq	24(%rsp), %rdi
	jae	.LBB210_167
	leaq	(%rdi,%rdi,8), %rcx
	shlq	$11, %rcx
	movq	96(%rsp), %rdx
	cmpq	$16384, 18368(%rdx,%rcx)
	jne	.LBB210_153
	cmpq	$0, 1936(%rdx,%rcx)
	jne	.LBB210_153
	addq	%rdx, %rcx
	leaq	1984(%rcx), %rdi
	movzbl	105(%rcx), %esi
	movzbl	104(%rcx), %r8d
	movq	96(%rcx), %rdx
	movq	%rdi, 192(%rsp)
	leaq	3008(%rcx), %rdi
	movq	%rdi, 200(%rsp)
	leaq	4032(%rcx), %rdi
	movq	%rdi, 208(%rsp)
	leaq	5056(%rcx), %rdi
	movq	%rdi, 216(%rsp)
	leaq	6080(%rcx), %rdi
	movq	%rdi, 224(%rsp)
	leaq	7104(%rcx), %rdi
	movq	%rdi, 232(%rsp)
	leaq	8128(%rcx), %rdi
	movq	%rdi, 240(%rsp)
	leaq	9152(%rcx), %rdi
	movq	%rdi, 248(%rsp)
	leaq	10176(%rcx), %rdi
	movq	%rdi, 256(%rsp)
	leaq	11200(%rcx), %rdi
	movq	%rdi, 264(%rsp)
	leaq	12224(%rcx), %rdi
	movq	%rdi, 272(%rsp)
	leaq	13248(%rcx), %rdi
	movq	%rdi, 280(%rsp)
	leaq	14272(%rcx), %rdi
	movq	%rdi, 288(%rsp)
	leaq	15296(%rcx), %rdi
	movq	%rdi, 296(%rsp)
	leaq	16320(%rcx), %rdi
	movq	%rdi, 304(%rsp)
	leaq	17344(%rcx), %rdi
	movq	%rdi, 312(%rsp)
	leaq	16(%r12), %rbx
	leaq	16(%r15), %rdi
	cmpq	%rbx, %rdi
	je	.LBB210_127
	addq	$8, %r13
	leaq	512(%rax), %r12
	shll	$6, %esi
	addl	%esi, %r8d
	shrl	$10, %r8d
	addq	%rdx, %r8
	movabsq	$18014398509481983, %rdx
	andq	%rdx, %r8
	movzbl	106(%rcx), %r10d
	subq	$-128, %rcx
	.cfi_escape 0x2e, 0x20
	movl	$16, %edx
	movl	%r14d, %edi
	leaq	192(%rsp), %rsi
	xorl	%r9d, %r9d
	pushq	$512
	pushq	%rax
	pushq	$2
	pushq	%r10
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj400_EB8_
	addq	$32, %rsp
	movq	%r12, %rax
	movq	%rbx, %r12
	cmpq	%rbx, %r15
	movq	48(%rsp), %rsi
	jne	.LBB210_16
	cmpb	$0, 32(%rsp)
	leaq	66688(%rsp), %rax
	jne	.LBB210_169
	movq	112(%rsp), %rcx
	rep		bsfq	%rcx, %rdx
	movq	%rdx, 608(%rsp)
	leaq	-1(%rcx), %rdx
	movq	%rdx, 600(%rsp)
	movl	%ecx, %edx
	shll	$5, %edx
	movq	%rdx, 616(%rsp)
	shll	$6, %ecx
	movq	%rcx, 584(%rsp)
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.328(%rip), %rcx
	movq	%rcx, 152(%rsp)
	xorl	%ecx, %ecx
	movq	72(%rsp), %rdx
	leaq	1088(%rsp), %rdi
	jmp	.LBB210_24
	.p2align	4
.LBB210_23:
	movq	160(%rsp), %rcx
	incq	%rcx
	movq	80(%rsp), %rdi
	movq	56(%rsp), %r15
	cmpq	$4, %rcx
	movq	48(%rsp), %rsi
	movq	104(%rsp), %rax
	movq	72(%rsp), %rdx
	je	.LBB210_116
.LBB210_24:
	movq	%rdx, 56(%rsp)
	movl	$8, %edx
	movq	%rcx, 160(%rsp)
	shrq	%cl, %rdx
	movq	%rax, 80(%rsp)
	movq	%r15, 72(%rsp)
	imulq	%rsi, %rdx
	movq	%rdx, 120(%rsp)
	movq	608(%rsp), %rcx
	shrq	%cl, %rdx
	imulq	112(%rsp), %rdx
	movq	600(%rsp), %rax
	movq	%rdx, 576(%rsp)
	leaq	(%rax,%rdx), %r11
	shrq	%cl, %r11
	testq	%r11, %r11
	movq	%rdi, 104(%rsp)
	je	.LBB210_63
	movq	72(%rsp), %rdx
	shlq	$5, %rdx
	movq	160(%rsp), %r15
	xorq	$3, %r15
	cmpb	$0, 144(%rsp)
	movq	%rdx, 32(%rsp)
	je	.LBB210_36
	movq	%rdi, %rbx
	xorl	%r14d, %r14d
	xorl	%r12d, %r12d
	.p2align	4
.LBB210_27:
	movq	112(%rsp), %rax
	addq	%r12, %rax
	movq	%rax, 88(%rsp)
	decq	%r11
	movl	$17, %eax
	movq	%r12, %r9
	movq	%r14, %r13
	.p2align	4
.LBB210_28:
	movq	%r9, %rdi
	movl	%r15d, %ecx
	shrq	%cl, %rdi
	cmpq	%rsi, %rdi
	jae	.LBB210_158
	movq	64(%rsp), %rcx
	movq	(%rcx,%rdi,8), %rdi
	cmpq	24(%rsp), %rdi
	jae	.LBB210_163
	leaq	63(%r13), %rcx
	cmpq	%rdx, %rcx
	jae	.LBB210_129
	leaq	(%rbx,%r13), %rcx
	leaq	(%rdi,%rdi,8), %r10
	shlq	$11, %r10
	movq	96(%rsp), %r8
	leaq	(%r8,%r10), %rdi
	addq	$128, %rdi
	movzbl	106(%r8,%r10), %r8d
	orb	$4, %r8b
	movq	%rcx, 175(%rsp,%rax)
	movq	%rdi, 183(%rsp,%rax)
	movb	$64, 191(%rsp,%rax)
	movb	%r8b, 192(%rsp,%rax)
	addq	$24, %rax
	addq	$64, %r13
	incq	%r9
	cmpq	$401, %rax
	jne	.LBB210_28
	movq	%r11, 40(%rsp)
	.cfi_escape 0x2e, 0x00
	movl	$384, %edx
	leaq	640(%rsp), %rdi
	leaq	192(%rsp), %rsi
	callq	*memcpy@GOTPCREL(%rip)
	leaq	16(%r12), %r13
	cmpq	56(%rsp), %r13
	seta	%al
	cmpq	$-17, %r12
	ja	.LBB210_35
	testb	%al, %al
	jne	.LBB210_140
.LBB210_34:
	shlq	$5, %r12
	addq	80(%rsp), %r12
	.cfi_escape 0x2e, 0x00
	leaq	640(%rsp), %rdi
	movq	%r12, %rsi
	callq	*blake3_servil_output16@GOTPCREL(%rip)
	addq	584(%rsp), %r14
	movq	88(%rsp), %r12
	movq	40(%rsp), %r11
	testq	%r11, %r11
	movq	32(%rsp), %rdx
	movq	48(%rsp), %rsi
	jne	.LBB210_27
	jmp	.LBB210_63
.LBB210_35:
	movb	$1, %al
	testb	%al, %al
	je	.LBB210_34
	jmp	.LBB210_140
	.p2align	4
.LBB210_36:
	movl	$511, %r13d
	movq	80(%rsp), %r14
	xorl	%r12d, %r12d
	.p2align	4
.LBB210_37:
	movq	%r11, 40(%rsp)
	movq	%r12, %rdi
	movl	%r15d, %ecx
	shrq	%cl, %rdi
	cmpq	%rsi, %rdi
	jae	.LBB210_158
	movq	64(%rsp), %r11
	movq	(%r11,%rdi,8), %rdi
	cmpq	24(%rsp), %rdi
	jae	.LBB210_163
	leaq	-448(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB210_128
	leaq	1(%r12), %rax
	movl	%r15d, %ecx
	shrq	%cl, %rax
	cmpq	%rsi, %rax
	jae	.LBB210_151
	movq	(%r11,%rax,8), %rbx
	cmpq	24(%rsp), %rbx
	jae	.LBB210_159
	leaq	-384(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB210_130
	leaq	2(%r12), %rax
	movl	%r15d, %ecx
	shrq	%cl, %rax
	cmpq	%rsi, %rax
	jae	.LBB210_151
	movq	(%r11,%rax,8), %r9
	cmpq	24(%rsp), %r9
	jae	.LBB210_154
	leaq	-320(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB210_131
	leaq	3(%r12), %rax
	movl	%r15d, %ecx
	shrq	%cl, %rax
	cmpq	%rsi, %rax
	jae	.LBB210_151
	movq	(%r11,%rax,8), %rcx
	cmpq	24(%rsp), %rcx
	jae	.LBB210_156
	leaq	-256(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB210_132
	movq	%rcx, 88(%rsp)
	leaq	4(%r12), %rax
	movl	%r15d, %ecx
	shrq	%cl, %rax
	movq	%rsi, %r8
	cmpq	%rsi, %rax
	jae	.LBB210_152
	movq	(%r11,%rax,8), %r10
	cmpq	24(%rsp), %r10
	jae	.LBB210_157
	leaq	-192(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB210_133
	leaq	5(%r12), %rax
	movl	%r15d, %ecx
	shrq	%cl, %rax
	cmpq	%r8, %rax
	jae	.LBB210_152
	movq	(%r11,%rax,8), %rsi
	cmpq	24(%rsp), %rsi
	jae	.LBB210_155
	leaq	-128(%r13), %rax
	cmpq	32(%rsp), %rax
	jae	.LBB210_134
	leaq	6(%r12), %rax
	movl	%r15d, %ecx
	shrq	%cl, %rax
	cmpq	%r8, %rax
	jae	.LBB210_152
	movq	%r14, %rdx
	movq	(%r11,%rax,8), %r14
	cmpq	24(%rsp), %r14
	jae	.LBB210_160
	leaq	-64(%r13), %rax
	cmpq	32(%rsp), %rax
	jae	.LBB210_135
	leaq	7(%r12), %rax
	movq	%rax, %r11
	movl	%r15d, %ecx
	shrq	%cl, %r11
	cmpq	%r8, %r11
	jae	.LBB210_161
	movq	64(%rsp), %rcx
	movq	(%rcx,%r11,8), %r11
	cmpq	24(%rsp), %r11
	jae	.LBB210_162
	cmpq	32(%rsp), %r13
	jae	.LBB210_136
	cmpq	56(%rsp), %rax
	jae	.LBB210_138
	leaq	(%rdi,%rdi,8), %rax
	shlq	$11, %rax
	movq	%rdx, 184(%rsp)
	movq	%rsi, 128(%rsp)
	movq	96(%rsp), %rsi
	leaq	(%rsi,%rax), %rcx
	movq	%rcx, 176(%rsp)
	leaq	(%rbx,%rbx,8), %r8
	shlq	$11, %r8
	leaq	(%rsi,%r8), %rcx
	movq	%rcx, 168(%rsp)
	leaq	(%r9,%r9,8), %rbx
	shlq	$11, %rbx
	leaq	(%rsi,%rbx), %rcx
	movq	%rcx, 632(%rsp)
	movq	88(%rsp), %rcx
	leaq	(%rcx,%rcx,8), %rcx
	shlq	$11, %rcx
	leaq	(%rsi,%rcx), %rdi
	leaq	(%r10,%r10,8), %rdx
	shlq	$11, %rdx
	movq	%rdx, %r10
	movq	%rdx, 88(%rsp)
	movzbl	106(%rsi,%rax), %eax
	movzbl	106(%rsi,%r8), %edx
	shll	$8, %edx
	orl	%eax, %edx
	leaq	(%rsi,%r10), %rax
	movq	%rax, 624(%rsp)
	movq	128(%rsp), %rax
	leaq	(%rax,%rax,8), %r10
	shlq	$11, %r10
	movzbl	106(%rsi,%rbx), %eax
	shll	$16, %eax
	orl	%edx, %eax
	leaq	(%r14,%r14,8), %r8
	shlq	$11, %r8
	movq	%r8, 128(%rsp)
	movzbl	106(%rsi,%rcx), %edx
	shll	$24, %edx
	orl	%eax, %edx
	addq	%rsi, %r8
	leaq	(%r11,%r11,8), %r9
	shlq	$11, %r9
	movd	%edx, %xmm0
	movq	104(%rsp), %rdx
	leaq	(%rdx,%r13), %r11
	addq	$-511, %r11
	movq	%r11, 192(%rsp)
	leaq	-447(%rdx,%r13), %rax
	movq	%rax, 200(%rsp)
	leaq	-383(%rdx,%r13), %rax
	movq	%rax, 208(%rsp)
	leaq	-319(%rdx,%r13), %rax
	movq	%rax, 216(%rsp)
	leaq	-255(%rdx,%r13), %rax
	movq	%rax, 224(%rsp)
	leaq	-191(%rdx,%r13), %rax
	movq	%rax, 232(%rsp)
	leaq	-127(%rdx,%r13), %rax
	movq	%rax, 240(%rsp)
	leaq	-63(%rdx,%r13), %rax
	movq	%rax, 248(%rsp)
	movq	176(%rsp), %rdx
	movl	128(%rdx), %eax
	movl	%eax, 256(%rsp)
	movq	168(%rsp), %r11
	movl	128(%r11), %eax
	movl	%eax, 260(%rsp)
	movq	632(%rsp), %rbx
	movl	128(%rbx), %eax
	movl	%eax, 264(%rsp)
	movl	128(%rdi), %eax
	movl	%eax, 268(%rsp)
	movq	624(%rsp), %r14
	movl	128(%r14), %eax
	movl	%eax, 272(%rsp)
	leaq	(%rsi,%r10), %rcx
	movl	128(%rcx), %eax
	movl	%eax, 276(%rsp)
	movl	128(%r8), %eax
	movl	%eax, 280(%rsp)
	movl	128(%rsi,%r9), %eax
	movl	%eax, 284(%rsp)
	movl	132(%rdx), %eax
	movl	%eax, 288(%rsp)
	movl	132(%r11), %eax
	movl	%eax, 292(%rsp)
	movl	132(%rbx), %eax
	movl	%eax, 296(%rsp)
	movl	132(%rdi), %eax
	movl	%eax, 300(%rsp)
	movl	132(%r14), %eax
	movl	%eax, 304(%rsp)
	movl	132(%rcx), %eax
	movl	%eax, 308(%rsp)
	movl	132(%r8), %eax
	movl	%eax, 312(%rsp)
	movl	132(%rsi,%r9), %eax
	movl	%eax, 316(%rsp)
	movl	136(%rdx), %eax
	movl	%eax, 320(%rsp)
	movl	136(%r11), %eax
	movl	%eax, 324(%rsp)
	movl	136(%rbx), %eax
	movl	%eax, 328(%rsp)
	movl	136(%rdi), %eax
	movl	%eax, 332(%rsp)
	movl	136(%r14), %eax
	movl	%eax, 336(%rsp)
	movl	136(%rcx), %eax
	movl	%eax, 340(%rsp)
	movl	136(%r8), %eax
	movl	%eax, 344(%rsp)
	movl	136(%rsi,%r9), %eax
	movl	%eax, 348(%rsp)
	movl	140(%rdx), %eax
	movl	%eax, 352(%rsp)
	movl	140(%r11), %eax
	movl	%eax, 356(%rsp)
	movl	140(%rbx), %eax
	movl	%eax, 360(%rsp)
	movl	140(%rdi), %eax
	movl	%eax, 364(%rsp)
	movl	140(%r14), %eax
	movl	%eax, 368(%rsp)
	movl	140(%rcx), %eax
	movl	%eax, 372(%rsp)
	movl	140(%r8), %eax
	movl	%eax, 376(%rsp)
	movl	140(%rsi,%r9), %eax
	movl	%eax, 380(%rsp)
	movl	144(%rdx), %eax
	movl	%eax, 384(%rsp)
	movl	144(%r11), %eax
	movl	%eax, 388(%rsp)
	movl	144(%rbx), %eax
	movl	%eax, 392(%rsp)
	movl	144(%rdi), %eax
	movl	%eax, 396(%rsp)
	movl	144(%r14), %eax
	movl	%eax, 400(%rsp)
	movl	144(%rcx), %eax
	movl	%eax, 404(%rsp)
	movl	144(%r8), %eax
	movl	%eax, 408(%rsp)
	movl	144(%rsi,%r9), %eax
	movl	%eax, 412(%rsp)
	movl	148(%rdx), %eax
	movl	%eax, 416(%rsp)
	movl	148(%r11), %eax
	movl	%eax, 420(%rsp)
	movl	148(%rbx), %eax
	movl	%eax, 424(%rsp)
	movl	148(%rdi), %eax
	movl	%eax, 428(%rsp)
	movl	148(%r14), %eax
	movl	%eax, 432(%rsp)
	movl	148(%rcx), %eax
	movl	%eax, 436(%rsp)
	movl	148(%r8), %eax
	movl	%eax, 440(%rsp)
	movl	148(%rsi,%r9), %eax
	movl	%eax, 444(%rsp)
	movl	152(%rdx), %eax
	movl	%eax, 448(%rsp)
	movl	152(%r11), %eax
	movl	%eax, 452(%rsp)
	movl	152(%rbx), %eax
	movl	%eax, 456(%rsp)
	movl	152(%rdi), %eax
	movl	%eax, 460(%rsp)
	movl	152(%r14), %eax
	movl	%eax, 464(%rsp)
	movl	152(%rcx), %eax
	movl	%eax, 468(%rsp)
	movl	152(%r8), %eax
	movl	%eax, 472(%rsp)
	movl	152(%rsi,%r9), %eax
	movl	%eax, 476(%rsp)
	movl	156(%rdx), %eax
	movl	%eax, 480(%rsp)
	movl	156(%r11), %eax
	movl	%eax, 484(%rsp)
	movl	156(%rbx), %eax
	movl	%eax, 488(%rsp)
	movl	156(%rdi), %eax
	movl	%eax, 492(%rsp)
	movl	156(%r14), %eax
	movl	%eax, 496(%rsp)
	movl	156(%rcx), %eax
	movl	%eax, 500(%rsp)
	movq	88(%rsp), %rax
	movzbl	106(%rsi,%rax), %eax
	movzbl	106(%rsi,%r10), %edx
	movl	156(%r8), %ecx
	movl	%ecx, 504(%rsp)
	movl	156(%rsi,%r9), %ecx
	movl	%ecx, 508(%rsp)
	movzbl	%al, %eax
	movzbl	%dl, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	movq	128(%rsp), %rax
	movzbl	106(%rsi,%rax), %eax
	movzbl	%al, %eax
	shll	$16, %eax
	orl	%ecx, %eax
	movzbl	106(%rsi,%r9), %ecx
	shll	$24, %ecx
	orl	%eax, %ecx
	movd	%ecx, %xmm1
	movdqa	.LCPI210_0(%rip), %xmm2
	por	%xmm2, %xmm0
	movdqa	.LCPI210_1(%rip), %xmm3
	movdqa	%xmm3, 512(%rsp)
	movdqa	%xmm3, 528(%rsp)
	pxor	%xmm3, %xmm3
	punpcklbw	%xmm3, %xmm0
	punpcklwd	%xmm3, %xmm0
	movdqa	%xmm0, 544(%rsp)
	addq	112(%rsp), %r12
	movq	40(%rsp), %r14
	decq	%r14
	por	%xmm2, %xmm1
	punpcklbw	%xmm3, %xmm1
	punpcklwd	%xmm3, %xmm1
	movdqa	%xmm1, 560(%rsp)
	.cfi_escape 0x2e, 0x00
	leaq	192(%rsp), %rdi
	movq	%r15, %rbx
	movq	%r12, %r15
	movq	184(%rsp), %r12
	movq	%r12, %rsi
	callq	*blake3_servil_output8@GOTPCREL(%rip)
	movq	%r14, %r11
	movq	48(%rsp), %rsi
	addq	616(%rsp), %r12
	movq	%r12, %r14
	movq	%r15, %r12
	movq	%rbx, %r15
	addq	584(%rsp), %r13
	testq	%r11, %r11
	movq	32(%rsp), %rdx
	jne	.LBB210_37
.LBB210_63:
	movq	120(%rsp), %rax
	movq	576(%rsp), %r12
	subq	%r12, %rax
	cmpq	$8, %rax
	setae	%al
	testb	%al, 144(%rsp)
	movq	64(%rsp), %r14
	movq	72(%rsp), %r13
	movq	160(%rsp), %rbx
	je	.LBB210_66
	movzbl	_RNvNvNtCs8b9n3vPMt31_13blake3_servil8platform12x86_features8FEATURES.0(%rip), %eax
	testb	%al, %al
	je	.LBB210_70
	testb	$4, %al
	jne	.LBB210_71
.LBB210_66:
	movq	56(%rsp), %rax
	shlq	$5, %rax
	addq	80(%rsp), %rax
	movq	%rax, 40(%rsp)
	movq	%rbx, %rax
	xorq	$3, %rax
	movq	%rax, 32(%rsp)
	movq	%r13, %rdx
	shlq	$5, %rdx
	testq	%r12, %r12
	jne	.LBB210_115
	cmpq	$3, %rbx
	ja	.LBB210_23
	cmpq	$0, 56(%rsp)
	je	.LBB210_23
	movl	$1, %r15d
	movq	$-1, %r14
	movq	80(%rsp), %rbx
	xorl	%r13d, %r13d
	jmp	.LBB210_99
.LBB210_70:
	.cfi_escape 0x2e, 0x00
	movq	%rsi, %r15
	callq	_RNvNtCs8b9n3vPMt31_13blake3_servil8platform17read_x86_features
	movq	%r15, %rsi
	movb	%al, _RNvNvNtCs8b9n3vPMt31_13blake3_servil8platform12x86_features8FEATURES.0(%rip)
	testb	$4, %al
	je	.LBB210_66
.LBB210_71:
	movq	%rbx, %rcx
	xorq	$3, %rcx
	movq	%r12, %rdi
	movq	%rcx, 32(%rsp)
	shrq	%cl, %rdi
	cmpq	%rsi, %rdi
	jae	.LBB210_158
	movq	(%r14,%rdi,8), %rdi
	cmpq	24(%rsp), %rdi
	jae	.LBB210_163
	movq	%r13, %rdx
	shlq	$5, %rdx
	movq	%r12, %r13
	shlq	$6, %r13
	leaq	63(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB210_129
	leaq	1(%r12), %rax
	movq	%rax, %r8
	movq	32(%rsp), %rcx
	shrq	%cl, %r8
	cmpq	%rsi, %r8
	jae	.LBB210_168
	movq	(%r14,%r8,8), %r15
	cmpq	24(%rsp), %r15
	jae	.LBB210_171
	shlq	$6, %rax
	leaq	63(%rax), %rcx
	cmpq	%rdx, %rcx
	jae	.LBB210_142
	leaq	2(%r12), %rbx
	movq	%rbx, %r8
	movq	32(%rsp), %rcx
	shrq	%cl, %r8
	cmpq	%rsi, %r8
	jae	.LBB210_168
	movq	(%r14,%r8,8), %r10
	cmpq	24(%rsp), %r10
	jae	.LBB210_157
	shlq	$6, %rbx
	leaq	63(%rbx), %rcx
	cmpq	%rdx, %rcx
	jae	.LBB210_143
	leaq	3(%r12), %r8
	movq	%r8, %r9
	movq	32(%rsp), %rcx
	shrq	%cl, %r9
	cmpq	%rsi, %r9
	jae	.LBB210_172
	movq	(%r14,%r9,8), %r9
	cmpq	24(%rsp), %r9
	jae	.LBB210_154
	shlq	$6, %r8
	leaq	63(%r8), %rcx
	cmpq	%rdx, %rcx
	jae	.LBB210_144
	movq	%r9, 88(%rsp)
	movq	%r10, 40(%rsp)
	movq	%rsi, %r9
	leaq	4(%r12), %r10
	movq	%r10, %rsi
	movq	32(%rsp), %rcx
	shrq	%cl, %rsi
	movq	%r9, %r11
	cmpq	%r9, %rsi
	jae	.LBB210_165
	movq	(%r14,%rsi,8), %r9
	cmpq	24(%rsp), %r9
	jae	.LBB210_154
	shlq	$6, %r10
	leaq	63(%r10), %rcx
	cmpq	%rdx, %rcx
	jae	.LBB210_145
	movq	%r15, 184(%rsp)
	leaq	5(%r12), %r15
	movq	%r15, %rsi
	movq	32(%rsp), %rcx
	shrq	%cl, %rsi
	cmpq	%r11, %rsi
	jae	.LBB210_165
	movq	(%r14,%rsi,8), %rsi
	cmpq	24(%rsp), %rsi
	jae	.LBB210_155
	shlq	$6, %r15
	leaq	63(%r15), %rcx
	cmpq	%rdx, %rcx
	jae	.LBB210_146
	movq	%rsi, 176(%rsp)
	movq	%r9, 128(%rsp)
	leaq	6(%r12), %r9
	movq	%r9, %rsi
	movq	32(%rsp), %rcx
	shrq	%cl, %rsi
	cmpq	%r11, %rsi
	jae	.LBB210_165
	movq	(%r14,%rsi,8), %rsi
	cmpq	24(%rsp), %rsi
	jae	.LBB210_155
	shlq	$6, %r9
	leaq	63(%r9), %rcx
	cmpq	%rdx, %rcx
	jae	.LBB210_147
	movq	%rsi, 168(%rsp)
	movq	%rbx, %rsi
	leaq	7(%r12), %rbx
	movq	%rbx, %r14
	movq	32(%rsp), %rcx
	shrq	%cl, %r14
	cmpq	%r11, %r14
	jae	.LBB210_173
	movq	64(%rsp), %rcx
	movq	(%rcx,%r14,8), %rcx
	cmpq	24(%rsp), %rcx
	jae	.LBB210_156
	shlq	$6, %rbx
	leaq	63(%rbx), %r14
	cmpq	%rdx, %r14
	jae	.LBB210_143
	movq	104(%rsp), %r11
	addq	%r11, %r13
	movq	%r13, 192(%rsp)
	leaq	(%rdi,%rdi,8), %rdi
	shlq	$11, %rdi
	movq	96(%rsp), %r12
	leaq	(%r12,%rdi), %r14
	subq	$-128, %r14
	movq	%r14, 200(%rsp)
	movzbl	106(%r12,%rdi), %edi
	orb	$4, %dil
	movb	$64, 208(%rsp)
	movb	%dil, 209(%rsp)
	addq	%r11, %rax
	movq	%rax, 216(%rsp)
	movq	184(%rsp), %rax
	leaq	(%rax,%rax,8), %rax
	shlq	$11, %rax
	leaq	(%r12,%rax), %rdi
	subq	$-128, %rdi
	movq	%rdi, 224(%rsp)
	movzbl	106(%r12,%rax), %eax
	orb	$4, %al
	movb	$64, 232(%rsp)
	movb	%al, 233(%rsp)
	movq	40(%rsp), %rax
	leaq	(%rax,%rax,8), %rax
	shlq	$11, %rax
	addq	%r11, %rsi
	movq	%rsi, 240(%rsp)
	leaq	(%r12,%rax), %rdx
	subq	$-128, %rdx
	movq	%rdx, 248(%rsp)
	movzbl	106(%r12,%rax), %eax
	orb	$4, %al
	movb	$64, 256(%rsp)
	movb	%al, 257(%rsp)
	movq	88(%rsp), %rax
	leaq	(%rax,%rax,8), %rax
	shlq	$11, %rax
	addq	%r11, %r8
	movq	%r8, 264(%rsp)
	leaq	(%r12,%rax), %rdx
	subq	$-128, %rdx
	movq	%rdx, 272(%rsp)
	movzbl	106(%r12,%rax), %eax
	orb	$4, %al
	movb	$64, 280(%rsp)
	movb	%al, 281(%rsp)
	movq	128(%rsp), %rax
	leaq	(%rax,%rax,8), %rax
	shlq	$11, %rax
	addq	%r11, %r10
	movq	%r10, 288(%rsp)
	leaq	(%r12,%rax), %rdx
	subq	$-128, %rdx
	movq	%rdx, 296(%rsp)
	movzbl	106(%r12,%rax), %eax
	orb	$4, %al
	movb	$64, 304(%rsp)
	movb	%al, 305(%rsp)
	movq	176(%rsp), %rax
	leaq	(%rax,%rax,8), %rax
	shlq	$11, %rax
	addq	%r11, %r15
	movq	%r15, 312(%rsp)
	leaq	(%r12,%rax), %rdx
	subq	$-128, %rdx
	movq	%rdx, 320(%rsp)
	movzbl	106(%r12,%rax), %eax
	orb	$4, %al
	movb	$64, 328(%rsp)
	movb	%al, 329(%rsp)
	movq	168(%rsp), %rax
	leaq	(%rax,%rax,8), %rax
	shlq	$11, %rax
	addq	%r11, %r9
	movq	%r9, 336(%rsp)
	leaq	(%r12,%rax), %rdx
	subq	$-128, %rdx
	movq	%rdx, 344(%rsp)
	movzbl	106(%r12,%rax), %eax
	orb	$4, %al
	movb	$64, 352(%rsp)
	movb	%al, 353(%rsp)
	addq	%r11, %rbx
	leaq	(%rcx,%rcx,8), %rax
	shlq	$11, %rax
	movq	%rbx, 360(%rsp)
	leaq	(%r12,%rax), %rcx
	addq	$128, %rcx
	movq	%rcx, 368(%rsp)
	movzbl	106(%r12,%rax), %eax
	orb	$4, %al
	movb	$64, 376(%rsp)
	movb	%al, 377(%rsp)
	movq	576(%rsp), %rsi
	leaq	8(%rsi), %r13
	movq	56(%rsp), %r15
	cmpq	%r15, %rsi
	jae	.LBB210_150
	shlq	$5, %rsi
	movq	80(%rsp), %rbx
	addq	%rbx, %rsi
	.cfi_escape 0x2e, 0x00
	movl	$8, %edx
	leaq	192(%rsp), %rdi
	callq	_RINvNtCs8b9n3vPMt31_13blake3_servil10ffi_output10hash_groupKj8_EB4_
	shlq	$5, %r15
	addq	%rbx, %r15
	movq	%r15, 40(%rsp)
	movq	72(%rsp), %rdx
	shlq	$5, %rdx
	cmpq	%r13, 120(%rsp)
	jbe	.LBB210_23
.LBB210_97:
	cmpq	56(%rsp), %r13
	jae	.LBB210_23
	movq	%r13, %r14
	notq	%r14
	movq	%r13, %rbx
	shlq	$5, %rbx
	addq	80(%rsp), %rbx
	leaq	1(%r13), %r15
.LBB210_99:
	movq	%r13, %rdi
	movq	32(%rsp), %rcx
	shrq	%cl, %rdi
	cmpq	48(%rsp), %rdi
	jae	.LBB210_174
	movq	64(%rsp), %rax
	movq	(%rax,%rdi,8), %rdi
	cmpq	24(%rsp), %rdi
	jae	.LBB210_163
	shlq	$6, %r13
	leaq	63(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB210_129
	movq	%rdx, %r12
	addq	104(%rsp), %r13
	leaq	(%rdi,%rdi,8), %rcx
	shlq	$11, %rcx
	movq	96(%rsp), %rdx
	movzbl	106(%rdx,%rcx), %eax
	orb	$4, %al
	movaps	128(%rdx,%rcx), %xmm0
	movaps	144(%rdx,%rcx), %xmm1
	movaps	%xmm1, 208(%rsp)
	movaps	%xmm0, 192(%rsp)
	cmpb	$5, 140(%rsp)
	jne	.LBB210_104
	movzbl	%al, %r8d
	.cfi_escape 0x2e, 0x00
	leaq	192(%rsp), %rdi
	movq	%r13, %rsi
	movl	$64, %edx
	xorl	%ecx, %ecx
	callq	*blake3_servil_compress_in_place_avx512@GOTPCREL(%rip)
	jmp	.LBB210_105
.LBB210_104:
	.cfi_escape 0x2e, 0x00
	movzbl	%al, %r8d
	leaq	192(%rsp), %rdi
	movq	%r13, %rsi
	movl	$64, %edx
	xorl	%ecx, %ecx
	callq	*blake3_servil_compress_in_place_sse41@GOTPCREL(%rip)
.LBB210_105:
	movdqa	192(%rsp), %xmm0
	movdqa	208(%rsp), %xmm1
	movdqu	%xmm1, 16(%rbx)
	movdqu	%xmm0, (%rbx)
	addq	%r14, 120(%rsp)
	movq	64(%rsp), %r14
	je	.LBB210_23
	movq	%r12, %rdx
	addq	$32, %rbx
	movq	%r15, %r13
	shlq	$6, %r13
	jmp	.LBB210_109
	.p2align	4
.LBB210_107:
	movzbl	%al, %r8d
	.cfi_escape 0x2e, 0x00
	leaq	192(%rsp), %rdi
	movl	$64, %edx
	xorl	%ecx, %ecx
	callq	*blake3_servil_compress_in_place_avx512@GOTPCREL(%rip)
.LBB210_108:
	movq	120(%rsp), %rax
	decq	%rax
	movdqa	192(%rsp), %xmm0
	movdqa	208(%rsp), %xmm1
	movdqu	%xmm1, 16(%rbx)
	movdqu	%xmm0, (%rbx)
	addq	$32, %rbx
	addq	$64, %r13
	incq	%r15
	movq	%rax, 120(%rsp)
	testq	%rax, %rax
	movq	%r12, %rdx
	je	.LBB210_23
.LBB210_109:
	cmpq	40(%rsp), %rbx
	je	.LBB210_23
	movq	%r15, %rdi
	movq	32(%rsp), %rcx
	shrq	%cl, %rdi
	cmpq	48(%rsp), %rdi
	jae	.LBB210_174
	movq	(%r14,%rdi,8), %rdi
	cmpq	24(%rsp), %rdi
	jae	.LBB210_163
	leaq	63(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB210_129
	movq	104(%rsp), %rax
	leaq	(%rax,%r13), %rsi
	leaq	(%rdi,%rdi,8), %rcx
	shlq	$11, %rcx
	movq	96(%rsp), %rdx
	movzbl	106(%rdx,%rcx), %eax
	orb	$4, %al
	movaps	128(%rdx,%rcx), %xmm0
	movaps	144(%rdx,%rcx), %xmm1
	movaps	%xmm1, 208(%rsp)
	movaps	%xmm0, 192(%rsp)
	cmpb	$5, 140(%rsp)
	je	.LBB210_107
	.cfi_escape 0x2e, 0x00
	movzbl	%al, %r8d
	leaq	192(%rsp), %rdi
	movl	$64, %edx
	xorl	%ecx, %ecx
	callq	*blake3_servil_compress_in_place_sse41@GOTPCREL(%rip)
	jmp	.LBB210_108
.LBB210_115:
	movq	%r12, %r13
	cmpq	%r13, 120(%rsp)
	ja	.LBB210_97
	jmp	.LBB210_23
.LBB210_116:
	xorl	%r15d, %r15d
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.321(%rip), %rax
	movq	%rax, 40(%rsp)
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.323(%rip), %rax
	movq	%rax, 152(%rsp)
	leaq	192(%rsp), %r14
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.324(%rip), %r13
	movq	64(%rsp), %rbx
	jmp	.LBB210_120
	.p2align	4
.LBB210_117:
	cmpq	56(%rsp), %r15
	jae	.LBB210_166
	movq	%r15, %rax
	shlq	$5, %rax
	movq	80(%rsp), %rcx
	movdqu	(%rcx,%rax), %xmm0
	movdqu	16(%rcx,%rax), %xmm1
.LBB210_119:
	movdqa	%xmm1, 208(%rsp)
	movdqa	%xmm0, 192(%rsp)
	movq	%rdx, %rbx
	addq	$8, %rbx
	incq	%r15
	movq	$0, 18368(%rdi)
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rsi
	callq	_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore10push_group
	cmpq	592(%rsp), %rbx
	je	.LBB210_126
.LBB210_120:
	movq	(%rbx), %rdi
	cmpq	24(%rsp), %rdi
	jae	.LBB210_167
	leaq	(%rdi,%rdi,8), %rdi
	shlq	$11, %rdi
	movq	96(%rsp), %rax
	cmpq	$16384, 18368(%rax,%rdi)
	movq	104(%rsp), %rsi
	jne	.LBB210_164
	cmpq	$0, 1936(%rax,%rdi)
	jne	.LBB210_164
	movq	%rbx, %rdx
	addq	%rax, %rdi
	movzbl	105(%rdi), %eax
	shll	$6, %eax
	movzbl	104(%rdi), %ecx
	addl	%eax, %ecx
	shrl	$10, %ecx
	addq	96(%rdi), %rcx
	pxor	%xmm0, %xmm0
	movdqa	%xmm0, 240(%rsp)
	movdqa	%xmm0, 224(%rsp)
	movdqa	%xmm0, 208(%rsp)
	movdqa	%xmm0, 192(%rsp)
	movabsq	$18014398509481983, %rax
	testq	%rax, %rcx
	jne	.LBB210_117
	leaq	(%r15,%r15), %r12
	leaq	1(,%r15,2), %rax
	cmpq	72(%rsp), %rax
	jae	.LBB210_141
	shlq	$5, %r12
	movdqu	(%rsi,%r12), %xmm0
	movdqu	16(%rsi,%r12), %xmm1
	movdqu	32(%rsi,%r12), %xmm2
	movdqu	48(%rsi,%r12), %xmm3
	movdqa	%xmm3, 240(%rsp)
	movdqa	%xmm2, 224(%rsp)
	jmp	.LBB210_119
.LBB210_126:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.LBB210_127:
	.cfi_def_cfa %rbp, 16
	movl	$16, %r13d
	jmp	.LBB210_139
.LBB210_128:
	addq	$-511, %r13
.LBB210_129:
	leaq	64(%r13), %rsi
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.128(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_130:
	addq	$-447, %r13
	leaq	64(%r13), %rsi
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.128(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_131:
	addq	$-383, %r13
	leaq	64(%r13), %rsi
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.128(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_132:
	addq	$-319, %r13
	leaq	64(%r13), %rsi
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.128(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_133:
	addq	$-255, %r13
	leaq	64(%r13), %rsi
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.128(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_134:
	addq	$-191, %r13
	jmp	.LBB210_137
.LBB210_135:
	addq	$-127, %r13
	jmp	.LBB210_137
.LBB210_136:
	addq	$-63, %r13
.LBB210_137:
	movq	32(%rsp), %rdx
	leaq	64(%r13), %rsi
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.128(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_138:
	movl	$8, %r13d
	movq	56(%rsp), %r15
.LBB210_139:
	addq	%r12, %r13
	movq	152(%rsp), %rcx
	.cfi_escape 0x2e, 0x00
	movq	%r12, %rdi
	movq	%r13, %rsi
	movq	%r15, %rdx
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_140:
	movq	56(%rsp), %r15
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.327(%rip), %rcx
	.cfi_escape 0x2e, 0x00
	movq	%r12, %rdi
	movq	%r13, %rsi
	movq	%r15, %rdx
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_143:
	movq	%rbx, %r13
	leaq	64(%r13), %rsi
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.128(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_141:
	movl	$2, %r13d
	movq	72(%rsp), %r15
	jmp	.LBB210_139
.LBB210_142:
	movq	%rax, %r13
	leaq	64(%r13), %rsi
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.128(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_144:
	movq	%r8, %r13
	leaq	64(%r13), %rsi
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.128(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_145:
	movq	%r10, %r13
	leaq	64(%r13), %rsi
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.128(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_146:
	movq	%r15, %r13
	leaq	64(%r13), %rsi
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.128(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_147:
	movq	%r9, %r13
	leaq	64(%r13), %rsi
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.128(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_158:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rdx
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_150:
	movq	%rsi, %r12
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.326(%rip), %rcx
	.cfi_escape 0x2e, 0x00
	movq	%r12, %rdi
	movq	%r13, %rsi
	movq	%r15, %rdx
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB210_151:
	movq	%rax, %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rdx
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_152:
	movq	%rax, %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rdx
	movq	%r8, %rsi
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_153:
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.113(%rip), %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.330(%rip), %rdx
	movl	$12, %esi
	callq	*_RNvNtCskADBYZwJmSU_4core6option13expect_failed@GOTPCREL(%rip)
.LBB210_154:
	movq	%r9, %rdi
	movq	24(%rsp), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.127(%rip), %rdx
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_155:
	movq	%rsi, %rdi
	movq	24(%rsp), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.127(%rip), %rdx
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_156:
	movq	%rcx, %rdi
	movq	24(%rsp), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.127(%rip), %rdx
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_157:
	movq	%r10, %rdi
	movq	24(%rsp), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.127(%rip), %rdx
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_159:
	movq	%rbx, %rdi
	movq	24(%rsp), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.127(%rip), %rdx
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_160:
	movq	%r14, %rdi
	movq	24(%rsp), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.127(%rip), %rdx
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_161:
	movq	%r11, %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rdx
	movq	%r8, %rsi
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_162:
	movq	%r11, %rdi
.LBB210_163:
	movq	24(%rsp), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.127(%rip), %rdx
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_164:
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.322(%rip), %rdi
	callq	*_RNvNtCskADBYZwJmSU_4core6option13unwrap_failed@GOTPCREL(%rip)
.LBB210_165:
	movq	%rsi, %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rdx
	movq	%r11, %rsi
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_166:
	movq	%r15, %rdi
	movq	56(%rsp), %rax
	movq	%rax, 24(%rsp)
	movq	%r13, 40(%rsp)
.LBB210_167:
	.cfi_escape 0x2e, 0x00
	movq	24(%rsp), %rsi
	movq	40(%rsp), %rdx
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_168:
	movq	%r8, %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rdx
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_169:
	.cfi_escape 0x2e, 0x00
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.325(%rip), %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core9panicking11panic_const23panic_const_div_by_zero@GOTPCREL(%rip)
.LBB210_171:
	movq	%r15, %rdi
	movq	24(%rsp), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.127(%rip), %rdx
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_172:
	movq	%r9, %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rdx
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_173:
	movq	%r14, %rdi
.LBB210_174:
	movq	48(%rsp), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rdx
	.cfi_escape 0x2e, 0x00
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB210_175:
.Ltmp1183:
	subl	%r13d, %r12d
	movl	%r12d, 66624(%rsp)
	.cfi_escape 0x2e, 0x00
	movq	%rax, %rdi
	callq	_Unwind_Resume@PLT
.Lfunc_end210:
	.size	_RNvNtCs8b9n3vPMt31_13blake3_servil10ffi_output11held_groups, .Lfunc_end210-_RNvNtCs8b9n3vPMt31_13blake3_servil10ffi_output11held_groups

# source blake3_servil-9e4037ac4510b2d3.s
_RNvNtCs8b9n3vPMt31_13blake3_servil4each10flush_held:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$1064, %rsp
	.cfi_def_cfa_offset 1120
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movl	(%rdx), %ecx
	testq	%rcx, %rcx
	je	.LBB214_25
	movq	%rdx, %rbx
	movq	%rsi, %r14
	movq	%rdi, %r15
	leaq	8(%rdx), %rax
	movq	(%rax), %rdi
	leaq	(,%rcx,8), %r12
	leaq	(%rax,%rcx,8), %rsi
	xorl	%edx, %edx
	.p2align	4
.LBB214_3:
	movq	8(%rbx,%rdx), %rax
	cmpq	%r14, %rax
	jae	.LBB214_26
	leaq	(%rax,%rax,8), %rax
	shlq	$11, %rax
	cmpb	$0, 106(%r15,%rax)
	jne	.LBB214_5
	addq	$8, %rdx
	cmpq	%rdx, %r12
	jne	.LBB214_3
	movq	%r15, %rdi
	movq	%r14, %rsi
	leaq	8(%rbx), %rdx
	callq	_RINvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohortKj80_EB4_
	jmp	.LBB214_24
.LBB214_5:
	cmpq	%r14, %rdi
	jae	.LBB214_27
	leaq	(%rdi,%rdi,8), %rax
	shlq	$11, %rax
	movzbl	107(%r15,%rax), %eax
	cmpb	$3, %al
	jne	.LBB214_7
	leaq	40(%rsp), %rdx
	xorl	%ecx, %ecx
	leaq	8(%rbx), %r13
	xorl	%edi, %edi
.LBB214_9:
	addq	$8, %rdi
	.p2align	4
.LBB214_10:
	cmpq	%rsi, %r13
	je	.LBB214_16
	movq	(%r13), %rbp
	cmpq	%r14, %rbp
	jae	.LBB214_28
	addq	$8, %r13
	leaq	(,%rbp,8), %rax
	addq	%rbp, %rax
	shlq	$11, %rax
	cmpb	$0, 106(%r15,%rax)
	jne	.LBB214_10
	cmpq	$1032, %rdi
	je	.LBB214_14
.LBB214_15:
	movq	%rbp, 32(%rsp,%rdi)
	incq	%rcx
	jmp	.LBB214_9
.LBB214_14:
	movq	%rdi, (%rsp)
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.358(%rip), %rdi
	movq	%rsi, 16(%rsp)
	movq	%rcx, 8(%rsp)
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	movq	(%rsp), %rdi
	movq	8(%rsp), %rcx
	movq	16(%rsp), %rsi
	leaq	40(%rsp), %rdx
	jmp	.LBB214_15
.LBB214_7:
	movzbl	%al, %r8d
	movq	%r15, %rdi
	movq	%r14, %rsi
	leaq	8(%rbx), %rdx
	callq	_RNvNtCs8b9n3vPMt31_13blake3_servil10ffi_output11held_groups
.LBB214_24:
	movl	$0, (%rbx)
.LBB214_25:
	addq	$1064, %rsp
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.LBB214_16:
	.cfi_def_cfa_offset 1120
	movl	%ecx, 32(%rsp)
	testl	%ecx, %ecx
	je	.LBB214_18
	movl	%ecx, %ecx
	movq	%r15, %rdi
	movq	%r14, %rsi
	callq	_RINvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohortKj80_EB4_
.LBB214_18:
	xorl	%ebp, %ebp
	leaq	24(%rsp), %r13
	jmp	.LBB214_19
	.p2align	4
.LBB214_22:
	addq	$8, %rbp
	cmpq	%rbp, %r12
	je	.LBB214_24
.LBB214_19:
	leaq	8(%rbx), %rax
	movq	(%rax,%rbp), %rdi
	cmpq	%r14, %rdi
	jae	.LBB214_29
	leaq	(%rdi,%rdi,8), %rax
	shlq	$11, %rax
	cmpb	$0, 106(%r15,%rax)
	je	.LBB214_22
	movq	%rdi, 24(%rsp)
	movq	%r15, %rdi
	movq	%r14, %rsi
	movq	%r13, %rdx
	callq	_RINvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohortKj1_EB4_
	jmp	.LBB214_22
.LBB214_26:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.135(%rip), %rdx
	movq	%rax, %rdi
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB214_29:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.359(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB214_28:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.136(%rip), %rdx
	movq	%rbp, %rdi
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB214_27:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.357(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.Lfunc_end214:
	.size	_RNvNtCs8b9n3vPMt31_13blake3_servil4each10flush_held, .Lfunc_end214-_RNvNtCs8b9n3vPMt31_13blake3_servil4each10flush_held
