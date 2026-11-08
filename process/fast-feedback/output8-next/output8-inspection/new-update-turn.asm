
/home/samshackleton/blake3-reports/optimization-resume-20261108/output8-private-bin/new-1:     file format elf64-x86-64


Disassembly of section .text:

0000000000049710 <blake3_servil::each::update_turn>:
   49710:	55                   	push   %rbp
   49711:	41 57                	push   %r15
   49713:	41 56                	push   %r14
   49715:	41 55                	push   %r13
   49717:	41 54                	push   %r12
   49719:	53                   	push   %rbx
   4971a:	48 81 ec c8 00 00 00 	sub    $0xc8,%rsp
   49721:	44 89 44 24 5c       	mov    %r8d,0x5c(%rsp)
   49726:	49 89 cd             	mov    %rcx,%r13
   49729:	48 89 d3             	mov    %rdx,%rbx
   4972c:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
   49731:	48 83 fe 08          	cmp    $0x8,%rsi
   49735:	48 89 7c 24 50       	mov    %rdi,0x50(%rsp)
   4973a:	0f 82 6e 01 00 00    	jb     498ae <blake3_servil::each::update_turn+0x19e>
   49740:	49 89 ff             	mov    %rdi,%r15
   49743:	48 8b 05 c6 5c 07 00 	mov    0x75cc6(%rip),%rax        # bf410 <_DYNAMIC+0x728>
   4974a:	0f b6 00             	movzbl (%rax),%eax
   4974d:	84 c0                	test   %al,%al
   4974f:	0f 84 72 06 00 00    	je     49dc7 <blake3_servil::each::update_turn+0x6b7>
   49755:	04 fd                	add    $0xfd,%al
   49757:	0f b6 c0             	movzbl %al,%eax
   4975a:	48 8d 04 c5 ff ff ff 	lea    -0x1(,%rax,8),%rax
   49761:	ff 
   49762:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
   49767:	0f 83 41 01 00 00    	jae    498ae <blake3_servil::each::update_turn+0x19e>
   4976d:	4d 85 ed             	test   %r13,%r13
   49770:	0f 84 2b 01 00 00    	je     498a1 <blake3_servil::each::update_turn+0x191>
   49776:	48 89 5c 24 30       	mov    %rbx,0x30(%rsp)
   4977b:	48 83 c3 10          	add    $0x10,%rbx
   4977f:	31 d2                	xor    %edx,%edx
   49781:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   49788:	0f 1f 84 00 00 00 00 
   4978f:	00 
   49790:	48 8b 7b f0          	mov    -0x10(%rbx),%rdi
   49794:	48 3b 7c 24 08       	cmp    0x8(%rsp),%rdi
   49799:	0f 83 49 06 00 00    	jae    49de8 <blake3_servil::each::update_turn+0x6d8>
   4979f:	4c 8d 34 ff          	lea    (%rdi,%rdi,8),%r14
   497a3:	49 c1 e6 0b          	shl    $0xb,%r14
   497a7:	4b 83 bc 37 90 07 00 	cmpq   $0x0,0x790(%r15,%r14,1)
   497ae:	00 00 
   497b0:	0f 85 db 00 00 00    	jne    49891 <blake3_servil::each::update_turn+0x181>
   497b6:	4b 83 7c 37 60 00    	cmpq   $0x0,0x60(%r15,%r14,1)
   497bc:	0f 85 cf 00 00 00    	jne    49891 <blake3_servil::each::update_turn+0x181>
   497c2:	43 80 7c 37 69 00    	cmpb   $0x0,0x69(%r15,%r14,1)
   497c8:	0f 85 c3 00 00 00    	jne    49891 <blake3_servil::each::update_turn+0x181>
   497ce:	4b 83 bc 37 a0 00 00 	cmpq   $0x0,0xa0(%r15,%r14,1)
   497d5:	00 00 
   497d7:	0f 85 b4 00 00 00    	jne    49891 <blake3_servil::each::update_turn+0x181>
   497dd:	4d 01 fe             	add    %r15,%r14
   497e0:	4c 8b 7b f8          	mov    -0x8(%rbx),%r15
   497e4:	4c 8b 23             	mov    (%rbx),%r12
   497e7:	49 8b 86 c0 47 00 00 	mov    0x47c0(%r14),%rax
   497ee:	41 0f b6 4e 68       	movzbl 0x68(%r14),%ecx
   497f3:	48 85 c0             	test   %rax,%rax
   497f6:	74 09                	je     49801 <blake3_servil::each::update_turn+0xf1>
   497f8:	80 f9 40             	cmp    $0x40,%cl
   497fb:	0f 85 90 00 00 00    	jne    49891 <blake3_servil::each::update_turn+0x181>
   49801:	0f b6 f9             	movzbl %cl,%edi
   49804:	4c 01 e0             	add    %r12,%rax
   49807:	48 01 f8             	add    %rdi,%rax
   4980a:	48 3d 00 04 00 00    	cmp    $0x400,%rax
   49810:	77 7f                	ja     49891 <blake3_servil::each::update_turn+0x181>
   49812:	bd 40 00 00 00       	mov    $0x40,%ebp
   49817:	48 29 fd             	sub    %rdi,%rbp
   4981a:	4c 39 e5             	cmp    %r12,%rbp
   4981d:	49 0f 43 ec          	cmovae %r12,%rbp
   49821:	48 8d 34 2f          	lea    (%rdi,%rbp,1),%rsi
   49825:	48 83 fe 41          	cmp    $0x41,%rsi
   49829:	0f 83 40 05 00 00    	jae    49d6f <blake3_servil::each::update_turn+0x65f>
   4982f:	4c 01 f7             	add    %r14,%rdi
   49832:	4c 89 fe             	mov    %r15,%rsi
   49835:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
   4983a:	48 89 ea             	mov    %rbp,%rdx
   4983d:	ff 15 25 57 07 00    	call   *0x75725(%rip)        # bef68 <memcpy@GLIBC_2.14>
   49843:	41 00 6e 68          	add    %bpl,0x68(%r14)
   49847:	49 29 ec             	sub    %rbp,%r12
   4984a:	49 01 ef             	add    %rbp,%r15
   4984d:	49 8b 86 c0 47 00 00 	mov    0x47c0(%r14),%rax
   49854:	49 8d 3c 06          	lea    (%r14,%rax,1),%rdi
   49858:	48 81 c7 c0 07 00 00 	add    $0x7c0,%rdi
   4985f:	4c 89 fe             	mov    %r15,%rsi
   49862:	4c 89 e2             	mov    %r12,%rdx
   49865:	ff 15 fd 56 07 00    	call   *0x756fd(%rip)        # bef68 <memcpy@GLIBC_2.14>
   4986b:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
   49870:	4d 01 a6 c0 47 00 00 	add    %r12,0x47c0(%r14)
   49877:	48 ff c2             	inc    %rdx
   4987a:	48 83 c3 18          	add    $0x18,%rbx
   4987e:	49 39 d5             	cmp    %rdx,%r13
   49881:	4c 8b 7c 24 50       	mov    0x50(%rsp),%r15
   49886:	0f 85 04 ff ff ff    	jne    49790 <blake3_servil::each::update_turn+0x80>
   4988c:	4c 89 ea             	mov    %r13,%rdx
   4988f:	eb 09                	jmp    4989a <blake3_servil::each::update_turn+0x18a>
   49891:	4c 39 ea             	cmp    %r13,%rdx
   49894:	0f 87 38 05 00 00    	ja     49dd2 <blake3_servil::each::update_turn+0x6c2>
   4989a:	48 8b 5c 24 30       	mov    0x30(%rsp),%rbx
   4989f:	eb 02                	jmp    498a3 <blake3_servil::each::update_turn+0x193>
   498a1:	31 d2                	xor    %edx,%edx
   498a3:	49 29 d5             	sub    %rdx,%r13
   498a6:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
   498aa:	48 8d 1c c3          	lea    (%rbx,%rax,8),%rbx
   498ae:	4d 85 ed             	test   %r13,%r13
   498b1:	0f 84 a6 04 00 00    	je     49d5d <blake3_servil::each::update_turn+0x64d>
   498b7:	4a 8d 04 ed 00 00 00 	lea    0x0(,%r13,8),%rax
   498be:	00 
   498bf:	4c 8d 24 40          	lea    (%rax,%rax,2),%r12
   498c3:	ff 15 5f 56 07 00    	call   *0x7565f(%rip)        # bef28 <_DYNAMIC+0x240>
   498c9:	be 08 00 00 00       	mov    $0x8,%esi
   498ce:	4c 89 e7             	mov    %r12,%rdi
   498d1:	ff 15 59 56 07 00    	call   *0x75659(%rip)        # bef30 <_DYNAMIC+0x248>
   498d7:	48 85 c0             	test   %rax,%rax
   498da:	0f 84 1a 05 00 00    	je     49dfa <blake3_servil::each::update_turn+0x6ea>
   498e0:	49 89 c6             	mov    %rax,%r14
   498e3:	48 89 c7             	mov    %rax,%rdi
   498e6:	48 89 de             	mov    %rbx,%rsi
   498e9:	4c 89 e2             	mov    %r12,%rdx
   498ec:	ff 15 76 56 07 00    	call   *0x75676(%rip)        # bef68 <memcpy@GLIBC_2.14>
   498f2:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
   498f9:	00 00 
   498fb:	48 c7 44 24 20 08 00 	movq   $0x8,0x20(%rsp)
   49902:	00 00 
   49904:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
   4990b:	00 00 
   4990d:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
   49914:	00 00 
   49916:	48 c7 44 24 40 08 00 	movq   $0x8,0x40(%rsp)
   4991d:	00 00 
   4991f:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
   49926:	00 00 
   49928:	4c 89 eb             	mov    %r13,%rbx
   4992b:	eb 37                	jmp    49964 <blake3_servil::each::update_turn+0x254>
   4992d:	0f 1f 00             	nopl   (%rax)
   49930:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
   49937:	00 00 
   49939:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
   4993e:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   49943:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   49948:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
   4994d:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
   49952:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
   49959:	00 00 
   4995b:	4d 85 ed             	test   %r13,%r13
   4995e:	0f 84 a3 03 00 00    	je     49d07 <blake3_servil::each::update_turn+0x5f7>
   49964:	48 89 5c 24 30       	mov    %rbx,0x30(%rsp)
   49969:	4c 89 6c 24 60       	mov    %r13,0x60(%rsp)
   4996e:	4a 8d 04 6d 00 00 00 	lea    0x0(,%r13,2),%rax
   49975:	00 
   49976:	4c 01 e8             	add    %r13,%rax
   49979:	49 8d 1c c6          	lea    (%r14,%rax,8),%rbx
   4997d:	4c 89 74 24 10       	mov    %r14,0x10(%rsp)
   49982:	eb 3f                	jmp    499c3 <blake3_servil::each::update_turn+0x2b3>
   49984:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   4998b:	00 00 00 00 00 
   49990:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
   49995:	48 8d 0c 6d 00 00 00 	lea    0x0(,%rbp,2),%rcx
   4999c:	00 
   4999d:	48 01 e9             	add    %rbp,%rcx
   499a0:	4c 89 3c c8          	mov    %r15,(%rax,%rcx,8)
   499a4:	4c 89 6c c8 08       	mov    %r13,0x8(%rax,%rcx,8)
   499a9:	4c 89 64 c8 10       	mov    %r12,0x10(%rax,%rcx,8)
   499ae:	48 ff c5             	inc    %rbp
   499b1:	48 89 6c 24 28       	mov    %rbp,0x28(%rsp)
   499b6:	49 83 c6 18          	add    $0x18,%r14
   499ba:	49 39 de             	cmp    %rbx,%r14
   499bd:	0f 84 fd 00 00 00    	je     49ac0 <blake3_servil::each::update_turn+0x3b0>
   499c3:	4d 8b 3e             	mov    (%r14),%r15
   499c6:	4c 3b 7c 24 08       	cmp    0x8(%rsp),%r15
   499cb:	0f 83 b0 03 00 00    	jae    49d81 <blake3_servil::each::update_turn+0x671>
   499d1:	4d 8b 6e 08          	mov    0x8(%r14),%r13
   499d5:	4d 8b 66 10          	mov    0x10(%r14),%r12
   499d9:	4b 8d 2c ff          	lea    (%r15,%r15,8),%rbp
   499dd:	48 c1 e5 0b          	shl    $0xb,%rbp
   499e1:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
   499e6:	48 81 bc 28 c0 47 00 	cmpq   $0x4000,0x47c0(%rax,%rbp,1)
   499ed:	00 00 40 00 00 
   499f2:	75 2c                	jne    49a20 <blake3_servil::each::update_turn+0x310>
   499f4:	48 83 bc 28 90 07 00 	cmpq   $0x0,0x790(%rax,%rbp,1)
   499fb:	00 00 
   499fd:	75 21                	jne    49a20 <blake3_servil::each::update_turn+0x310>
   499ff:	48 8b 6c 24 28       	mov    0x28(%rsp),%rbp
   49a04:	48 3b 6c 24 18       	cmp    0x18(%rsp),%rbp
   49a09:	75 85                	jne    49990 <blake3_servil::each::update_turn+0x280>
   49a0b:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
   49a10:	ff 15 f2 55 07 00    	call   *0x755f2(%rip)        # bf008 <_DYNAMIC+0x320>
   49a16:	e9 75 ff ff ff       	jmp    49990 <blake3_servil::each::update_turn+0x280>
   49a1b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   49a20:	48 01 c5             	add    %rax,%rbp
   49a23:	0f b6 4c 24 5c       	movzbl 0x5c(%rsp),%ecx
   49a28:	48 89 ef             	mov    %rbp,%rdi
   49a2b:	4c 89 ee             	mov    %r13,%rsi
   49a2e:	4c 89 e2             	mov    %r12,%rdx
   49a31:	41 b8 01 00 00 00    	mov    $0x1,%r8d
   49a37:	e8 64 5f 01 00       	call   5f9a0 <<blake3_servil::incremental::Hasher>::gather_part>
   49a3c:	48 81 bd c0 47 00 00 	cmpq   $0x4000,0x47c0(%rbp)
   49a43:	00 40 00 00 
   49a47:	0f 85 69 ff ff ff    	jne    499b6 <blake3_servil::each::update_turn+0x2a6>
   49a4d:	48 83 bd 90 07 00 00 	cmpq   $0x0,0x790(%rbp)
   49a54:	00 
   49a55:	0f 85 5b ff ff ff    	jne    499b6 <blake3_servil::each::update_turn+0x2a6>
   49a5b:	49 89 c5             	mov    %rax,%r13
   49a5e:	49 89 d4             	mov    %rdx,%r12
   49a61:	48 8b 6c 24 48       	mov    0x48(%rsp),%rbp
   49a66:	48 3b 6c 24 38       	cmp    0x38(%rsp),%rbp
   49a6b:	75 0b                	jne    49a78 <blake3_servil::each::update_turn+0x368>
   49a6d:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
   49a72:	ff 15 78 59 07 00    	call   *0x75978(%rip)        # bf3f0 <_DYNAMIC+0x708>
   49a78:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
   49a7d:	4c 89 3c e8          	mov    %r15,(%rax,%rbp,8)
   49a81:	48 ff c5             	inc    %rbp
   49a84:	48 89 6c 24 48       	mov    %rbp,0x48(%rsp)
   49a89:	4d 85 e4             	test   %r12,%r12
   49a8c:	0f 84 24 ff ff ff    	je     499b6 <blake3_servil::each::update_turn+0x2a6>
   49a92:	48 8b 6c 24 28       	mov    0x28(%rsp),%rbp
   49a97:	48 3b 6c 24 18       	cmp    0x18(%rsp),%rbp
   49a9c:	0f 85 ee fe ff ff    	jne    49990 <blake3_servil::each::update_turn+0x280>
   49aa2:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
   49aa7:	ff 15 5b 55 07 00    	call   *0x7555b(%rip)        # bf008 <_DYNAMIC+0x320>
   49aad:	e9 de fe ff ff       	jmp    49990 <blake3_servil::each::update_turn+0x280>
   49ab2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   49ab9:	1f 84 00 00 00 00 00 
   49ac0:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
   49ac5:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
   49aca:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
   49acf:	48 89 df             	mov    %rbx,%rdi
   49ad2:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   49ad7:	e8 44 1c 00 00       	call   4b720 <blake3_servil::each::hash_held>
   49adc:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
   49ae1:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
   49ae6:	48 85 c9             	test   %rcx,%rcx
   49ae9:	74 55                	je     49b40 <blake3_servil::each::update_turn+0x430>
   49aeb:	48 c1 e1 03          	shl    $0x3,%rcx
   49aef:	31 d2                	xor    %edx,%edx
   49af1:	eb 16                	jmp    49b09 <blake3_servil::each::update_turn+0x3f9>
   49af3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   49afa:	84 00 00 00 00 00 
   49b00:	48 83 c2 08          	add    $0x8,%rdx
   49b04:	48 39 d1             	cmp    %rdx,%rcx
   49b07:	74 37                	je     49b40 <blake3_servil::each::update_turn+0x430>
   49b09:	48 8b 04 17          	mov    (%rdi,%rdx,1),%rax
   49b0d:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
   49b12:	0f 83 80 02 00 00    	jae    49d98 <blake3_servil::each::update_turn+0x688>
   49b18:	48 8d 04 c0          	lea    (%rax,%rax,8),%rax
   49b1c:	48 c1 e0 0b          	shl    $0xb,%rax
   49b20:	48 81 bc 03 c0 47 00 	cmpq   $0x4000,0x47c0(%rbx,%rax,1)
   49b27:	00 00 40 00 00 
   49b2c:	75 d2                	jne    49b00 <blake3_servil::each::update_turn+0x3f0>
   49b2e:	48 83 bc 03 90 07 00 	cmpq   $0x0,0x790(%rbx,%rax,1)
   49b35:	00 00 
   49b37:	75 c7                	jne    49b00 <blake3_servil::each::update_turn+0x3f0>
   49b39:	e9 71 02 00 00       	jmp    49daf <blake3_servil::each::update_turn+0x69f>
   49b3e:	66 90                	xchg   %ax,%ax
   49b40:	4c 8b 54 24 60       	mov    0x60(%rsp),%r10
   49b45:	44 89 d1             	mov    %r10d,%ecx
   49b48:	83 e1 03             	and    $0x3,%ecx
   49b4b:	49 83 fa 04          	cmp    $0x4,%r10
   49b4f:	73 0f                	jae    49b60 <blake3_servil::each::update_turn+0x450>
   49b51:	31 d2                	xor    %edx,%edx
   49b53:	31 c0                	xor    %eax,%eax
   49b55:	eb 4a                	jmp    49ba1 <blake3_servil::each::update_turn+0x491>
   49b57:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   49b5e:	00 00 
   49b60:	4c 89 d6             	mov    %r10,%rsi
   49b63:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
   49b67:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   49b6c:	4c 8d 40 58          	lea    0x58(%rax),%r8
   49b70:	31 d2                	xor    %edx,%edx
   49b72:	31 c0                	xor    %eax,%eax
   49b74:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   49b7b:	00 00 00 00 00 
   49b80:	49 03 40 b8          	add    -0x48(%r8),%rax
   49b84:	49 03 40 d0          	add    -0x30(%r8),%rax
   49b88:	49 03 40 e8          	add    -0x18(%r8),%rax
   49b8c:	49 03 00             	add    (%r8),%rax
   49b8f:	48 83 c2 04          	add    $0x4,%rdx
   49b93:	49 83 c0 60          	add    $0x60,%r8
   49b97:	48 39 d6             	cmp    %rdx,%rsi
   49b9a:	75 e4                	jne    49b80 <blake3_servil::each::update_turn+0x470>
   49b9c:	48 85 c9             	test   %rcx,%rcx
   49b9f:	74 2c                	je     49bcd <blake3_servil::each::update_turn+0x4bd>
   49ba1:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
   49ba5:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
   49baa:	48 8d 14 d6          	lea    (%rsi,%rdx,8),%rdx
   49bae:	48 83 c2 10          	add    $0x10,%rdx
   49bb2:	c1 e1 03             	shl    $0x3,%ecx
   49bb5:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
   49bb9:	31 f6                	xor    %esi,%esi
   49bbb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   49bc0:	48 03 04 32          	add    (%rdx,%rsi,1),%rax
   49bc4:	48 83 c6 18          	add    $0x18,%rsi
   49bc8:	48 39 f1             	cmp    %rsi,%rcx
   49bcb:	75 f3                	jne    49bc0 <blake3_servil::each::update_turn+0x4b0>
   49bcd:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
   49bd2:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
   49bd7:	4d 85 ed             	test   %r13,%r13
   49bda:	74 14                	je     49bf0 <blake3_servil::each::update_turn+0x4e0>
   49bdc:	44 89 ea             	mov    %r13d,%edx
   49bdf:	83 e2 03             	and    $0x3,%edx
   49be2:	49 83 fd 04          	cmp    $0x4,%r13
   49be6:	73 18                	jae    49c00 <blake3_servil::each::update_turn+0x4f0>
   49be8:	31 f6                	xor    %esi,%esi
   49bea:	31 c9                	xor    %ecx,%ecx
   49bec:	eb 43                	jmp    49c31 <blake3_servil::each::update_turn+0x521>
   49bee:	66 90                	xchg   %ax,%ax
   49bf0:	31 c9                	xor    %ecx,%ecx
   49bf2:	eb 69                	jmp    49c5d <blake3_servil::each::update_turn+0x54d>
   49bf4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   49bfb:	00 00 00 00 00 
   49c00:	4d 89 e8             	mov    %r13,%r8
   49c03:	49 83 e0 fc          	and    $0xfffffffffffffffc,%r8
   49c07:	4d 8d 4e 58          	lea    0x58(%r14),%r9
   49c0b:	31 f6                	xor    %esi,%esi
   49c0d:	31 c9                	xor    %ecx,%ecx
   49c0f:	90                   	nop
   49c10:	49 03 49 b8          	add    -0x48(%r9),%rcx
   49c14:	49 03 49 d0          	add    -0x30(%r9),%rcx
   49c18:	49 03 49 e8          	add    -0x18(%r9),%rcx
   49c1c:	49 03 09             	add    (%r9),%rcx
   49c1f:	48 83 c6 04          	add    $0x4,%rsi
   49c23:	49 83 c1 60          	add    $0x60,%r9
   49c27:	49 39 f0             	cmp    %rsi,%r8
   49c2a:	75 e4                	jne    49c10 <blake3_servil::each::update_turn+0x500>
   49c2c:	48 85 d2             	test   %rdx,%rdx
   49c2f:	74 2c                	je     49c5d <blake3_servil::each::update_turn+0x54d>
   49c31:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
   49c35:	49 8d 34 f6          	lea    (%r14,%rsi,8),%rsi
   49c39:	48 83 c6 10          	add    $0x10,%rsi
   49c3d:	c1 e2 03             	shl    $0x3,%edx
   49c40:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
   49c44:	45 31 c0             	xor    %r8d,%r8d
   49c47:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   49c4e:	00 00 
   49c50:	4a 03 0c 06          	add    (%rsi,%r8,1),%rcx
   49c54:	49 83 c0 18          	add    $0x18,%r8
   49c58:	4c 39 c2             	cmp    %r8,%rdx
   49c5b:	75 f3                	jne    49c50 <blake3_servil::each::update_turn+0x540>
   49c5d:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
   49c62:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
   49c67:	48 39 c1             	cmp    %rax,%rcx
   49c6a:	0f 82 c0 fc ff ff    	jb     49930 <blake3_servil::each::update_turn+0x220>
   49c70:	75 09                	jne    49c7b <blake3_servil::each::update_turn+0x56b>
   49c72:	4d 39 d5             	cmp    %r10,%r13
   49c75:	0f 82 b5 fc ff ff    	jb     49930 <blake3_servil::each::update_turn+0x220>
   49c7b:	4c 89 54 24 78       	mov    %r10,0x78(%rsp)
   49c80:	4c 89 ac 24 80 00 00 	mov    %r13,0x80(%rsp)
   49c87:	00 
   49c88:	48 8d 44 24 78       	lea    0x78(%rsp),%rax
   49c8d:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
   49c94:	00 
   49c95:	48 8b 05 84 53 07 00 	mov    0x75384(%rip),%rax        # bf020 <_DYNAMIC+0x338>
   49c9c:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
   49ca3:	00 
   49ca4:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
   49ca9:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
   49cb0:	00 
   49cb1:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
   49cb8:	00 
   49cb9:	48 8d 8c 24 80 00 00 	lea    0x80(%rsp),%rcx
   49cc0:	00 
   49cc1:	48 89 8c 24 a8 00 00 	mov    %rcx,0xa8(%rsp)
   49cc8:	00 
   49cc9:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
   49cd0:	00 
   49cd1:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
   49cd6:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
   49cdd:	00 
   49cde:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
   49ce5:	00 
   49ce6:	48 8d 15 7b 1b 07 00 	lea    0x71b7b(%rip),%rdx        # bb868 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x208>
   49ced:	48 8d b4 24 88 00 00 	lea    0x88(%rsp),%rsi
   49cf4:	00 
   49cf5:	48 8d 3d d6 63 fc ff 	lea    -0x39c2a(%rip),%rdi        # 100d2 <anon.7aa99caee07d4b49ecce0ae005529d8e.6.llvm.12571053693337283289+0xb>
   49cfc:	ff 15 56 52 07 00    	call   *0x75256(%rip)        # bef58 <_DYNAMIC+0x270>
   49d02:	e9 a6 00 00 00       	jmp    49dad <blake3_servil::each::update_turn+0x69d>
   49d07:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
   49d0c:	48 85 f6             	test   %rsi,%rsi
   49d0f:	74 14                	je     49d25 <blake3_servil::each::update_turn+0x615>
   49d11:	48 c1 e6 03          	shl    $0x3,%rsi
   49d15:	ba 08 00 00 00       	mov    $0x8,%edx
   49d1a:	ff 15 40 52 07 00    	call   *0x75240(%rip)        # bef60 <_DYNAMIC+0x278>
   49d20:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   49d25:	48 85 c0             	test   %rax,%rax
   49d28:	74 18                	je     49d42 <blake3_servil::each::update_turn+0x632>
   49d2a:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
   49d2f:	48 c1 e0 03          	shl    $0x3,%rax
   49d33:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
   49d37:	ba 08 00 00 00       	mov    $0x8,%edx
   49d3c:	ff 15 1e 52 07 00    	call   *0x7521e(%rip)        # bef60 <_DYNAMIC+0x278>
   49d42:	48 85 db             	test   %rbx,%rbx
   49d45:	74 16                	je     49d5d <blake3_servil::each::update_turn+0x64d>
   49d47:	48 c1 e3 03          	shl    $0x3,%rbx
   49d4b:	48 8d 34 5b          	lea    (%rbx,%rbx,2),%rsi
   49d4f:	ba 08 00 00 00       	mov    $0x8,%edx
   49d54:	4c 89 f7             	mov    %r14,%rdi
   49d57:	ff 15 03 52 07 00    	call   *0x75203(%rip)        # bef60 <_DYNAMIC+0x278>
   49d5d:	48 81 c4 c8 00 00 00 	add    $0xc8,%rsp
   49d64:	5b                   	pop    %rbx
   49d65:	41 5c                	pop    %r12
   49d67:	41 5d                	pop    %r13
   49d69:	41 5e                	pop    %r14
   49d6b:	41 5f                	pop    %r15
   49d6d:	5d                   	pop    %rbp
   49d6e:	c3                   	ret
   49d6f:	48 8d 0d 92 1d 07 00 	lea    0x71d92(%rip),%rcx        # bbb08 <anon.921201f36d8dba35c91945dd38eee41b.13.llvm.13452284647098554375>
   49d76:	ba 40 00 00 00       	mov    $0x40,%edx
   49d7b:	ff 15 97 52 07 00    	call   *0x75297(%rip)        # bf018 <_DYNAMIC+0x330>
   49d81:	48 8d 15 b0 1a 07 00 	lea    0x71ab0(%rip),%rdx        # bb838 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x1d8>
   49d88:	4c 89 ff             	mov    %r15,%rdi
   49d8b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   49d90:	ff 15 52 52 07 00    	call   *0x75252(%rip)        # befe8 <_DYNAMIC+0x300>
   49d96:	eb 15                	jmp    49dad <blake3_servil::each::update_turn+0x69d>
   49d98:	48 8d 15 21 1a 07 00 	lea    0x71a21(%rip),%rdx        # bb7c0 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x160>
   49d9f:	48 89 c7             	mov    %rax,%rdi
   49da2:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   49da7:	ff 15 3b 52 07 00    	call   *0x7523b(%rip)        # befe8 <_DYNAMIC+0x300>
   49dad:	0f 0b                	ud2
   49daf:	be 3d 00 00 00       	mov    $0x3d,%esi
   49db4:	48 8d 15 95 1a 07 00 	lea    0x71a95(%rip),%rdx        # bb850 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x1f0>
   49dbb:	48 8d 3d 17 81 fc ff 	lea    -0x37ee9(%rip),%rdi        # 11ed9 <BLAKE3_IV_3+0xd>
   49dc2:	e9 35 ff ff ff       	jmp    49cfc <blake3_servil::each::update_turn+0x5ec>
   49dc7:	ff 15 4b 56 07 00    	call   *0x7564b(%rip)        # bf418 <_DYNAMIC+0x730>
   49dcd:	e9 83 f9 ff ff       	jmp    49755 <blake3_servil::each::update_turn+0x45>
   49dd2:	48 8d 0d a7 1a 07 00 	lea    0x71aa7(%rip),%rcx        # bb880 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x220>
   49dd9:	48 89 d7             	mov    %rdx,%rdi
   49ddc:	4c 89 ee             	mov    %r13,%rsi
   49ddf:	4c 89 ea             	mov    %r13,%rdx
   49de2:	ff 15 30 52 07 00    	call   *0x75230(%rip)        # bf018 <_DYNAMIC+0x330>
   49de8:	48 8d 15 31 1a 07 00 	lea    0x71a31(%rip),%rdx        # bb820 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x1c0>
   49def:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   49df4:	ff 15 ee 51 07 00    	call   *0x751ee(%rip)        # befe8 <_DYNAMIC+0x300>
   49dfa:	bf 08 00 00 00       	mov    $0x8,%edi
   49dff:	4c 89 e6             	mov    %r12,%rsi
   49e02:	ff 15 18 51 07 00    	call   *0x75118(%rip)        # bef20 <_DYNAMIC+0x238>
   49e08:	eb 02                	jmp    49e0c <blake3_servil::each::update_turn+0x6fc>
   49e0a:	eb 00                	jmp    49e0c <blake3_servil::each::update_turn+0x6fc>
   49e0c:	48 89 c3             	mov    %rax,%rbx
   49e0f:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
   49e14:	48 85 f6             	test   %rsi,%rsi
   49e17:	75 1c                	jne    49e35 <blake3_servil::each::update_turn+0x725>
   49e19:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   49e1e:	48 85 c0             	test   %rax,%rax
   49e21:	75 30                	jne    49e53 <blake3_servil::each::update_turn+0x743>
   49e23:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   49e28:	48 85 c0             	test   %rax,%rax
   49e2b:	75 48                	jne    49e75 <blake3_servil::each::update_turn+0x765>
   49e2d:	48 89 df             	mov    %rbx,%rdi
   49e30:	e8 fb fd 06 00       	call   b9c30 <_Unwind_Resume@plt>
   49e35:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
   49e3a:	48 c1 e6 03          	shl    $0x3,%rsi
   49e3e:	ba 08 00 00 00       	mov    $0x8,%edx
   49e43:	ff 15 17 51 07 00    	call   *0x75117(%rip)        # bef60 <_DYNAMIC+0x278>
   49e49:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   49e4e:	48 85 c0             	test   %rax,%rax
   49e51:	74 d0                	je     49e23 <blake3_servil::each::update_turn+0x713>
   49e53:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
   49e58:	48 c1 e0 03          	shl    $0x3,%rax
   49e5c:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
   49e60:	ba 08 00 00 00       	mov    $0x8,%edx
   49e65:	ff 15 f5 50 07 00    	call   *0x750f5(%rip)        # bef60 <_DYNAMIC+0x278>
   49e6b:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   49e70:	48 85 c0             	test   %rax,%rax
   49e73:	74 b8                	je     49e2d <blake3_servil::each::update_turn+0x71d>
   49e75:	48 c1 e0 03          	shl    $0x3,%rax
   49e79:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
   49e7d:	ba 08 00 00 00       	mov    $0x8,%edx
   49e82:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
   49e87:	ff 15 d3 50 07 00    	call   *0x750d3(%rip)        # bef60 <_DYNAMIC+0x278>
   49e8d:	48 89 df             	mov    %rbx,%rdi
   49e90:	e8 9b fd 06 00       	call   b9c30 <_Unwind_Resume@plt>
