# source blake3_servil-9e4037ac4510b2d3.s
_RINvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohortKj80_EB4_:
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
	subq	$64, %rsp
	movq	$0, (%rsp)
	movq	%rsp, %r11
	subq	$212992, %r11
.LBB26_1:
	subq	$4096, %rsp
	movq	$0, (%rsp)
	cmpq	%r11, %rsp
	jne	.LBB26_1
	subq	$1664, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rcx, %r13
	movq	%rdi, %rcx
	movq	%rdx, 136(%rsp)
	movq	(%rdx), %rdi
	movq	%rsi, 104(%rsp)
	cmpq	%rsi, %rdi
	jae	.LBB26_104
	leaq	(%rdi,%rdi,8), %rax
	shlq	$11, %rax
	movaps	128(%rcx,%rax), %xmm0
	movaps	144(%rcx,%rax), %xmm1
	movaps	%xmm1, 288(%rsp)
	movaps	%xmm0, 272(%rsp)
	movzbl	106(%rcx,%rax), %edx
	movb	%dl, 152(%rsp)
	movq	%rcx, 112(%rsp)
	movzbl	107(%rcx,%rax), %eax
	movb	%al, 176(%rsp)
	movl	$0, 1344(%rsp)
	movl	$0, 66944(%rsp)
	movq	%r13, %r14
	shlq	$9, %r14
	xorl	%r15d, %r15d
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.161(%rip), %rbx
	movq	memset@GOTPCREL(%rip), %r12
	jmp	.LBB26_5
	.p2align	4
.LBB26_4:
	leaq	(%rsp,%r15), %rdi
	addq	$1408, %rdi
	movl	$512, %edx
	xorl	%esi, %esi
	callq	*%r12
	addq	$512, %r15
	cmpq	%r15, %r14
	je	.LBB26_7
.LBB26_5:
	cmpq	$65536, %r15
	jne	.LBB26_4
	movq	%rbx, %rdi
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	jmp	.LBB26_4
.LBB26_7:
	movl	%r13d, 1344(%rsp)
	movl	66944(%rsp), %r14d
	movq	%r14, %rax
	shlq	$8, %rax
	movl	$32768, %r15d
	subq	%rax, %r15
	leaq	1344(%rsp), %rcx
	leaq	(%rax,%rcx), %r12
	addq	$65664, %r12
	movq	%r13, 168(%rsp)
	shlq	$8, %r13
	xorl	%ebx, %ebx
	xorps	%xmm0, %xmm0
	jmp	.LBB26_9
	.p2align	4
.LBB26_8:
	leaq	(%r12,%rbx), %rax
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
	addq	$256, %rbx
	cmpq	%rbx, %r13
	je	.LBB26_11
.LBB26_9:
	cmpq	%rbx, %r15
	jne	.LBB26_8
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.162(%rip), %rdi
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	xorps	%xmm0, %xmm0
	jmp	.LBB26_8
.LBB26_11:
	movq	168(%rsp), %r15
	leal	(%r14,%r15), %eax
	movl	%eax, 66944(%rsp)
	leaq	116224(%rsp), %rdi
	leaq	1344(%rsp), %rsi
	movl	$98432, %edx
	callq	*memcpy@GOTPCREL(%rip)
	movl	116224(%rsp), %eax
	movq	%rax, 40(%rsp)
	shlq	$4, %rax
	movq	%rax, 144(%rsp)
	movl	181824(%rsp), %eax
	leaq	181888(%rsp), %rbx
	shlq	$3, %rax
	movq	%rax, 120(%rsp)
	leaq	(,%r15,8), %rax
	movq	%rax, 160(%rsp)
	movq	136(%rsp), %r14
	leaq	(%r14,%r15,8), %rax
	movq	%rax, 256(%rsp)
	movq	%r15, %rsi
	shlq	$7, %rsi
	xorl	%r13d, %r13d
	movq	112(%rsp), %rax
	movq	%rsi, 184(%rsp)
	jmp	.LBB26_13
	.p2align	4
.LBB26_12:
	movq	%r15, 1352(%rsp,%r13)
	movq	%rdx, 1360(%rsp,%r13)
	movq	%rdi, 1368(%rsp,%r13)
	movq	%r8, 1376(%rsp,%r13)
	movq	%r9, 1384(%rsp,%r13)
	movq	%r10, 1392(%rsp,%r13)
	movq	%r11, 1400(%rsp,%r13)
	movq	32(%rsp), %rcx
	movq	%rcx, 1408(%rsp,%r13)
	movq	88(%rsp), %rcx
	movq	%rcx, 1416(%rsp,%r13)
	movq	48(%rsp), %rcx
	movq	%rcx, 1424(%rsp,%r13)
	movq	80(%rsp), %rcx
	movq	%rcx, 1432(%rsp,%r13)
	movq	64(%rsp), %rcx
	movq	%rcx, 1440(%rsp,%r13)
	movq	96(%rsp), %rcx
	movq	%rcx, 1448(%rsp,%r13)
	movq	72(%rsp), %rcx
	movq	%rcx, 1456(%rsp,%r13)
	movq	56(%rsp), %rcx
	movq	%rcx, 1464(%rsp,%r13)
	movq	%r12, 1472(%rsp,%r13)
	addq	$8, %r14
	subq	$-128, %r13
	cmpq	%r13, %rsi
	je	.LBB26_18
.LBB26_13:
	movq	(%r14), %rdi
	cmpq	104(%rsp), %rdi
	jae	.LBB26_98
	leaq	(%rdi,%rdi,8), %r12
	shlq	$11, %r12
	cmpq	$16384, 18368(%rax,%r12)
	jne	.LBB26_97
	cmpq	$0, 1936(%rax,%r12)
	jne	.LBB26_97
	addq	%rax, %r12
	leaq	1984(%r12), %r15
	leaq	3008(%r12), %rdx
	leaq	4032(%r12), %rdi
	leaq	5056(%r12), %r8
	leaq	6080(%r12), %r9
	leaq	7104(%r12), %r10
	leaq	8128(%r12), %r11
	leaq	9152(%r12), %rcx
	movq	%rcx, 32(%rsp)
	leaq	10176(%r12), %rcx
	movq	%rcx, 88(%rsp)
	leaq	11200(%r12), %rcx
	movq	%rcx, 48(%rsp)
	leaq	12224(%r12), %rcx
	movq	%rcx, 80(%rsp)
	leaq	13248(%r12), %rcx
	movq	%rcx, 64(%rsp)
	leaq	14272(%r12), %rcx
	movq	%rcx, 96(%rsp)
	leaq	15296(%r12), %rcx
	movq	%rcx, 72(%rsp)
	leaq	16320(%r12), %rcx
	movq	%rcx, 56(%rsp)
	addq	$17344, %r12
	cmpq	$16384, %r13
	jne	.LBB26_12
	movq	%rdi, 224(%rsp)
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.107(%rip), %rdi
	movq	%rdx, 232(%rsp)
	movq	%r8, 216(%rsp)
	movq	%r9, 208(%rsp)
	movq	%r10, 200(%rsp)
	movq	%r11, 192(%rsp)
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	movq	192(%rsp), %r11
	movq	200(%rsp), %r10
	movq	208(%rsp), %r9
	movq	216(%rsp), %r8
	movq	224(%rsp), %rdi
	movq	232(%rsp), %rdx
	movq	184(%rsp), %rsi
	movq	112(%rsp), %rax
	jmp	.LBB26_12
.LBB26_18:
	movq	168(%rsp), %r13
	movl	%r13d, 1344(%rsp)
	leaq	99832(%rsp), %rdi
	leaq	1344(%rsp), %rsi
	movl	$16392, %edx
	callq	*memcpy@GOTPCREL(%rip)
	movq	160(%rsp), %r9
	movq	112(%rsp), %r8
	movq	136(%rsp), %rdx
	movq	104(%rsp), %rsi
	movl	99832(%rsp), %eax
	leaq	99840(%rsp), %r14
	movq	%rax, 32(%rsp)
	shlq	$4, %rax
	movq	%rax, 80(%rsp)
	xorl	%r12d, %r12d
	jmp	.LBB26_20
	.p2align	4
.LBB26_19:
	movabsq	$18014398509481983, %rax
	andq	%rax, %r15
	movq	%r15, 1352(%rsp,%r12)
	addq	$8, %r12
	cmpq	%r12, %r9
	je	.LBB26_25
.LBB26_20:
	movq	(%rdx,%r12), %rdi
	cmpq	%rsi, %rdi
	jae	.LBB26_100
	leaq	(%rdi,%rdi,8), %rax
	shlq	$11, %rax
	cmpq	$16384, 18368(%r8,%rax)
	jne	.LBB26_99
	cmpq	$0, 1936(%r8,%rax)
	jne	.LBB26_99
	addq	%r8, %rax
	movzbl	105(%rax), %ecx
	shll	$6, %ecx
	movzbl	104(%rax), %r15d
	addl	%ecx, %r15d
	shrl	$10, %r15d
	addq	96(%rax), %r15
	cmpq	$1024, %r12
	jne	.LBB26_19
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.107(%rip), %rdi
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	movq	160(%rsp), %r9
	movq	112(%rsp), %r8
	movq	136(%rsp), %rdx
	movq	104(%rsp), %rsi
	jmp	.LBB26_19
.LBB26_25:
	movl	%r13d, 1344(%rsp)
	leaq	312(%rsp), %rdi
	leaq	1344(%rsp), %rsi
	movl	$1032, %edx
	callq	*memcpy@GOTPCREL(%rip)
	movl	312(%rsp), %ecx
	movzbl	176(%rsp), %eax
	movl	%eax, 132(%rsp)
	movq	%rcx, 88(%rsp)
	testq	%rcx, %rcx
	je	.LBB26_30
	movq	%r14, %rsi
	leaq	320(%rsp), %r13
	movq	40(%rsp), %rax
	shlq	$4, %rax
	addq	$16, %rax
	movq	%rax, 40(%rsp)
	shlq	$4, 32(%rsp)
	shlq	$4, 88(%rsp)
	xorl	%edi, %edi
	movzbl	152(%rsp), %eax
	movq	%rax, 48(%rsp)
	leaq	116288(%rsp), %r15
	.p2align	4
.LBB26_27:
	cmpq	%rdi, 32(%rsp)
	je	.LBB26_93
	leaq	16(%rdi), %r14
	cmpq	%r14, 40(%rsp)
	je	.LBB26_96
	movq	(%r13), %r8
	addq	$8, %r13
	leaq	128(%rsi), %r12
	movl	$16, %edx
	movl	132(%rsp), %edi
	leaq	272(%rsp), %rcx
	xorl	%r9d, %r9d
	pushq	$512
	pushq	%r15
	addq	$512, %r15
	pushq	$2
	pushq	72(%rsp)
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj400_EB8_
	addq	$32, %rsp
	movq	%r12, %rsi
	movq	%r14, %rdi
	cmpq	%r14, 88(%rsp)
	jne	.LBB26_27
.LBB26_30:
	movzbl	152(%rsp), %ecx
	orb	$4, %cl
	movl	$16, %eax
	movq	$0, 248(%rsp)
	movzbl	%cl, %ecx
	movl	%ecx, 244(%rsp)
	movq	120(%rsp), %r15
	movq	144(%rsp), %rdx
	leaq	116288(%rsp), %rsi
	.p2align	4
