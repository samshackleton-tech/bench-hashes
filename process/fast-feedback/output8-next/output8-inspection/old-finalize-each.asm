
/home/samshackleton/blake3-reports/optimization-resume-20261108/output8-private-bin/old-1:     file format elf64-x86-64


Disassembly of section .text:

0000000000049650 <blake3_servil::each::finalize_each>:
   49650:	55                   	push   %rbp
   49651:	48 89 e5             	mov    %rsp,%rbp
   49654:	41 57                	push   %r15
   49656:	41 56                	push   %r14
   49658:	41 55                	push   %r13
   4965a:	41 54                	push   %r12
   4965c:	53                   	push   %rbx
   4965d:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
   49661:	48 81 ec 00 04 00 00 	sub    $0x400,%rsp
   49668:	48 89 54 24 28       	mov    %rdx,0x28(%rsp)
   4966d:	48 89 4c 24 60       	mov    %rcx,0x60(%rsp)
   49672:	4c 89 8c 24 80 00 00 	mov    %r9,0x80(%rsp)
   49679:	00 
   4967a:	4c 39 c9             	cmp    %r9,%rcx
   4967d:	0f 85 2d 03 00 00    	jne    499b0 <blake3_servil::each::finalize_each+0x360>
   49683:	4d 89 c7             	mov    %r8,%r15
   49686:	49 89 cc             	mov    %rcx,%r12
   49689:	49 89 fd             	mov    %rdi,%r13
   4968c:	48 83 f9 0f          	cmp    $0xf,%rcx
   49690:	0f 86 56 03 00 00    	jbe    499ec <blake3_servil::each::finalize_each+0x39c>
   49696:	48 8b 05 db 0d 07 00 	mov    0x70ddb(%rip),%rax        # ba478 <_DYNAMIC+0x728>
   4969d:	0f b6 00             	movzbl (%rax),%eax
   496a0:	84 c0                	test   %al,%al
   496a2:	48 89 74 24 20       	mov    %rsi,0x20(%rsp)
   496a7:	0f 84 2c 03 00 00    	je     499d9 <blake3_servil::each::finalize_each+0x389>
   496ad:	3c 05                	cmp    $0x5,%al
   496af:	0f 85 37 03 00 00    	jne    499ec <blake3_servil::each::finalize_each+0x39c>
   496b5:	49 8d 44 24 0f       	lea    0xf(%r12),%rax
   496ba:	48 c1 e8 04          	shr    $0x4,%rax
   496be:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
   496c3:	31 c9                	xor    %ecx,%ecx
   496c5:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
   496ca:	4c 89 64 24 38       	mov    %r12,0x38(%rsp)
   496cf:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
   496d4:	eb 36                	jmp    4970c <blake3_servil::each::finalize_each+0xbc>
   496d6:	66 2e 0f 1f 84 00 00 	cs nopw 0x0(%rax,%rax,1)
   496dd:	00 00 00 
   496e0:	4c 89 ef             	mov    %r13,%rdi
   496e3:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
   496e8:	4d 89 f1             	mov    %r14,%r9
   496eb:	e8 60 f5 ff ff       	call   48c50 <blake3_servil::each::finish_each>
   496f0:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
   496f5:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
   496fa:	48 ff c1             	inc    %rcx
   496fd:	48 83 eb 80          	sub    $0xffffffffffffff80,%rbx
   49701:	48 3b 4c 24 50       	cmp    0x50(%rsp),%rcx
   49706:	0f 84 f6 02 00 00    	je     49a02 <blake3_servil::each::finalize_each+0x3b2>
   4970c:	48 89 c8             	mov    %rcx,%rax
   4970f:	48 c1 e0 04          	shl    $0x4,%rax
   49713:	4d 89 e6             	mov    %r12,%r14
   49716:	49 29 c6             	sub    %rax,%r14
   49719:	48 89 ca             	mov    %rcx,%rdx
   4971c:	48 c1 e2 07          	shl    $0x7,%rdx
   49720:	48 03 54 24 28       	add    0x28(%rsp),%rdx
   49725:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
   4972a:	49 89 c8             	mov    %rcx,%r8
   4972d:	49 c1 e0 09          	shl    $0x9,%r8
   49731:	4d 01 f8             	add    %r15,%r8
   49734:	49 83 fe 10          	cmp    $0x10,%r14
   49738:	b8 10 00 00 00       	mov    $0x10,%eax
   4973d:	4c 0f 43 f0          	cmovae %rax,%r14
   49741:	4c 89 f1             	mov    %r14,%rcx
   49744:	72 9a                	jb     496e0 <blake3_servil::each::finalize_each+0x90>
   49746:	4c 89 44 24 40       	mov    %r8,0x40(%rsp)
   4974b:	48 8d 82 80 00 00 00 	lea    0x80(%rdx),%rax
   49752:	c6 44 24 1e 00       	movb   $0x0,0x1e(%rsp)
   49757:	48 89 54 24 48       	mov    %rdx,0x48(%rsp)
   4975c:	48 89 94 24 40 02 00 	mov    %rdx,0x240(%rsp)
   49763:	00 
   49764:	48 89 84 24 48 02 00 	mov    %rax,0x248(%rsp)
   4976b:	00 
   4976c:	4c 89 ac 24 50 02 00 	mov    %r13,0x250(%rsp)
   49773:	00 
   49774:	48 89 b4 24 58 02 00 	mov    %rsi,0x258(%rsp)
   4977b:	00 
   4977c:	48 8d 44 24 1e       	lea    0x1e(%rsp),%rax
   49781:	48 89 84 24 60 02 00 	mov    %rax,0x260(%rsp)
   49788:	00 
   49789:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
   4978e:	48 8d b4 24 40 02 00 	lea    0x240(%rsp),%rsi
   49795:	00 
   49796:	e8 95 1c 01 00       	call   5b430 <<core::iter::adapters::GenericShunt<core::iter::adapters::map::Map<core::slice::iter::Iter<usize>, blake3_servil::each::finalize_each::{closure#0}>, core::option::Option<core::convert::Infallible>> as core::iter::traits::iterator::Iterator>::next>
   4979b:	48 83 7c 24 68 00    	cmpq   $0x0,0x68(%rsp)
   497a1:	0f 84 c1 00 00 00    	je     49868 <blake3_servil::each::finalize_each+0x218>
   497a7:	45 31 ff             	xor    %r15d,%r15d
   497aa:	45 31 e4             	xor    %r12d,%r12d
   497ad:	eb 3e                	jmp    497ed <blake3_servil::each::finalize_each+0x19d>
   497af:	90                   	nop
   497b0:	48 8d 84 24 88 00 00 	lea    0x88(%rsp),%rax
   497b7:	00 
   497b8:	4c 01 e0             	add    %r12,%rax
   497bb:	48 8b 4c 24 78       	mov    0x78(%rsp),%rcx
   497c0:	48 89 48 10          	mov    %rcx,0x10(%rax)
   497c4:	0f 10 44 24 68       	movups 0x68(%rsp),%xmm0
   497c9:	0f 11 00             	movups %xmm0,(%rax)
   497cc:	41 ff c7             	inc    %r15d
   497cf:	48 8d 7c 24 68       	lea    0x68(%rsp),%rdi
   497d4:	48 8d b4 24 40 02 00 	lea    0x240(%rsp),%rsi
   497db:	00 
   497dc:	e8 4f 1c 01 00       	call   5b430 <<core::iter::adapters::GenericShunt<core::iter::adapters::map::Map<core::slice::iter::Iter<usize>, blake3_servil::each::finalize_each::{closure#0}>, core::option::Option<core::convert::Infallible>> as core::iter::traits::iterator::Iterator>::next>
   497e1:	49 83 c4 18          	add    $0x18,%r12
   497e5:	48 83 7c 24 68 00    	cmpq   $0x0,0x68(%rsp)
   497eb:	74 23                	je     49810 <blake3_servil::each::finalize_each+0x1c0>
   497ed:	49 81 fc 80 01 00 00 	cmp    $0x180,%r12
   497f4:	75 ba                	jne    497b0 <blake3_servil::each::finalize_each+0x160>
   497f6:	48 8d 3d 0b d3 06 00 	lea    0x6d30b(%rip),%rdi        # b6b08 <anon.fb21938848e060c004961cda41cca647.1.llvm.1439097068734657871>
   497fd:	ff 15 6d 0c 07 00    	call   *0x70c6d(%rip)        # ba470 <_DYNAMIC+0x720>
   49803:	eb ab                	jmp    497b0 <blake3_servil::each::finalize_each+0x160>
   49805:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   4980c:	00 00 00 00 
   49810:	80 7c 24 1e 00       	cmpb   $0x0,0x1e(%rsp)
   49815:	4c 8b 64 24 38       	mov    0x38(%rsp),%r12
   4981a:	75 57                	jne    49873 <blake3_servil::each::finalize_each+0x223>
   4981c:	ba 84 01 00 00       	mov    $0x184,%edx
   49821:	48 8d bc 24 44 02 00 	lea    0x244(%rsp),%rdi
   49828:	00 
   49829:	48 8d b4 24 84 00 00 	lea    0x84(%rsp),%rsi
   49830:	00 
   49831:	ff 15 99 07 07 00    	call   *0x70799(%rip)        # b9fd0 <memcpy@GLIBC_2.14>
   49837:	44 89 bc 24 40 02 00 	mov    %r15d,0x240(%rsp)
   4983e:	00 
   4983f:	41 83 ff 10          	cmp    $0x10,%r15d
   49843:	0f 85 e0 01 00 00    	jne    49a29 <blake3_servil::each::finalize_each+0x3d9>
   49849:	48 8d bc 24 48 02 00 	lea    0x248(%rsp),%rdi
   49850:	00 
   49851:	48 8b 74 24 40       	mov    0x40(%rsp),%rsi
   49856:	ff 15 2c 0c 07 00    	call   *0x70c2c(%rip)        # ba488 <_DYNAMIC+0x738>
   4985c:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
   49861:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
   49866:	eb 4d                	jmp    498b5 <blake3_servil::each::finalize_each+0x265>
   49868:	80 7c 24 1e 00       	cmpb   $0x0,0x1e(%rsp)
   4986d:	0f 84 ab 01 00 00    	je     49a1e <blake3_servil::each::finalize_each+0x3ce>
   49873:	4c 89 ef             	mov    %r13,%rdi
   49876:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
   4987b:	4c 8b 7c 24 48       	mov    0x48(%rsp),%r15
   49880:	4c 89 fa             	mov    %r15,%rdx
   49883:	4c 8b 64 24 40       	mov    0x40(%rsp),%r12
   49888:	4c 89 e1             	mov    %r12,%rcx
   4988b:	4d 89 f0             	mov    %r14,%r8
   4988e:	e8 2d 73 01 00       	call   60bc0 <blake3_servil::ffi_output::staged_group>
   49893:	4c 89 fa             	mov    %r15,%rdx
   49896:	4d 89 e0             	mov    %r12,%r8
   49899:	4c 8b 64 24 38       	mov    0x38(%rsp),%r12
   4989e:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
   498a3:	b9 10 00 00 00       	mov    $0x10,%ecx
   498a8:	84 c0                	test   %al,%al
   498aa:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
   498af:	0f 84 2b fe ff ff    	je     496e0 <blake3_servil::each::finalize_each+0x90>
   498b5:	31 c0                	xor    %eax,%eax
   498b7:	48 8d 94 24 c0 00 00 	lea    0xc0(%rsp),%rdx
   498be:	00 
   498bf:	0f 57 db             	xorps  %xmm3,%xmm3
   498c2:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   498c9:	1f 84 00 00 00 00 00 
   498d0:	48 8b 3c 03          	mov    (%rbx,%rax,1),%rdi
   498d4:	48 39 f7             	cmp    %rsi,%rdi
   498d7:	0f 83 34 01 00 00    	jae    49a11 <blake3_servil::each::finalize_each+0x3c1>
   498dd:	48 83 c0 08          	add    $0x8,%rax
   498e1:	48 8d 0c ff          	lea    (%rdi,%rdi,8),%rcx
   498e5:	48 c1 e1 0b          	shl    $0xb,%rcx
   498e9:	0f 29 9c 24 80 00 00 	movaps %xmm3,0x80(%rsp)
   498f0:	00 
   498f1:	0f 29 9c 24 b0 00 00 	movaps %xmm3,0xb0(%rsp)
   498f8:	00 
   498f9:	0f 29 9c 24 a0 00 00 	movaps %xmm3,0xa0(%rsp)
   49900:	00 
   49901:	0f 29 9c 24 90 00 00 	movaps %xmm3,0x90(%rsp)
   49908:	00 
   49909:	41 0f 28 84 0d 80 00 	movaps 0x80(%r13,%rcx,1),%xmm0
   49910:	00 00 
   49912:	0f 29 02             	movaps %xmm0,(%rdx)
   49915:	41 0f 28 84 0d 90 00 	movaps 0x90(%r13,%rcx,1),%xmm0
   4991c:	00 00 
   4991e:	0f 29 42 10          	movaps %xmm0,0x10(%rdx)
   49922:	0f 28 84 24 80 00 00 	movaps 0x80(%rsp),%xmm0
   49929:	00 
   4992a:	0f 28 8c 24 c0 00 00 	movaps 0xc0(%rsp),%xmm1
   49931:	00 
   49932:	41 0f 29 44 0d 00    	movaps %xmm0,0x0(%r13,%rcx,1)
   49938:	0f 28 84 24 90 00 00 	movaps 0x90(%rsp),%xmm0
   4993f:	00 
   49940:	0f 28 94 24 d0 00 00 	movaps 0xd0(%rsp),%xmm2
   49947:	00 
   49948:	41 0f 29 44 0d 10    	movaps %xmm0,0x10(%r13,%rcx,1)
   4994e:	41 0f 29 4c 0d 40    	movaps %xmm1,0x40(%r13,%rcx,1)
   49954:	41 0f 29 54 0d 50    	movaps %xmm2,0x50(%r13,%rcx,1)
   4995a:	0f 28 84 24 a0 00 00 	movaps 0xa0(%rsp),%xmm0
   49961:	00 
   49962:	41 0f 29 44 0d 20    	movaps %xmm0,0x20(%r13,%rcx,1)
   49968:	0f 28 84 24 b0 00 00 	movaps 0xb0(%rsp),%xmm0
   4996f:	00 
   49970:	41 0f 29 44 0d 30    	movaps %xmm0,0x30(%r13,%rcx,1)
   49976:	49 c7 44 0d 60 00 00 	movq   $0x0,0x60(%r13,%rcx,1)
   4997d:	00 00 
   4997f:	66 41 c7 44 0d 68 00 	movw   $0x0,0x68(%r13,%rcx,1)
   49986:	00 
   49987:	49 c7 84 0d a0 00 00 	movq   $0x0,0xa0(%r13,%rcx,1)
   4998e:	00 00 00 00 00 
   49993:	49 c7 84 0d c0 47 00 	movq   $0x0,0x47c0(%r13,%rcx,1)
   4999a:	00 00 00 00 00 
   4999f:	48 3d 80 00 00 00    	cmp    $0x80,%rax
   499a5:	0f 85 25 ff ff ff    	jne    498d0 <blake3_servil::each::finalize_each+0x280>
   499ab:	e9 45 fd ff ff       	jmp    496f5 <blake3_servil::each::finalize_each+0xa5>
   499b0:	48 8d 0d eb 7e fc ff 	lea    -0x38115(%rip),%rcx        # 118a2 <BLAKE3_IV_3+0x56>
   499b7:	4c 8d 0d ea ce 06 00 	lea    0x6ceea(%rip),%r9        # b68a8 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x228>
   499be:	48 8d 74 24 60       	lea    0x60(%rsp),%rsi
   499c3:	48 8d 94 24 80 00 00 	lea    0x80(%rsp),%rdx
   499ca:	00 
   499cb:	41 b8 39 00 00 00    	mov    $0x39,%r8d
   499d1:	31 ff                	xor    %edi,%edi
   499d3:	ff 15 b7 0a 07 00    	call   *0x70ab7(%rip)        # ba490 <_DYNAMIC+0x740>
   499d9:	ff 15 a1 0a 07 00    	call   *0x70aa1(%rip)        # ba480 <_DYNAMIC+0x730>
   499df:	48 8b 74 24 20       	mov    0x20(%rsp),%rsi
   499e4:	3c 05                	cmp    $0x5,%al
   499e6:	0f 84 c9 fc ff ff    	je     496b5 <blake3_servil::each::finalize_each+0x65>
   499ec:	4c 89 ef             	mov    %r13,%rdi
   499ef:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
   499f4:	4c 89 e1             	mov    %r12,%rcx
   499f7:	4d 89 f8             	mov    %r15,%r8
   499fa:	4d 89 e1             	mov    %r12,%r9
   499fd:	e8 4e f2 ff ff       	call   48c50 <blake3_servil::each::finish_each>
   49a02:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
   49a06:	5b                   	pop    %rbx
   49a07:	41 5c                	pop    %r12
   49a09:	41 5d                	pop    %r13
   49a0b:	41 5e                	pop    %r14
   49a0d:	41 5f                	pop    %r15
   49a0f:	5d                   	pop    %rbp
   49a10:	c3                   	ret
   49a11:	48 8d 15 c0 ce 06 00 	lea    0x6cec0(%rip),%rdx        # b68d8 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x258>
   49a18:	ff 15 32 06 07 00    	call   *0x70632(%rip)        # ba050 <_DYNAMIC+0x300>
   49a1e:	c7 84 24 40 02 00 00 	movl   $0x0,0x240(%rsp)
   49a25:	00 00 00 00 
   49a29:	48 8d 3d 29 7e fc ff 	lea    -0x381d7(%rip),%rdi        # 11859 <BLAKE3_IV_3+0xd>
   49a30:	48 8d 0d c1 cd 06 00 	lea    0x6cdc1(%rip),%rcx        # b67f8 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x178>
   49a37:	4c 8d 05 82 ce 06 00 	lea    0x6ce82(%rip),%r8        # b68c0 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x240>
   49a3e:	48 8d 54 24 1f       	lea    0x1f(%rsp),%rdx
   49a43:	be 2b 00 00 00       	mov    $0x2b,%esi
   49a48:	ff 15 72 07 07 00    	call   *0x70772(%rip)        # ba1c0 <_DYNAMIC+0x470>
