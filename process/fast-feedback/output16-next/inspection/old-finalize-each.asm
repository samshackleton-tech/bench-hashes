
/home/samshackleton/blake3-reports/optimization-resume-20261108/private-bin/epyc-old-1:     file format elf64-x86-64


Disassembly of section .text:

0000000000047a90 <blake3_servil::each::finalize_each>:
   47a90:	55                   	push   %rbp
   47a91:	48 89 e5             	mov    %rsp,%rbp
   47a94:	41 57                	push   %r15
   47a96:	41 56                	push   %r14
   47a98:	41 55                	push   %r13
   47a9a:	41 54                	push   %r12
   47a9c:	53                   	push   %rbx
   47a9d:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
   47aa1:	48 81 ec 80 01 00 00 	sub    $0x180,%rsp
   47aa8:	4c 89 44 24 58       	mov    %r8,0x58(%rsp)
   47aad:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
   47ab2:	48 89 74 24 40       	mov    %rsi,0x40(%rsp)
   47ab7:	48 89 7c 24 50       	mov    %rdi,0x50(%rsp)
   47abc:	48 89 4c 24 78       	mov    %rcx,0x78(%rsp)
   47ac1:	4c 89 8c 24 80 00 00 	mov    %r9,0x80(%rsp)
   47ac8:	00 
   47ac9:	4c 39 c9             	cmp    %r9,%rcx
   47acc:	0f 85 2a 02 00 00    	jne    47cfc <blake3_servil::each::finalize_each+0x26c>
   47ad2:	48 85 c9             	test   %rcx,%rcx
   47ad5:	0f 84 12 02 00 00    	je     47ced <blake3_servil::each::finalize_each+0x25d>
   47adb:	48 c1 e1 03          	shl    $0x3,%rcx
   47adf:	31 d2                	xor    %edx,%edx
   47ae1:	4c 8d bc 24 80 00 00 	lea    0x80(%rsp),%r15
   47ae8:	00 
   47ae9:	4c 8d 6c 24 20       	lea    0x20(%rsp),%r13
   47aee:	48 89 4c 24 48       	mov    %rcx,0x48(%rsp)
   47af3:	e9 03 01 00 00       	jmp    47bfb <blake3_servil::each::finalize_each+0x16b>
   47af8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   47aff:	00 
   47b00:	31 c9                	xor    %ecx,%ecx
   47b02:	ff 15 08 bd 06 00    	call   *0x6bd08(%rip)        # b3810 <_DYNAMIC+0x708>
   47b08:	48 8b 44 24 58       	mov    0x58(%rsp),%rax
   47b0d:	48 8b 54 24 70       	mov    0x70(%rsp),%rdx
   47b12:	48 8d 04 90          	lea    (%rax,%rdx,4),%rax
   47b16:	0f 28 44 24 20       	movaps 0x20(%rsp),%xmm0
   47b1b:	0f 28 4c 24 30       	movaps 0x30(%rsp),%xmm1
   47b20:	0f 29 8c 24 30 01 00 	movaps %xmm1,0x130(%rsp)
   47b27:	00 
   47b28:	0f 29 84 24 20 01 00 	movaps %xmm0,0x120(%rsp)
   47b2f:	00 
   47b30:	0f 11 48 10          	movups %xmm1,0x10(%rax)
   47b34:	0f 11 00             	movups %xmm0,(%rax)
   47b37:	0f 57 c0             	xorps  %xmm0,%xmm0
   47b3a:	0f 29 84 24 80 00 00 	movaps %xmm0,0x80(%rsp)
   47b41:	00 
   47b42:	0f 29 84 24 b0 00 00 	movaps %xmm0,0xb0(%rsp)
   47b49:	00 
   47b4a:	0f 29 84 24 a0 00 00 	movaps %xmm0,0xa0(%rsp)
   47b51:	00 
   47b52:	0f 29 84 24 90 00 00 	movaps %xmm0,0x90(%rsp)
   47b59:	00 
   47b5a:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
   47b5f:	0f 28 00             	movaps (%rax),%xmm0
   47b62:	0f 29 03             	movaps %xmm0,(%rbx)
   47b65:	0f 28 40 10          	movaps 0x10(%rax),%xmm0
   47b69:	0f 29 43 10          	movaps %xmm0,0x10(%rbx)
   47b6d:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
   47b74:	00 
   47b75:	0f 28 8c 24 c0 00 00 	movaps 0xc0(%rsp),%xmm1
   47b7c:	00 
   47b7d:	41 0f 29 04 24       	movaps %xmm0,(%r12)
   47b82:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
   47b89:	00 
   47b8a:	0f 28 94 24 d0 00 00 	movaps 0xd0(%rsp),%xmm2
   47b91:	00 
   47b92:	41 0f 29 44 24 10    	movaps %xmm0,0x10(%r12)
   47b98:	41 0f 29 4c 24 40    	movaps %xmm1,0x40(%r12)
   47b9e:	41 0f 29 54 24 50    	movaps %xmm2,0x50(%r12)
   47ba4:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
   47bab:	00 
   47bac:	41 0f 29 44 24 20    	movaps %xmm0,0x20(%r12)
   47bb2:	0f 28 84 24 b0 00 00 	movaps 0xb0(%rsp),%xmm0
   47bb9:	00 
   47bba:	41 0f 29 44 24 30    	movaps %xmm0,0x30(%r12)
   47bc0:	49 c7 44 24 60 00 00 	movq   $0x0,0x60(%r12)
   47bc7:	00 00 
   47bc9:	66 41 c7 44 24 68 00 	movw   $0x0,0x68(%r12)
   47bd0:	00 
   47bd1:	49 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%r12)
   47bd8:	00 00 00 00 00 
   47bdd:	49 c7 84 24 c0 47 00 	movq   $0x0,0x47c0(%r12)
   47be4:	00 00 00 00 00 
   47be9:	48 83 c2 08          	add    $0x8,%rdx
   47bed:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
   47bf2:	48 39 d1             	cmp    %rdx,%rcx
   47bf5:	0f 84 f2 00 00 00    	je     47ced <blake3_servil::each::finalize_each+0x25d>
   47bfb:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
   47c00:	48 89 54 24 70       	mov    %rdx,0x70(%rsp)
   47c05:	48 8b 3c 10          	mov    (%rax,%rdx,1),%rdi
   47c09:	48 3b 7c 24 40       	cmp    0x40(%rsp),%rdi
   47c0e:	0f 83 11 01 00 00    	jae    47d25 <blake3_servil::each::finalize_each+0x295>
   47c14:	4d 89 fe             	mov    %r15,%r14
   47c17:	48 8d 1c ff          	lea    (%rdi,%rdi,8),%rbx
   47c1b:	48 c1 e3 0b          	shl    $0xb,%rbx
   47c1f:	4c 8b 7c 24 50       	mov    0x50(%rsp),%r15
   47c24:	4d 8d 24 1f          	lea    (%r15,%rbx,1),%r12
   47c28:	49 8d 34 1f          	lea    (%r15,%rbx,1),%rsi
   47c2c:	48 81 c6 c0 07 00 00 	add    $0x7c0,%rsi
   47c33:	49 8b 94 1f c0 47 00 	mov    0x47c0(%r15,%rbx,1),%rdx
   47c3a:	00 
   47c3b:	4c 89 e7             	mov    %r12,%rdi
   47c3e:	31 c9                	xor    %ecx,%ecx
   47c40:	e8 3b 0c 01 00       	call   58880 <<blake3_servil::incremental::HasherCore>::update_pooled>
   47c45:	41 0f b6 44 1f 6a    	movzbl 0x6a(%r15,%rbx,1),%eax
   47c4b:	41 0f b6 4c 1f 6b    	movzbl 0x6b(%r15,%rbx,1),%ecx
   47c51:	49 8d 14 1f          	lea    (%r15,%rbx,1),%rdx
   47c55:	48 81 c2 80 00 00 00 	add    $0x80,%rdx
   47c5c:	48 89 54 24 30       	mov    %rdx,0x30(%rsp)
   47c61:	88 44 24 39          	mov    %al,0x39(%rsp)
   47c65:	88 4c 24 38          	mov    %cl,0x38(%rsp)
   47c69:	48 89 54 24 68       	mov    %rdx,0x68(%rsp)
   47c6e:	48 89 54 24 20       	mov    %rdx,0x20(%rsp)
   47c73:	88 44 24 28          	mov    %al,0x28(%rsp)
   47c77:	88 4c 24 29          	mov    %cl,0x29(%rsp)
   47c7b:	88 4c 24 2a          	mov    %cl,0x2a(%rsp)
   47c7f:	c6 44 24 2b 00       	movb   $0x0,0x2b(%rsp)
   47c84:	49 8d 8c 1f a0 00 00 	lea    0xa0(%r15,%rbx,1),%rcx
   47c8b:	00 
   47c8c:	4d 89 f7             	mov    %r14,%r15
   47c8f:	4c 89 f7             	mov    %r14,%rdi
   47c92:	4c 89 ee             	mov    %r13,%rsi
   47c95:	4c 89 e2             	mov    %r12,%rdx
   47c98:	e8 33 88 00 00       	call   504d0 <blake3_servil::hasher::final_node::<blake3_servil::hasher::ChunkState<blake3_servil::platform::Platform>, blake3_servil::hasher::Output<blake3_servil::platform::Platform>, blake3_servil::hasher::Kernels<blake3_servil::platform::Platform, blake3_servil::incremental::HasherHooks>>>
   47c9d:	48 8d 9c 24 c0 00 00 	lea    0xc0(%rsp),%rbx
   47ca4:	00 
   47ca5:	0f 28 03             	movaps (%rbx),%xmm0
   47ca8:	0f 28 4b 10          	movaps 0x10(%rbx),%xmm1
   47cac:	0f 29 4c 24 30       	movaps %xmm1,0x30(%rsp)
   47cb1:	0f 29 44 24 20       	movaps %xmm0,0x20(%rsp)
   47cb6:	0f b6 84 24 f0 00 00 	movzbl 0xf0(%rsp),%eax
   47cbd:	00 
   47cbe:	0c 08                	or     $0x8,%al
   47cc0:	80 bc 24 f1 00 00 00 	cmpb   $0x5,0xf1(%rsp)
   47cc7:	05 
   47cc8:	0f b6 94 24 e0 00 00 	movzbl 0xe0(%rsp),%edx
   47ccf:	00 
   47cd0:	44 0f b6 c0          	movzbl %al,%r8d
   47cd4:	4c 89 ef             	mov    %r13,%rdi
   47cd7:	4c 89 f6             	mov    %r14,%rsi
   47cda:	0f 84 20 fe ff ff    	je     47b00 <blake3_servil::each::finalize_each+0x70>
   47ce0:	31 c9                	xor    %ecx,%ecx
   47ce2:	ff 15 30 bb 06 00    	call   *0x6bb30(%rip)        # b3818 <_DYNAMIC+0x710>
   47ce8:	e9 1b fe ff ff       	jmp    47b08 <blake3_servil::each::finalize_each+0x78>
   47ced:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
   47cf1:	5b                   	pop    %rbx
   47cf2:	41 5c                	pop    %r12
   47cf4:	41 5d                	pop    %r13
   47cf6:	41 5e                	pop    %r14
   47cf8:	41 5f                	pop    %r15
   47cfa:	5d                   	pop    %rbp
   47cfb:	c3                   	ret
   47cfc:	48 8d 0d 56 93 fc ff 	lea    -0x36caa(%rip),%rcx        # 11059 <BLAKE3_IV_3+0xd>
   47d03:	4c 8d 0d 96 82 06 00 	lea    0x68296(%rip),%r9        # affa0 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x160>
   47d0a:	48 8d 74 24 78       	lea    0x78(%rsp),%rsi
   47d0f:	48 8d 94 24 80 00 00 	lea    0x80(%rsp),%rdx
   47d16:	00 
   47d17:	41 b8 39 00 00 00    	mov    $0x39,%r8d
   47d1d:	31 ff                	xor    %edi,%edi
   47d1f:	ff 15 13 bb 06 00    	call   *0x6bb13(%rip)        # b3838 <_DYNAMIC+0x730>
   47d25:	48 8d 15 8c 82 06 00 	lea    0x6828c(%rip),%rdx        # affb8 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x178>
   47d2c:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
   47d31:	ff 15 d1 b6 06 00    	call   *0x6b6d1(%rip)        # b3408 <_DYNAMIC+0x300>