.LBB26_31:
	movq	%r15, %r12
	movq	%rbx, %r13
	movq	%rdx, %r15
	movq	%rsi, %rbx
	movq	%rax, 192(%rsp)
	movq	%rax, %rcx
	imulq	168(%rsp), %rcx
	movq	%rcx, %rsi
	movabsq	$137438953470, %rax
	andq	%rax, %rsi
	cmpq	%rdx, %rsi
	ja	.LBB26_91
	movq	%rcx, %rax
	shrq	$5, %rax
	xorl	%edx, %edx
	testb	$30, %cl
	setne	%dl
	addq	%rax, %rdx
	je	.LBB26_76
	movq	%r13, 264(%rsp)
	movq	%r12, 144(%rsp)
	movq	%r15, 120(%rsp)
	shlq	$5, %rsi
	movq	%rdx, %rdi
	shlq	$7, %rdi
	xorl	%r15d, %r15d
	movq	%rbx, %r13
	movq	%rcx, 184(%rsp)
	movq	%rdx, 152(%rsp)
	movq	%rdi, 176(%rsp)
	jmp	.LBB26_35
	.p2align	4
.LBB26_36:
	movq	%r13, 32(%rsp)
	movq	%rbx, 48(%rsp)
	movq	%rbx, 64(%rsp)
	movq	%rbx, 72(%rsp)
	movq	%rbx, 96(%rsp)
	movq	%rbx, 80(%rsp)
	movq	%rbx, 88(%rsp)
	movq	%rbx, %rax
	movq	%rbx, %r11
	movq	%rbx, %r10
	movq	%rbx, %r9
	movq	%rbx, %r8
	movq	%rbx, %r13
.LBB26_47:
	movq	%rbx, 56(%rsp)
	movq	%rbx, 40(%rsp)
	movq	%rbx, %r14
	movq	%rbx, %r12
	cmpq	$16384, %r15
	je	.LBB26_48
.LBB26_34:
	movq	%r13, 1352(%rsp,%r15)
	movq	%r8, 1360(%rsp,%r15)
	movq	%r9, 1368(%rsp,%r15)
	movq	%r10, 1376(%rsp,%r15)
	movq	%r11, 1384(%rsp,%r15)
	movq	%rax, 1392(%rsp,%r15)
	movq	88(%rsp), %rax
	movq	%rax, 1400(%rsp,%r15)
	movq	80(%rsp), %rax
	movq	%rax, 1408(%rsp,%r15)
	movq	96(%rsp), %rax
	movq	%rax, 1416(%rsp,%r15)
	movq	72(%rsp), %rax
	movq	%rax, 1424(%rsp,%r15)
	movq	64(%rsp), %rax
	movq	%rax, 1432(%rsp,%r15)
	movq	48(%rsp), %rax
	movq	%rax, 1440(%rsp,%r15)
	movq	56(%rsp), %rax
	movq	%rax, 1448(%rsp,%r15)
	movq	40(%rsp), %rax
	movq	%rax, 1456(%rsp,%r15)
	movq	%r14, 1464(%rsp,%r15)
	movq	%r12, 1472(%rsp,%r15)
	subq	$-128, %r15
	movq	32(%rsp), %r13
	cmpq	%r15, %rdi
	je	.LBB26_75
.LBB26_35:
	cmpq	$64, %rsi
	jb	.LBB26_36
	leaq	64(%r13), %r8
	leaq	-64(%rsi), %rax
	cmpq	$64, %rax
	jae	.LBB26_39
	movq	%r8, 32(%rsp)
	movq	%rax, %rsi
	movq	%rbx, 48(%rsp)
	movq	%rbx, 64(%rsp)
	movq	%rbx, 72(%rsp)
	movq	%rbx, 96(%rsp)
	movq	%rbx, 80(%rsp)
	movq	%rbx, 88(%rsp)
	movq	%rbx, %rax
	movq	%rbx, %r11
	movq	%rbx, %r10
	movq	%rbx, %r9
	movq	%rbx, %r8
	jmp	.LBB26_47
	.p2align	4
.LBB26_39:
	leaq	128(%r13), %r9
	leaq	-128(%rsi), %rax
	cmpq	$64, %rax
	jae	.LBB26_41
	movq	%r9, 32(%rsp)
	movq	%rax, %rsi
	movq	%rbx, 48(%rsp)
	movq	%rbx, 64(%rsp)
	movq	%rbx, 72(%rsp)
	movq	%rbx, 96(%rsp)
	movq	%rbx, 80(%rsp)
	movq	%rbx, 88(%rsp)
	movq	%rbx, %rax
	movq	%rbx, %r11
	movq	%rbx, %r10
	movq	%rbx, %r9
	jmp	.LBB26_47
.LBB26_41:
	leaq	192(%r13), %r10
	leaq	-192(%rsi), %rax
	cmpq	$64, %rax
	jae	.LBB26_43
	movq	%r10, 32(%rsp)
	movq	%rax, %rsi
	movq	%rbx, 48(%rsp)
	movq	%rbx, 64(%rsp)
	movq	%rbx, 72(%rsp)
	movq	%rbx, 96(%rsp)
	movq	%rbx, 80(%rsp)
	movq	%rbx, 88(%rsp)
	movq	%rbx, %rax
	movq	%rbx, %r11
	movq	%rbx, %r10
	jmp	.LBB26_47
.LBB26_43:
	leaq	256(%r13), %r11
	leaq	-256(%rsi), %rax
	cmpq	$64, %rax
	jae	.LBB26_45
	movq	%r11, 32(%rsp)
	movq	%rax, %rsi
	movq	%rbx, 48(%rsp)
	movq	%rbx, 64(%rsp)
	movq	%rbx, 72(%rsp)
	movq	%rbx, 96(%rsp)
	movq	%rbx, 80(%rsp)
	movq	%rbx, 88(%rsp)
	movq	%rbx, %rax
	movq	%rbx, %r11
	jmp	.LBB26_47
.LBB26_45:
	leaq	320(%r13), %r14
	leaq	-320(%rsi), %rax
	cmpq	$64, %rax
	jae	.LBB26_49
	movq	%r14, 32(%rsp)
	movq	%rax, %rsi
	movq	%rbx, 48(%rsp)
	movq	%rbx, 64(%rsp)
	movq	%rbx, 72(%rsp)
	movq	%rbx, 96(%rsp)
	movq	%rbx, 80(%rsp)
	movq	%rbx, 88(%rsp)
	movq	%rbx, %rax
	jmp	.LBB26_47
.LBB26_49:
	leaq	384(%r13), %r14
	leaq	-384(%rsi), %rax
	cmpq	$64, %rax
	jae	.LBB26_51
	movq	%r14, 32(%rsp)
	movq	%rax, %rsi
	movq	%rbx, 48(%rsp)
	movq	%rbx, 64(%rsp)
	movq	%rbx, 72(%rsp)
	movq	%rbx, 96(%rsp)
	movq	%rbx, 80(%rsp)
	movq	%rbx, 88(%rsp)
	jmp	.LBB26_63
.LBB26_51:
	leaq	448(%r13), %r12
	leaq	-448(%rsi), %rax
	cmpq	$64, %rax
	movq	%r14, 88(%rsp)
	jae	.LBB26_53
	movq	%r12, 32(%rsp)
	movq	%rax, %rsi
	movq	%rbx, 48(%rsp)
	movq	%rbx, 64(%rsp)
	movq	%rbx, 72(%rsp)
	movq	%rbx, 96(%rsp)
	movq	%rbx, 80(%rsp)
	jmp	.LBB26_63
.LBB26_53:
	leaq	-512(%rsi), %rax
	cmpq	$64, %rax
	movq	%r12, 80(%rsp)
	jae	.LBB26_55
	leaq	512(%r13), %rsi
	movq	%rsi, 32(%rsp)
	movq	%rax, %rsi
	movq	%rbx, 48(%rsp)
	movq	%rbx, 64(%rsp)
	movq	%rbx, 72(%rsp)
	movq	%rbx, 96(%rsp)
	jmp	.LBB26_63
.LBB26_55:
	leaq	512(%r13), %rax
	movq	%rax, 96(%rsp)
	leaq	-576(%rsi), %rax
	cmpq	$64, %rax
	jae	.LBB26_57
	leaq	576(%r13), %rsi
	movq	%rsi, 32(%rsp)
	movq	%rax, %rsi
	movq	%rbx, 48(%rsp)
	movq	%rbx, 64(%rsp)
	movq	%rbx, 72(%rsp)
	jmp	.LBB26_63
.LBB26_57:
	leaq	576(%r13), %rax
	movq	%rax, 72(%rsp)
	leaq	640(%r13), %r12
	leaq	-640(%rsi), %rax
	cmpq	$64, %rax
	jae	.LBB26_59
	movq	%r12, 32(%rsp)
	movq	%rax, %rsi
	movq	%rbx, 48(%rsp)
	movq	%rbx, 64(%rsp)
	jmp	.LBB26_63
.LBB26_59:
	movq	%r12, 64(%rsp)
	leaq	704(%r13), %r12
	leaq	-704(%rsi), %rax
	cmpq	$64, %rax
	jae	.LBB26_61
	movq	%r12, 32(%rsp)
	movq	%rax, %rsi
	movq	%rbx, 48(%rsp)
	jmp	.LBB26_63
.LBB26_61:
	leaq	-768(%rsi), %rax
	cmpq	$64, %rax
	movq	%r12, 48(%rsp)
	jae	.LBB26_68
	leaq	768(%r13), %rsi
	movq	%rsi, 32(%rsp)
	movq	%rax, %rsi
.LBB26_63:
	movq	%rbx, 56(%rsp)
.LBB26_64:
	movq	%rbx, 40(%rsp)
.LBB26_65:
	movq	%rbx, %r14
.LBB26_66:
	movq	%rbx, %r12
	leaq	320(%r13), %rax
	cmpq	$16384, %r15
	jne	.LBB26_34
.LBB26_48:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.107(%rip), %rdi
	movq	%rsi, 160(%rsp)
	movq	%r8, 232(%rsp)
	movq	%r9, 224(%rsp)
	movq	%r10, 216(%rsp)
	movq	%r11, 208(%rsp)
	movq	%rax, 200(%rsp)
	callq	*_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip)
	movq	200(%rsp), %rax
	movq	208(%rsp), %r11
	movq	216(%rsp), %r10
	movq	224(%rsp), %r9
	movq	232(%rsp), %r8
	movq	176(%rsp), %rdi
	movq	160(%rsp), %rsi
	movq	152(%rsp), %rdx
	movq	184(%rsp), %rcx
	jmp	.LBB26_34
.LBB26_68:
	leaq	768(%r13), %rax
	movq	%rax, 56(%rsp)
	leaq	832(%r13), %r14
	leaq	-832(%rsi), %rax
	cmpq	$64, %rax
	jae	.LBB26_70
	movq	%r14, 32(%rsp)
	movq	%rax, %rsi
	jmp	.LBB26_64
.LBB26_70:
	movq	%r14, 40(%rsp)
	leaq	896(%r13), %r14
	leaq	-896(%rsi), %rax
	cmpq	$64, %rax
	jae	.LBB26_72
	movq	%r14, 32(%rsp)
	movq	%rax, %rsi
	jmp	.LBB26_65
.LBB26_72:
	leaq	960(%r13), %r12
	leaq	-960(%rsi), %rax
	cmpq	$64, %rax
	jae	.LBB26_74
	movq	%r12, 32(%rsp)
	movq	%rax, %rsi
	jmp	.LBB26_66
.LBB26_74:
	leaq	1024(%r13), %rax
	movq	%rax, 32(%rsp)
	addq	$-1024, %rsi
	leaq	320(%r13), %rax
	cmpq	$16384, %r15
	jne	.LBB26_34
	jmp	.LBB26_48
	.p2align	4
.LBB26_75:
	movq	120(%rsp), %r15
	movq	144(%rsp), %r12
	movq	264(%rsp), %r13
	jmp	.LBB26_77
	.p2align	4
.LBB26_76:
	xorl	%edx, %edx
