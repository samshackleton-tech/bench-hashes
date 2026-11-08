
/home/samshackleton/blake3-reports/optimization-resume-20261108/output8-private-bin/new-1:     file format elf64-x86-64


Disassembly of section .text:

0000000000049ea0 <blake3_servil::each::finalize_each>:
   49ea0:	55                   	push   %rbp
   49ea1:	48 89 e5             	mov    %rsp,%rbp
   49ea4:	41 57                	push   %r15
   49ea6:	41 56                	push   %r14
   49ea8:	41 55                	push   %r13
   49eaa:	41 54                	push   %r12
   49eac:	53                   	push   %rbx
   49ead:	48 83 e4 c0          	and    $0xffffffffffffffc0,%rsp
   49eb1:	48 81 ec 40 02 00 00 	sub    $0x240,%rsp
   49eb8:	48 89 8c 24 00 02 00 	mov    %rcx,0x200(%rsp)
   49ebf:	00 
   49ec0:	4c 89 4c 24 40       	mov    %r9,0x40(%rsp)
   49ec5:	4c 39 c9             	cmp    %r9,%rcx
   49ec8:	0f 85 a5 0d 00 00    	jne    4ac73 <blake3_servil::each::finalize_each+0xdd3>
   49ece:	4d 89 c4             	mov    %r8,%r12
   49ed1:	49 89 ca             	mov    %rcx,%r10
   49ed4:	49 89 d3             	mov    %rdx,%r11
   49ed7:	49 89 f0             	mov    %rsi,%r8
   49eda:	49 89 fd             	mov    %rdi,%r13
   49edd:	48 83 f9 07          	cmp    $0x7,%rcx
   49ee1:	0f 86 d2 0d 00 00    	jbe    4acb9 <blake3_servil::each::finalize_each+0xe19>
   49ee7:	48 8b 05 22 55 07 00 	mov    0x75522(%rip),%rax        # bf410 <_DYNAMIC+0x728>
   49eee:	0f b6 00             	movzbl (%rax),%eax
   49ef1:	84 c0                	test   %al,%al
   49ef3:	4c 89 44 24 18       	mov    %r8,0x18(%rsp)
   49ef8:	4c 89 54 24 20       	mov    %r10,0x20(%rsp)
   49efd:	4c 89 5c 24 28       	mov    %r11,0x28(%rsp)
   49f02:	0f 84 94 0d 00 00    	je     4ac9c <blake3_servil::each::finalize_each+0xdfc>
   49f08:	3c 03                	cmp    $0x3,%al
   49f0a:	0f 84 a9 0d 00 00    	je     4acb9 <blake3_servil::each::finalize_each+0xe19>
   49f10:	0f b6 c0             	movzbl %al,%eax
   49f13:	83 f8 04             	cmp    $0x4,%eax
   49f16:	0f 85 c7 0a 00 00    	jne    4a9e3 <blake3_servil::each::finalize_each+0xb43>
   49f1c:	4d 8d 7a 07          	lea    0x7(%r10),%r15
   49f20:	49 c1 ef 03          	shr    $0x3,%r15
   49f24:	48 8d 74 24 48       	lea    0x48(%rsp),%rsi
   49f29:	eb 47                	jmp    49f72 <blake3_servil::each::finalize_each+0xd2>
   49f2b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   49f30:	4c 89 ef             	mov    %r13,%rdi
   49f33:	4c 89 c6             	mov    %r8,%rsi
   49f36:	4c 89 da             	mov    %r11,%rdx
   49f39:	4c 89 c9             	mov    %r9,%rcx
   49f3c:	4d 89 e0             	mov    %r12,%r8
   49f3f:	4c 89 d3             	mov    %r10,%rbx
   49f42:	4d 89 de             	mov    %r11,%r14
   49f45:	e8 46 f5 ff ff       	call   49490 <blake3_servil::each::finish_each>
   49f4a:	48 8d 74 24 48       	lea    0x48(%rsp),%rsi
   49f4f:	4d 89 f3             	mov    %r14,%r11
   49f52:	49 89 da             	mov    %rbx,%r10
   49f55:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
   49f5a:	49 83 c2 f8          	add    $0xfffffffffffffff8,%r10
   49f5e:	49 83 c3 40          	add    $0x40,%r11
   49f62:	49 81 c4 00 01 00 00 	add    $0x100,%r12
   49f69:	49 ff cf             	dec    %r15
   49f6c:	0f 84 5e 0d 00 00    	je     4acd0 <blake3_servil::each::finalize_each+0xe30>
   49f72:	49 83 fa 08          	cmp    $0x8,%r10
   49f76:	41 b9 08 00 00 00    	mov    $0x8,%r9d
   49f7c:	4d 0f 42 ca          	cmovb  %r10,%r9
   49f80:	72 ae                	jb     49f30 <blake3_servil::each::finalize_each+0x90>
   49f82:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
   49f87:	c7 44 24 40 00 00 00 	movl   $0x0,0x40(%rsp)
   49f8e:	00 
   49f8f:	49 8b 3b             	mov    (%r11),%rdi
   49f92:	4c 39 c7             	cmp    %r8,%rdi
   49f95:	0f 83 76 0d 00 00    	jae    4ad11 <blake3_servil::each::finalize_each+0xe71>
   49f9b:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   49f9f:	48 c1 e0 0b          	shl    $0xb,%rax
   49fa3:	4a 8d 1c 28          	lea    (%rax,%r13,1),%rbx
   49fa7:	49 83 bc 05 c0 47 00 	cmpq   $0x0,0x47c0(%r13,%rax,1)
   49fae:	00 00 
   49fb0:	4c 89 54 24 20       	mov    %r10,0x20(%rsp)
   49fb5:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
   49fba:	0f 85 30 04 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   49fc0:	49 83 bc 05 90 07 00 	cmpq   $0x0,0x790(%r13,%rax,1)
   49fc7:	00 00 
   49fc9:	0f 85 21 04 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   49fcf:	49 83 7c 05 60 00    	cmpq   $0x0,0x60(%r13,%rax,1)
   49fd5:	0f 85 15 04 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   49fdb:	49 83 bc 05 a0 00 00 	cmpq   $0x0,0xa0(%r13,%rax,1)
   49fe2:	00 00 
   49fe4:	0f 85 06 04 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   49fea:	48 8d 43 40          	lea    0x40(%rbx),%rax
   49fee:	80 7b 69 00          	cmpb   $0x0,0x69(%rbx)
   49ff2:	0f b6 4b 68          	movzbl 0x68(%rbx),%ecx
   49ff6:	0f 94 c2             	sete   %dl
   49ff9:	0a 53 6a             	or     0x6a(%rbx),%dl
   49ffc:	80 ca 0a             	or     $0xa,%dl
   49fff:	48 89 5c 24 48       	mov    %rbx,0x48(%rsp)
   4a004:	48 89 44 24 50       	mov    %rax,0x50(%rsp)
   4a009:	88 4c 24 58          	mov    %cl,0x58(%rsp)
   4a00d:	88 54 24 59          	mov    %dl,0x59(%rsp)
   4a011:	c7 44 24 40 01 00 00 	movl   $0x1,0x40(%rsp)
   4a018:	00 
   4a019:	49 8b 7b 08          	mov    0x8(%r11),%rdi
   4a01d:	4c 39 c7             	cmp    %r8,%rdi
   4a020:	0f 83 eb 0c 00 00    	jae    4ad11 <blake3_servil::each::finalize_each+0xe71>
   4a026:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   4a02a:	48 c1 e0 0b          	shl    $0xb,%rax
   4a02e:	49 83 bc 05 c0 47 00 	cmpq   $0x0,0x47c0(%r13,%rax,1)
   4a035:	00 00 
   4a037:	0f 85 b3 03 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a03d:	49 83 bc 05 90 07 00 	cmpq   $0x0,0x790(%r13,%rax,1)
   4a044:	00 00 
   4a046:	0f 85 a4 03 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a04c:	49 83 7c 05 60 00    	cmpq   $0x0,0x60(%r13,%rax,1)
   4a052:	0f 85 98 03 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a058:	49 83 bc 05 a0 00 00 	cmpq   $0x0,0xa0(%r13,%rax,1)
   4a05f:	00 00 
   4a061:	0f 85 89 03 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a067:	4c 01 e8             	add    %r13,%rax
   4a06a:	0f b6 48 68          	movzbl 0x68(%rax),%ecx
   4a06e:	80 78 69 00          	cmpb   $0x0,0x69(%rax)
   4a072:	0f 94 c2             	sete   %dl
   4a075:	0a 50 6a             	or     0x6a(%rax),%dl
   4a078:	80 ca 0a             	or     $0xa,%dl
   4a07b:	48 89 44 24 60       	mov    %rax,0x60(%rsp)
   4a080:	48 83 c0 40          	add    $0x40,%rax
   4a084:	48 89 44 24 68       	mov    %rax,0x68(%rsp)
   4a089:	88 4c 24 70          	mov    %cl,0x70(%rsp)
   4a08d:	88 54 24 71          	mov    %dl,0x71(%rsp)
   4a091:	c7 44 24 40 02 00 00 	movl   $0x2,0x40(%rsp)
   4a098:	00 
   4a099:	49 8b 7b 10          	mov    0x10(%r11),%rdi
   4a09d:	4c 39 c7             	cmp    %r8,%rdi
   4a0a0:	0f 83 6b 0c 00 00    	jae    4ad11 <blake3_servil::each::finalize_each+0xe71>
   4a0a6:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   4a0aa:	48 c1 e0 0b          	shl    $0xb,%rax
   4a0ae:	49 83 bc 05 c0 47 00 	cmpq   $0x0,0x47c0(%r13,%rax,1)
   4a0b5:	00 00 
   4a0b7:	0f 85 33 03 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a0bd:	49 83 bc 05 90 07 00 	cmpq   $0x0,0x790(%r13,%rax,1)
   4a0c4:	00 00 
   4a0c6:	0f 85 24 03 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a0cc:	49 83 7c 05 60 00    	cmpq   $0x0,0x60(%r13,%rax,1)
   4a0d2:	0f 85 18 03 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a0d8:	49 83 bc 05 a0 00 00 	cmpq   $0x0,0xa0(%r13,%rax,1)
   4a0df:	00 00 
   4a0e1:	0f 85 09 03 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a0e7:	4c 01 e8             	add    %r13,%rax
   4a0ea:	0f b6 48 68          	movzbl 0x68(%rax),%ecx
   4a0ee:	80 78 69 00          	cmpb   $0x0,0x69(%rax)
   4a0f2:	0f 94 c2             	sete   %dl
   4a0f5:	0a 50 6a             	or     0x6a(%rax),%dl
   4a0f8:	80 ca 0a             	or     $0xa,%dl
   4a0fb:	48 89 44 24 78       	mov    %rax,0x78(%rsp)
   4a100:	48 83 c0 40          	add    $0x40,%rax
   4a104:	48 89 84 24 80 00 00 	mov    %rax,0x80(%rsp)
   4a10b:	00 
   4a10c:	88 8c 24 88 00 00 00 	mov    %cl,0x88(%rsp)
   4a113:	88 94 24 89 00 00 00 	mov    %dl,0x89(%rsp)
   4a11a:	c7 44 24 40 03 00 00 	movl   $0x3,0x40(%rsp)
   4a121:	00 
   4a122:	49 8b 7b 18          	mov    0x18(%r11),%rdi
   4a126:	4c 39 c7             	cmp    %r8,%rdi
   4a129:	0f 83 e2 0b 00 00    	jae    4ad11 <blake3_servil::each::finalize_each+0xe71>
   4a12f:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   4a133:	48 c1 e0 0b          	shl    $0xb,%rax
   4a137:	49 83 bc 05 c0 47 00 	cmpq   $0x0,0x47c0(%r13,%rax,1)
   4a13e:	00 00 
   4a140:	0f 85 aa 02 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a146:	49 83 bc 05 90 07 00 	cmpq   $0x0,0x790(%r13,%rax,1)
   4a14d:	00 00 
   4a14f:	0f 85 9b 02 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a155:	49 83 7c 05 60 00    	cmpq   $0x0,0x60(%r13,%rax,1)
   4a15b:	0f 85 8f 02 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a161:	49 83 bc 05 a0 00 00 	cmpq   $0x0,0xa0(%r13,%rax,1)
   4a168:	00 00 
   4a16a:	0f 85 80 02 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a170:	4c 01 e8             	add    %r13,%rax
   4a173:	0f b6 48 68          	movzbl 0x68(%rax),%ecx
   4a177:	80 78 69 00          	cmpb   $0x0,0x69(%rax)
   4a17b:	0f 94 c2             	sete   %dl
   4a17e:	0a 50 6a             	or     0x6a(%rax),%dl
   4a181:	80 ca 0a             	or     $0xa,%dl
   4a184:	48 89 84 24 90 00 00 	mov    %rax,0x90(%rsp)
   4a18b:	00 
   4a18c:	48 83 c0 40          	add    $0x40,%rax
   4a190:	48 89 84 24 98 00 00 	mov    %rax,0x98(%rsp)
   4a197:	00 
   4a198:	88 8c 24 a0 00 00 00 	mov    %cl,0xa0(%rsp)
   4a19f:	88 94 24 a1 00 00 00 	mov    %dl,0xa1(%rsp)
   4a1a6:	c7 44 24 40 04 00 00 	movl   $0x4,0x40(%rsp)
   4a1ad:	00 
   4a1ae:	49 8b 7b 20          	mov    0x20(%r11),%rdi
   4a1b2:	4c 39 c7             	cmp    %r8,%rdi
   4a1b5:	0f 83 56 0b 00 00    	jae    4ad11 <blake3_servil::each::finalize_each+0xe71>
   4a1bb:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   4a1bf:	48 c1 e0 0b          	shl    $0xb,%rax
   4a1c3:	49 83 bc 05 c0 47 00 	cmpq   $0x0,0x47c0(%r13,%rax,1)
   4a1ca:	00 00 
   4a1cc:	0f 85 1e 02 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a1d2:	49 83 bc 05 90 07 00 	cmpq   $0x0,0x790(%r13,%rax,1)
   4a1d9:	00 00 
   4a1db:	0f 85 0f 02 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a1e1:	49 83 7c 05 60 00    	cmpq   $0x0,0x60(%r13,%rax,1)
   4a1e7:	0f 85 03 02 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a1ed:	49 83 bc 05 a0 00 00 	cmpq   $0x0,0xa0(%r13,%rax,1)
   4a1f4:	00 00 
   4a1f6:	0f 85 f4 01 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a1fc:	4c 01 e8             	add    %r13,%rax
   4a1ff:	0f b6 48 68          	movzbl 0x68(%rax),%ecx
   4a203:	80 78 69 00          	cmpb   $0x0,0x69(%rax)
   4a207:	0f 94 c2             	sete   %dl
   4a20a:	0a 50 6a             	or     0x6a(%rax),%dl
   4a20d:	80 ca 0a             	or     $0xa,%dl
   4a210:	48 89 84 24 a8 00 00 	mov    %rax,0xa8(%rsp)
   4a217:	00 
   4a218:	48 83 c0 40          	add    $0x40,%rax
   4a21c:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
   4a223:	00 
   4a224:	88 8c 24 b8 00 00 00 	mov    %cl,0xb8(%rsp)
   4a22b:	88 94 24 b9 00 00 00 	mov    %dl,0xb9(%rsp)
   4a232:	c7 44 24 40 05 00 00 	movl   $0x5,0x40(%rsp)
   4a239:	00 
   4a23a:	49 8b 7b 28          	mov    0x28(%r11),%rdi
   4a23e:	4c 39 c7             	cmp    %r8,%rdi
   4a241:	0f 83 ca 0a 00 00    	jae    4ad11 <blake3_servil::each::finalize_each+0xe71>
   4a247:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   4a24b:	48 c1 e0 0b          	shl    $0xb,%rax
   4a24f:	49 83 bc 05 c0 47 00 	cmpq   $0x0,0x47c0(%r13,%rax,1)
   4a256:	00 00 
   4a258:	0f 85 92 01 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a25e:	49 83 bc 05 90 07 00 	cmpq   $0x0,0x790(%r13,%rax,1)
   4a265:	00 00 
   4a267:	0f 85 83 01 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a26d:	49 83 7c 05 60 00    	cmpq   $0x0,0x60(%r13,%rax,1)
   4a273:	0f 85 77 01 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a279:	49 83 bc 05 a0 00 00 	cmpq   $0x0,0xa0(%r13,%rax,1)
   4a280:	00 00 
   4a282:	0f 85 68 01 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a288:	4c 01 e8             	add    %r13,%rax
   4a28b:	0f b6 48 68          	movzbl 0x68(%rax),%ecx
   4a28f:	80 78 69 00          	cmpb   $0x0,0x69(%rax)
   4a293:	0f 94 c2             	sete   %dl
   4a296:	0a 50 6a             	or     0x6a(%rax),%dl
   4a299:	80 ca 0a             	or     $0xa,%dl
   4a29c:	48 89 84 24 c0 00 00 	mov    %rax,0xc0(%rsp)
   4a2a3:	00 
   4a2a4:	48 83 c0 40          	add    $0x40,%rax
   4a2a8:	48 89 84 24 c8 00 00 	mov    %rax,0xc8(%rsp)
   4a2af:	00 
   4a2b0:	88 8c 24 d0 00 00 00 	mov    %cl,0xd0(%rsp)
   4a2b7:	88 94 24 d1 00 00 00 	mov    %dl,0xd1(%rsp)
   4a2be:	c7 44 24 40 06 00 00 	movl   $0x6,0x40(%rsp)
   4a2c5:	00 
   4a2c6:	49 8b 7b 30          	mov    0x30(%r11),%rdi
   4a2ca:	4c 39 c7             	cmp    %r8,%rdi
   4a2cd:	0f 83 3e 0a 00 00    	jae    4ad11 <blake3_servil::each::finalize_each+0xe71>
   4a2d3:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   4a2d7:	48 c1 e0 0b          	shl    $0xb,%rax
   4a2db:	49 83 bc 05 c0 47 00 	cmpq   $0x0,0x47c0(%r13,%rax,1)
   4a2e2:	00 00 
   4a2e4:	0f 85 06 01 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a2ea:	49 83 bc 05 90 07 00 	cmpq   $0x0,0x790(%r13,%rax,1)
   4a2f1:	00 00 
   4a2f3:	0f 85 f7 00 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a2f9:	49 83 7c 05 60 00    	cmpq   $0x0,0x60(%r13,%rax,1)
   4a2ff:	0f 85 eb 00 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a305:	49 83 bc 05 a0 00 00 	cmpq   $0x0,0xa0(%r13,%rax,1)
   4a30c:	00 00 
   4a30e:	0f 85 dc 00 00 00    	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a314:	4c 01 e8             	add    %r13,%rax
   4a317:	0f b6 48 68          	movzbl 0x68(%rax),%ecx
   4a31b:	80 78 69 00          	cmpb   $0x0,0x69(%rax)
   4a31f:	0f 94 c2             	sete   %dl
   4a322:	0a 50 6a             	or     0x6a(%rax),%dl
   4a325:	80 ca 0a             	or     $0xa,%dl
   4a328:	48 89 84 24 d8 00 00 	mov    %rax,0xd8(%rsp)
   4a32f:	00 
   4a330:	48 83 c0 40          	add    $0x40,%rax
   4a334:	48 89 84 24 e0 00 00 	mov    %rax,0xe0(%rsp)
   4a33b:	00 
   4a33c:	88 8c 24 e8 00 00 00 	mov    %cl,0xe8(%rsp)
   4a343:	88 94 24 e9 00 00 00 	mov    %dl,0xe9(%rsp)
   4a34a:	c7 44 24 40 07 00 00 	movl   $0x7,0x40(%rsp)
   4a351:	00 
   4a352:	49 8b 7b 38          	mov    0x38(%r11),%rdi
   4a356:	4c 39 c7             	cmp    %r8,%rdi
   4a359:	0f 83 b2 09 00 00    	jae    4ad11 <blake3_servil::each::finalize_each+0xe71>
   4a35f:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   4a363:	48 c1 e0 0b          	shl    $0xb,%rax
   4a367:	49 83 bc 05 c0 47 00 	cmpq   $0x0,0x47c0(%r13,%rax,1)
   4a36e:	00 00 
   4a370:	75 7e                	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a372:	49 83 bc 05 90 07 00 	cmpq   $0x0,0x790(%r13,%rax,1)
   4a379:	00 00 
   4a37b:	75 73                	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a37d:	49 83 7c 05 60 00    	cmpq   $0x0,0x60(%r13,%rax,1)
   4a383:	75 6b                	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a385:	49 83 bc 05 a0 00 00 	cmpq   $0x0,0xa0(%r13,%rax,1)
   4a38c:	00 00 
   4a38e:	75 60                	jne    4a3f0 <blake3_servil::each::finalize_each+0x550>
   4a390:	4c 01 e8             	add    %r13,%rax
   4a393:	80 78 69 00          	cmpb   $0x0,0x69(%rax)
   4a397:	0f 94 c1             	sete   %cl
   4a39a:	0a 48 6a             	or     0x6a(%rax),%cl
   4a39d:	0f b6 50 68          	movzbl 0x68(%rax),%edx
   4a3a1:	80 c9 0a             	or     $0xa,%cl
   4a3a4:	48 89 84 24 f0 00 00 	mov    %rax,0xf0(%rsp)
   4a3ab:	00 
   4a3ac:	48 83 c0 40          	add    $0x40,%rax
   4a3b0:	48 89 84 24 f8 00 00 	mov    %rax,0xf8(%rsp)
   4a3b7:	00 
   4a3b8:	88 94 24 00 01 00 00 	mov    %dl,0x100(%rsp)
   4a3bf:	88 8c 24 01 01 00 00 	mov    %cl,0x101(%rsp)
   4a3c6:	c7 44 24 40 08 00 00 	movl   $0x8,0x40(%rsp)
   4a3cd:	00 
   4a3ce:	48 89 f7             	mov    %rsi,%rdi
   4a3d1:	4c 89 e6             	mov    %r12,%rsi
   4a3d4:	4c 89 ca             	mov    %r9,%rdx
   4a3d7:	4c 89 c3             	mov    %r8,%rbx
   4a3da:	4d 89 de             	mov    %r11,%r14
   4a3dd:	e8 de 20 00 00       	call   4c4c0 <blake3_servil::ffi_output::hash_group::<8>>
   4a3e2:	eb 31                	jmp    4a415 <blake3_servil::each::finalize_each+0x575>
   4a3e4:	66 66 66 2e 0f 1f 84 	data16 data16 cs nopw 0x0(%rax,%rax,1)
   4a3eb:	00 00 00 00 00 
   4a3f0:	4c 89 ef             	mov    %r13,%rdi
   4a3f3:	4c 89 c6             	mov    %r8,%rsi
   4a3f6:	4c 89 da             	mov    %r11,%rdx
   4a3f9:	4c 89 e1             	mov    %r12,%rcx
   4a3fc:	4c 89 c3             	mov    %r8,%rbx
   4a3ff:	4d 89 c8             	mov    %r9,%r8
   4a402:	4d 89 de             	mov    %r11,%r14
   4a405:	4d 89 cf             	mov    %r9,%r15
   4a408:	e8 33 3b 00 00       	call   4df40 <blake3_servil::ffi_output::staged_group::<8>>
   4a40d:	84 c0                	test   %al,%al
   4a40f:	0f 84 9b 05 00 00    	je     4a9b0 <blake3_servil::each::finalize_each+0xb10>
   4a415:	0f 57 db             	xorps  %xmm3,%xmm3
   4a418:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
   4a41d:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
   4a422:	0f 29 5c 24 60       	movaps %xmm3,0x60(%rsp)
   4a427:	0f 29 5c 24 50       	movaps %xmm3,0x50(%rsp)
   4a42c:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
   4a431:	0f 28 80 80 00 00 00 	movaps 0x80(%rax),%xmm0
   4a438:	48 8d 74 24 48       	lea    0x48(%rsp),%rsi
   4a43d:	0f 29 46 38          	movaps %xmm0,0x38(%rsi)
   4a441:	0f 28 80 90 00 00 00 	movaps 0x90(%rax),%xmm0
   4a448:	0f 29 46 48          	movaps %xmm0,0x48(%rsi)
   4a44c:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
   4a451:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
   4a458:	00 
   4a459:	0f 29 00             	movaps %xmm0,(%rax)
   4a45c:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
   4a461:	0f 28 94 24 90 00 00 	movaps 0x90(%rsp),%xmm2
   4a468:	00 
   4a469:	0f 29 40 10          	movaps %xmm0,0x10(%rax)
   4a46d:	0f 29 48 40          	movaps %xmm1,0x40(%rax)
   4a471:	0f 29 50 50          	movaps %xmm2,0x50(%rax)
   4a475:	0f 28 44 24 60       	movaps 0x60(%rsp),%xmm0
   4a47a:	0f 29 40 20          	movaps %xmm0,0x20(%rax)
   4a47e:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
   4a483:	0f 29 40 30          	movaps %xmm0,0x30(%rax)
   4a487:	48 c7 40 60 00 00 00 	movq   $0x0,0x60(%rax)
   4a48e:	00 
   4a48f:	66 c7 40 68 00 00    	movw   $0x0,0x68(%rax)
   4a495:	48 c7 80 a0 00 00 00 	movq   $0x0,0xa0(%rax)
   4a49c:	00 00 00 00 
   4a4a0:	48 c7 80 c0 47 00 00 	movq   $0x0,0x47c0(%rax)
   4a4a7:	00 00 00 00 
   4a4ab:	49 8b 7e 08          	mov    0x8(%r14),%rdi
   4a4af:	48 39 df             	cmp    %rbx,%rdi
   4a4b2:	0f 83 47 08 00 00    	jae    4acff <blake3_servil::each::finalize_each+0xe5f>
   4a4b8:	49 89 d8             	mov    %rbx,%r8
   4a4bb:	4d 89 f3             	mov    %r14,%r11
   4a4be:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   4a4c2:	48 c1 e0 0b          	shl    $0xb,%rax
   4a4c6:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
   4a4cb:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
   4a4d0:	0f 29 5c 24 60       	movaps %xmm3,0x60(%rsp)
   4a4d5:	0f 29 5c 24 50       	movaps %xmm3,0x50(%rsp)
   4a4da:	41 0f 28 84 05 80 00 	movaps 0x80(%r13,%rax,1),%xmm0
   4a4e1:	00 00 
   4a4e3:	0f 29 46 38          	movaps %xmm0,0x38(%rsi)
   4a4e7:	41 0f 28 84 05 90 00 	movaps 0x90(%r13,%rax,1),%xmm0
   4a4ee:	00 00 
   4a4f0:	0f 29 46 48          	movaps %xmm0,0x48(%rsi)
   4a4f4:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
   4a4f9:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
   4a500:	00 
   4a501:	41 0f 29 44 05 00    	movaps %xmm0,0x0(%r13,%rax,1)
   4a507:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
   4a50c:	0f 28 94 24 90 00 00 	movaps 0x90(%rsp),%xmm2
   4a513:	00 
   4a514:	41 0f 29 44 05 10    	movaps %xmm0,0x10(%r13,%rax,1)
   4a51a:	41 0f 29 4c 05 40    	movaps %xmm1,0x40(%r13,%rax,1)
   4a520:	41 0f 29 54 05 50    	movaps %xmm2,0x50(%r13,%rax,1)
   4a526:	0f 28 44 24 60       	movaps 0x60(%rsp),%xmm0
   4a52b:	41 0f 29 44 05 20    	movaps %xmm0,0x20(%r13,%rax,1)
   4a531:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
   4a536:	41 0f 29 44 05 30    	movaps %xmm0,0x30(%r13,%rax,1)
   4a53c:	49 c7 44 05 60 00 00 	movq   $0x0,0x60(%r13,%rax,1)
   4a543:	00 00 
   4a545:	66 41 c7 44 05 68 00 	movw   $0x0,0x68(%r13,%rax,1)
   4a54c:	00 
   4a54d:	49 c7 84 05 a0 00 00 	movq   $0x0,0xa0(%r13,%rax,1)
   4a554:	00 00 00 00 00 
   4a559:	49 c7 84 05 c0 47 00 	movq   $0x0,0x47c0(%r13,%rax,1)
   4a560:	00 00 00 00 00 
   4a565:	49 8b 7e 10          	mov    0x10(%r14),%rdi
   4a569:	48 39 df             	cmp    %rbx,%rdi
   4a56c:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
   4a571:	0f 83 88 07 00 00    	jae    4acff <blake3_servil::each::finalize_each+0xe5f>
   4a577:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   4a57b:	48 c1 e0 0b          	shl    $0xb,%rax
   4a57f:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
   4a584:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
   4a589:	0f 29 5c 24 60       	movaps %xmm3,0x60(%rsp)
   4a58e:	0f 29 5c 24 50       	movaps %xmm3,0x50(%rsp)
   4a593:	41 0f 28 84 05 80 00 	movaps 0x80(%r13,%rax,1),%xmm0
   4a59a:	00 00 
   4a59c:	0f 29 46 38          	movaps %xmm0,0x38(%rsi)
   4a5a0:	41 0f 28 84 05 90 00 	movaps 0x90(%r13,%rax,1),%xmm0
   4a5a7:	00 00 
   4a5a9:	0f 29 46 48          	movaps %xmm0,0x48(%rsi)
   4a5ad:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
   4a5b2:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
   4a5b9:	00 
   4a5ba:	41 0f 29 44 05 00    	movaps %xmm0,0x0(%r13,%rax,1)
   4a5c0:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
   4a5c5:	0f 28 94 24 90 00 00 	movaps 0x90(%rsp),%xmm2
   4a5cc:	00 
   4a5cd:	41 0f 29 44 05 10    	movaps %xmm0,0x10(%r13,%rax,1)
   4a5d3:	41 0f 29 4c 05 40    	movaps %xmm1,0x40(%r13,%rax,1)
   4a5d9:	41 0f 29 54 05 50    	movaps %xmm2,0x50(%r13,%rax,1)
   4a5df:	0f 28 44 24 60       	movaps 0x60(%rsp),%xmm0
   4a5e4:	41 0f 29 44 05 20    	movaps %xmm0,0x20(%r13,%rax,1)
   4a5ea:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
   4a5ef:	41 0f 29 44 05 30    	movaps %xmm0,0x30(%r13,%rax,1)
   4a5f5:	49 c7 44 05 60 00 00 	movq   $0x0,0x60(%r13,%rax,1)
   4a5fc:	00 00 
   4a5fe:	66 41 c7 44 05 68 00 	movw   $0x0,0x68(%r13,%rax,1)
   4a605:	00 
   4a606:	49 c7 84 05 a0 00 00 	movq   $0x0,0xa0(%r13,%rax,1)
   4a60d:	00 00 00 00 00 
   4a612:	49 c7 84 05 c0 47 00 	movq   $0x0,0x47c0(%r13,%rax,1)
   4a619:	00 00 00 00 00 
   4a61e:	49 8b 7b 18          	mov    0x18(%r11),%rdi
   4a622:	4c 39 c7             	cmp    %r8,%rdi
   4a625:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
   4a62a:	0f 83 cf 06 00 00    	jae    4acff <blake3_servil::each::finalize_each+0xe5f>
   4a630:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   4a634:	48 c1 e0 0b          	shl    $0xb,%rax
   4a638:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
   4a63d:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
   4a642:	0f 29 5c 24 60       	movaps %xmm3,0x60(%rsp)
   4a647:	0f 29 5c 24 50       	movaps %xmm3,0x50(%rsp)
   4a64c:	41 0f 28 84 05 80 00 	movaps 0x80(%r13,%rax,1),%xmm0
   4a653:	00 00 
   4a655:	0f 29 46 38          	movaps %xmm0,0x38(%rsi)
   4a659:	41 0f 28 84 05 90 00 	movaps 0x90(%r13,%rax,1),%xmm0
   4a660:	00 00 
   4a662:	0f 29 46 48          	movaps %xmm0,0x48(%rsi)
   4a666:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
   4a66b:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
   4a672:	00 
   4a673:	41 0f 29 44 05 00    	movaps %xmm0,0x0(%r13,%rax,1)
   4a679:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
   4a67e:	0f 28 94 24 90 00 00 	movaps 0x90(%rsp),%xmm2
   4a685:	00 
   4a686:	41 0f 29 44 05 10    	movaps %xmm0,0x10(%r13,%rax,1)
   4a68c:	41 0f 29 4c 05 40    	movaps %xmm1,0x40(%r13,%rax,1)
   4a692:	41 0f 29 54 05 50    	movaps %xmm2,0x50(%r13,%rax,1)
   4a698:	0f 28 44 24 60       	movaps 0x60(%rsp),%xmm0
   4a69d:	41 0f 29 44 05 20    	movaps %xmm0,0x20(%r13,%rax,1)
   4a6a3:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
   4a6a8:	41 0f 29 44 05 30    	movaps %xmm0,0x30(%r13,%rax,1)
   4a6ae:	49 c7 44 05 60 00 00 	movq   $0x0,0x60(%r13,%rax,1)
   4a6b5:	00 00 
   4a6b7:	66 41 c7 44 05 68 00 	movw   $0x0,0x68(%r13,%rax,1)
   4a6be:	00 
   4a6bf:	49 c7 84 05 a0 00 00 	movq   $0x0,0xa0(%r13,%rax,1)
   4a6c6:	00 00 00 00 00 
   4a6cb:	49 c7 84 05 c0 47 00 	movq   $0x0,0x47c0(%r13,%rax,1)
   4a6d2:	00 00 00 00 00 
   4a6d7:	49 8b 7b 20          	mov    0x20(%r11),%rdi
   4a6db:	4c 39 c7             	cmp    %r8,%rdi
   4a6de:	0f 83 1b 06 00 00    	jae    4acff <blake3_servil::each::finalize_each+0xe5f>
   4a6e4:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   4a6e8:	48 c1 e0 0b          	shl    $0xb,%rax
   4a6ec:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
   4a6f1:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
   4a6f6:	0f 29 5c 24 60       	movaps %xmm3,0x60(%rsp)
   4a6fb:	0f 29 5c 24 50       	movaps %xmm3,0x50(%rsp)
   4a700:	41 0f 28 84 05 80 00 	movaps 0x80(%r13,%rax,1),%xmm0
   4a707:	00 00 
   4a709:	0f 29 46 38          	movaps %xmm0,0x38(%rsi)
   4a70d:	41 0f 28 84 05 90 00 	movaps 0x90(%r13,%rax,1),%xmm0
   4a714:	00 00 
   4a716:	0f 29 46 48          	movaps %xmm0,0x48(%rsi)
   4a71a:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
   4a71f:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
   4a726:	00 
   4a727:	41 0f 29 44 05 00    	movaps %xmm0,0x0(%r13,%rax,1)
   4a72d:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
   4a732:	0f 28 94 24 90 00 00 	movaps 0x90(%rsp),%xmm2
   4a739:	00 
   4a73a:	41 0f 29 44 05 10    	movaps %xmm0,0x10(%r13,%rax,1)
   4a740:	41 0f 29 4c 05 40    	movaps %xmm1,0x40(%r13,%rax,1)
   4a746:	41 0f 29 54 05 50    	movaps %xmm2,0x50(%r13,%rax,1)
   4a74c:	0f 28 44 24 60       	movaps 0x60(%rsp),%xmm0
   4a751:	41 0f 29 44 05 20    	movaps %xmm0,0x20(%r13,%rax,1)
   4a757:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
   4a75c:	41 0f 29 44 05 30    	movaps %xmm0,0x30(%r13,%rax,1)
   4a762:	49 c7 44 05 60 00 00 	movq   $0x0,0x60(%r13,%rax,1)
   4a769:	00 00 
   4a76b:	66 41 c7 44 05 68 00 	movw   $0x0,0x68(%r13,%rax,1)
   4a772:	00 
   4a773:	49 c7 84 05 a0 00 00 	movq   $0x0,0xa0(%r13,%rax,1)
   4a77a:	00 00 00 00 00 
   4a77f:	49 c7 84 05 c0 47 00 	movq   $0x0,0x47c0(%r13,%rax,1)
   4a786:	00 00 00 00 00 
   4a78b:	49 8b 7b 28          	mov    0x28(%r11),%rdi
   4a78f:	4c 39 c7             	cmp    %r8,%rdi
   4a792:	0f 83 67 05 00 00    	jae    4acff <blake3_servil::each::finalize_each+0xe5f>
   4a798:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   4a79c:	48 c1 e0 0b          	shl    $0xb,%rax
   4a7a0:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
   4a7a5:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
   4a7aa:	0f 29 5c 24 60       	movaps %xmm3,0x60(%rsp)
   4a7af:	0f 29 5c 24 50       	movaps %xmm3,0x50(%rsp)
   4a7b4:	41 0f 28 84 05 80 00 	movaps 0x80(%r13,%rax,1),%xmm0
   4a7bb:	00 00 
   4a7bd:	0f 29 46 38          	movaps %xmm0,0x38(%rsi)
   4a7c1:	41 0f 28 84 05 90 00 	movaps 0x90(%r13,%rax,1),%xmm0
   4a7c8:	00 00 
   4a7ca:	0f 29 46 48          	movaps %xmm0,0x48(%rsi)
   4a7ce:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
   4a7d3:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
   4a7da:	00 
   4a7db:	41 0f 29 44 05 00    	movaps %xmm0,0x0(%r13,%rax,1)
   4a7e1:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
   4a7e6:	0f 28 94 24 90 00 00 	movaps 0x90(%rsp),%xmm2
   4a7ed:	00 
   4a7ee:	41 0f 29 44 05 10    	movaps %xmm0,0x10(%r13,%rax,1)
   4a7f4:	41 0f 29 4c 05 40    	movaps %xmm1,0x40(%r13,%rax,1)
   4a7fa:	41 0f 29 54 05 50    	movaps %xmm2,0x50(%r13,%rax,1)
   4a800:	0f 28 44 24 60       	movaps 0x60(%rsp),%xmm0
   4a805:	41 0f 29 44 05 20    	movaps %xmm0,0x20(%r13,%rax,1)
   4a80b:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
   4a810:	41 0f 29 44 05 30    	movaps %xmm0,0x30(%r13,%rax,1)
   4a816:	49 c7 44 05 60 00 00 	movq   $0x0,0x60(%r13,%rax,1)
   4a81d:	00 00 
   4a81f:	66 41 c7 44 05 68 00 	movw   $0x0,0x68(%r13,%rax,1)
   4a826:	00 
   4a827:	49 c7 84 05 a0 00 00 	movq   $0x0,0xa0(%r13,%rax,1)
   4a82e:	00 00 00 00 00 
   4a833:	49 c7 84 05 c0 47 00 	movq   $0x0,0x47c0(%r13,%rax,1)
   4a83a:	00 00 00 00 00 
   4a83f:	49 8b 7b 30          	mov    0x30(%r11),%rdi
   4a843:	4c 39 c7             	cmp    %r8,%rdi
   4a846:	0f 83 b3 04 00 00    	jae    4acff <blake3_servil::each::finalize_each+0xe5f>
   4a84c:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   4a850:	48 c1 e0 0b          	shl    $0xb,%rax
   4a854:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
   4a859:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
   4a85e:	0f 29 5c 24 60       	movaps %xmm3,0x60(%rsp)
   4a863:	0f 29 5c 24 50       	movaps %xmm3,0x50(%rsp)
   4a868:	41 0f 28 84 05 80 00 	movaps 0x80(%r13,%rax,1),%xmm0
   4a86f:	00 00 
   4a871:	0f 29 46 38          	movaps %xmm0,0x38(%rsi)
   4a875:	41 0f 28 84 05 90 00 	movaps 0x90(%r13,%rax,1),%xmm0
   4a87c:	00 00 
   4a87e:	0f 29 46 48          	movaps %xmm0,0x48(%rsi)
   4a882:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
   4a887:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
   4a88e:	00 
   4a88f:	41 0f 29 44 05 00    	movaps %xmm0,0x0(%r13,%rax,1)
   4a895:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
   4a89a:	0f 28 94 24 90 00 00 	movaps 0x90(%rsp),%xmm2
   4a8a1:	00 
   4a8a2:	41 0f 29 44 05 10    	movaps %xmm0,0x10(%r13,%rax,1)
   4a8a8:	41 0f 29 4c 05 40    	movaps %xmm1,0x40(%r13,%rax,1)
   4a8ae:	41 0f 29 54 05 50    	movaps %xmm2,0x50(%r13,%rax,1)
   4a8b4:	0f 28 44 24 60       	movaps 0x60(%rsp),%xmm0
   4a8b9:	41 0f 29 44 05 20    	movaps %xmm0,0x20(%r13,%rax,1)
   4a8bf:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
   4a8c4:	41 0f 29 44 05 30    	movaps %xmm0,0x30(%r13,%rax,1)
   4a8ca:	49 c7 44 05 60 00 00 	movq   $0x0,0x60(%r13,%rax,1)
   4a8d1:	00 00 
   4a8d3:	66 41 c7 44 05 68 00 	movw   $0x0,0x68(%r13,%rax,1)
   4a8da:	00 
   4a8db:	49 c7 84 05 a0 00 00 	movq   $0x0,0xa0(%r13,%rax,1)
   4a8e2:	00 00 00 00 00 
   4a8e7:	49 c7 84 05 c0 47 00 	movq   $0x0,0x47c0(%r13,%rax,1)
   4a8ee:	00 00 00 00 00 
   4a8f3:	49 8b 7b 38          	mov    0x38(%r11),%rdi
   4a8f7:	4c 39 c7             	cmp    %r8,%rdi
   4a8fa:	0f 83 ff 03 00 00    	jae    4acff <blake3_servil::each::finalize_each+0xe5f>
   4a900:	48 8d 04 ff          	lea    (%rdi,%rdi,8),%rax
   4a904:	48 c1 e0 0b          	shl    $0xb,%rax
   4a908:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
   4a90d:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
   4a912:	0f 29 5c 24 60       	movaps %xmm3,0x60(%rsp)
   4a917:	0f 29 5c 24 50       	movaps %xmm3,0x50(%rsp)
   4a91c:	41 0f 28 84 05 80 00 	movaps 0x80(%r13,%rax,1),%xmm0
   4a923:	00 00 
   4a925:	0f 29 46 38          	movaps %xmm0,0x38(%rsi)
   4a929:	41 0f 28 84 05 90 00 	movaps 0x90(%r13,%rax,1),%xmm0
   4a930:	00 00 
   4a932:	0f 29 46 48          	movaps %xmm0,0x48(%rsi)
   4a936:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
   4a93b:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
   4a942:	00 
   4a943:	41 0f 29 44 05 00    	movaps %xmm0,0x0(%r13,%rax,1)
   4a949:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
   4a94e:	0f 28 94 24 90 00 00 	movaps 0x90(%rsp),%xmm2
   4a955:	00 
   4a956:	41 0f 29 44 05 10    	movaps %xmm0,0x10(%r13,%rax,1)
   4a95c:	41 0f 29 4c 05 40    	movaps %xmm1,0x40(%r13,%rax,1)
   4a962:	41 0f 29 54 05 50    	movaps %xmm2,0x50(%r13,%rax,1)
   4a968:	0f 28 44 24 60       	movaps 0x60(%rsp),%xmm0
   4a96d:	41 0f 29 44 05 20    	movaps %xmm0,0x20(%r13,%rax,1)
   4a973:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
   4a978:	41 0f 29 44 05 30    	movaps %xmm0,0x30(%r13,%rax,1)
   4a97e:	49 c7 44 05 60 00 00 	movq   $0x0,0x60(%r13,%rax,1)
   4a985:	00 00 
   4a987:	66 41 c7 44 05 68 00 	movw   $0x0,0x68(%r13,%rax,1)
   4a98e:	00 
   4a98f:	49 c7 84 05 a0 00 00 	movq   $0x0,0xa0(%r13,%rax,1)
   4a996:	00 00 00 00 00 
   4a99b:	49 c7 84 05 c0 47 00 	movq   $0x0,0x47c0(%r13,%rax,1)
   4a9a2:	00 00 00 00 00 
   4a9a7:	e9 ae f5 ff ff       	jmp    49f5a <blake3_servil::each::finalize_each+0xba>
   4a9ac:	0f 1f 40 00          	nopl   0x0(%rax)
   4a9b0:	b9 08 00 00 00       	mov    $0x8,%ecx
   4a9b5:	4c 89 ef             	mov    %r13,%rdi
   4a9b8:	48 89 de             	mov    %rbx,%rsi
   4a9bb:	4c 89 f2             	mov    %r14,%rdx
   4a9be:	4d 89 e0             	mov    %r12,%r8
   4a9c1:	4d 89 f9             	mov    %r15,%r9
   4a9c4:	e8 c7 ea ff ff       	call   49490 <blake3_servil::each::finish_each>
   4a9c9:	49 89 d8             	mov    %rbx,%r8
   4a9cc:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
   4a9d1:	4d 89 f3             	mov    %r14,%r11
   4a9d4:	4c 8b 7c 24 30       	mov    0x30(%rsp),%r15
   4a9d9:	48 8d 74 24 48       	lea    0x48(%rsp),%rsi
   4a9de:	e9 77 f5 ff ff       	jmp    49f5a <blake3_servil::each::finalize_each+0xba>
   4a9e3:	49 83 fa 10          	cmp    $0x10,%r10
   4a9e7:	0f 82 cc 02 00 00    	jb     4acb9 <blake3_servil::each::finalize_each+0xe19>
   4a9ed:	49 8d 42 0f          	lea    0xf(%r10),%rax
   4a9f1:	48 c1 e8 04          	shr    $0x4,%rax
   4a9f5:	48 89 84 24 f8 01 00 	mov    %rax,0x1f8(%rsp)
   4a9fc:	00 
   4a9fd:	4c 8d 74 24 48       	lea    0x48(%rsp),%r14
   4aa02:	31 c9                	xor    %ecx,%ecx
   4aa04:	4d 89 df             	mov    %r11,%r15
   4aa07:	4c 89 64 24 38       	mov    %r12,0x38(%rsp)
   4aa0c:	eb 41                	jmp    4aa4f <blake3_servil::each::finalize_each+0xbaf>
   4aa0e:	66 90                	xchg   %ax,%ax
   4aa10:	4c 89 ef             	mov    %r13,%rdi
   4aa13:	4c 89 c6             	mov    %r8,%rsi
   4aa16:	48 89 da             	mov    %rbx,%rdx
   4aa19:	4d 89 e0             	mov    %r12,%r8
   4aa1c:	e8 6f ea ff ff       	call   49490 <blake3_servil::each::finish_each>
   4aa21:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
   4aa26:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
   4aa2b:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
   4aa30:	4c 8b 64 24 38       	mov    0x38(%rsp),%r12
   4aa35:	48 8b 4c 24 30       	mov    0x30(%rsp),%rcx
   4aa3a:	48 ff c1             	inc    %rcx
   4aa3d:	49 83 ef 80          	sub    $0xffffffffffffff80,%r15
   4aa41:	48 3b 8c 24 f8 01 00 	cmp    0x1f8(%rsp),%rcx
   4aa48:	00 
   4aa49:	0f 84 81 02 00 00    	je     4acd0 <blake3_servil::each::finalize_each+0xe30>
   4aa4f:	48 89 c8             	mov    %rcx,%rax
   4aa52:	48 c1 e0 04          	shl    $0x4,%rax
   4aa56:	49 29 c2             	sub    %rax,%r10
   4aa59:	49 83 fa 10          	cmp    $0x10,%r10
   4aa5d:	41 b9 10 00 00 00    	mov    $0x10,%r9d
   4aa63:	4d 0f 42 ca          	cmovb  %r10,%r9
   4aa67:	48 89 cb             	mov    %rcx,%rbx
   4aa6a:	48 c1 e3 07          	shl    $0x7,%rbx
   4aa6e:	4c 01 db             	add    %r11,%rbx
   4aa71:	4c 89 e0             	mov    %r12,%rax
   4aa74:	48 89 4c 24 30       	mov    %rcx,0x30(%rsp)
   4aa79:	49 89 cc             	mov    %rcx,%r12
   4aa7c:	49 c1 e4 09          	shl    $0x9,%r12
   4aa80:	49 01 c4             	add    %rax,%r12
   4aa83:	4c 89 c9             	mov    %r9,%rcx
   4aa86:	49 83 fa 0f          	cmp    $0xf,%r10
   4aa8a:	76 84                	jbe    4aa10 <blake3_servil::each::finalize_each+0xb70>
   4aa8c:	c7 44 24 40 00 00 00 	movl   $0x0,0x40(%rsp)
   4aa93:	00 
   4aa94:	b8 19 00 00 00       	mov    $0x19,%eax
   4aa99:	31 c9                	xor    %ecx,%ecx
   4aa9b:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   4aaa0:	49 8b 3c cf          	mov    (%r15,%rcx,8),%rdi
   4aaa4:	4c 39 c7             	cmp    %r8,%rdi
   4aaa7:	0f 83 42 02 00 00    	jae    4acef <blake3_servil::each::finalize_each+0xe4f>
   4aaad:	4c 8d 14 ff          	lea    (%rdi,%rdi,8),%r10
   4aab1:	49 c1 e2 0b          	shl    $0xb,%r10
   4aab5:	4b 83 bc 15 c0 47 00 	cmpq   $0x0,0x47c0(%r13,%r10,1)
   4aabc:	00 00 
   4aabe:	75 70                	jne    4ab30 <blake3_servil::each::finalize_each+0xc90>
   4aac0:	4b 83 bc 15 90 07 00 	cmpq   $0x0,0x790(%r13,%r10,1)
   4aac7:	00 00 
   4aac9:	75 65                	jne    4ab30 <blake3_servil::each::finalize_each+0xc90>
   4aacb:	4b 83 7c 15 60 00    	cmpq   $0x0,0x60(%r13,%r10,1)
   4aad1:	75 5d                	jne    4ab30 <blake3_servil::each::finalize_each+0xc90>
   4aad3:	4b 83 bc 15 a0 00 00 	cmpq   $0x0,0xa0(%r13,%r10,1)
   4aada:	00 00 
   4aadc:	75 52                	jne    4ab30 <blake3_servil::each::finalize_each+0xc90>
   4aade:	4d 01 ea             	add    %r13,%r10
   4aae1:	41 0f b6 72 68       	movzbl 0x68(%r10),%esi
   4aae6:	41 80 7a 69 00       	cmpb   $0x0,0x69(%r10)
   4aaeb:	40 0f 94 c7          	sete   %dil
   4aaef:	41 0a 7a 6a          	or     0x6a(%r10),%dil
   4aaf3:	40 80 cf 0a          	or     $0xa,%dil
   4aaf7:	4c 89 54 04 2f       	mov    %r10,0x2f(%rsp,%rax,1)
   4aafc:	49 83 c2 40          	add    $0x40,%r10
   4ab00:	4c 89 54 04 37       	mov    %r10,0x37(%rsp,%rax,1)
   4ab05:	40 88 74 04 3f       	mov    %sil,0x3f(%rsp,%rax,1)
   4ab0a:	40 88 7c 04 40       	mov    %dil,0x40(%rsp,%rax,1)
   4ab0f:	48 ff c1             	inc    %rcx
   4ab12:	89 4c 24 40          	mov    %ecx,0x40(%rsp)
   4ab16:	48 83 c0 18          	add    $0x18,%rax
   4ab1a:	48 3d 99 01 00 00    	cmp    $0x199,%rax
   4ab20:	0f 85 7a ff ff ff    	jne    4aaa0 <blake3_servil::each::finalize_each+0xc00>
   4ab26:	eb 13                	jmp    4ab3b <blake3_servil::each::finalize_each+0xc9b>
   4ab28:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
   4ab2f:	00 
   4ab30:	3d 99 01 00 00       	cmp    $0x199,%eax
   4ab35:	0f 85 f0 00 00 00    	jne    4ac2b <blake3_servil::each::finalize_each+0xd8b>
   4ab3b:	4c 89 f7             	mov    %r14,%rdi
   4ab3e:	4c 89 e6             	mov    %r12,%rsi
   4ab41:	ff 15 d9 48 07 00    	call   *0x748d9(%rip)        # bf420 <_DYNAMIC+0x738>
   4ab47:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
   4ab4c:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
   4ab51:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
   4ab56:	0f 57 db             	xorps  %xmm3,%xmm3
   4ab59:	31 c0                	xor    %eax,%eax
   4ab5b:	4c 8b 64 24 38       	mov    0x38(%rsp),%r12
   4ab60:	49 8b 3c 07          	mov    (%r15,%rax,1),%rdi
   4ab64:	4c 39 c7             	cmp    %r8,%rdi
   4ab67:	0f 83 72 01 00 00    	jae    4acdf <blake3_servil::each::finalize_each+0xe3f>
   4ab6d:	48 83 c0 08          	add    $0x8,%rax
   4ab71:	48 8d 0c ff          	lea    (%rdi,%rdi,8),%rcx
   4ab75:	48 c1 e1 0b          	shl    $0xb,%rcx
   4ab79:	0f 29 5c 24 40       	movaps %xmm3,0x40(%rsp)
   4ab7e:	0f 29 5c 24 70       	movaps %xmm3,0x70(%rsp)
   4ab83:	0f 29 5c 24 60       	movaps %xmm3,0x60(%rsp)
   4ab88:	0f 29 5c 24 50       	movaps %xmm3,0x50(%rsp)
   4ab8d:	41 0f 28 84 0d 80 00 	movaps 0x80(%r13,%rcx,1),%xmm0
   4ab94:	00 00 
   4ab96:	41 0f 29 46 38       	movaps %xmm0,0x38(%r14)
   4ab9b:	41 0f 28 84 0d 90 00 	movaps 0x90(%r13,%rcx,1),%xmm0
   4aba2:	00 00 
   4aba4:	41 0f 29 46 48       	movaps %xmm0,0x48(%r14)
   4aba9:	0f 28 44 24 40       	movaps 0x40(%rsp),%xmm0
   4abae:	0f 28 8c 24 80 00 00 	movaps 0x80(%rsp),%xmm1
   4abb5:	00 
   4abb6:	41 0f 29 44 0d 00    	movaps %xmm0,0x0(%r13,%rcx,1)
   4abbc:	0f 28 44 24 50       	movaps 0x50(%rsp),%xmm0
   4abc1:	0f 28 94 24 90 00 00 	movaps 0x90(%rsp),%xmm2
   4abc8:	00 
   4abc9:	41 0f 29 44 0d 10    	movaps %xmm0,0x10(%r13,%rcx,1)
   4abcf:	41 0f 29 4c 0d 40    	movaps %xmm1,0x40(%r13,%rcx,1)
   4abd5:	41 0f 29 54 0d 50    	movaps %xmm2,0x50(%r13,%rcx,1)
   4abdb:	0f 28 44 24 60       	movaps 0x60(%rsp),%xmm0
   4abe0:	41 0f 29 44 0d 20    	movaps %xmm0,0x20(%r13,%rcx,1)
   4abe6:	0f 28 44 24 70       	movaps 0x70(%rsp),%xmm0
   4abeb:	41 0f 29 44 0d 30    	movaps %xmm0,0x30(%r13,%rcx,1)
   4abf1:	49 c7 44 0d 60 00 00 	movq   $0x0,0x60(%r13,%rcx,1)
   4abf8:	00 00 
   4abfa:	66 41 c7 44 0d 68 00 	movw   $0x0,0x68(%r13,%rcx,1)
   4ac01:	00 
   4ac02:	49 c7 84 0d a0 00 00 	movq   $0x0,0xa0(%r13,%rcx,1)
   4ac09:	00 00 00 00 00 
   4ac0e:	49 c7 84 0d c0 47 00 	movq   $0x0,0x47c0(%r13,%rcx,1)
   4ac15:	00 00 00 00 00 
   4ac1a:	48 3d 80 00 00 00    	cmp    $0x80,%rax
   4ac20:	0f 85 3a ff ff ff    	jne    4ab60 <blake3_servil::each::finalize_each+0xcc0>
   4ac26:	e9 0a fe ff ff       	jmp    4aa35 <blake3_servil::each::finalize_each+0xb95>
   4ac2b:	4c 89 ef             	mov    %r13,%rdi
   4ac2e:	4c 89 c6             	mov    %r8,%rsi
   4ac31:	48 89 da             	mov    %rbx,%rdx
   4ac34:	4c 89 e1             	mov    %r12,%rcx
   4ac37:	4d 89 c8             	mov    %r9,%r8
   4ac3a:	4c 89 8c 24 f0 01 00 	mov    %r9,0x1f0(%rsp)
   4ac41:	00 
   4ac42:	e8 39 1f 00 00       	call   4cb80 <blake3_servil::ffi_output::staged_group::<16>>
   4ac47:	4c 8b 8c 24 f0 01 00 	mov    0x1f0(%rsp),%r9
   4ac4e:	00 
   4ac4f:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
   4ac54:	b9 10 00 00 00       	mov    $0x10,%ecx
   4ac59:	84 c0                	test   %al,%al
   4ac5b:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
   4ac60:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
   4ac65:	0f 57 db             	xorps  %xmm3,%xmm3
   4ac68:	0f 84 a2 fd ff ff    	je     4aa10 <blake3_servil::each::finalize_each+0xb70>
   4ac6e:	e9 e6 fe ff ff       	jmp    4ab59 <blake3_servil::each::finalize_each+0xcb9>
   4ac73:	48 8d 0d 7d 72 fc ff 	lea    -0x38d83(%rip),%rcx        # 11ef7 <BLAKE3_IV_3+0x2b>
   4ac7a:	4c 8d 0d 17 0c 07 00 	lea    0x70c17(%rip),%r9        # bb898 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x238>
   4ac81:	48 8d b4 24 00 02 00 	lea    0x200(%rsp),%rsi
   4ac88:	00 
   4ac89:	48 8d 54 24 40       	lea    0x40(%rsp),%rdx
   4ac8e:	41 b8 39 00 00 00    	mov    $0x39,%r8d
   4ac94:	31 ff                	xor    %edi,%edi
   4ac96:	ff 15 8c 47 07 00    	call   *0x7478c(%rip)        # bf428 <_DYNAMIC+0x740>
   4ac9c:	ff 15 76 47 07 00    	call   *0x74776(%rip)        # bf418 <_DYNAMIC+0x730>
   4aca2:	4c 8b 5c 24 28       	mov    0x28(%rsp),%r11
   4aca7:	4c 8b 54 24 20       	mov    0x20(%rsp),%r10
   4acac:	4c 8b 44 24 18       	mov    0x18(%rsp),%r8
   4acb1:	3c 03                	cmp    $0x3,%al
   4acb3:	0f 85 57 f2 ff ff    	jne    49f10 <blake3_servil::each::finalize_each+0x70>
   4acb9:	4c 89 ef             	mov    %r13,%rdi
   4acbc:	4c 89 c6             	mov    %r8,%rsi
   4acbf:	4c 89 da             	mov    %r11,%rdx
   4acc2:	4c 89 d1             	mov    %r10,%rcx
   4acc5:	4d 89 e0             	mov    %r12,%r8
   4acc8:	4d 89 d1             	mov    %r10,%r9
   4accb:	e8 c0 e7 ff ff       	call   49490 <blake3_servil::each::finish_each>
   4acd0:	48 8d 65 d8          	lea    -0x28(%rbp),%rsp
   4acd4:	5b                   	pop    %rbx
   4acd5:	41 5c                	pop    %r12
   4acd7:	41 5d                	pop    %r13
   4acd9:	41 5e                	pop    %r14
   4acdb:	41 5f                	pop    %r15
   4acdd:	5d                   	pop    %rbp
   4acde:	c3                   	ret
   4acdf:	48 8d 15 c2 0a 07 00 	lea    0x70ac2(%rip),%rdx        # bb7a8 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x148>
   4ace6:	4c 89 c6             	mov    %r8,%rsi
   4ace9:	ff 15 f9 42 07 00    	call   *0x742f9(%rip)        # befe8 <_DYNAMIC+0x300>
   4acef:	48 8d 15 9a 0a 07 00 	lea    0x70a9a(%rip),%rdx        # bb790 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x130>
   4acf6:	4c 89 c6             	mov    %r8,%rsi
   4acf9:	ff 15 e9 42 07 00    	call   *0x742e9(%rip)        # befe8 <_DYNAMIC+0x300>
   4acff:	48 8d 15 a2 0a 07 00 	lea    0x70aa2(%rip),%rdx        # bb7a8 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x148>
   4ad06:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
   4ad0b:	ff 15 d7 42 07 00    	call   *0x742d7(%rip)        # befe8 <_DYNAMIC+0x300>
   4ad11:	48 8d 15 78 0a 07 00 	lea    0x70a78(%rip),%rdx        # bb790 <anon.96b72b8be5451df710a4c3be8dc88096.8.llvm.15663618361618640270+0x130>
   4ad18:	48 8b 74 24 18       	mov    0x18(%rsp),%rsi
   4ad1d:	ff 15 c5 42 07 00    	call   *0x742c5(%rip)        # befe8 <_DYNAMIC+0x300>
