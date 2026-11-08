
/home/samshackleton/blake3-reports/optimization-resume-20261108/private-bin/epyc-new-1:     file format elf64-x86-64


Disassembly of section .text:

0000000000048550 <blake3_servil::each::finalize_each>:
   48550:	55                   	push   %rbp
   48551:	48 89 e5             	mov    %rsp,%rbp
   48554:	41 57                	push   %r15
   48556:	41 56                	push   %r14
   48558:	41 55                	push   %r13
   4855a:	41 54                	push   %r12
   4855c:	53                   	push   %rbx
   4855d:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
   48561:	48 81 ec 40 04 00 00 	sub    $0x440,%rsp
   48568:	4c 89 44 24 48       	mov    %r8,0x48(%rsp)
   4856d:	48 89 54 24 50       	mov    %rdx,0x50(%rsp)
   48572:	48 89 74 24 38       	mov    %rsi,0x38(%rsp)
   48577:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
   4857e:	00 
   4857f:	4c 89 8c 24 c0 00 00 	mov    %r9,0xc0(%rsp)
   48586:	00 
   48587:	4c 39 c9             	cmp    %r9,%rcx
   4858a:	0f 85 ca 06 00 00    	jne    48c5a <blake3_servil::each::finalize_each+0x70a>
   48590:	49 89 fd             	mov    %rdi,%r13
   48593:	48 83 f9 0f          	cmp    $0xf,%rcx
   48597:	48 89 4c 24 58       	mov    %rcx,0x58(%rsp)
   4859c:	0f 86 e2 04 00 00    	jbe    48a84 <blake3_servil::each::finalize_each+0x534>
   485a2:	48 8b 05 7f dc 06 00 	mov    0x6dc7f(%rip),%rax        # b6228 <_DYNAMIC+0x720>
   485a9:	0f b6 00             	movzbl (%rax),%eax
   485ac:	84 c0                	test   %al,%al
   485ae:	0f 84 d2 06 00 00    	je     48c86 <blake3_servil::each::finalize_each+0x736>
   485b4:	3c 05                	cmp    $0x5,%al
   485b6:	0f 85 d1 04 00 00    	jne    48a8d <blake3_servil::each::finalize_each+0x53d>
   485bc:	48 8d 41 0f          	lea    0xf(%rcx),%rax
   485c0:	48 c1 e8 04          	shr    $0x4,%rax
   485c4:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
   485cb:	00 
   485cc:	45 31 ff             	xor    %r15d,%r15d
   485cf:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   485d4:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
   485d9:	48 89 c8             	mov    %rcx,%rax
   485dc:	48 8b 54 24 50       	mov    0x50(%rsp),%rdx
   485e1:	48 89 54 24 60       	mov    %rdx,0x60(%rsp)
   485e6:	eb 41                	jmp    48629 <blake3_servil::each::finalize_each+0xd9>
   485e8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   485ef:	00 
   485f0:	4c 8b bc 24 a8 00 00 	mov    0xa8(%rsp),%r15
   485f7:	00 
   485f8:	49 ff c7             	inc    %r15
   485fb:	48 83 6c 24 60 80    	subq   $0xffffffffffffff80,0x60(%rsp)
   48601:	48 8b 84 24 a0 00 00 	mov    0xa0(%rsp),%rax
   48608:	00 
   48609:	48 83 c0 f0          	add    $0xfffffffffffffff0,%rax
   4860d:	48 81 44 24 68 00 02 	addq   $0x200,0x68(%rsp)
   48614:	00 00 
   48616:	4c 3b bc 24 98 00 00 	cmp    0x98(%rsp),%r15
   4861d:	00 
   4861e:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
   48623:	0f 84 22 06 00 00    	je     48c4b <blake3_servil::each::finalize_each+0x6fb>
   48629:	48 83 f8 10          	cmp    $0x10,%rax
   4862d:	ba 10 00 00 00       	mov    $0x10,%edx
   48632:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
   48639:	00 
   4863a:	48 0f 42 d0          	cmovb  %rax,%rdx
   4863e:	48 89 94 24 b0 00 00 	mov    %rdx,0xb0(%rsp)
   48645:	00 
   48646:	4c 89 fb             	mov    %r15,%rbx
   48649:	48 c1 e3 04          	shl    $0x4,%rbx
   4864d:	48 89 c8             	mov    %rcx,%rax
   48650:	48 29 d8             	sub    %rbx,%rax
   48653:	48 83 f8 10          	cmp    $0x10,%rax
   48657:	4c 89 bc 24 a8 00 00 	mov    %r15,0xa8(%rsp)
   4865e:	00 
   4865f:	0f 82 5d 02 00 00    	jb     488c2 <blake3_servil::each::finalize_each+0x372>
   48665:	4c 89 f8             	mov    %r15,%rax
   48668:	48 c1 e0 07          	shl    $0x7,%rax
   4866c:	48 03 44 24 50       	add    0x50(%rsp),%rax
   48671:	48 8d 88 80 00 00 00 	lea    0x80(%rax),%rcx
   48678:	c6 44 24 37 00       	movb   $0x0,0x37(%rsp)
   4867d:	48 89 84 24 80 02 00 	mov    %rax,0x280(%rsp)
   48684:	00 
   48685:	48 89 8c 24 88 02 00 	mov    %rcx,0x288(%rsp)
   4868c:	00 
   4868d:	48 c7 84 24 90 02 00 	movq   $0x0,0x290(%rsp)
   48694:	00 00 00 00 00 
   48699:	48 89 84 24 98 02 00 	mov    %rax,0x298(%rsp)
   486a0:	00 
   486a1:	48 c7 84 24 a0 02 00 	movq   $0x10,0x2a0(%rsp)
   486a8:	00 10 00 00 00 
   486ad:	4c 89 ac 24 a8 02 00 	mov    %r13,0x2a8(%rsp)
   486b4:	00 
   486b5:	48 8b 44 24 38       	mov    0x38(%rsp),%rax
   486ba:	48 89 84 24 b0 02 00 	mov    %rax,0x2b0(%rsp)
   486c1:	00 
   486c2:	48 8d 44 24 37       	lea    0x37(%rsp),%rax
   486c7:	48 89 84 24 b8 02 00 	mov    %rax,0x2b8(%rsp)
   486ce:	00 
   486cf:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
   486d4:	48 8d b4 24 80 02 00 	lea    0x280(%rsp),%rsi
   486db:	00 
   486dc:	e8 ff dd 00 00       	call   564e0 <<core::iter::adapters::GenericShunt<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<usize>>, blake3_servil::each::finalize_each::{closure#0}>, core::option::Option<core::convert::Infallible>> as core::iter::traits::iterator::Iterator>::next>
   486e1:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
   486e7:	0f 84 c5 01 00 00    	je     488b2 <blake3_servil::each::finalize_each+0x362>
   486ed:	4d 89 fe             	mov    %r15,%r14
   486f0:	49 c1 e6 09          	shl    $0x9,%r14
   486f4:	4c 03 74 24 48       	add    0x48(%rsp),%r14
   486f9:	45 31 e4             	xor    %r12d,%r12d
   486fc:	45 31 ff             	xor    %r15d,%r15d
   486ff:	eb 4f                	jmp    48750 <blake3_servil::each::finalize_each+0x200>
   48701:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   48708:	0f 1f 84 00 00 00 00 
   4870f:	00 
   48710:	48 8d 84 24 c8 00 00 	lea    0xc8(%rsp),%rax
   48717:	00 
   48718:	4c 01 f8             	add    %r15,%rax
   4871b:	48 8b 8c 24 80 00 00 	mov    0x80(%rsp),%rcx
   48722:	00 
   48723:	48 89 48 10          	mov    %rcx,0x10(%rax)
   48727:	0f 10 44 24 70       	movups 0x70(%rsp),%xmm0
   4872c:	0f 11 00             	movups %xmm0,(%rax)
   4872f:	41 ff c4             	inc    %r12d
   48732:	48 8d 7c 24 70       	lea    0x70(%rsp),%rdi
   48737:	48 8d b4 24 80 02 00 	lea    0x280(%rsp),%rsi
   4873e:	00 
   4873f:	e8 9c dd 00 00       	call   564e0 <<core::iter::adapters::GenericShunt<core::iter::adapters::map::Map<core::iter::adapters::enumerate::Enumerate<core::slice::iter::Iter<usize>>, blake3_servil::each::finalize_each::{closure#0}>, core::option::Option<core::convert::Infallible>> as core::iter::traits::iterator::Iterator>::next>
   48744:	49 83 c7 18          	add    $0x18,%r15
   48748:	48 83 7c 24 70 00    	cmpq   $0x0,0x70(%rsp)
   4874e:	74 20                	je     48770 <blake3_servil::each::finalize_each+0x220>
   48750:	49 81 ff 80 01 00 00 	cmp    $0x180,%r15
   48757:	75 b7                	jne    48710 <blake3_servil::each::finalize_each+0x1c0>
   48759:	48 8d 3d 68 a3 06 00 	lea    0x6a368(%rip),%rdi        # b2ac8 <anon.214b6aaf620b6c72229f96ee5a0ca9bf.1.llvm.10250022233121038763>
   48760:	ff 15 ba da 06 00    	call   *0x6daba(%rip)        # b6220 <_DYNAMIC+0x718>
   48766:	eb a8                	jmp    48710 <blake3_servil::each::finalize_each+0x1c0>
   48768:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   4876f:	00 
   48770:	80 7c 24 37 00       	cmpb   $0x0,0x37(%rsp)
   48775:	0f 85 42 01 00 00    	jne    488bd <blake3_servil::each::finalize_each+0x36d>
   4877b:	ba 84 01 00 00       	mov    $0x184,%edx
   48780:	48 8d bc 24 84 02 00 	lea    0x284(%rsp),%rdi
   48787:	00 
   48788:	48 8d b4 24 c4 00 00 	lea    0xc4(%rsp),%rsi
   4878f:	00 
   48790:	ff 15 f2 d5 06 00    	call   *0x6d5f2(%rip)        # b5d88 <memcpy@GLIBC_2.14>
   48796:	44 89 a4 24 80 02 00 	mov    %r12d,0x280(%rsp)
   4879d:	00 
   4879e:	41 83 fc 10          	cmp    $0x10,%r12d
   487a2:	0f 85 38 05 00 00    	jne    48ce0 <blake3_servil::each::finalize_each+0x790>
   487a8:	48 8d bc 24 88 02 00 	lea    0x288(%rsp),%rdi
   487af:	00 
   487b0:	4c 89 f6             	mov    %r14,%rsi
   487b3:	ff 15 7f da 06 00    	call   *0x6da7f(%rip)        # b6238 <_DYNAMIC+0x730>
   487b9:	31 c0                	xor    %eax,%eax
   487bb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   487c0:	48 8b 4c 24 60       	mov    0x60(%rsp),%rcx
   487c5:	48 8b 3c 01          	mov    (%rcx,%rax,1),%rdi
   487c9:	48 3b 7c 24 38       	cmp    0x38(%rsp),%rdi
   487ce:	0f 83 dd 04 00 00    	jae    48cb1 <blake3_servil::each::finalize_each+0x761>
   487d4:	48 83 c0 08          	add    $0x8,%rax
   487d8:	48 8d 0c ff          	lea    (%rdi,%rdi,8),%rcx
   487dc:	48 c1 e1 0b          	shl    $0xb,%rcx
   487e0:	0f 57 c0             	xorps  %xmm0,%xmm0
   487e3:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
   487ea:	00 
   487eb:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
   487f2:	00 
   487f3:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
   487fa:	00 
   487fb:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
   48802:	00 
   48803:	41 0f 28 84 0d 80 00 	movaps 0x80(%r13,%rcx,1),%xmm0
   4880a:	00 00 
   4880c:	48 8d 94 24 00 01 00 	lea    0x100(%rsp),%rdx
   48813:	00 
   48814:	0f 29 02             	movaps %xmm0,(%rdx)
   48817:	41 0f 28 84 0d 90 00 	movaps 0x90(%r13,%rcx,1),%xmm0
   4881e:	00 00 
   48820:	0f 29 42 10          	movaps %xmm0,0x10(%rdx)
   48824:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
   4882b:	00 
   4882c:	0f 28 8c 24 00 01 00 	movaps 0x100(%rsp),%xmm1
   48833:	00 
   48834:	41 0f 29 44 0d 00    	movaps %xmm0,0x0(%r13,%rcx,1)
   4883a:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
   48841:	00 
   48842:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
   48849:	00 
   4884a:	41 0f 29 44 0d 10    	movaps %xmm0,0x10(%r13,%rcx,1)
   48850:	41 0f 29 4c 0d 40    	movaps %xmm1,0x40(%r13,%rcx,1)
   48856:	41 0f 29 54 0d 50    	movaps %xmm2,0x50(%r13,%rcx,1)
   4885c:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
   48863:	00 
   48864:	41 0f 29 44 0d 20    	movaps %xmm0,0x20(%r13,%rcx,1)
   4886a:	0f 28 84 24 f0 00 00 	movaps 0xf0(%rsp),%xmm0
   48871:	00 
   48872:	41 0f 29 44 0d 30    	movaps %xmm0,0x30(%r13,%rcx,1)
   48878:	49 c7 44 0d 60 00 00 	movq   $0x0,0x60(%r13,%rcx,1)
   4887f:	00 00 
   48881:	66 41 c7 44 0d 68 00 	movw   $0x0,0x68(%r13,%rcx,1)
   48888:	00 
   48889:	49 c7 84 0d a0 00 00 	movq   $0x0,0xa0(%r13,%rcx,1)
   48890:	00 00 00 00 00 
   48895:	49 c7 84 0d c0 47 00 	movq   $0x0,0x47c0(%r13,%rcx,1)
   4889c:	00 00 00 00 00 
   488a1:	48 3d 80 00 00 00    	cmp    $0x80,%rax
   488a7:	0f 85 13 ff ff ff    	jne    487c0 <blake3_servil::each::finalize_each+0x270>
   488ad:	e9 3e fd ff ff       	jmp    485f0 <blake3_servil::each::finalize_each+0xa0>
   488b2:	80 7c 24 37 00       	cmpb   $0x0,0x37(%rsp)
   488b7:	0f 84 18 04 00 00    	je     48cd5 <blake3_servil::each::finalize_each+0x785>
   488bd:	48 8b 4c 24 58       	mov    0x58(%rsp),%rcx
   488c2:	48 39 d9             	cmp    %rbx,%rcx
   488c5:	0f 84 25 fd ff ff    	je     485f0 <blake3_servil::each::finalize_each+0xa0>
   488cb:	4c 8b 64 24 68       	mov    0x68(%rsp),%r12
   488d0:	31 db                	xor    %ebx,%ebx
   488d2:	e9 02 01 00 00       	jmp    489d9 <blake3_servil::each::finalize_each+0x489>
   488d7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   488de:	00 00 
   488e0:	31 c9                	xor    %ecx,%ecx
   488e2:	ff 15 28 d9 06 00    	call   *0x6d928(%rip)        # b6210 <_DYNAMIC+0x708>
   488e8:	48 ff c3             	inc    %rbx
   488eb:	0f 28 84 24 80 02 00 	movaps 0x280(%rsp),%xmm0
   488f2:	00 
   488f3:	0f 28 8c 24 90 02 00 	movaps 0x290(%rsp),%xmm1
   488fa:	00 
   488fb:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
   48902:	00 
   48903:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
   48908:	41 0f 11 4c 24 10    	movups %xmm1,0x10(%r12)
   4890e:	41 0f 11 04 24       	movups %xmm0,(%r12)
   48913:	0f 57 c0             	xorps  %xmm0,%xmm0
   48916:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
   4891d:	00 
   4891e:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
   48925:	00 
   48926:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
   4892d:	00 
   4892e:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
   48935:	00 
   48936:	41 0f 28 87 80 00 00 	movaps 0x80(%r15),%xmm0
   4893d:	00 
   4893e:	48 8d 84 24 00 01 00 	lea    0x100(%rsp),%rax
   48945:	00 
   48946:	0f 29 00             	movaps %xmm0,(%rax)
   48949:	41 0f 28 87 90 00 00 	movaps 0x90(%r15),%xmm0
   48950:	00 
   48951:	0f 29 40 10          	movaps %xmm0,0x10(%rax)
   48955:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
   4895c:	00 
   4895d:	0f 28 8c 24 00 01 00 	movaps 0x100(%rsp),%xmm1
   48964:	00 
   48965:	41 0f 29 07          	movaps %xmm0,(%r15)
   48969:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
   48970:	00 
   48971:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
   48978:	00 
   48979:	41 0f 29 47 10       	movaps %xmm0,0x10(%r15)
   4897e:	41 0f 29 4f 40       	movaps %xmm1,0x40(%r15)
   48983:	41 0f 29 57 50       	movaps %xmm2,0x50(%r15)
   48988:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
   4898f:	00 
   48990:	41 0f 29 47 20       	movaps %xmm0,0x20(%r15)
   48995:	0f 28 84 24 f0 00 00 	movaps 0xf0(%rsp),%xmm0
   4899c:	00 
   4899d:	41 0f 29 47 30       	movaps %xmm0,0x30(%r15)
   489a2:	49 c7 47 60 00 00 00 	movq   $0x0,0x60(%r15)
   489a9:	00 
   489aa:	66 41 c7 47 68 00 00 	movw   $0x0,0x68(%r15)
   489b1:	49 c7 87 a0 00 00 00 	movq   $0x0,0xa0(%r15)
   489b8:	00 00 00 00 
   489bc:	49 c7 87 c0 47 00 00 	movq   $0x0,0x47c0(%r15)
   489c3:	00 00 00 00 
   489c7:	49 83 c4 20          	add    $0x20,%r12
   489cb:	48 39 9c 24 b0 00 00 	cmp    %rbx,0xb0(%rsp)
   489d2:	00 
   489d3:	0f 84 17 fc ff ff    	je     485f0 <blake3_servil::each::finalize_each+0xa0>
   489d9:	48 8b 44 24 60       	mov    0x60(%rsp),%rax
   489de:	48 8b 3c d8          	mov    (%rax,%rbx,8),%rdi
   489e2:	48 3b 7c 24 38       	cmp    0x38(%rsp),%rdi
   489e7:	0f 83 b2 02 00 00    	jae    48c9f <blake3_servil::each::finalize_each+0x74f>
   489ed:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   489f1:	48 c1 e0 0b          	shl    $0xb,%rax
   489f5:	4e 8d 3c 28          	lea    (%rax,%r13,1),%r15
   489f9:	4a 8d 34 28          	lea    (%rax,%r13,1),%rsi
   489fd:	48 81 c6 c0 07 00 00 	add    $0x7c0,%rsi
   48a04:	49 8b 94 05 c0 47 00 	mov    0x47c0(%r13,%rax,1),%rdx
   48a0b:	00 
   48a0c:	4c 89 ff             	mov    %r15,%rdi
   48a0f:	31 c9                	xor    %ecx,%ecx
   48a11:	e8 7a c1 00 00       	call   54b90 <<blake3_servil::incremental::HasherCore>::update_pooled>
   48a16:	4c 8d b4 24 c0 00 00 	lea    0xc0(%rsp),%r14
   48a1d:	00 
   48a1e:	4c 89 f7             	mov    %r14,%rdi
   48a21:	4c 89 fe             	mov    %r15,%rsi
   48a24:	e8 97 ba 00 00       	call   544c0 <<blake3_servil::incremental::HasherCore>::final_output>
   48a29:	48 8d 84 24 00 01 00 	lea    0x100(%rsp),%rax
   48a30:	00 
   48a31:	0f 28 00             	movaps (%rax),%xmm0
   48a34:	0f 28 48 10          	movaps 0x10(%rax),%xmm1
   48a38:	0f 29 8c 24 90 02 00 	movaps %xmm1,0x290(%rsp)
   48a3f:	00 
   48a40:	0f 29 84 24 80 02 00 	movaps %xmm0,0x280(%rsp)
   48a47:	00 
   48a48:	0f b6 84 24 30 01 00 	movzbl 0x130(%rsp),%eax
   48a4f:	00 
   48a50:	0c 08                	or     $0x8,%al
   48a52:	80 bc 24 31 01 00 00 	cmpb   $0x5,0x131(%rsp)
   48a59:	05 
   48a5a:	0f b6 94 24 20 01 00 	movzbl 0x120(%rsp),%edx
   48a61:	00 
   48a62:	44 0f b6 c0          	movzbl %al,%r8d
   48a66:	48 8d bc 24 80 02 00 	lea    0x280(%rsp),%rdi
   48a6d:	00 
   48a6e:	4c 89 f6             	mov    %r14,%rsi
   48a71:	0f 84 69 fe ff ff    	je     488e0 <blake3_servil::each::finalize_each+0x390>
   48a77:	31 c9                	xor    %ecx,%ecx
   48a79:	ff 15 99 d7 06 00    	call   *0x6d799(%rip)        # b6218 <_DYNAMIC+0x710>
   48a7f:	e9 64 fe ff ff       	jmp    488e8 <blake3_servil::each::finalize_each+0x398>
   48a84:	48 85 c9             	test   %rcx,%rcx
   48a87:	0f 84 be 01 00 00    	je     48c4b <blake3_servil::each::finalize_each+0x6fb>
   48a8d:	48 8d 9c 24 00 01 00 	lea    0x100(%rsp),%rbx
   48a94:	00 
   48a95:	45 31 f6             	xor    %r14d,%r14d
   48a98:	4c 8d bc 24 c0 00 00 	lea    0xc0(%rsp),%r15
   48a9f:	00 
   48aa0:	e9 0b 01 00 00       	jmp    48bb0 <blake3_servil::each::finalize_each+0x660>
   48aa5:	66 66 2e 0f 1f 84 00 	data16 cs nopw 0x0(%rax,%rax,1)
   48aac:	00 00 00 00 
   48ab0:	31 c9                	xor    %ecx,%ecx
   48ab2:	ff 15 58 d7 06 00    	call   *0x6d758(%rip)        # b6210 <_DYNAMIC+0x708>
   48ab8:	49 ff c6             	inc    %r14
   48abb:	0f 28 84 24 80 02 00 	movaps 0x280(%rsp),%xmm0
   48ac2:	00 
   48ac3:	0f 28 8c 24 90 02 00 	movaps 0x290(%rsp),%xmm1
   48aca:	00 
   48acb:	0f 29 8c 24 80 00 00 	movaps %xmm1,0x80(%rsp)
   48ad2:	00 
   48ad3:	0f 29 44 24 70       	movaps %xmm0,0x70(%rsp)
   48ad8:	48 8b 44 24 48       	mov    0x48(%rsp),%rax
   48add:	0f 11 48 10          	movups %xmm1,0x10(%rax)
   48ae1:	0f 11 00             	movups %xmm0,(%rax)
   48ae4:	0f 57 c0             	xorps  %xmm0,%xmm0
   48ae7:	0f 29 84 24 c0 00 00 	movaps %xmm0,0xc0(%rsp)
   48aee:	00 
   48aef:	0f 29 84 24 f0 00 00 	movaps %xmm0,0xf0(%rsp)
   48af6:	00 
   48af7:	0f 29 84 24 e0 00 00 	movaps %xmm0,0xe0(%rsp)
   48afe:	00 
   48aff:	0f 29 84 24 d0 00 00 	movaps %xmm0,0xd0(%rsp)
   48b06:	00 
   48b07:	41 0f 28 84 24 80 00 	movaps 0x80(%r12),%xmm0
   48b0e:	00 00 
   48b10:	0f 29 03             	movaps %xmm0,(%rbx)
   48b13:	41 0f 28 84 24 90 00 	movaps 0x90(%r12),%xmm0
   48b1a:	00 00 
   48b1c:	0f 29 43 10          	movaps %xmm0,0x10(%rbx)
   48b20:	0f 28 84 24 c0 00 00 	movaps 0xc0(%rsp),%xmm0
   48b27:	00 
   48b28:	0f 28 8c 24 00 01 00 	movaps 0x100(%rsp),%xmm1
   48b2f:	00 
   48b30:	41 0f 29 04 24       	movaps %xmm0,(%r12)
   48b35:	0f 28 84 24 d0 00 00 	movaps 0xd0(%rsp),%xmm0
   48b3c:	00 
   48b3d:	0f 28 94 24 10 01 00 	movaps 0x110(%rsp),%xmm2
   48b44:	00 
   48b45:	41 0f 29 44 24 10    	movaps %xmm0,0x10(%r12)
   48b4b:	41 0f 29 4c 24 40    	movaps %xmm1,0x40(%r12)
   48b51:	41 0f 29 54 24 50    	movaps %xmm2,0x50(%r12)
   48b57:	0f 28 84 24 e0 00 00 	movaps 0xe0(%rsp),%xmm0
   48b5e:	00 
   48b5f:	41 0f 29 44 24 20    	movaps %xmm0,0x20(%r12)
   48b65:	0f 28 84 24 f0 00 00 	movaps 0xf0(%rsp),%xmm0
   48b6c:	00 
   48b6d:	41 0f 29 44 24 30    	movaps %xmm0,0x30(%r12)
   48b73:	49 c7 44 24 60 00 00 	movq   $0x0,0x60(%r12)
   48b7a:	00 00 
   48b7c:	66 41 c7 44 24 68 00 	movw   $0x0,0x68(%r12)
   48b83:	00 
   48b84:	49 c7 84 24 a0 00 00 	movq   $0x0,0xa0(%r12)
   48b8b:	00 00 00 00 00 
   48b90:	49 c7 84 24 c0 47 00 	movq   $0x0,0x47c0(%r12)
   48b97:	00 00 00 00 00 
   48b9c:	48 83 c0 20          	add    $0x20,%rax
   48ba0:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
   48ba5:	4c 39 74 24 58       	cmp    %r14,0x58(%rsp)
   48baa:	0f 84 9b 00 00 00    	je     48c4b <blake3_servil::each::finalize_each+0x6fb>
   48bb0:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
   48bb5:	4a 8b 3c f0          	mov    (%rax,%r14,8),%rdi
   48bb9:	48 3b 7c 24 38       	cmp    0x38(%rsp),%rdi
   48bbe:	0f 83 ff 00 00 00    	jae    48cc3 <blake3_servil::each::finalize_each+0x773>
   48bc4:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   48bc8:	48 c1 e0 0b          	shl    $0xb,%rax
   48bcc:	4e 8d 24 28          	lea    (%rax,%r13,1),%r12
   48bd0:	4a 8d 34 28          	lea    (%rax,%r13,1),%rsi
   48bd4:	48 81 c6 c0 07 00 00 	add    $0x7c0,%rsi
   48bdb:	49 8b 94 05 c0 47 00 	mov    0x47c0(%r13,%rax,1),%rdx
   48be2:	00 
   48be3:	4c 89 e7             	mov    %r12,%rdi
   48be6:	31 c9                	xor    %ecx,%ecx
   48be8:	e8 a3 bf 00 00       	call   54b90 <<blake3_servil::incremental::HasherCore>::update_pooled>
   48bed:	4c 89 ff             	mov    %r15,%rdi
   48bf0:	4c 89 e6             	mov    %r12,%rsi
   48bf3:	e8 c8 b8 00 00       	call   544c0 <<blake3_servil::incremental::HasherCore>::final_output>
   48bf8:	0f 28 03             	movaps (%rbx),%xmm0
   48bfb:	0f 28 4b 10          	movaps 0x10(%rbx),%xmm1
   48bff:	0f 29 8c 24 90 02 00 	movaps %xmm1,0x290(%rsp)
   48c06:	00 
   48c07:	0f 29 84 24 80 02 00 	movaps %xmm0,0x280(%rsp)
   48c0e:	00 
   48c0f:	0f b6 84 24 30 01 00 	movzbl 0x130(%rsp),%eax
   48c16:	00 
   48c17:	0c 08                	or     $0x8,%al
   48c19:	80 bc 24 31 01 00 00 	cmpb   $0x5,0x131(%rsp)
   48c20:	05 
   48c21:	0f b6 94 24 20 01 00 	movzbl 0x120(%rsp),%edx
   48c28:	00 
   48c29:	44 0f b6 c0          	movzbl %al,%r8d
   48c2d:	48 8d bc 24 80 02 00 	lea    0x280(%rsp),%rdi
   48c34:	00 
   48c35:	4c 89 fe             	mov    %r15,%rsi
   48c38:	0f 84 72 fe ff ff    	je     48ab0 <blake3_servil::each::finalize_each+0x560>
   48c3e:	31 c9                	xor    %ecx,%ecx
   48c40:	ff 15 d2 d5 06 00    	call   *0x6d5d2(%rip)        # b6218 <_DYNAMIC+0x710>
   48c46:	e9 6d fe ff ff       	jmp    48ab8 <blake3_servil::each::finalize_each+0x568>
   48c4b:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
   48c4f:	5b                   	pop    %rbx
   48c50:	41 5c                	pop    %r12
   48c52:	41 5d                	pop    %r13
   48c54:	41 5e                	pop    %r14
   48c56:	41 5f                	pop    %r15
   48c58:	5d                   	pop    %rbp
   48c59:	c3                   	ret
   48c5a:	48 8d 0d 23 8e fc ff 	lea    -0x371dd(%rip),%rcx        # 11a84 <BLAKE3_IV_3+0x38>
   48c61:	4c 8d 0d a8 9c 06 00 	lea    0x69ca8(%rip),%r9        # b2910 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x180>
   48c68:	48 8d b4 24 b8 00 00 	lea    0xb8(%rsp),%rsi
   48c6f:	00 
   48c70:	48 8d 94 24 c0 00 00 	lea    0xc0(%rsp),%rdx
   48c77:	00 
   48c78:	41 b8 39 00 00 00    	mov    $0x39,%r8d
   48c7e:	31 ff                	xor    %edi,%edi
   48c80:	ff 15 ba d5 06 00    	call   *0x6d5ba(%rip)        # b6240 <_DYNAMIC+0x738>
   48c86:	48 89 cb             	mov    %rcx,%rbx
   48c89:	ff 15 a1 d5 06 00    	call   *0x6d5a1(%rip)        # b6230 <_DYNAMIC+0x728>
   48c8f:	48 89 d9             	mov    %rbx,%rcx
   48c92:	3c 05                	cmp    $0x5,%al
   48c94:	0f 84 22 f9 ff ff    	je     485bc <blake3_servil::each::finalize_each+0x6c>
   48c9a:	e9 ee fd ff ff       	jmp    48a8d <blake3_servil::each::finalize_each+0x53d>
   48c9f:	48 8d 15 ca 9c 06 00 	lea    0x69cca(%rip),%rdx        # b2970 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x1e0>
   48ca6:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
   48cab:	ff 15 57 d1 06 00    	call   *0x6d157(%rip)        # b5e08 <_DYNAMIC+0x300>
   48cb1:	48 8d 15 a0 9c 06 00 	lea    0x69ca0(%rip),%rdx        # b2958 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x1c8>
   48cb8:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
   48cbd:	ff 15 45 d1 06 00    	call   *0x6d145(%rip)        # b5e08 <_DYNAMIC+0x300>
   48cc3:	48 8d 15 5e 9c 06 00 	lea    0x69c5e(%rip),%rdx        # b2928 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x198>
   48cca:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
   48ccf:	ff 15 33 d1 06 00    	call   *0x6d133(%rip)        # b5e08 <_DYNAMIC+0x300>
   48cd5:	c7 84 24 80 02 00 00 	movl   $0x0,0x280(%rsp)
   48cdc:	00 00 00 00 
   48ce0:	48 8d 3d 72 8d fc ff 	lea    -0x3728e(%rip),%rdi        # 11a59 <BLAKE3_IV_3+0xd>
   48ce7:	48 8d 0d 02 9c 06 00 	lea    0x69c02(%rip),%rcx        # b28f0 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x160>
   48cee:	4c 8d 05 4b 9c 06 00 	lea    0x69c4b(%rip),%r8        # b2940 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x1b0>
   48cf5:	48 8d 54 24 47       	lea    0x47(%rsp),%rdx
   48cfa:	be 2b 00 00 00       	mov    $0x2b,%esi
   48cff:	ff 15 5b d2 06 00    	call   *0x6d25b(%rip)        # b5f60 <_DYNAMIC+0x458>