.LBB26_77:
	shrq	%rcx
	movl	%edx, 1344(%rsp)
	movq	%rcx, %r14
	movl	$16392, %edx
	leaq	99832(%rsp), %rdi
	leaq	1344(%rsp), %rsi
	callq	*memcpy@GOTPCREL(%rip)
	movl	99832(%rsp), %eax
	shlq	$4, %rax
	cmpq	%rax, %r14
	ja	.LBB26_92
	cmpq	%r12, %r14
	ja	.LBB26_94
	movq	%r14, %rax
	shlq	$5, %rax
	subq	$8, %rsp
	movl	140(%rsp), %edi
	leaq	99848(%rsp), %rsi
	movq	%r14, %rdx
	leaq	280(%rsp), %rcx
	movl	252(%rsp), %r8d
	movq	%r13, %r9
	pushq	%rax
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj40_EB8_
	addq	$16, %rsp
	movq	192(%rsp), %rcx
	movq	%rcx, %rax
	shrq	%rax
	movq	%r13, %rsi
	movq	%r12, %rdx
	cmpq	$3, %rcx
	ja	.LBB26_31
	movq	%r15, 120(%rsp)
	xorl	%r14d, %r14d
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.39(%rip), %rax
	movq	%rax, 32(%rsp)
	movq	104(%rsp), %rax
	movq	136(%rsp), %r15
	movq	112(%rsp), %rcx
	jmp	.LBB26_84
	.p2align	4
.LBB26_81:
	cmpq	%r12, %r14
	jae	.LBB26_102
	movq	%r14, %rax
	shlq	$5, %rax
	movups	(%r13,%rax), %xmm0
	movups	16(%r13,%rax), %xmm1
.LBB26_83:
	movaps	%xmm1, 1360(%rsp)
	movaps	%xmm0, 1344(%rsp)
	addq	$8, %r15
	incq	%r14
	movq	$0, 18368(%rdi)
	leaq	1344(%rsp), %rsi
	callq	_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore10push_group
	cmpq	256(%rsp), %r15
	movq	104(%rsp), %rax
	movq	112(%rsp), %rcx
	je	.LBB26_90
.LBB26_84:
	movq	(%r15), %rdi
	cmpq	%rax, %rdi
	jae	.LBB26_103
	leaq	(%rdi,%rdi,8), %rdi
	shlq	$11, %rdi
	cmpq	$16384, 18368(%rcx,%rdi)
	jne	.LBB26_101
	cmpq	$0, 1936(%rcx,%rdi)
	jne	.LBB26_101
	addq	%rcx, %rdi
	movzbl	105(%rdi), %eax
	shll	$6, %eax
	movzbl	104(%rdi), %ecx
	addl	%eax, %ecx
	shrl	$10, %ecx
	addq	96(%rdi), %rcx
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 1392(%rsp)
	movaps	%xmm0, 1376(%rsp)
	movaps	%xmm0, 1360(%rsp)
	movaps	%xmm0, 1344(%rsp)
	movabsq	$18014398509481983, %rax
	testq	%rax, %rcx
	jne	.LBB26_81
	leaq	(%r14,%r14), %rcx
	leaq	1(,%r14,2), %rax
	cmpq	120(%rsp), %rax
	jae	.LBB26_95
	shlq	$5, %rcx
	movups	(%rbx,%rcx), %xmm0
	movups	16(%rbx,%rcx), %xmm1
	movups	32(%rbx,%rcx), %xmm2
	movups	48(%rbx,%rcx), %xmm3
	movaps	%xmm3, 1392(%rsp)
	movaps	%xmm2, 1376(%rsp)
	jmp	.LBB26_83
.LBB26_90:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.LBB26_91:
	.cfi_def_cfa %rbp, 16
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.45(%rip), %rcx
	movq	248(%rsp), %rdi
	movq	%r15, %rdx
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB26_92:
	movq	%rax, %r12
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.44(%rip), %rcx
	xorl	%edi, %edi
	movq	%r14, %rsi
	movq	%r12, %rdx
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB26_93:
	movq	%rdi, %rsi
	movq	80(%rsp), %rdx
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.47(%rip), %rcx
	addq	$16, %rsi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB26_94:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.43(%rip), %rcx
	xorl	%edi, %edi
	movq	%r14, %rsi
	movq	%r12, %rdx
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB26_95:
	movq	%rcx, 248(%rsp)
	leaq	2(%rcx), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.41(%rip), %rcx
	movq	120(%rsp), %r15
	movq	248(%rsp), %rdi
	movq	%r15, %rdx
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB26_96:
	movq	144(%rsp), %rsi
	movq	%rsi, %rdx
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.46(%rip), %rcx
	addq	$16, %rsi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB26_97:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.111(%rip), %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.112(%rip), %rdx
	movl	$12, %esi
	callq	*_RNvNtCskADBYZwJmSU_4core6option13expect_failed@GOTPCREL(%rip)
.LBB26_98:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.110(%rip), %rdx
	movq	104(%rsp), %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB26_99:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.114(%rip), %rdi
	callq	*_RNvNtCskADBYZwJmSU_4core6option13unwrap_failed@GOTPCREL(%rip)
.LBB26_100:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.113(%rip), %rdx
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB26_101:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.40(%rip), %rdi
	callq	*_RNvNtCskADBYZwJmSU_4core6option13unwrap_failed@GOTPCREL(%rip)
.LBB26_102:
	movq	%r14, %rdi
	movq	%r12, 104(%rsp)
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.42(%rip), %rax
	movq	%rax, 32(%rsp)
.LBB26_103:
	movq	104(%rsp), %rsi
	movq	32(%rsp), %rdx
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB26_104:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.38(%rip), %rdx
	movq	104(%rsp), %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.Lfunc_end26:
	.size	_RINvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohortKj80_EB4_, .Lfunc_end26-_RINvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohortKj80_EB4_

# source blake3_servil-9e4037ac4510b2d3.s
_RNvNtCs8b9n3vPMt31_13blake3_servil4each10flush_held:
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
	subq	$64, %rsp
	movq	$0, (%rsp)
	movq	%rsp, %r11
	subq	$196608, %r11
.LBB212_1:
	subq	$4096, %rsp
	movq	$0, (%rsp)
	cmpq	%r11, %rsp
	jne	.LBB212_1
	subq	$1024, %rsp
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	movq	%rdx, %r14
	movq	%rsi, %r11
	movq	%rdi, %rsi
	movl	(%rdx), %ebx
	testq	%rbx, %rbx
	je	.LBB212_9
	leaq	8(%r14), %rdx
	movq	(%rdx), %rdi
	leaq	(,%rbx,8), %r8
	leaq	(%rdx,%rbx,8), %r15
	xorl	%ecx, %ecx
	movq	%rsi, 32(%rsp)
	.p2align	4
.LBB212_4:
	movq	(%rdx,%rcx), %rax
	cmpq	%r11, %rax
	jae	.LBB212_198
	leaq	(%rax,%rax,8), %rax
	shlq	$11, %rax
	cmpb	$0, 106(%rsi,%rax)
	jne	.LBB212_10
	addq	$8, %rcx
	cmpq	%rcx, %r8
	jne	.LBB212_4
	movq	%rsi, %rdi
	movq	%r11, %rsi
	movq	%rbx, %rcx
	movq	%r11, %r15
	callq	_RINvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohortKj80_EB4_
	movq	%r15, %r11
	movq	32(%rsp), %rsi
	testl	%ebx, %ebx
	jne	.LBB212_151
	jmp	.LBB212_158
.LBB212_9:
	xorl	%ebx, %ebx
	testl	%ebx, %ebx
	jne	.LBB212_151
	jmp	.LBB212_158
.LBB212_10:
	cmpq	%r11, %rdi
	jae	.LBB212_218
	leaq	(%rdi,%rdi,8), %rax
	shlq	$11, %rax
	movzbl	107(%rsi,%rax), %eax
	movq	$0, 120(%rsp)
	cmpl	$3, %eax
	movq	%r11, 24(%rsp)
	movq	%rbx, 16(%rsp)
	movq	%rdx, 40(%rsp)
	movq	%r8, 216(%rsp)
	movq	%r14, 240(%rsp)
	je	.LBB212_14
	cmpl	$4, %eax
	movl	%eax, 116(%rsp)
	jne	.LBB212_22
	movl	$8, %eax
	movq	%rax, 152(%rsp)
	jmp	.LBB212_23
.LBB212_14:
	movq	_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip), %r13
	movq	%rdx, %rbx
	xorl	%r12d, %r12d
.LBB212_15:
	addq	$8, %r12
	.p2align	4
.LBB212_16:
	cmpq	%r15, %rbx
	je	.LBB212_129
	movq	(%rbx), %r14
	cmpq	24(%rsp), %r14
	jae	.LBB212_211
	addq	$8, %rbx
	leaq	(%r14,%r14,8), %rax
	shlq	$11, %rax
	cmpb	$0, 106(%rsi,%rax)
	jne	.LBB212_16
	cmpq	$1032, %r12
	je	.LBB212_21
.LBB212_20:
	movq	%r14, 768(%rsp,%r12)
	movq	120(%rsp), %rax
	incl	%eax
	movq	%rax, 120(%rsp)
	jmp	.LBB212_15
.LBB212_21:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.107(%rip), %rdi
	callq	*%r13
	movq	32(%rsp), %rsi
	jmp	.LBB212_20
.LBB212_22:
	movl	$16, %eax
	movq	%rax, 152(%rsp)
	movb	$1, %al
	movq	%rax, 120(%rsp)
.LBB212_23:
	movl	$0, 66368(%rsp)
	movl	$64, %r15d
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.161(%rip), %rbx
	movq	_RNvNtCskeivrnDCxeX_8arrayvec8arrayvec12extend_panic@GOTPCREL(%rip), %r14
	movq	memset@GOTPCREL(%rip), %r12
	movq	16(%rsp), %r13
	jmp	.LBB212_25
	.p2align	4
.LBB212_24:
	leaq	(%rsp,%r15), %rdi
	addq	$768, %rdi
	decq	%r13
	movl	$512, %edx
	xorl	%esi, %esi
	callq	*%r12
	addq	$512, %r15
	testq	%r13, %r13
	je	.LBB212_27
.LBB212_25:
	cmpq	$65600, %r15
	jne	.LBB212_24
	movq	%rbx, %rdi
	callq	*%r14
	jmp	.LBB212_24
.LBB212_27:
	movq	16(%rsp), %r13
	movl	%r13d, 768(%rsp)
	movl	66368(%rsp), %r15d
	movq	%r15, %r12
	shlq	$8, %r12
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.162(%rip), %rbx
	pxor	%xmm0, %xmm0
	jmp	.LBB212_29
	.p2align	4
.LBB212_28:
	leaq	(%rsp,%r12), %rax
	addq	$66432, %rax
	decq	%r13
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
	addq	$256, %r12
	testq	%r13, %r13
	je	.LBB212_31
.LBB212_29:
	cmpq	$32768, %r12
	jne	.LBB212_28
	movq	%rbx, %rdi
	callq	*%r14
	pxor	%xmm0, %xmm0
	jmp	.LBB212_28
.LBB212_31:
	movq	16(%rsp), %r13
	leal	(%r15,%r13), %eax
	movl	%eax, 66368(%rsp)
	leaq	99200(%rsp), %rdi
	leaq	768(%rsp), %rsi
	movl	$98432, %edx
	callq	*memcpy@GOTPCREL(%rip)
	movl	99200(%rsp), %ecx
	leaq	99264(%rsp), %rdx
	shlq	$4, %rcx
	movl	164800(%rsp), %eax
	leaq	164864(%rsp), %r12
	shlq	$3, %rax
	movq	%rax, 96(%rsp)
	shlq	$4, %r13
	movq	%rcx, 80(%rsp)
	leaq	16(%rcx), %rax
	movq	%rax, 48(%rsp)
	xorl	%r10d, %r10d
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.327(%rip), %rax
	movq	%rax, 8(%rsp)
	movq	%rdx, %rax
	movq	40(%rsp), %r15
	.p2align	4
