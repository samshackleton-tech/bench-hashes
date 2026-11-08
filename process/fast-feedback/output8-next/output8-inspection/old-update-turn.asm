
/home/samshackleton/blake3-reports/optimization-resume-20261108/output8-private-bin/old-1:     file format elf64-x86-64


Disassembly of section .text:

0000000000048ed0 <blake3_servil::each::update_turn>:
   48ed0:	55                   	push   %rbp
   48ed1:	41 57                	push   %r15
   48ed3:	41 56                	push   %r14
   48ed5:	41 55                	push   %r13
   48ed7:	41 54                	push   %r12
   48ed9:	53                   	push   %rbx
   48eda:	48 81 ec c8 00 00 00 	sub    $0xc8,%rsp
   48ee1:	44 89 44 24 5c       	mov    %r8d,0x5c(%rsp)
   48ee6:	49 89 cd             	mov    %rcx,%r13
   48ee9:	48 89 d3             	mov    %rdx,%rbx
   48eec:	48 89 74 24 08       	mov    %rsi,0x8(%rsp)
   48ef1:	48 83 fe 10          	cmp    $0x10,%rsi
   48ef5:	48 89 7c 24 50       	mov    %rdi,0x50(%rsp)
   48efa:	0f 82 5e 01 00 00    	jb     4905e <blake3_servil::each::update_turn+0x18e>
   48f00:	49 89 ff             	mov    %rdi,%r15
   48f03:	48 8b 05 6e 15 07 00 	mov    0x7156e(%rip),%rax        # ba478 <_DYNAMIC+0x728>
   48f0a:	0f b6 00             	movzbl (%rax),%eax
   48f0d:	84 c0                	test   %al,%al
   48f0f:	0f 84 62 06 00 00    	je     49577 <blake3_servil::each::update_turn+0x6a7>
   48f15:	3c 05                	cmp    $0x5,%al
   48f17:	0f 85 41 01 00 00    	jne    4905e <blake3_servil::each::update_turn+0x18e>
   48f1d:	4d 85 ed             	test   %r13,%r13
   48f20:	0f 84 2b 01 00 00    	je     49051 <blake3_servil::each::update_turn+0x181>
   48f26:	48 89 5c 24 30       	mov    %rbx,0x30(%rsp)
   48f2b:	48 83 c3 10          	add    $0x10,%rbx
   48f2f:	31 d2                	xor    %edx,%edx
   48f31:	66 66 66 66 66 66 2e 	data16 data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   48f38:	0f 1f 84 00 00 00 00 
   48f3f:	00 
   48f40:	48 8b 7b f0          	mov    -0x10(%rbx),%rdi
   48f44:	48 3b 7c 24 08       	cmp    0x8(%rsp),%rdi
   48f49:	0f 83 51 06 00 00    	jae    495a0 <blake3_servil::each::update_turn+0x6d0>
   48f4f:	4c 8d 34 ff          	lea    (%rdi,%rdi,8),%r14
   48f53:	49 c1 e6 0b          	shl    $0xb,%r14
   48f57:	4b 83 bc 37 90 07 00 	cmpq   $0x0,0x790(%r15,%r14,1)
   48f5e:	00 00 
   48f60:	0f 85 db 00 00 00    	jne    49041 <blake3_servil::each::update_turn+0x171>
   48f66:	4b 83 7c 37 60 00    	cmpq   $0x0,0x60(%r15,%r14,1)
   48f6c:	0f 85 cf 00 00 00    	jne    49041 <blake3_servil::each::update_turn+0x171>
   48f72:	43 80 7c 37 69 00    	cmpb   $0x0,0x69(%r15,%r14,1)
   48f78:	0f 85 c3 00 00 00    	jne    49041 <blake3_servil::each::update_turn+0x171>
   48f7e:	4b 83 bc 37 a0 00 00 	cmpq   $0x0,0xa0(%r15,%r14,1)
   48f85:	00 00 
   48f87:	0f 85 b4 00 00 00    	jne    49041 <blake3_servil::each::update_turn+0x171>
   48f8d:	4d 01 fe             	add    %r15,%r14
   48f90:	4c 8b 7b f8          	mov    -0x8(%rbx),%r15
   48f94:	4c 8b 23             	mov    (%rbx),%r12
   48f97:	49 8b 86 c0 47 00 00 	mov    0x47c0(%r14),%rax
   48f9e:	41 0f b6 4e 68       	movzbl 0x68(%r14),%ecx
   48fa3:	48 85 c0             	test   %rax,%rax
   48fa6:	74 09                	je     48fb1 <blake3_servil::each::update_turn+0xe1>
   48fa8:	80 f9 40             	cmp    $0x40,%cl
   48fab:	0f 85 90 00 00 00    	jne    49041 <blake3_servil::each::update_turn+0x171>
   48fb1:	0f b6 f9             	movzbl %cl,%edi
   48fb4:	4c 01 e0             	add    %r12,%rax
   48fb7:	48 01 f8             	add    %rdi,%rax
   48fba:	48 3d 00 04 00 00    	cmp    $0x400,%rax
   48fc0:	77 7f                	ja     49041 <blake3_servil::each::update_turn+0x171>
   48fc2:	bd 40 00 00 00       	mov    $0x40,%ebp
   48fc7:	48 29 fd             	sub    %rdi,%rbp
   48fca:	4c 39 e5             	cmp    %r12,%rbp
   48fcd:	49 0f 43 ec          	cmovae %r12,%rbp
   48fd1:	48 8d 34 2f          	lea    (%rdi,%rbp,1),%rsi
   48fd5:	48 83 fe 41          	cmp    $0x41,%rsi
   48fd9:	0f 83 40 05 00 00    	jae    4951f <blake3_servil::each::update_turn+0x64f>
   48fdf:	4c 01 f7             	add    %r14,%rdi
   48fe2:	4c 89 fe             	mov    %r15,%rsi
   48fe5:	48 89 54 24 10       	mov    %rdx,0x10(%rsp)
   48fea:	48 89 ea             	mov    %rbp,%rdx
   48fed:	ff 15 dd 0f 07 00    	call   *0x70fdd(%rip)        # b9fd0 <memcpy@GLIBC_2.14>
   48ff3:	41 00 6e 68          	add    %bpl,0x68(%r14)
   48ff7:	49 29 ec             	sub    %rbp,%r12
   48ffa:	49 01 ef             	add    %rbp,%r15
   48ffd:	49 8b 86 c0 47 00 00 	mov    0x47c0(%r14),%rax
   49004:	49 8d 3c 06          	lea    (%r14,%rax,1),%rdi
   49008:	48 81 c7 c0 07 00 00 	add    $0x7c0,%rdi
   4900f:	4c 89 fe             	mov    %r15,%rsi
   49012:	4c 89 e2             	mov    %r12,%rdx
   49015:	ff 15 b5 0f 07 00    	call   *0x70fb5(%rip)        # b9fd0 <memcpy@GLIBC_2.14>
   4901b:	48 8b 54 24 10       	mov    0x10(%rsp),%rdx
   49020:	4d 01 a6 c0 47 00 00 	add    %r12,0x47c0(%r14)
   49027:	48 ff c2             	inc    %rdx
   4902a:	48 83 c3 18          	add    $0x18,%rbx
   4902e:	49 39 d5             	cmp    %rdx,%r13
   49031:	4c 8b 7c 24 50       	mov    0x50(%rsp),%r15
   49036:	0f 85 04 ff ff ff    	jne    48f40 <blake3_servil::each::update_turn+0x70>
   4903c:	4c 89 ea             	mov    %r13,%rdx
   4903f:	eb 09                	jmp    4904a <blake3_servil::each::update_turn+0x17a>
   49041:	4c 39 ea             	cmp    %r13,%rdx
   49044:	0f 87 40 05 00 00    	ja     4958a <blake3_servil::each::update_turn+0x6ba>
   4904a:	48 8b 5c 24 30       	mov    0x30(%rsp),%rbx
   4904f:	eb 02                	jmp    49053 <blake3_servil::each::update_turn+0x183>
   49051:	31 d2                	xor    %edx,%edx
   49053:	49 29 d5             	sub    %rdx,%r13
   49056:	48 8d 04 52          	lea    (%rdx,%rdx,2),%rax
   4905a:	48 8d 1c c3          	lea    (%rbx,%rax,8),%rbx
   4905e:	4d 85 ed             	test   %r13,%r13
   49061:	0f 84 a6 04 00 00    	je     4950d <blake3_servil::each::update_turn+0x63d>
   49067:	4a 8d 04 ed 00 00 00 	lea    0x0(,%r13,8),%rax
   4906e:	00 
   4906f:	4c 8d 24 40          	lea    (%rax,%rax,2),%r12
   49073:	ff 15 17 0f 07 00    	call   *0x70f17(%rip)        # b9f90 <_DYNAMIC+0x240>
   49079:	be 08 00 00 00       	mov    $0x8,%esi
   4907e:	4c 89 e7             	mov    %r12,%rdi
   49081:	ff 15 11 0f 07 00    	call   *0x70f11(%rip)        # b9f98 <_DYNAMIC+0x248>
   49087:	48 85 c0             	test   %rax,%rax
   4908a:	0f 84 22 05 00 00    	je     495b2 <blake3_servil::each::update_turn+0x6e2>
   49090:	49 89 c6             	mov    %rax,%r14
   49093:	48 89 c7             	mov    %rax,%rdi
   49096:	48 89 de             	mov    %rbx,%rsi
   49099:	4c 89 e2             	mov    %r12,%rdx
   4909c:	ff 15 2e 0f 07 00    	call   *0x70f2e(%rip)        # b9fd0 <memcpy@GLIBC_2.14>
   490a2:	48 c7 44 24 18 00 00 	movq   $0x0,0x18(%rsp)
   490a9:	00 00 
   490ab:	48 c7 44 24 20 08 00 	movq   $0x8,0x20(%rsp)
   490b2:	00 00 
   490b4:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
   490bb:	00 00 
   490bd:	48 c7 44 24 38 00 00 	movq   $0x0,0x38(%rsp)
   490c4:	00 00 
   490c6:	48 c7 44 24 40 08 00 	movq   $0x8,0x40(%rsp)
   490cd:	00 00 
   490cf:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
   490d6:	00 00 
   490d8:	4c 89 eb             	mov    %r13,%rbx
   490db:	eb 37                	jmp    49114 <blake3_servil::each::update_turn+0x244>
   490dd:	0f 1f 00             	nopl   (%rax)
   490e0:	48 c7 44 24 48 00 00 	movq   $0x0,0x48(%rsp)
   490e7:	00 00 
   490e9:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
   490ee:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   490f3:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   490f8:	48 8b 4c 24 10       	mov    0x10(%rsp),%rcx
   490fd:	48 89 4c 24 20       	mov    %rcx,0x20(%rsp)
   49102:	48 c7 44 24 28 00 00 	movq   $0x0,0x28(%rsp)
   49109:	00 00 
   4910b:	4d 85 ed             	test   %r13,%r13
   4910e:	0f 84 a3 03 00 00    	je     494b7 <blake3_servil::each::update_turn+0x5e7>
   49114:	48 89 5c 24 30       	mov    %rbx,0x30(%rsp)
   49119:	4c 89 6c 24 60       	mov    %r13,0x60(%rsp)
   4911e:	4a 8d 04 6d 00 00 00 	lea    0x0(,%r13,2),%rax
   49125:	00 
   49126:	4c 01 e8             	add    %r13,%rax
   49129:	49 8d 1c c6          	lea    (%r14,%rax,8),%rbx
   4912d:	4c 89 74 24 10       	mov    %r14,0x10(%rsp)
   49132:	eb 3f                	jmp    49173 <blake3_servil::each::update_turn+0x2a3>
   49134:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   4913b:	00 00 00 00 00 
   49140:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
   49145:	48 8d 0c 6d 00 00 00 	lea    0x0(,%rbp,2),%rcx
   4914c:	00 
   4914d:	48 01 e9             	add    %rbp,%rcx
   49150:	4c 89 3c c8          	mov    %r15,(%rax,%rcx,8)
   49154:	4c 89 6c c8 08       	mov    %r13,0x8(%rax,%rcx,8)
   49159:	4c 89 64 c8 10       	mov    %r12,0x10(%rax,%rcx,8)
   4915e:	48 ff c5             	inc    %rbp
   49161:	48 89 6c 24 28       	mov    %rbp,0x28(%rsp)
   49166:	49 83 c6 18          	add    $0x18,%r14
   4916a:	49 39 de             	cmp    %rbx,%r14
   4916d:	0f 84 fd 00 00 00    	je     49270 <blake3_servil::each::update_turn+0x3a0>
   49173:	4d 8b 3e             	mov    (%r14),%r15
   49176:	4c 3b 7c 24 08       	cmp    0x8(%rsp),%r15
   4917b:	0f 83 b0 03 00 00    	jae    49531 <blake3_servil::each::update_turn+0x661>
   49181:	4d 8b 6e 08          	mov    0x8(%r14),%r13
   49185:	4d 8b 66 10          	mov    0x10(%r14),%r12
   49189:	4b 8d 2c ff          	lea    (%r15,%r15,8),%rbp
   4918d:	48 c1 e5 0b          	shl    $0xb,%rbp
   49191:	48 8b 44 24 50       	mov    0x50(%rsp),%rax
   49196:	48 81 bc 28 c0 47 00 	cmpq   $0x4000,0x47c0(%rax,%rbp,1)
   4919d:	00 00 40 00 00 
   491a2:	75 2c                	jne    491d0 <blake3_servil::each::update_turn+0x300>
   491a4:	48 83 bc 28 90 07 00 	cmpq   $0x0,0x790(%rax,%rbp,1)
   491ab:	00 00 
   491ad:	75 21                	jne    491d0 <blake3_servil::each::update_turn+0x300>
   491af:	48 8b 6c 24 28       	mov    0x28(%rsp),%rbp
   491b4:	48 3b 6c 24 18       	cmp    0x18(%rsp),%rbp
   491b9:	75 85                	jne    49140 <blake3_servil::each::update_turn+0x270>
   491bb:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
   491c0:	ff 15 aa 0e 07 00    	call   *0x70eaa(%rip)        # ba070 <_DYNAMIC+0x320>
   491c6:	e9 75 ff ff ff       	jmp    49140 <blake3_servil::each::update_turn+0x270>
   491cb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   491d0:	48 01 c5             	add    %rax,%rbp
   491d3:	0f b6 4c 24 5c       	movzbl 0x5c(%rsp),%ecx
   491d8:	48 89 ef             	mov    %rbp,%rdi
   491db:	4c 89 ee             	mov    %r13,%rsi
   491de:	4c 89 e2             	mov    %r12,%rdx
   491e1:	41 b8 01 00 00 00    	mov    $0x1,%r8d
   491e7:	e8 e4 f8 00 00       	call   58ad0 <<blake3_servil::incremental::Hasher>::gather_part>
   491ec:	48 81 bd c0 47 00 00 	cmpq   $0x4000,0x47c0(%rbp)
   491f3:	00 40 00 00 
   491f7:	0f 85 69 ff ff ff    	jne    49166 <blake3_servil::each::update_turn+0x296>
   491fd:	48 83 bd 90 07 00 00 	cmpq   $0x0,0x790(%rbp)
   49204:	00 
   49205:	0f 85 5b ff ff ff    	jne    49166 <blake3_servil::each::update_turn+0x296>
   4920b:	49 89 c5             	mov    %rax,%r13
   4920e:	49 89 d4             	mov    %rdx,%r12
   49211:	48 8b 6c 24 48       	mov    0x48(%rsp),%rbp
   49216:	48 3b 6c 24 38       	cmp    0x38(%rsp),%rbp
   4921b:	75 0b                	jne    49228 <blake3_servil::each::update_turn+0x358>
   4921d:	48 8d 7c 24 38       	lea    0x38(%rsp),%rdi
   49222:	ff 15 30 12 07 00    	call   *0x71230(%rip)        # ba458 <_DYNAMIC+0x708>
   49228:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
   4922d:	4c 89 3c e8          	mov    %r15,(%rax,%rbp,8)
   49231:	48 ff c5             	inc    %rbp
   49234:	48 89 6c 24 48       	mov    %rbp,0x48(%rsp)
   49239:	4d 85 e4             	test   %r12,%r12
   4923c:	0f 84 24 ff ff ff    	je     49166 <blake3_servil::each::update_turn+0x296>
   49242:	48 8b 6c 24 28       	mov    0x28(%rsp),%rbp
   49247:	48 3b 6c 24 18       	cmp    0x18(%rsp),%rbp
   4924c:	0f 85 ee fe ff ff    	jne    49140 <blake3_servil::each::update_turn+0x270>
   49252:	48 8d 7c 24 18       	lea    0x18(%rsp),%rdi
   49257:	ff 15 13 0e 07 00    	call   *0x70e13(%rip)        # ba070 <_DYNAMIC+0x320>
   4925d:	e9 de fe ff ff       	jmp    49140 <blake3_servil::each::update_turn+0x270>
   49262:	66 66 66 66 66 2e 0f 	data16 data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   49269:	1f 84 00 00 00 00 00 
   49270:	48 8b 54 24 40       	mov    0x40(%rsp),%rdx
   49275:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
   4927a:	48 8b 5c 24 50       	mov    0x50(%rsp),%rbx
   4927f:	48 89 df             	mov    %rbx,%rdi
   49282:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   49287:	e8 b4 11 00 00       	call   4a440 <blake3_servil::each::hash_held>
   4928c:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
   49291:	48 8b 4c 24 48       	mov    0x48(%rsp),%rcx
   49296:	48 85 c9             	test   %rcx,%rcx
   49299:	74 55                	je     492f0 <blake3_servil::each::update_turn+0x420>
   4929b:	48 c1 e1 03          	shl    $0x3,%rcx
   4929f:	31 d2                	xor    %edx,%edx
   492a1:	eb 16                	jmp    492b9 <blake3_servil::each::update_turn+0x3e9>
   492a3:	66 66 66 66 2e 0f 1f 	data16 data16 data16 cs nopw 0x0(%rax,%rax,1)
   492aa:	84 00 00 00 00 00 
   492b0:	48 83 c2 08          	add    $0x8,%rdx
   492b4:	48 39 d1             	cmp    %rdx,%rcx
   492b7:	74 37                	je     492f0 <blake3_servil::each::update_turn+0x420>
   492b9:	48 8b 04 17          	mov    (%rdi,%rdx,1),%rax
   492bd:	48 3b 44 24 08       	cmp    0x8(%rsp),%rax
   492c2:	0f 83 80 02 00 00    	jae    49548 <blake3_servil::each::update_turn+0x678>
   492c8:	48 8d 04 c0          	lea    (%rax,%rax,8),%rax
   492cc:	48 c1 e0 0b          	shl    $0xb,%rax
   492d0:	48 81 bc 03 c0 47 00 	cmpq   $0x4000,0x47c0(%rbx,%rax,1)
   492d7:	00 00 40 00 00 
   492dc:	75 d2                	jne    492b0 <blake3_servil::each::update_turn+0x3e0>
   492de:	48 83 bc 03 90 07 00 	cmpq   $0x0,0x790(%rbx,%rax,1)
   492e5:	00 00 
   492e7:	75 c7                	jne    492b0 <blake3_servil::each::update_turn+0x3e0>
   492e9:	e9 71 02 00 00       	jmp    4955f <blake3_servil::each::update_turn+0x68f>
   492ee:	66 90                	xchg   %ax,%ax
   492f0:	4c 8b 54 24 60       	mov    0x60(%rsp),%r10
   492f5:	44 89 d1             	mov    %r10d,%ecx
   492f8:	83 e1 03             	and    $0x3,%ecx
   492fb:	49 83 fa 04          	cmp    $0x4,%r10
   492ff:	73 0f                	jae    49310 <blake3_servil::each::update_turn+0x440>
   49301:	31 d2                	xor    %edx,%edx
   49303:	31 c0                	xor    %eax,%eax
   49305:	eb 4a                	jmp    49351 <blake3_servil::each::update_turn+0x481>
   49307:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   4930e:	00 00 
   49310:	4c 89 d6             	mov    %r10,%rsi
   49313:	48 83 e6 fc          	and    $0xfffffffffffffffc,%rsi
   49317:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
   4931c:	4c 8d 40 58          	lea    0x58(%rax),%r8
   49320:	31 d2                	xor    %edx,%edx
   49322:	31 c0                	xor    %eax,%eax
   49324:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   4932b:	00 00 00 00 00 
   49330:	49 03 40 b8          	add    -0x48(%r8),%rax
   49334:	49 03 40 d0          	add    -0x30(%r8),%rax
   49338:	49 03 40 e8          	add    -0x18(%r8),%rax
   4933c:	49 03 00             	add    (%r8),%rax
   4933f:	48 83 c2 04          	add    $0x4,%rdx
   49343:	49 83 c0 60          	add    $0x60,%r8
   49347:	48 39 d6             	cmp    %rdx,%rsi
   4934a:	75 e4                	jne    49330 <blake3_servil::each::update_turn+0x460>
   4934c:	48 85 c9             	test   %rcx,%rcx
   4934f:	74 2c                	je     4937d <blake3_servil::each::update_turn+0x4ad>
   49351:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
   49355:	48 8b 74 24 10       	mov    0x10(%rsp),%rsi
   4935a:	48 8d 14 d6          	lea    (%rsi,%rdx,8),%rdx
   4935e:	48 83 c2 10          	add    $0x10,%rdx
   49362:	c1 e1 03             	shl    $0x3,%ecx
   49365:	48 8d 0c 49          	lea    (%rcx,%rcx,2),%rcx
   49369:	31 f6                	xor    %esi,%esi
   4936b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   49370:	48 03 04 32          	add    (%rdx,%rsi,1),%rax
   49374:	48 83 c6 18          	add    $0x18,%rsi
   49378:	48 39 f1             	cmp    %rsi,%rcx
   4937b:	75 f3                	jne    49370 <blake3_servil::each::update_turn+0x4a0>
   4937d:	4c 8b 74 24 20       	mov    0x20(%rsp),%r14
   49382:	4c 8b 6c 24 28       	mov    0x28(%rsp),%r13
   49387:	4d 85 ed             	test   %r13,%r13
   4938a:	74 14                	je     493a0 <blake3_servil::each::update_turn+0x4d0>
   4938c:	44 89 ea             	mov    %r13d,%edx
   4938f:	83 e2 03             	and    $0x3,%edx
   49392:	49 83 fd 04          	cmp    $0x4,%r13
   49396:	73 18                	jae    493b0 <blake3_servil::each::update_turn+0x4e0>
   49398:	31 f6                	xor    %esi,%esi
   4939a:	31 c9                	xor    %ecx,%ecx
   4939c:	eb 43                	jmp    493e1 <blake3_servil::each::update_turn+0x511>
   4939e:	66 90                	xchg   %ax,%ax
   493a0:	31 c9                	xor    %ecx,%ecx
   493a2:	eb 69                	jmp    4940d <blake3_servil::each::update_turn+0x53d>
   493a4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   493ab:	00 00 00 00 00 
   493b0:	4d 89 e8             	mov    %r13,%r8
   493b3:	49 83 e0 fc          	and    $0xfffffffffffffffc,%r8
   493b7:	4d 8d 4e 58          	lea    0x58(%r14),%r9
   493bb:	31 f6                	xor    %esi,%esi
   493bd:	31 c9                	xor    %ecx,%ecx
   493bf:	90                   	nop
   493c0:	49 03 49 b8          	add    -0x48(%r9),%rcx
   493c4:	49 03 49 d0          	add    -0x30(%r9),%rcx
   493c8:	49 03 49 e8          	add    -0x18(%r9),%rcx
   493cc:	49 03 09             	add    (%r9),%rcx
   493cf:	48 83 c6 04          	add    $0x4,%rsi
   493d3:	49 83 c1 60          	add    $0x60,%r9
   493d7:	49 39 f0             	cmp    %rsi,%r8
   493da:	75 e4                	jne    493c0 <blake3_servil::each::update_turn+0x4f0>
   493dc:	48 85 d2             	test   %rdx,%rdx
   493df:	74 2c                	je     4940d <blake3_servil::each::update_turn+0x53d>
   493e1:	48 8d 34 76          	lea    (%rsi,%rsi,2),%rsi
   493e5:	49 8d 34 f6          	lea    (%r14,%rsi,8),%rsi
   493e9:	48 83 c6 10          	add    $0x10,%rsi
   493ed:	c1 e2 03             	shl    $0x3,%edx
   493f0:	48 8d 14 52          	lea    (%rdx,%rdx,2),%rdx
   493f4:	45 31 c0             	xor    %r8d,%r8d
   493f7:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
   493fe:	00 00 
   49400:	4a 03 0c 06          	add    (%rsi,%r8,1),%rcx
   49404:	49 83 c0 18          	add    $0x18,%r8
   49408:	4c 39 c2             	cmp    %r8,%rdx
   4940b:	75 f3                	jne    49400 <blake3_servil::each::update_turn+0x530>
   4940d:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
   49412:	48 89 4c 24 70       	mov    %rcx,0x70(%rsp)
   49417:	48 39 c1             	cmp    %rax,%rcx
   4941a:	0f 82 c0 fc ff ff    	jb     490e0 <blake3_servil::each::update_turn+0x210>
   49420:	75 09                	jne    4942b <blake3_servil::each::update_turn+0x55b>
   49422:	4d 39 d5             	cmp    %r10,%r13
   49425:	0f 82 b5 fc ff ff    	jb     490e0 <blake3_servil::each::update_turn+0x210>
   4942b:	4c 89 54 24 78       	mov    %r10,0x78(%rsp)
   49430:	4c 89 ac 24 80 00 00 	mov    %r13,0x80(%rsp)
   49437:	00 
   49438:	48 8d 44 24 78       	lea    0x78(%rsp),%rax
   4943d:	48 89 84 24 88 00 00 	mov    %rax,0x88(%rsp)
   49444:	00 
   49445:	48 8b 05 3c 0c 07 00 	mov    0x70c3c(%rip),%rax        # ba088 <_DYNAMIC+0x338>
   4944c:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
   49453:	00 
   49454:	48 8d 4c 24 68       	lea    0x68(%rsp),%rcx
   49459:	48 89 8c 24 98 00 00 	mov    %rcx,0x98(%rsp)
   49460:	00 
   49461:	48 89 84 24 a0 00 00 	mov    %rax,0xa0(%rsp)
   49468:	00 
   49469:	48 8d 8c 24 80 00 00 	lea    0x80(%rsp),%rcx
   49470:	00 
   49471:	48 89 8c 24 a8 00 00 	mov    %rcx,0xa8(%rsp)
   49478:	00 
   49479:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
   49480:	00 
   49481:	48 8d 4c 24 70       	lea    0x70(%rsp),%rcx
   49486:	48 89 8c 24 b8 00 00 	mov    %rcx,0xb8(%rsp)
   4948d:	00 
   4948e:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
   49495:	00 
   49496:	48 8d 15 db d3 06 00 	lea    0x6d3db(%rip),%rdx        # b6878 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x1f8>
   4949d:	48 8d b4 24 88 00 00 	lea    0x88(%rsp),%rsi
   494a4:	00 
   494a5:	48 8d 3d 9c 64 fc ff 	lea    -0x39b64(%rip),%rdi        # f948 <anon.7aa99caee07d4b49ecce0ae005529d8e.6.llvm.12571053693337283289+0xb>
   494ac:	ff 15 0e 0b 07 00    	call   *0x70b0e(%rip)        # b9fc0 <_DYNAMIC+0x270>
   494b2:	e9 a6 00 00 00       	jmp    4955d <blake3_servil::each::update_turn+0x68d>
   494b7:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
   494bc:	48 85 f6             	test   %rsi,%rsi
   494bf:	74 14                	je     494d5 <blake3_servil::each::update_turn+0x605>
   494c1:	48 c1 e6 03          	shl    $0x3,%rsi
   494c5:	ba 08 00 00 00       	mov    $0x8,%edx
   494ca:	ff 15 f8 0a 07 00    	call   *0x70af8(%rip)        # b9fc8 <_DYNAMIC+0x278>
   494d0:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   494d5:	48 85 c0             	test   %rax,%rax
   494d8:	74 18                	je     494f2 <blake3_servil::each::update_turn+0x622>
   494da:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
   494df:	48 c1 e0 03          	shl    $0x3,%rax
   494e3:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
   494e7:	ba 08 00 00 00       	mov    $0x8,%edx
   494ec:	ff 15 d6 0a 07 00    	call   *0x70ad6(%rip)        # b9fc8 <_DYNAMIC+0x278>
   494f2:	48 85 db             	test   %rbx,%rbx
   494f5:	74 16                	je     4950d <blake3_servil::each::update_turn+0x63d>
   494f7:	48 c1 e3 03          	shl    $0x3,%rbx
   494fb:	48 8d 34 5b          	lea    (%rbx,%rbx,2),%rsi
   494ff:	ba 08 00 00 00       	mov    $0x8,%edx
   49504:	4c 89 f7             	mov    %r14,%rdi
   49507:	ff 15 bb 0a 07 00    	call   *0x70abb(%rip)        # b9fc8 <_DYNAMIC+0x278>
   4950d:	48 81 c4 c8 00 00 00 	add    $0xc8,%rsp
   49514:	5b                   	pop    %rbx
   49515:	41 5c                	pop    %r12
   49517:	41 5d                	pop    %r13
   49519:	41 5e                	pop    %r14
   4951b:	41 5f                	pop    %r15
   4951d:	5d                   	pop    %rbp
   4951e:	c3                   	ret
   4951f:	48 8d 0d d2 e6 06 00 	lea    0x6e6d2(%rip),%rcx        # b7bf8 <anon.1cd5bc457da77ad6d639f8f43569f404.19.llvm.13118178400756819167>
   49526:	ba 40 00 00 00       	mov    $0x40,%edx
   4952b:	ff 15 4f 0b 07 00    	call   *0x70b4f(%rip)        # ba080 <_DYNAMIC+0x330>
   49531:	48 8d 15 10 d3 06 00 	lea    0x6d310(%rip),%rdx        # b6848 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x1c8>
   49538:	4c 89 ff             	mov    %r15,%rdi
   4953b:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   49540:	ff 15 0a 0b 07 00    	call   *0x70b0a(%rip)        # ba050 <_DYNAMIC+0x300>
   49546:	eb 15                	jmp    4955d <blake3_servil::each::update_turn+0x68d>
   49548:	48 8d 15 61 d2 06 00 	lea    0x6d261(%rip),%rdx        # b67b0 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x130>
   4954f:	48 89 c7             	mov    %rax,%rdi
   49552:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   49557:	ff 15 f3 0a 07 00    	call   *0x70af3(%rip)        # ba050 <_DYNAMIC+0x300>
   4955d:	0f 0b                	ud2
   4955f:	be 3d 00 00 00       	mov    $0x3d,%esi
   49564:	48 8d 15 f5 d2 06 00 	lea    0x6d2f5(%rip),%rdx        # b6860 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x1e0>
   4956b:	48 8d 3d 12 83 fc ff 	lea    -0x37cee(%rip),%rdi        # 11884 <BLAKE3_IV_3+0x38>
   49572:	e9 35 ff ff ff       	jmp    494ac <blake3_servil::each::update_turn+0x5dc>
   49577:	ff 15 03 0f 07 00    	call   *0x70f03(%rip)        # ba480 <_DYNAMIC+0x730>
   4957d:	3c 05                	cmp    $0x5,%al
   4957f:	0f 84 98 f9 ff ff    	je     48f1d <blake3_servil::each::update_turn+0x4d>
   49585:	e9 d4 fa ff ff       	jmp    4905e <blake3_servil::each::update_turn+0x18e>
   4958a:	48 8d 0d ff d2 06 00 	lea    0x6d2ff(%rip),%rcx        # b6890 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x210>
   49591:	48 89 d7             	mov    %rdx,%rdi
   49594:	4c 89 ee             	mov    %r13,%rsi
   49597:	4c 89 ea             	mov    %r13,%rdx
   4959a:	ff 15 e0 0a 07 00    	call   *0x70ae0(%rip)        # ba080 <_DYNAMIC+0x330>
   495a0:	48 8d 15 89 d2 06 00 	lea    0x6d289(%rip),%rdx        # b6830 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x1b0>
   495a7:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
   495ac:	ff 15 9e 0a 07 00    	call   *0x70a9e(%rip)        # ba050 <_DYNAMIC+0x300>
   495b2:	bf 08 00 00 00       	mov    $0x8,%edi
   495b7:	4c 89 e6             	mov    %r12,%rsi
   495ba:	ff 15 c8 09 07 00    	call   *0x709c8(%rip)        # b9f88 <_DYNAMIC+0x238>
   495c0:	eb 02                	jmp    495c4 <blake3_servil::each::update_turn+0x6f4>
   495c2:	eb 00                	jmp    495c4 <blake3_servil::each::update_turn+0x6f4>
   495c4:	48 89 c3             	mov    %rax,%rbx
   495c7:	48 8b 74 24 38       	mov    0x38(%rsp),%rsi
   495cc:	48 85 f6             	test   %rsi,%rsi
   495cf:	75 1c                	jne    495ed <blake3_servil::each::update_turn+0x71d>
   495d1:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   495d6:	48 85 c0             	test   %rax,%rax
   495d9:	75 30                	jne    4960b <blake3_servil::each::update_turn+0x73b>
   495db:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   495e0:	48 85 c0             	test   %rax,%rax
   495e3:	75 48                	jne    4962d <blake3_servil::each::update_turn+0x75d>
   495e5:	48 89 df             	mov    %rbx,%rdi
   495e8:	e8 63 b6 06 00       	call   b4c50 <_Unwind_Resume@plt>
   495ed:	48 8b 7c 24 40       	mov    0x40(%rsp),%rdi
   495f2:	48 c1 e6 03          	shl    $0x3,%rsi
   495f6:	ba 08 00 00 00       	mov    $0x8,%edx
   495fb:	ff 15 c7 09 07 00    	call   *0x709c7(%rip)        # b9fc8 <_DYNAMIC+0x278>
   49601:	48 8b 44 24 18       	mov    0x18(%rsp),%rax
   49606:	48 85 c0             	test   %rax,%rax
   49609:	74 d0                	je     495db <blake3_servil::each::update_turn+0x70b>
   4960b:	48 8b 7c 24 20       	mov    0x20(%rsp),%rdi
   49610:	48 c1 e0 03          	shl    $0x3,%rax
   49614:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
   49618:	ba 08 00 00 00       	mov    $0x8,%edx
   4961d:	ff 15 a5 09 07 00    	call   *0x709a5(%rip)        # b9fc8 <_DYNAMIC+0x278>
   49623:	48 8b 44 24 30       	mov    0x30(%rsp),%rax
   49628:	48 85 c0             	test   %rax,%rax
   4962b:	74 b8                	je     495e5 <blake3_servil::each::update_turn+0x715>
   4962d:	48 c1 e0 03          	shl    $0x3,%rax
   49631:	48 8d 34 40          	lea    (%rax,%rax,2),%rsi
   49635:	ba 08 00 00 00       	mov    $0x8,%edx
   4963a:	48 8b 7c 24 10       	mov    0x10(%rsp),%rdi
   4963f:	ff 15 83 09 07 00    	call   *0x70983(%rip)        # b9fc8 <_DYNAMIC+0x278>
   49645:	48 89 df             	mov    %rbx,%rdi
   49648:	e8 03 b6 06 00       	call   b4c50 <_Unwind_Resume@plt>