.LBB212_32:
	movq	(%r15), %rdi
	cmpq	24(%rsp), %rdi
	movq	32(%rsp), %rdx
	jae	.LBB212_217
	leaq	(%rdi,%rdi,8), %rcx
	shlq	$11, %rcx
	cmpq	$16384, 18368(%rdx,%rcx)
	jne	.LBB212_199
	cmpq	$0, 1936(%rdx,%rcx)
	jne	.LBB212_199
	addq	%rdx, %rcx
	leaq	1984(%rcx), %rdi
	movzbl	105(%rcx), %esi
	movzbl	104(%rcx), %r8d
	movq	96(%rcx), %rdx
	movq	%rdi, 768(%rsp)
	leaq	3008(%rcx), %rdi
	movq	%rdi, 776(%rsp)
	leaq	4032(%rcx), %rdi
	movq	%rdi, 784(%rsp)
	leaq	5056(%rcx), %rdi
	movq	%rdi, 792(%rsp)
	leaq	6080(%rcx), %rdi
	movq	%rdi, 800(%rsp)
	leaq	7104(%rcx), %rdi
	movq	%rdi, 808(%rsp)
	leaq	8128(%rcx), %rdi
	movq	%rdi, 816(%rsp)
	leaq	9152(%rcx), %rdi
	movq	%rdi, 824(%rsp)
	leaq	10176(%rcx), %rdi
	movq	%rdi, 832(%rsp)
	leaq	11200(%rcx), %rdi
	movq	%rdi, 840(%rsp)
	leaq	12224(%rcx), %rdi
	movq	%rdi, 848(%rsp)
	leaq	13248(%rcx), %rdi
	movq	%rdi, 856(%rsp)
	leaq	14272(%rcx), %rdi
	movq	%rdi, 864(%rsp)
	leaq	15296(%rcx), %rdi
	movq	%rdi, 872(%rsp)
	leaq	16320(%rcx), %rdi
	movq	%rdi, 880(%rsp)
	leaq	17344(%rcx), %rdi
	movq	%rdi, 888(%rsp)
	leaq	16(%r10), %r14
	cmpq	%r14, 48(%rsp)
	je	.LBB212_170
	addq	$8, %r15
	movq	%r12, %rbx
	leaq	512(%rax), %r12
	shll	$6, %esi
	addl	%esi, %r8d
	shrl	$10, %r8d
	addq	%rdx, %r8
	movabsq	$18014398509481983, %rdx
	andq	%rdx, %r8
	movzbl	106(%rcx), %r10d
	subq	$-128, %rcx
	movzbl	116(%rsp), %edi
	movl	$16, %edx
	leaq	768(%rsp), %rsi
	xorl	%r9d, %r9d
	pushq	$512
	pushq	%rax
	pushq	$2
	pushq	%r10
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj400_EB8_
	movq	72(%rsp), %r9
	addq	$32, %rsp
	movq	%r12, %rax
	movq	%rbx, %r12
	movq	%r14, %r10
	cmpq	%r14, %r13
	movq	16(%rsp), %r14
	jne	.LBB212_32
	movq	152(%rsp), %rax
	rep		bsfq	%rax, %rcx
	movq	%rcx, 320(%rsp)
	leaq	-1(%rax), %rcx
	movq	%rcx, 312(%rsp)
	movl	%eax, %ecx
	shll	$5, %ecx
	movq	%rcx, 336(%rsp)
	shll	$6, %eax
	movq	%rax, 248(%rsp)
	xorl	%ecx, %ecx
	movq	24(%rsp), %r11
	movq	80(%rsp), %rdx
	leaq	99264(%rsp), %rsi
	jmp	.LBB212_39
	.p2align	4
.LBB212_38:
	movq	192(%rsp), %rcx
	incq	%rcx
	movq	72(%rsp), %rsi
	movq	128(%rsp), %rdx
	cmpq	$4, %rcx
	movq	16(%rsp), %r14
	je	.LBB212_159
.LBB212_39:
	movq	96(%rsp), %rax
	movq	%rax, 128(%rsp)
	movq	%r12, 72(%rsp)
	movl	$8, %eax
	movq	%rcx, 192(%rsp)
	shrq	%cl, %rax
	movq	%rdx, 96(%rsp)
	movq	%rsi, 200(%rsp)
	imulq	%r14, %rax
	movq	%rax, 208(%rsp)
	movq	320(%rsp), %rcx
	shrq	%cl, %rax
	movq	%rax, 328(%rsp)
	movq	%rax, %rdx
	imulq	152(%rsp), %rdx
	movq	312(%rsp), %rax
	movq	%rdx, 184(%rsp)
	leaq	(%rax,%rdx), %rsi
	shrq	%cl, %rsi
	testq	%rsi, %rsi
	je	.LBB212_76
	movq	96(%rsp), %rdx
	shlq	$5, %rdx
	movq	192(%rsp), %rax
	xorq	$3, %rax
	movq	%rax, 48(%rsp)
	cmpb	$0, 120(%rsp)
	movq	%rdx, 8(%rsp)
	je	.LBB212_49
	xorl	%r13d, %r13d
	xorl	%r15d, %r15d
	.p2align	4
.LBB212_42:
	movq	152(%rsp), %rax
	leaq	(%r15,%rax), %r12
	decq	%rsi
	movq	%rsi, 104(%rsp)
	movl	$17, %eax
	movq	%r15, 80(%rsp)
	movq	%r13, 160(%rsp)
	movq	32(%rsp), %r8
	movq	200(%rsp), %r10
	.p2align	4
.LBB212_43:
	movq	%r15, %rdi
	movq	48(%rsp), %rcx
	shrq	%cl, %rdi
	cmpq	%r14, %rdi
	jae	.LBB212_194
	movq	(%r9,%rdi,8), %rdi
	cmpq	%r11, %rdi
	jae	.LBB212_207
	leaq	63(%r13), %rcx
	cmpq	%rdx, %rcx
	jae	.LBB212_183
	leaq	(%r10,%r13), %rcx
	leaq	(%rdi,%rdi,8), %rsi
	shlq	$11, %rsi
	leaq	(%r8,%rsi), %rdi
	addq	$128, %rdi
	movzbl	106(%r8,%rsi), %esi
	orb	$4, %sil
	movq	%rcx, 751(%rsp,%rax)
	movq	%rdi, 759(%rsp,%rax)
	movb	$64, 767(%rsp,%rax)
	movb	%sil, 768(%rsp,%rax)
	addq	$24, %rax
	addq	$64, %r13
	incq	%r15
	cmpq	$401, %rax
	jne	.LBB212_43
	movq	%r11, %rbx
	movl	$384, %edx
	leaq	352(%rsp), %r15
	movq	%r15, %rdi
	leaq	768(%rsp), %rsi
	callq	*memcpy@GOTPCREL(%rip)
	movq	80(%rsp), %rsi
	leaq	16(%rsi), %r13
	cmpq	128(%rsp), %r13
	ja	.LBB212_181
	shlq	$5, %rsi
	addq	72(%rsp), %rsi
	movq	%r15, %rdi
	callq	*blake3_servil_output16@GOTPCREL(%rip)
	movq	160(%rsp), %r13
	addq	248(%rsp), %r13
	movq	%r12, %r15
	movq	104(%rsp), %rsi
	testq	%rsi, %rsi
	movq	40(%rsp), %r9
	movq	%rbx, %r11
	movq	8(%rsp), %rdx
	jne	.LBB212_42
	jmp	.LBB212_76
	.p2align	4
.LBB212_49:
	movl	$511, %r13d
	movq	72(%rsp), %r12
	xorl	%r15d, %r15d
	.p2align	4
.LBB212_50:
	movq	%r15, %rdi
	movq	48(%rsp), %rcx
	shrq	%cl, %rdi
	cmpq	%r14, %rdi
	jae	.LBB212_194
	movq	(%r9,%rdi,8), %rdi
	cmpq	%r11, %rdi
	jae	.LBB212_207
	leaq	-448(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB212_171
	leaq	1(%r15), %rax
	movq	48(%rsp), %rcx
	shrq	%cl, %rax
	cmpq	%r14, %rax
	jae	.LBB212_196
	movq	(%r9,%rax,8), %rbx
	cmpq	%r11, %rbx
	jae	.LBB212_201
	leaq	-384(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB212_172
	leaq	2(%r15), %rax
	movq	48(%rsp), %rcx
	shrq	%cl, %rax
	cmpq	%r14, %rax
	jae	.LBB212_196
	movq	(%r9,%rax,8), %r8
	cmpq	%r11, %r8
	jae	.LBB212_204
	leaq	-320(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB212_173
	leaq	3(%r15), %rax
	movq	48(%rsp), %rcx
	shrq	%cl, %rax
	cmpq	%r14, %rax
	jae	.LBB212_196
	movq	(%r9,%rax,8), %rcx
	cmpq	%r11, %rcx
	jae	.LBB212_205
	leaq	-256(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB212_174
	movq	%rcx, 160(%rsp)
	movq	%rsi, 104(%rsp)
	leaq	4(%r15), %rax
	movq	48(%rsp), %rcx
	shrq	%cl, %rax
	cmpq	%r14, %rax
	jae	.LBB212_196
	movq	(%r9,%rax,8), %r10
	cmpq	%r11, %r10
	jae	.LBB212_202
	leaq	-192(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB212_175
	leaq	5(%r15), %rax
	movq	48(%rsp), %rcx
	shrq	%cl, %rax
	cmpq	%r14, %rax
	jae	.LBB212_196
	movq	(%r9,%rax,8), %rsi
	cmpq	%r11, %rsi
	jae	.LBB212_200
	leaq	-128(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB212_176
	movq	%r15, 80(%rsp)
	leaq	6(%r15), %rax
	movq	48(%rsp), %rcx
	shrq	%cl, %rax
	cmpq	%r14, %rax
	jae	.LBB212_196
	movq	(%r9,%rax,8), %r15
	cmpq	%r11, %r15
	jae	.LBB212_206
	leaq	-64(%r13), %rax
	cmpq	%rdx, %rax
	jae	.LBB212_177
	movq	%rsi, 224(%rsp)
	movq	%r8, %rsi
	movq	%r12, %r8
	movq	%r11, %r12
	movq	80(%rsp), %rax
	addq	$7, %rax
	movq	%rax, %r11
	movq	48(%rsp), %rcx
	shrq	%cl, %r11
	cmpq	%r14, %r11
	jae	.LBB212_209
	movq	(%r9,%r11,8), %r11
	cmpq	%r12, %r11
	jae	.LBB212_208
	movq	8(%rsp), %rdx
	cmpq	%rdx, %r13
	jae	.LBB212_178
	cmpq	128(%rsp), %rax
	jae	.LBB212_179
	leaq	(%rdi,%rdi,8), %rax
	shlq	$11, %rax
	movq	32(%rsp), %r9
	leaq	(%r9,%rax), %rcx
	movq	%rcx, 272(%rsp)
	leaq	(%rbx,%rbx,8), %r12
	shlq	$11, %r12
	leaq	(%r9,%r12), %rcx
	movq	%rcx, 256(%rsp)
	leaq	(%rsi,%rsi,8), %r14
	shlq	$11, %r14
	leaq	(%r9,%r14), %rcx
	movq	%rcx, 344(%rsp)
	movq	160(%rsp), %rcx
	leaq	(%rcx,%rcx,8), %rcx
	shlq	$11, %rcx
	leaq	(%r9,%rcx), %rbx
	leaq	(%r10,%r10,8), %rdx
	shlq	$11, %rdx
	movq	%rdx, 288(%rsp)
	movzbl	106(%r9,%rax), %eax
	movq	%r8, 160(%rsp)
	movzbl	106(%r9,%r12), %r8d
	shll	$8, %r8d
	orl	%eax, %r8d
	leaq	(%r9,%rdx), %r12
	movq	224(%rsp), %rax
	leaq	(%rax,%rax,8), %r10
	shlq	$11, %r10
	movzbl	106(%r9,%r14), %eax
	shll	$16, %eax
	orl	%r8d, %eax
	leaq	(%r15,%r15,8), %r8
	shlq	$11, %r8
	movzbl	106(%r9,%rcx), %r14d
	shll	$24, %r14d
	orl	%eax, %r14d
	leaq	(%r9,%r8), %rcx
	leaq	(%r11,%r11,8), %r15
	shlq	$11, %r15
	movd	%r14d, %xmm0
	movq	200(%rsp), %rdx
	leaq	(%rdx,%r13), %r11
	addq	$-511, %r11
	movq	%r11, 768(%rsp)
	leaq	-447(%rdx,%r13), %rax
	movq	%rax, 776(%rsp)
	leaq	-383(%rdx,%r13), %rax
	movq	%rax, 784(%rsp)
	leaq	-319(%rdx,%r13), %rax
	movq	%rax, 792(%rsp)
	leaq	-255(%rdx,%r13), %rax
	movq	%rax, 800(%rsp)
	leaq	-191(%rdx,%r13), %rax
	movq	%rax, 808(%rsp)
	leaq	-127(%rdx,%r13), %rax
	movq	%rax, 816(%rsp)
	leaq	-63(%rdx,%r13), %rax
	movq	%rax, 824(%rsp)
	movq	272(%rsp), %rdx
	movl	128(%rdx), %eax
	movl	%eax, 832(%rsp)
	movq	256(%rsp), %rsi
	movl	128(%rsi), %eax
	movl	%eax, 836(%rsp)
	movq	344(%rsp), %r11
	movl	128(%r11), %eax
	movl	%eax, 840(%rsp)
	movl	128(%rbx), %eax
	movl	%eax, 844(%rsp)
	movl	128(%r12), %eax
	movl	%eax, 848(%rsp)
	leaq	(%r9,%r10), %rdi
	movl	128(%rdi), %eax
	movl	%eax, 852(%rsp)
	movl	128(%rcx), %eax
	movl	%eax, 856(%rsp)
	movl	128(%r9,%r15), %eax
	movl	%eax, 860(%rsp)
	movl	132(%rdx), %eax
	movl	%eax, 864(%rsp)
	movl	132(%rsi), %eax
	movl	%eax, 868(%rsp)
	movl	132(%r11), %eax
	movl	%eax, 872(%rsp)
	movl	132(%rbx), %eax
	movl	%eax, 876(%rsp)
	movl	132(%r12), %eax
	movl	%eax, 880(%rsp)
	movl	132(%rdi), %eax
	movl	%eax, 884(%rsp)
	movl	132(%rcx), %eax
	movl	%eax, 888(%rsp)
	movl	132(%r9,%r15), %eax
	movl	%eax, 892(%rsp)
	movl	136(%rdx), %eax
	movl	%eax, 896(%rsp)
	movl	136(%rsi), %eax
	movl	%eax, 900(%rsp)
	movl	136(%r11), %eax
	movl	%eax, 904(%rsp)
	movl	136(%rbx), %eax
	movl	%eax, 908(%rsp)
	movl	136(%r12), %eax
	movl	%eax, 912(%rsp)
	movl	136(%rdi), %eax
	movl	%eax, 916(%rsp)
	movl	136(%rcx), %eax
	movl	%eax, 920(%rsp)
	movl	136(%r9,%r15), %eax
	movl	%eax, 924(%rsp)
	movl	140(%rdx), %eax
	movl	%eax, 928(%rsp)
	movl	140(%rsi), %eax
	movl	%eax, 932(%rsp)
	movl	140(%r11), %eax
	movl	%eax, 936(%rsp)
	movl	140(%rbx), %eax
	movl	%eax, 940(%rsp)
	movl	140(%r12), %eax
	movl	%eax, 944(%rsp)
	movl	140(%rdi), %eax
	movl	%eax, 948(%rsp)
	movl	140(%rcx), %eax
	movl	%eax, 952(%rsp)
	movl	140(%r9,%r15), %eax
	movl	%eax, 956(%rsp)
	movl	144(%rdx), %eax
	movl	%eax, 960(%rsp)
	movl	144(%rsi), %eax
	movl	%eax, 964(%rsp)
	movl	144(%r11), %eax
	movl	%eax, 968(%rsp)
	movl	144(%rbx), %eax
	movl	%eax, 972(%rsp)
	movl	144(%r12), %eax
	movl	%eax, 976(%rsp)
	movl	144(%rdi), %eax
	movl	%eax, 980(%rsp)
	movl	144(%rcx), %eax
	movl	%eax, 984(%rsp)
	movl	144(%r9,%r15), %eax
	movl	%eax, 988(%rsp)
	movl	148(%rdx), %eax
	movl	%eax, 992(%rsp)
	movl	148(%rsi), %eax
	movl	%eax, 996(%rsp)
	movl	148(%r11), %eax
	movl	%eax, 1000(%rsp)
	movl	148(%rbx), %eax
	movl	%eax, 1004(%rsp)
	movl	148(%r12), %eax
	movl	%eax, 1008(%rsp)
	movl	148(%rdi), %eax
	movl	%eax, 1012(%rsp)
	movl	148(%rcx), %eax
	movl	%eax, 1016(%rsp)
	movl	148(%r9,%r15), %eax
	movl	%eax, 1020(%rsp)
	movl	152(%rdx), %eax
	movl	%eax, 1024(%rsp)
	movl	152(%rsi), %eax
	movl	%eax, 1028(%rsp)
	movl	152(%r11), %eax
	movl	%eax, 1032(%rsp)
	movl	152(%rbx), %eax
	movl	%eax, 1036(%rsp)
	movl	152(%r12), %eax
	movl	%eax, 1040(%rsp)
	movl	152(%rdi), %eax
	movl	%eax, 1044(%rsp)
	movl	152(%rcx), %eax
	movl	%eax, 1048(%rsp)
	movl	152(%r9,%r15), %eax
	movl	%eax, 1052(%rsp)
	movl	156(%rdx), %eax
	movl	%eax, 1056(%rsp)
	movl	156(%rsi), %eax
	movl	%eax, 1060(%rsp)
	movl	156(%r11), %eax
	movl	%eax, 1064(%rsp)
	movl	156(%rbx), %eax
	movl	%eax, 1068(%rsp)
	movl	156(%r12), %eax
	movl	%eax, 1072(%rsp)
	movl	156(%rdi), %eax
	movl	%eax, 1076(%rsp)
	movq	288(%rsp), %rax
	movzbl	106(%r9,%rax), %eax
	movzbl	106(%r9,%r10), %edx
	movl	156(%rcx), %ecx
	movl	%ecx, 1080(%rsp)
	movl	156(%r9,%r15), %ecx
	movl	%ecx, 1084(%rsp)
	movzbl	%al, %eax
	movzbl	%dl, %ecx
	shll	$8, %ecx
	orl	%eax, %ecx
	movzbl	106(%r9,%r8), %eax
	movzbl	%al, %eax
	shll	$16, %eax
	orl	%ecx, %eax
	movzbl	106(%r9,%r15), %ecx
	shll	$24, %ecx
	orl	%eax, %ecx
	movd	%ecx, %xmm1
	movdqa	.LCPI212_6(%rip), %xmm2
	por	%xmm2, %xmm0
	movdqa	.LCPI212_7(%rip), %xmm3
	movdqa	%xmm3, 1088(%rsp)
	movdqa	%xmm3, 1104(%rsp)
	pxor	%xmm3, %xmm3
	punpcklbw	%xmm3, %xmm0
	punpcklwd	%xmm3, %xmm0
	movdqa	%xmm0, 1120(%rsp)
	movq	80(%rsp), %r15
	addq	152(%rsp), %r15
	movq	104(%rsp), %r14
	decq	%r14
	por	%xmm2, %xmm1
	punpcklbw	%xmm3, %xmm1
	punpcklwd	%xmm3, %xmm1
	movdqa	%xmm1, 1136(%rsp)
	leaq	768(%rsp), %rdi
	movq	160(%rsp), %rbx
	movq	%rbx, %rsi
	callq	*blake3_servil_output8@GOTPCREL(%rip)
	movq	%r14, %rsi
	movq	16(%rsp), %r14
	movq	24(%rsp), %r11
	movq	8(%rsp), %rdx
	movq	40(%rsp), %r9
	addq	336(%rsp), %rbx
	addq	248(%rsp), %r13
	testq	%rsi, %rsi
	movq	%rbx, %r12
	jne	.LBB212_50
.LBB212_76:
	movq	208(%rsp), %rax
	subq	184(%rsp), %rax
	cmpq	$8, %rax
	setae	%al
	testb	%al, 120(%rsp)
	movq	32(%rsp), %rdx
	movq	200(%rsp), %r12
	movq	128(%rsp), %rbx
	je	.LBB212_79
	movzbl	_RNvNvNtCs8b9n3vPMt31_13blake3_servil8platform12x86_features8FEATURES.0(%rip), %eax
	testb	%al, %al
	je	.LBB212_82
	testb	$4, %al
	jne	.LBB212_83
.LBB212_79:
	movq	%rbx, %rax
	shlq	$5, %rax
	addq	72(%rsp), %rax
	movq	%rax, 80(%rsp)
	movq	192(%rsp), %rax
	xorq	$3, %rax
	movq	%rax, 48(%rsp)
	movq	96(%rsp), %rax
	shlq	$5, %rax
	movq	%rax, 8(%rsp)
	cmpq	$0, 328(%rsp)
	jne	.LBB212_128
	testq	%rbx, %rbx
	je	.LBB212_38
	movl	$1, %r15d
	movq	$-1, %rbx
	movq	72(%rsp), %r14
	xorl	%r13d, %r13d
	jmp	.LBB212_112
.LBB212_82:
	callq	_RNvNtCs8b9n3vPMt31_13blake3_servil8platform17read_x86_features
	movq	24(%rsp), %r11
	movq	40(%rsp), %r9
	movq	32(%rsp), %rdx
	movb	%al, _RNvNvNtCs8b9n3vPMt31_13blake3_servil8platform12x86_features8FEATURES.0(%rip)
	testb	$4, %al
	je	.LBB212_79
.LBB212_83:
	movq	192(%rsp), %rcx
	xorq	$3, %rcx
	movq	184(%rsp), %r15
	movq	%r15, %rdi
	movq	%rcx, 48(%rsp)
	shrq	%cl, %rdi
	cmpq	%r14, %rdi
	jae	.LBB212_194
	movq	(%r9,%rdi,8), %rdi
	cmpq	%r11, %rdi
	jae	.LBB212_207
	movq	96(%rsp), %rcx
	shlq	$5, %rcx
	movq	%r15, %r13
	shlq	$6, %r13
	leaq	63(%r13), %rax
	movq	%rcx, 8(%rsp)
	cmpq	%rcx, %rax
	jae	.LBB212_184
	leaq	1(%r15), %rax
	movq	%rax, %rdx
	movq	48(%rsp), %rcx
	shrq	%cl, %rdx
	cmpq	%r14, %rdx
	jae	.LBB212_221
	movq	(%r9,%rdx,8), %rbx
	cmpq	%r11, %rbx
	jae	.LBB212_201
	shlq	$6, %rax
	leaq	63(%rax), %rcx
	cmpq	8(%rsp), %rcx
	jae	.LBB212_187
	leaq	2(%r15), %rdx
	movq	%rdx, %rsi
	movq	48(%rsp), %rcx
	shrq	%cl, %rsi
	cmpq	%r14, %rsi
	jae	.LBB212_215
	movq	(%r9,%rsi,8), %r10
	cmpq	%r11, %r10
	jae	.LBB212_202
	shlq	$6, %rdx
	leaq	63(%rdx), %rcx
	cmpq	8(%rsp), %rcx
	jae	.LBB212_188
	leaq	3(%r15), %r8
	movq	%r8, %rsi
	movq	48(%rsp), %rcx
	shrq	%cl, %rsi
	cmpq	%r14, %rsi
	jae	.LBB212_215
	movq	(%r9,%rsi,8), %rsi
	cmpq	%r11, %rsi
	jae	.LBB212_200
	shlq	$6, %r8
	leaq	63(%r8), %rcx
	cmpq	8(%rsp), %rcx
	jae	.LBB212_189
	movq	%rsi, 104(%rsp)
	movq	%r10, 80(%rsp)
	leaq	4(%r15), %r10
	movq	%r10, %rsi
	movq	48(%rsp), %rcx
	shrq	%cl, %rsi
	cmpq	%r14, %rsi
	jae	.LBB212_215
	movq	(%r9,%rsi,8), %rsi
	cmpq	%r11, %rsi
	jae	.LBB212_200
	shlq	$6, %r10
	leaq	63(%r10), %rcx
	cmpq	8(%rsp), %rcx
	jae	.LBB212_190
	movq	%rsi, 224(%rsp)
	movq	%rbx, 160(%rsp)
	movq	%r14, %r9
	leaq	5(%r15), %r14
	movq	%r14, %rsi
	movq	48(%rsp), %rcx
	shrq	%cl, %rsi
	cmpq	%r9, %rsi
	jae	.LBB212_219
	movq	40(%rsp), %rcx
	movq	(%rcx,%rsi,8), %rbx
	cmpq	%r11, %rbx
	jae	.LBB212_201
	shlq	$6, %r14
	leaq	63(%r14), %rcx
	cmpq	8(%rsp), %rcx
	jae	.LBB212_191
	leaq	6(%r15), %r9
	movq	%r9, %rsi
	movq	48(%rsp), %rcx
	shrq	%cl, %rsi
	cmpq	16(%rsp), %rsi
	jae	.LBB212_219
	movq	40(%rsp), %rcx
	movq	(%rcx,%rsi,8), %rsi
	cmpq	%r11, %rsi
	jae	.LBB212_200
	shlq	$6, %r9
	leaq	63(%r9), %rcx
	cmpq	8(%rsp), %rcx
	jae	.LBB212_192
	leaq	7(%r15), %r11
	movq	%r11, %r15
	movq	48(%rsp), %rcx
	shrq	%cl, %r15
	cmpq	16(%rsp), %r15
	jae	.LBB212_222
	movq	40(%rsp), %rcx
	movq	(%rcx,%r15,8), %rcx
	cmpq	24(%rsp), %rcx
	jae	.LBB212_224
	shlq	$6, %r11
	leaq	63(%r11), %r15
	cmpq	8(%rsp), %r15
	jae	.LBB212_193
	addq	%r12, %r13
	movq	%r13, 768(%rsp)
	leaq	(%rdi,%rdi,8), %rdi
	shlq	$11, %rdi
	movq	%r12, %r13
	movq	32(%rsp), %r12
	leaq	(%r12,%rdi), %r15
	subq	$-128, %r15
	movq	%r15, 776(%rsp)
	movzbl	106(%r12,%rdi), %edi
	orb	$4, %dil
	movb	$64, 784(%rsp)
	movb	%dil, 785(%rsp)
	addq	%r13, %rax
	movq	%rax, 792(%rsp)
	movq	160(%rsp), %rax
	leaq	(%rax,%rax,8), %rax
	shlq	$11, %rax
	leaq	(%r12,%rax), %rdi
	subq	$-128, %rdi
	movq	%rdi, 800(%rsp)
	movzbl	106(%r12,%rax), %eax
	orb	$4, %al
	movb	$64, 808(%rsp)
	movb	%al, 809(%rsp)
	movq	80(%rsp), %rax
	leaq	(%rax,%rax,8), %rax
	shlq	$11, %rax
	addq	%r13, %rdx
	movq	%rdx, 816(%rsp)
	leaq	(%r12,%rax), %rdx
	subq	$-128, %rdx
	movq	%rdx, 824(%rsp)
	movzbl	106(%r12,%rax), %eax
	orb	$4, %al
	movb	$64, 832(%rsp)
	movb	%al, 833(%rsp)
	movq	104(%rsp), %rax
	leaq	(%rax,%rax,8), %rax
	shlq	$11, %rax
	addq	%r13, %r8
	movq	%r8, 840(%rsp)
	leaq	(%r12,%rax), %rdx
	subq	$-128, %rdx
	movq	%rdx, 848(%rsp)
	movzbl	106(%r12,%rax), %eax
	orb	$4, %al
	movb	$64, 856(%rsp)
	movb	%al, 857(%rsp)
	movq	224(%rsp), %rax
	leaq	(%rax,%rax,8), %rax
	shlq	$11, %rax
	addq	%r13, %r10
	movq	%r10, 864(%rsp)
	leaq	(%r12,%rax), %rdx
	subq	$-128, %rdx
	movq	%rdx, 872(%rsp)
	movzbl	106(%r12,%rax), %eax
	orb	$4, %al
	movb	$64, 880(%rsp)
	movb	%al, 881(%rsp)
	leaq	(%rbx,%rbx,8), %rax
	shlq	$11, %rax
	addq	%r13, %r14
	movq	%r14, 888(%rsp)
	leaq	(%r12,%rax), %rdx
	subq	$-128, %rdx
	movq	%rdx, 896(%rsp)
	movzbl	106(%r12,%rax), %eax
	orb	$4, %al
	movb	$64, 904(%rsp)
	movb	%al, 905(%rsp)
	leaq	(%rsi,%rsi,8), %rax
	shlq	$11, %rax
	addq	%r13, %r9
	movq	%r9, 912(%rsp)
	leaq	(%r12,%rax), %rdx
	subq	$-128, %rdx
	movq	%rdx, 920(%rsp)
	movzbl	106(%r12,%rax), %eax
	orb	$4, %al
	movb	$64, 928(%rsp)
	movb	%al, 929(%rsp)
	addq	%r13, %r11
	leaq	(%rcx,%rcx,8), %rax
	shlq	$11, %rax
	movq	%r11, 936(%rsp)
	leaq	(%r12,%rax), %rcx
	addq	$128, %rcx
	movq	%rcx, 944(%rsp)
	movzbl	106(%r12,%rax), %eax
	orb	$4, %al
	movb	$64, 952(%rsp)
	movb	%al, 953(%rsp)
	movq	184(%rsp), %rsi
	leaq	8(%rsi), %r13
	movq	128(%rsp), %r14
	cmpq	%r14, %rsi
	jae	.LBB212_195
	shlq	$5, %rsi
	movq	72(%rsp), %rbx
	addq	%rbx, %rsi
	movl	$8, %edx
	leaq	768(%rsp), %rdi
	callq	_RINvNtCs8b9n3vPMt31_13blake3_servil10ffi_output10hash_groupKj8_EB4_
	shlq	$5, %r14
	addq	%rbx, %r14
	movq	%r14, 80(%rsp)
	movq	200(%rsp), %r12
.LBB212_109:
	cmpq	%r13, 208(%rsp)
	movq	32(%rsp), %rdx
	movq	40(%rsp), %r9
	movq	24(%rsp), %r11
	jbe	.LBB212_38
	cmpq	128(%rsp), %r13
	jae	.LBB212_38
	movq	%r13, %rbx
	notq	%rbx
	movq	%r13, %r14
	shlq	$5, %r14
	addq	72(%rsp), %r14
	leaq	1(%r13), %r15
.LBB212_112:
	movq	%r13, %rdi
	movq	48(%rsp), %rcx
	shrq	%cl, %rdi
	cmpq	16(%rsp), %rdi
	jae	.LBB212_223
	movq	(%r9,%rdi,8), %rdi
	cmpq	%r11, %rdi
	jae	.LBB212_207
	shlq	$6, %r13
	leaq	63(%r13), %rax
	cmpq	8(%rsp), %rax
	jae	.LBB212_184
	addq	%r12, %r13
	leaq	(%rdi,%rdi,8), %rax
	shlq	$11, %rax
	movzbl	106(%rdx,%rax), %ecx
	orb	$4, %cl
	movaps	128(%rdx,%rax), %xmm0
	movaps	144(%rdx,%rax), %xmm1
	movaps	%xmm1, 784(%rsp)
	movaps	%xmm0, 768(%rsp)
	movzbl	%cl, %r8d
	cmpb	$5, 116(%rsp)
	jne	.LBB212_117
	leaq	768(%rsp), %rdi
	movq	%r13, %rsi
	movl	$64, %edx
	xorl	%ecx, %ecx
	callq	*blake3_servil_compress_in_place_avx512@GOTPCREL(%rip)
	jmp	.LBB212_118
.LBB212_117:
	leaq	768(%rsp), %rdi
	movq	%r13, %rsi
	movl	$64, %edx
	xorl	%ecx, %ecx
	callq	*blake3_servil_compress_in_place_sse41@GOTPCREL(%rip)
.LBB212_118:
	movdqa	768(%rsp), %xmm0
	movdqa	784(%rsp), %xmm1
	movdqu	%xmm1, 16(%r14)
	movdqu	%xmm0, (%r14)
	addq	208(%rsp), %rbx
	movq	32(%rsp), %rdx
	movq	40(%rsp), %r9
	movq	24(%rsp), %r11
	je	.LBB212_38
	addq	$32, %r14
	movq	%r15, %r13
	shlq	$6, %r13
	jmp	.LBB212_122
	.p2align	4
.LBB212_120:
	leaq	768(%rsp), %rdi
	movl	$64, %edx
	xorl	%ecx, %ecx
	callq	*blake3_servil_compress_in_place_avx512@GOTPCREL(%rip)
.LBB212_121:
	decq	%rbx
	movdqa	768(%rsp), %xmm0
	movdqa	784(%rsp), %xmm1
	movdqu	%xmm1, 16(%r14)
	movdqu	%xmm0, (%r14)
	addq	$32, %r14
	addq	$64, %r13
	incq	%r15
	testq	%rbx, %rbx
	movq	32(%rsp), %rdx
	movq	40(%rsp), %r9
	movq	24(%rsp), %r11
	je	.LBB212_38
.LBB212_122:
	cmpq	80(%rsp), %r14
	je	.LBB212_38
	movq	%r15, %rdi
	movq	48(%rsp), %rcx
	shrq	%cl, %rdi
	cmpq	16(%rsp), %rdi
	jae	.LBB212_223
	movq	(%r9,%rdi,8), %rdi
	cmpq	%r11, %rdi
	jae	.LBB212_207
	leaq	63(%r13), %rax
	cmpq	8(%rsp), %rax
	jae	.LBB212_182
	leaq	(%r12,%r13), %rsi
	leaq	(%rdi,%rdi,8), %rax
	shlq	$11, %rax
	movzbl	106(%rdx,%rax), %ecx
	orb	$4, %cl
	movaps	128(%rdx,%rax), %xmm0
	movaps	144(%rdx,%rax), %xmm1
	movaps	%xmm1, 784(%rsp)
	movaps	%xmm0, 768(%rsp)
	movzbl	%cl, %r8d
	cmpb	$5, 116(%rsp)
	je	.LBB212_120
	leaq	768(%rsp), %rdi
	movl	$64, %edx
	xorl	%ecx, %ecx
	callq	*blake3_servil_compress_in_place_sse41@GOTPCREL(%rip)
	jmp	.LBB212_121
.LBB212_128:
	movq	184(%rsp), %r13
	jmp	.LBB212_109
.LBB212_129:
	movq	120(%rsp), %rax
	movl	%eax, 768(%rsp)
	leaq	99200(%rsp), %rdi
	leaq	768(%rsp), %rbx
	movl	$1032, %edx
	movq	%rbx, %rsi
	callq	*memcpy@GOTPCREL(%rip)
	movl	99200(%rsp), %ecx
	testq	%rcx, %rcx
	movq	24(%rsp), %r11
	je	.LBB212_131
	leaq	99208(%rsp), %rdx
	movq	32(%rsp), %rdi
	movq	%r11, %rsi
	movq	%r11, %r14
	callq	_RINvNtCs8b9n3vPMt31_13blake3_servil4each11hash_cohortKj80_EB4_
	movq	%r14, %r11
.LBB212_131:
	leaq	832(%rsp), %rax
	leaq	1408(%rsp), %rcx
	movq	%rbx, %xmm0
	pshufd	$68, %xmm0, %xmm0
	movdqa	.LCPI212_0(%rip), %xmm1
	paddq	%xmm0, %xmm1
	movdqa	%xmm1, 160(%rsp)
	movdqa	.LCPI212_1(%rip), %xmm1
	paddq	%xmm0, %xmm1
	movdqa	%xmm1, 224(%rsp)
	movdqa	.LCPI212_2(%rip), %xmm1
	paddq	%xmm0, %xmm1
	movdqa	%xmm1, 288(%rsp)
	movdqa	.LCPI212_3(%rip), %xmm1
	paddq	%xmm0, %xmm1
	movdqa	%xmm1, 272(%rsp)
	movdqa	.LCPI212_4(%rip), %xmm1
	paddq	%xmm0, %xmm1
	movdqa	%xmm1, 256(%rsp)
	paddq	.LCPI212_5(%rip), %xmm0
	movdqa	%xmm0, 128(%rsp)
	movq	%rcx, %xmm0
	pshufd	$68, %xmm0, %xmm0
	movdqa	%xmm0, 48(%rsp)
	movq	%rax, %xmm0
	pshufd	$68, %xmm0, %xmm0
	movdqa	%xmm0, 80(%rsp)
	xorl	%r15d, %r15d
	movq	32(%rsp), %rsi
	movq	40(%rsp), %rax
	movq	216(%rsp), %rcx
	jmp	.LBB212_135
	.p2align	4
.LBB212_132:
	movdqa	(%r15), %xmm0
	movdqa	16(%r15), %xmm1
.LBB212_133:
	movdqa	%xmm1, 368(%rsp)
	movdqa	%xmm0, 352(%rsp)
	movq	8(%rsp), %r15
	movq	$0, 18368(%r13)
	movq	%r13, %rdi
	leaq	352(%rsp), %rsi
	callq	_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore10push_group
	movq	32(%rsp), %rsi
	movq	40(%rsp), %rax
	movq	216(%rsp), %rcx
	movq	24(%rsp), %r11
.LBB212_134:
	addq	$8, %r15
	cmpq	%r15, %rcx
	je	.LBB212_150
.LBB212_135:
	movq	(%rax,%r15), %rdi
	cmpq	%r11, %rdi
	jae	.LBB212_210
	leaq	(%rdi,%rdi,8), %r13
	shlq	$11, %r13
	movzbl	106(%rsi,%r13), %ebx
	testb	%bl, %bl
	je	.LBB212_134
	movq	%r15, 8(%rsp)
	addq	%rsi, %r13
	movaps	128(%r13), %xmm0
	movaps	144(%r13), %xmm1
	movaps	%xmm1, 752(%rsp)
	movaps	%xmm0, 736(%rsp)
	movzbl	107(%r13), %r14d
	movq	1936(%r13), %r12
	movq	18368(%r13), %r15
	movl	$1, 768(%rsp)
	movl	$512, %edx
	leaq	832(%rsp), %rdi
	xorl	%esi, %esi
	callq	*memset@GOTPCREL(%rip)
	movl	$1, 1344(%rsp)
	leaq	1408(%rsp), %rax
	xorps	%xmm0, %xmm0
	movaps	%xmm0, (%rax)
	movaps	%xmm0, 16(%rax)
	movaps	%xmm0, 32(%rax)
	movaps	%xmm0, 48(%rax)
	movaps	%xmm0, 64(%rax)
	movaps	%xmm0, 80(%rax)
	movaps	%xmm0, 96(%rax)
	movaps	%xmm0, 112(%rax)
	movaps	%xmm0, 128(%rax)
	movaps	%xmm0, 144(%rax)
	movaps	%xmm0, 160(%rax)
	movaps	%xmm0, 176(%rax)
	movaps	%xmm0, 192(%rax)
	movaps	%xmm0, 208(%rax)
	movaps	%xmm0, 224(%rax)
	movaps	%xmm0, 240(%rax)
	cmpq	$16384, %r15
	jne	.LBB212_212
	testq	%r12, %r12
	jne	.LBB212_212
	leaq	17344(%r13), %rax
	leaq	1984(%r13), %rcx
	movl	$1, 352(%rsp)
	movq	%rcx, 360(%rsp)
	leaq	3008(%r13), %rcx
	movq	%rcx, 368(%rsp)
	leaq	4032(%r13), %rcx
	movq	%rcx, 376(%rsp)
	leaq	5056(%r13), %rcx
	movq	%rcx, 384(%rsp)
	leaq	6080(%r13), %rcx
	movq	%rcx, 392(%rsp)
	leaq	7104(%r13), %rcx
	movq	%rcx, 400(%rsp)
	leaq	8128(%r13), %rcx
	movq	%rcx, 408(%rsp)
	leaq	9152(%r13), %rcx
	movq	%rcx, 416(%rsp)
	leaq	10176(%r13), %rcx
	movq	%rcx, 424(%rsp)
	leaq	11200(%r13), %rcx
	movq	%rcx, 432(%rsp)
	leaq	12224(%r13), %rcx
	movq	%rcx, 440(%rsp)
	leaq	13248(%r13), %rcx
	movq	%rcx, 448(%rsp)
	leaq	14272(%r13), %rcx
	movq	%rcx, 456(%rsp)
	leaq	15296(%r13), %rcx
	movq	%rcx, 464(%rsp)
	leaq	16320(%r13), %rcx
	movq	%rcx, 472(%rsp)
	movq	%rax, 480(%rsp)
	movzbl	105(%r13), %eax
	shll	$6, %eax
	movzbl	104(%r13), %r8d
	addl	%eax, %r8d
	shrl	$10, %r8d
	addq	96(%r13), %r8
	movabsq	$18014398509481983, %r12
	andq	%r12, %r8
	movl	%r14d, %r12d
	cmpl	$5, %r14d
	je	.LBB212_142
	cmpl	$4, %r12d
	jne	.LBB212_144
	movzbl	%bl, %eax
	movl	$16, %esi
	movl	$16, %edx
	leaq	360(%rsp), %rdi
	leaq	736(%rsp), %r14
	movq	%r14, %rcx
	movl	$1, %r9d
	leaq	832(%rsp), %r15
	pushq	%r15
	pushq	$2
	pushq	$1
	pushq	%rax
	callq	*blake3_servil_hash_many_avx2@GOTPCREL(%rip)
	jmp	.LBB212_145
	.p2align	4
.LBB212_142:
	movzbl	_RNvNvNtCs8b9n3vPMt31_13blake3_servil8platform12x86_features8FEATURES.0(%rip), %eax
	testb	%al, %al
	je	.LBB212_149
.LBB212_143:
	movzbl	%bl, %eax
	movl	$16, %esi
	movl	$16, %edx
	leaq	360(%rsp), %rdi
	leaq	736(%rsp), %r14
	movq	%r14, %rcx
	movl	$1, %r9d
	leaq	832(%rsp), %r15
	pushq	%r15
	pushq	$2
	pushq	$1
	pushq	%rax
	callq	*blake3_servil_hash_many_avx512@GOTPCREL(%rip)
	jmp	.LBB212_145
	.p2align	4
.LBB212_144:
	leaq	360(%rsp), %rdi
	movzbl	%bl, %eax
	movl	$16, %esi
	movl	$16, %edx
	leaq	736(%rsp), %r14
	movq	%r14, %rcx
	movl	$1, %r9d
	leaq	832(%rsp), %r15
	pushq	%r15
	pushq	$2
	pushq	$1
	pushq	%rax
	callq	*blake3_servil_hash_many_sse41@GOTPCREL(%rip)
.LBB212_145:
	addq	$32, %rsp
	movl	%r12d, 104(%rsp)
	orb	$4, %bl
	movl	$1, 352(%rsp)
	movaps	160(%rsp), %xmm0
	movups	%xmm0, 376(%rsp)
	movaps	224(%rsp), %xmm0
	movups	%xmm0, 360(%rsp)
	movaps	288(%rsp), %xmm0
	movups	%xmm0, 408(%rsp)
	movaps	272(%rsp), %xmm0
	movups	%xmm0, 392(%rsp)
	movq	%r15, 424(%rsp)
	movaps	80(%rsp), %xmm0
	movups	%xmm0, 448(%rsp)
	movups	%xmm0, 432(%rsp)
	movq	%r15, 464(%rsp)
	movq	%r15, 472(%rsp)
	movq	%r15, 480(%rsp)
	subq	$8, %rsp
	movzbl	%bl, %ebx
	movl	$8, %edx
	movl	%r12d, %edi
	leaq	368(%rsp), %rsi
	movq	%r14, %rcx
	movl	%ebx, %r8d
	leaq	1416(%rsp), %r14
	movq	%r14, %r9
	pushq	$256
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj40_EB8_
	addq	$16, %rsp
	movl	$1, 352(%rsp)
	movaps	256(%rsp), %xmm0
	movups	%xmm0, 376(%rsp)
	movaps	128(%rsp), %xmm0
	movups	%xmm0, 360(%rsp)
	movq	%r14, 392(%rsp)
	movaps	48(%rsp), %xmm0
	movups	%xmm0, 416(%rsp)
	movups	%xmm0, 400(%rsp)
	movups	%xmm0, 448(%rsp)
	movups	%xmm0, 432(%rsp)
	movq	%r14, 464(%rsp)
	movq	%r14, 472(%rsp)
	movq	%r14, 480(%rsp)
	subq	$8, %rsp
	movl	$4, %edx
	movl	112(%rsp), %r12d
	movl	%r12d, %edi
	leaq	368(%rsp), %rsi
	leaq	744(%rsp), %r14
	movq	%r14, %rcx
	movl	%ebx, %r8d
	movq	%r15, %r9
	pushq	$128
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj40_EB8_
	addq	$16, %rsp
	movl	$1, 352(%rsp)
	movq	%r15, 360(%rsp)
	leaq	896(%rsp), %rax
	movq	%rax, 368(%rsp)
	movq	%r15, 376(%rsp)
	movaps	80(%rsp), %xmm0
	movups	%xmm0, 400(%rsp)
	movups	%xmm0, 384(%rsp)
	movups	%xmm0, 432(%rsp)
	movups	%xmm0, 416(%rsp)
	movups	%xmm0, 464(%rsp)
	movups	%xmm0, 448(%rsp)
	movq	%r15, 480(%rsp)
	subq	$8, %rsp
	movl	$2, %edx
	movl	%r12d, %edi
	leaq	368(%rsp), %rsi
	movq	%r14, %rcx
	movl	%ebx, %r8d
	leaq	1416(%rsp), %r9
	pushq	$64
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj40_EB8_
	addq	$16, %rsp
	movl	$1, 352(%rsp)
	movaps	48(%rsp), %xmm0
	movups	%xmm0, 376(%rsp)
	movups	%xmm0, 360(%rsp)
	movups	%xmm0, 408(%rsp)
	movups	%xmm0, 392(%rsp)
	movups	%xmm0, 440(%rsp)
	movups	%xmm0, 424(%rsp)
	movups	%xmm0, 472(%rsp)
	movups	%xmm0, 456(%rsp)
	subq	$8, %rsp
	movl	$1, %edx
	movl	%r12d, %edi
	leaq	368(%rsp), %rsi
	movq	%r14, %rcx
	movl	%ebx, %r8d
	movq	%r15, %r9
	pushq	$32
	callq	_RINvMs0_NtCs8b9n3vPMt31_13blake3_servil8platformNtB6_8Platform9hash_manyKj40_EB8_
	addq	$16, %rsp
	cmpq	$16384, 18368(%r13)
	jne	.LBB212_213
	cmpq	$0, 1936(%r13)
	jne	.LBB212_213
	movzbl	105(%r13), %eax
	shll	$6, %eax
	movzbl	104(%r13), %ecx
	addl	%eax, %ecx
	shrl	$10, %ecx
	addq	96(%r13), %rcx
	leaq	360(%rsp), %r14
	xorps	%xmm0, %xmm0
	movups	%xmm0, 40(%r14)
	movups	%xmm0, 24(%r14)
	movabsq	$18014398509481983, %rax
	testq	%rax, %rcx
	jne	.LBB212_132
	leaq	1408(%rsp), %rax
	movdqa	(%rax), %xmm0
	movdqa	16(%rax), %xmm1
	movdqa	32(%rax), %xmm2
	movdqa	48(%rax), %xmm3
	movdqa	%xmm3, 400(%rsp)
	movdqa	%xmm2, 384(%rsp)
	jmp	.LBB212_133
.LBB212_149:
	movq	%r8, %r12
	callq	_RNvNtCs8b9n3vPMt31_13blake3_servil8platform17read_x86_features
	movq	%r12, %r8
	movl	%r14d, %r12d
	movb	%al, _RNvNvNtCs8b9n3vPMt31_13blake3_servil8platform12x86_features8FEATURES.0(%rip)
	jmp	.LBB212_143
.LBB212_150:
	movq	16(%rsp), %rbx
	movq	240(%rsp), %r14
	testl	%ebx, %ebx
	je	.LBB212_158
.LBB212_151:
	movl	%ebx, %eax
	shlq	$3, %rax
	xorl	%ecx, %ecx
	jmp	.LBB212_153
	.p2align	4
.LBB212_152:
	addq	$8, %rcx
	cmpq	%rcx, %rax
	je	.LBB212_157
.LBB212_153:
	movq	8(%r14,%rcx), %rdi
	cmpq	%r11, %rdi
	jae	.LBB212_197
	leaq	(%rdi,%rdi,8), %rdx
	shlq	$11, %rdx
	cmpq	$16384, 18368(%rsi,%rdx)
	jne	.LBB212_152
	cmpq	$0, 1936(%rsi,%rdx)
	jne	.LBB212_152
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.333(%rip), %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.334(%rip), %rdx
	movl	$61, %esi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking9panic_fmt@GOTPCREL(%rip)
.LBB212_157:
	movl	$0, (%r14)
.LBB212_158:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.LBB212_159:
	.cfi_def_cfa %rbp, 16
	movl	$1, %r14d
	xorl	%ebx, %ebx
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.320(%rip), %rax
	movq	%rax, 8(%rsp)
	leaq	768(%rsp), %r15
	xorl	%r13d, %r13d
	jmp	.LBB212_163
	.p2align	4
.LBB212_160:
	cmpq	128(%rsp), %rbx
	jae	.LBB212_216
	movq	72(%rsp), %rax
	movdqu	(%rax,%r13), %xmm0
	movdqu	16(%rax,%r13), %xmm1
.LBB212_162:
	movdqa	%xmm1, 784(%rsp)
	movdqa	%xmm0, 768(%rsp)
	movq	$0, 18368(%rdi)
	movq	%r15, %rsi
	callq	_RNvMs1_NtCs8b9n3vPMt31_13blake3_servil11incrementalNtB5_10HasherCore10push_group
	addq	$32, %r13
	addq	$2, %r14
	incq	%rbx
	addq	$-8, 216(%rsp)
	movq	40(%rsp), %r9
	movq	24(%rsp), %r11
	je	.LBB212_169
.LBB212_163:
	movq	(%r9,%rbx,8), %rdi
	cmpq	%r11, %rdi
	movq	32(%rsp), %rax
	jae	.LBB212_217
	leaq	(%rdi,%rdi,8), %rdi
	shlq	$11, %rdi
	cmpq	$16384, 18368(%rax,%rdi)
	jne	.LBB212_214
	cmpq	$0, 1936(%rax,%rdi)
	jne	.LBB212_214
	addq	%rax, %rdi
	movzbl	105(%rdi), %eax
	shll	$6, %eax
	movzbl	104(%rdi), %ecx
	addl	%eax, %ecx
	shrl	$10, %ecx
	addq	96(%rdi), %rcx
	pxor	%xmm0, %xmm0
	movdqa	%xmm0, 816(%rsp)
	movdqa	%xmm0, 800(%rsp)
	movdqa	%xmm0, 784(%rsp)
	movdqa	%xmm0, 768(%rsp)
	movabsq	$18014398509481983, %rax
	testq	%rax, %rcx
	jne	.LBB212_160
	cmpq	96(%rsp), %r14
	jae	.LBB212_185
	movdqu	(%r12,%r13,2), %xmm0
	movdqu	16(%r12,%r13,2), %xmm1
	movdqu	32(%r12,%r13,2), %xmm2
	movdqu	48(%r12,%r13,2), %xmm3
	movdqa	%xmm3, 816(%rsp)
	movdqa	%xmm2, 800(%rsp)
	jmp	.LBB212_162
.LBB212_169:
	movl	-8(%r9), %ebx
	movq	240(%rsp), %r14
	movq	32(%rsp), %rsi
	testl	%ebx, %ebx
	jne	.LBB212_151
	jmp	.LBB212_158
.LBB212_170:
	movl	$16, %r13d
	movq	80(%rsp), %r14
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.329(%rip), %rax
	movq	%r10, %rdi
	jmp	.LBB212_180
.LBB212_171:
	addq	$-511, %r13
	leaq	64(%r13), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB212_172:
	addq	$-447, %r13
	leaq	64(%r13), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB212_173:
	addq	$-383, %r13
	leaq	64(%r13), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB212_174:
	addq	$-319, %r13
	leaq	64(%r13), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB212_175:
	addq	$-255, %r13
	leaq	64(%r13), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB212_176:
	addq	$-191, %r13
	leaq	64(%r13), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB212_177:
	addq	$-127, %r13
	leaq	64(%r13), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB212_178:
	addq	$-63, %r13
	leaq	64(%r13), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB212_179:
	movl	$8, %r13d
	movq	128(%rsp), %r14
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.326(%rip), %rax
	movq	80(%rsp), %rdi
.LBB212_180:
	addq	%rdi, %r13
	movq	%rax, %rcx
	movq	%r13, %rsi
	movq	%r14, %rdx
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB212_181:
	movq	128(%rsp), %r14
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.325(%rip), %rcx
	movq	%rsi, %rdi
	movq	%r13, %rsi
	movq	%r14, %rdx
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB212_182:
	movq	8(%rsp), %rdx
.LBB212_183:
	leaq	64(%r13), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB212_185:
	movq	%r14, %rdi
	decq	%rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.322(%rip), %rax
	movl	$2, %r13d
	movq	96(%rsp), %r14
	jmp	.LBB212_180
.LBB212_187:
	movq	%rax, %r13
	jmp	.LBB212_184
.LBB212_188:
	movq	%rdx, %r13
	jmp	.LBB212_184
.LBB212_189:
	movq	%r8, %r13
	jmp	.LBB212_184
.LBB212_190:
	movq	%r10, %r13
	jmp	.LBB212_184
.LBB212_191:
	movq	%r14, %r13
	jmp	.LBB212_184
.LBB212_192:
	movq	%r9, %r13
	jmp	.LBB212_184
.LBB212_193:
	movq	%r11, %r13
.LBB212_184:
	movq	8(%rsp), %rdx
	leaq	64(%r13), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.126(%rip), %rcx
	movq	%r13, %rdi
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB212_194:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.124(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_195:
	movq	%rsi, %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.324(%rip), %rcx
	movq	%r13, %rsi
	movq	%r14, %rdx
	callq	*_RNvNtNtCskADBYZwJmSU_4core5slice5index16slice_index_fail@GOTPCREL(%rip)
.LBB212_196:
	movq	%rax, %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.124(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_197:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.127(%rip), %rdx
	movq	%r11, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_198:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.134(%rip), %rdx
	movq	%rax, %rdi
	movq	%r11, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_199:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.111(%rip), %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.328(%rip), %rdx
	movl	$12, %esi
	callq	*_RNvNtCskADBYZwJmSU_4core6option13expect_failed@GOTPCREL(%rip)
.LBB212_200:
	movq	%rsi, %rdi
	movq	%r11, %r14
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.125(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_201:
	movq	%rbx, %rdi
	movq	%r11, %r14
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.125(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_202:
	movq	%r10, %rdi
	movq	%r11, %r14
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.125(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_204:
	movq	%r8, %rdi
	movq	%r11, %r14
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.125(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_205:
	movq	%rcx, %rdi
	movq	%r11, %r14
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.125(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_206:
	movq	%r15, %rdi
.LBB212_207:
	movq	%r11, %r14
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.125(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_208:
	movq	%r11, %rdi
	movq	%r12, %r14
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.125(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_209:
	movq	%r11, %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.124(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_210:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.358(%rip), %rdx
	movq	%r11, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_211:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.135(%rip), %rdx
	movq	%r14, %rdi
	movq	24(%rsp), %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_212:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.111(%rip), %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.112(%rip), %rdx
	movl	$12, %esi
	callq	*_RNvNtCskADBYZwJmSU_4core6option13expect_failed@GOTPCREL(%rip)
.LBB212_213:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.40(%rip), %rdi
	callq	*_RNvNtCskADBYZwJmSU_4core6option13unwrap_failed@GOTPCREL(%rip)
.LBB212_214:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.321(%rip), %rdi
	callq	*_RNvNtCskADBYZwJmSU_4core6option13unwrap_failed@GOTPCREL(%rip)
.LBB212_215:
	movq	%rsi, %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.124(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_216:
	movq	%rbx, %rdi
	movq	128(%rsp), %rax
	movq	%rax, 24(%rsp)
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.323(%rip), %rax
	movq	%rax, 8(%rsp)
.LBB212_217:
	movq	24(%rsp), %rsi
	movq	8(%rsp), %rdx
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_218:
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.357(%rip), %rdx
	movq	%r11, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_219:
	movq	%rsi, %rdi
	movq	16(%rsp), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.124(%rip), %rdx
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_221:
	movq	%rdx, %rdi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.124(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_222:
	movq	%r15, %rdi
.LBB212_223:
	movq	16(%rsp), %rsi
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.124(%rip), %rdx
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.LBB212_224:
	movq	%rcx, %rdi
	movq	24(%rsp), %r14
	leaq	.Lanon.d189a4455597bb98fde2c4269d24499f.125(%rip), %rdx
	movq	%r14, %rsi
	callq	*_RNvNtCskADBYZwJmSU_4core9panicking18panic_bounds_check@GOTPCREL(%rip)
.Lfunc_end212:
	.size	_RNvNtCs8b9n3vPMt31_13blake3_servil4each10flush_held, .Lfunc_end212-_RNvNtCs8b9n3vPMt31_13blake3_servil4each10flush_held
