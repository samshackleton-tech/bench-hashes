.intel_syntax noprefix
.text
.p2align 6
.global parent_bridge_roundtrip
.hidden parent_bridge_roundtrip
.type parent_bridge_roundtrip, @function
parent_bridge_roundtrip:
.cfi_startproc
    endbr64
    push r15
.cfi_def_cfa_offset 16
.cfi_offset r15, -16
    mov r11, rsi
    mov r15, rdx
    vmovdqa32 zmm0, ZMMWORD PTR [rdi + 0]
    vmovdqa32 zmm1, ZMMWORD PTR [rdi + 64]
    vmovdqa32 zmm2, ZMMWORD PTR [rdi + 128]
    vmovdqa32 zmm3, ZMMWORD PTR [rdi + 192]
    vmovdqa32 zmm4, ZMMWORD PTR [rdi + 256]
    vmovdqa32 zmm5, ZMMWORD PTR [rdi + 320]
    vmovdqa32 zmm6, ZMMWORD PTR [rdi + 384]
    vmovdqa32 zmm7, ZMMWORD PTR [rdi + 448]
    vmovdqa32 zmm8, ZMMWORD PTR [rdi + 512]
    vmovdqa32 zmm9, ZMMWORD PTR [rdi + 576]
    vmovdqa32 zmm10, ZMMWORD PTR [rdi + 640]
    vmovdqa32 zmm11, ZMMWORD PTR [rdi + 704]
    vmovdqa32 zmm12, ZMMWORD PTR [rdi + 768]
    vmovdqa32 zmm13, ZMMWORD PTR [rdi + 832]
    vmovdqa32 zmm14, ZMMWORD PTR [rdi + 896]
    vmovdqa32 zmm15, ZMMWORD PTR [rdi + 960]
    vpunpckldq zmm16, zmm0, zmm1
    vpunpckhdq zmm0, zmm0, zmm1
    vpunpckldq zmm1, zmm2, zmm3
    vpunpckhdq zmm2, zmm2, zmm3
    vpunpckldq zmm3, zmm4, zmm5
    vpunpckhdq zmm4, zmm4, zmm5
    vpunpckldq zmm5, zmm6, zmm7
    vpunpckhdq zmm6, zmm6, zmm7
    vpunpcklqdq zmm7, zmm16, zmm1
    vpunpckhqdq zmm16, zmm16, zmm1
    vpunpcklqdq zmm1, zmm0, zmm2
    vpunpckhqdq zmm0, zmm0, zmm2
    vpunpcklqdq zmm2, zmm3, zmm5
    vpunpckhqdq zmm3, zmm3, zmm5
    vpunpcklqdq zmm5, zmm4, zmm6
    vpunpckhqdq zmm4, zmm4, zmm6
    vshufi32x4 zmm6, zmm7, zmm2, 0x88
    vshufi32x4 zmm7, zmm7, zmm2, 0xdd
    vshufi32x4 zmm2, zmm1, zmm5, 0x88
    vshufi32x4 zmm1, zmm1, zmm5, 0xdd
    vshufi32x4 zmm5, zmm16, zmm3, 0x88
    vshufi32x4 zmm16, zmm16, zmm3, 0xdd
    vshufi32x4 zmm3, zmm0, zmm4, 0x88
    vshufi32x4 zmm0, zmm0, zmm4, 0xdd
    vshufi32x4 zmm4, zmm6, zmm5, 136
    vmovdqu32 ZMMWORD PTR [r15 + 0], zmm4
    vshufi32x4 zmm4, zmm2, zmm3, 136
    vmovdqu32 ZMMWORD PTR [r15 + 64], zmm4
    vshufi32x4 zmm4, zmm7, zmm16, 136
    vmovdqu32 ZMMWORD PTR [r15 + 128], zmm4
    vshufi32x4 zmm4, zmm1, zmm0, 136
    vmovdqu32 ZMMWORD PTR [r15 + 192], zmm4
    vshufi32x4 zmm4, zmm6, zmm5, 221
    vmovdqu32 ZMMWORD PTR [r15 + 256], zmm4
    vshufi32x4 zmm4, zmm2, zmm3, 221
    vmovdqu32 ZMMWORD PTR [r15 + 320], zmm4
    vshufi32x4 zmm4, zmm7, zmm16, 221
    vmovdqu32 ZMMWORD PTR [r15 + 384], zmm4
    vshufi32x4 zmm4, zmm1, zmm0, 221
    vmovdqu32 ZMMWORD PTR [r15 + 448], zmm4
    vpunpckldq zmm16, zmm8, zmm9
    vpunpckhdq zmm8, zmm8, zmm9
    vpunpckldq zmm9, zmm10, zmm11
    vpunpckhdq zmm10, zmm10, zmm11
    vpunpckldq zmm11, zmm12, zmm13
    vpunpckhdq zmm12, zmm12, zmm13
    vpunpckldq zmm13, zmm14, zmm15
    vpunpckhdq zmm14, zmm14, zmm15
    vpunpcklqdq zmm15, zmm16, zmm9
    vpunpckhqdq zmm16, zmm16, zmm9
    vpunpcklqdq zmm9, zmm8, zmm10
    vpunpckhqdq zmm8, zmm8, zmm10
    vpunpcklqdq zmm10, zmm11, zmm13
    vpunpckhqdq zmm11, zmm11, zmm13
    vpunpcklqdq zmm13, zmm12, zmm14
    vpunpckhqdq zmm12, zmm12, zmm14
    vshufi32x4 zmm14, zmm15, zmm10, 0x88
    vshufi32x4 zmm15, zmm15, zmm10, 0xdd
    vshufi32x4 zmm10, zmm9, zmm13, 0x88
    vshufi32x4 zmm9, zmm9, zmm13, 0xdd
    vshufi32x4 zmm13, zmm16, zmm11, 0x88
    vshufi32x4 zmm16, zmm16, zmm11, 0xdd
    vshufi32x4 zmm11, zmm8, zmm12, 0x88
    vshufi32x4 zmm8, zmm8, zmm12, 0xdd
    vshufi32x4 zmm12, zmm14, zmm13, 136
    vmovdqu32 ZMMWORD PTR [r15 + 512], zmm12
    vshufi32x4 zmm12, zmm10, zmm11, 136
    vmovdqu32 ZMMWORD PTR [r15 + 576], zmm12
    vshufi32x4 zmm12, zmm15, zmm16, 136
    vmovdqu32 ZMMWORD PTR [r15 + 640], zmm12
    vshufi32x4 zmm12, zmm9, zmm8, 136
    vmovdqu32 ZMMWORD PTR [r15 + 704], zmm12
    vshufi32x4 zmm12, zmm14, zmm13, 221
    vmovdqu32 ZMMWORD PTR [r15 + 768], zmm12
    vshufi32x4 zmm12, zmm10, zmm11, 221
    vmovdqu32 ZMMWORD PTR [r15 + 832], zmm12
    vshufi32x4 zmm12, zmm15, zmm16, 221
    vmovdqu32 ZMMWORD PTR [r15 + 896], zmm12
    vshufi32x4 zmm12, zmm9, zmm8, 221
    vmovdqu32 ZMMWORD PTR [r15 + 960], zmm12
    mov rax, QWORD PTR [rcx + 0]
    vmovdqu32 zmm16, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 8]
    vmovdqu32 zmm17, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 16]
    vmovdqu32 zmm18, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 24]
    vmovdqu32 zmm19, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 32]
    vmovdqu32 zmm20, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 40]
    vmovdqu32 zmm21, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 48]
    vmovdqu32 zmm22, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 56]
    vmovdqu32 zmm23, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 64]
    vmovdqu32 zmm24, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 72]
    vmovdqu32 zmm25, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 80]
    vmovdqu32 zmm26, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 88]
    vmovdqu32 zmm27, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 96]
    vmovdqu32 zmm28, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 104]
    vmovdqu32 zmm29, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 112]
    vmovdqu32 zmm30, ZMMWORD PTR [rax]
    mov rax, QWORD PTR [rcx + 120]
    vmovdqu32 zmm31, ZMMWORD PTR [rax]
    vpunpckldq zmm8, zmm16, zmm17
    vpunpckhdq zmm16, zmm16, zmm17
    vpunpckldq zmm17, zmm18, zmm19
    vpunpckhdq zmm18, zmm18, zmm19
    vpunpckldq zmm19, zmm20, zmm21
    vpunpckhdq zmm20, zmm20, zmm21
    vpunpckldq zmm21, zmm22, zmm23
    vpunpckhdq zmm22, zmm22, zmm23
    vpunpckldq zmm23, zmm24, zmm25
    vpunpckhdq zmm24, zmm24, zmm25
    vpunpckldq zmm25, zmm26, zmm27
    vpunpckhdq zmm26, zmm26, zmm27
    vpunpckldq zmm27, zmm28, zmm29
    vpunpckhdq zmm28, zmm28, zmm29
    vpunpckldq zmm29, zmm30, zmm31
    vpunpckhdq zmm30, zmm30, zmm31
    vpunpcklqdq zmm31, zmm8, zmm17
    vpunpckhqdq zmm8, zmm8, zmm17
    vpunpcklqdq zmm17, zmm16, zmm18
    vpunpckhqdq zmm16, zmm16, zmm18
    vpunpcklqdq zmm18, zmm19, zmm21
    vpunpckhqdq zmm19, zmm19, zmm21
    vpunpcklqdq zmm21, zmm20, zmm22
    vpunpckhqdq zmm20, zmm20, zmm22
    vpunpcklqdq zmm22, zmm23, zmm25
    vpunpckhqdq zmm23, zmm23, zmm25
    vpunpcklqdq zmm25, zmm24, zmm26
    vpunpckhqdq zmm24, zmm24, zmm26
    vpunpcklqdq zmm26, zmm27, zmm29
    vpunpckhqdq zmm27, zmm27, zmm29
    vpunpcklqdq zmm29, zmm28, zmm30
    vpunpckhqdq zmm28, zmm28, zmm30
    vshufi32x4 zmm30, zmm31, zmm18, 0x88
    vshufi32x4 zmm31, zmm31, zmm18, 0xdd
    vshufi32x4 zmm18, zmm17, zmm21, 0x88
    vshufi32x4 zmm17, zmm17, zmm21, 0xdd
    vshufi32x4 zmm21, zmm8, zmm19, 0x88
    vshufi32x4 zmm8, zmm8, zmm19, 0xdd
    vshufi32x4 zmm19, zmm16, zmm20, 0x88
    vshufi32x4 zmm16, zmm16, zmm20, 0xdd
    vshufi32x4 zmm20, zmm22, zmm26, 0x88
    vshufi32x4 zmm22, zmm22, zmm26, 0xdd
    vshufi32x4 zmm26, zmm25, zmm29, 0x88
    vshufi32x4 zmm25, zmm25, zmm29, 0xdd
    vshufi32x4 zmm29, zmm23, zmm27, 0x88
    vshufi32x4 zmm23, zmm23, zmm27, 0xdd
    vshufi32x4 zmm27, zmm24, zmm28, 0x88
    vshufi32x4 zmm24, zmm24, zmm28, 0xdd
    vshufi32x4 zmm28, zmm30, zmm20, 0x88
    vshufi32x4 zmm30, zmm30, zmm20, 0xdd
    vshufi32x4 zmm20, zmm18, zmm26, 0x88
    vshufi32x4 zmm18, zmm18, zmm26, 0xdd
    vshufi32x4 zmm26, zmm21, zmm29, 0x88
    vshufi32x4 zmm21, zmm21, zmm29, 0xdd
    vshufi32x4 zmm29, zmm19, zmm27, 0x88
    vshufi32x4 zmm19, zmm19, zmm27, 0xdd
    vshufi32x4 zmm27, zmm31, zmm22, 0x88
    vshufi32x4 zmm31, zmm31, zmm22, 0xdd
    vshufi32x4 zmm22, zmm17, zmm25, 0x88
    vshufi32x4 zmm17, zmm17, zmm25, 0xdd
    vshufi32x4 zmm25, zmm8, zmm23, 0x88
    vshufi32x4 zmm8, zmm8, zmm23, 0xdd
    vshufi32x4 zmm23, zmm16, zmm24, 0x88
    vshufi32x4 zmm16, zmm16, zmm24, 0xdd
    vmovdqa32 ZMMWORD PTR [r11 + 0], zmm28
    vmovdqa32 ZMMWORD PTR [r11 + 64], zmm26
    vmovdqa32 ZMMWORD PTR [r11 + 128], zmm20
    vmovdqa32 ZMMWORD PTR [r11 + 192], zmm29
    vmovdqa32 ZMMWORD PTR [r11 + 256], zmm27
    vmovdqa32 ZMMWORD PTR [r11 + 320], zmm25
    vmovdqa32 ZMMWORD PTR [r11 + 384], zmm22
    vmovdqa32 ZMMWORD PTR [r11 + 448], zmm23
    vmovdqa32 ZMMWORD PTR [r11 + 512], zmm30
    vmovdqa32 ZMMWORD PTR [r11 + 576], zmm21
    vmovdqa32 ZMMWORD PTR [r11 + 640], zmm18
    vmovdqa32 ZMMWORD PTR [r11 + 704], zmm19
    vmovdqa32 ZMMWORD PTR [r11 + 768], zmm31
    vmovdqa32 ZMMWORD PTR [r11 + 832], zmm8
    vmovdqa32 ZMMWORD PTR [r11 + 896], zmm17
    vmovdqa32 ZMMWORD PTR [r11 + 960], zmm16
    vzeroupper
    pop r15
.cfi_def_cfa_offset 8
.cfi_restore r15
    ret
.cfi_endproc
.size parent_bridge_roundtrip, .-parent_bridge_roundtrip
.p2align 6
.global parent_bridge_direct
.hidden parent_bridge_direct
.type parent_bridge_direct, @function
parent_bridge_direct:
.cfi_startproc
    endbr64
    push r15
.cfi_def_cfa_offset 16
.cfi_offset r15, -16
    mov r11, rsi
    mov r15, rdx
    vmovdqa32 zmm0, ZMMWORD PTR [rdi + 0]
    vmovdqa32 zmm1, ZMMWORD PTR [rdi + 64]
    vmovdqa32 zmm2, ZMMWORD PTR [rdi + 128]
    vmovdqa32 zmm3, ZMMWORD PTR [rdi + 192]
    vmovdqa32 zmm4, ZMMWORD PTR [rdi + 256]
    vmovdqa32 zmm5, ZMMWORD PTR [rdi + 320]
    vmovdqa32 zmm6, ZMMWORD PTR [rdi + 384]
    vmovdqa32 zmm7, ZMMWORD PTR [rdi + 448]
    vmovdqa32 zmm8, ZMMWORD PTR [rdi + 512]
    vmovdqa32 zmm9, ZMMWORD PTR [rdi + 576]
    vmovdqa32 zmm10, ZMMWORD PTR [rdi + 640]
    vmovdqa32 zmm11, ZMMWORD PTR [rdi + 704]
    vmovdqa32 zmm12, ZMMWORD PTR [rdi + 768]
    vmovdqa32 zmm13, ZMMWORD PTR [rdi + 832]
    vmovdqa32 zmm14, ZMMWORD PTR [rdi + 896]
    vmovdqa32 zmm15, ZMMWORD PTR [rdi + 960]
    vmovdqa32 zmm30, ZMMWORD PTR [rip + .Leven]
    vmovdqa32 zmm31, ZMMWORD PTR [rip + .Lodd]
    vpermd zmm16, zmm30, zmm0
    vpermd zmm24, zmm30, zmm8
    vshufi32x4 zmm16, zmm16, zmm24, 0x44
    vpermd zmm24, zmm31, zmm0
    vpermd zmm8, zmm31, zmm8
    vshufi32x4 zmm24, zmm24, zmm8, 0x44
    vpermd zmm17, zmm30, zmm1
    vpermd zmm25, zmm30, zmm9
    vshufi32x4 zmm17, zmm17, zmm25, 0x44
    vpermd zmm25, zmm31, zmm1
    vpermd zmm9, zmm31, zmm9
    vshufi32x4 zmm25, zmm25, zmm9, 0x44
    vpermd zmm18, zmm30, zmm2
    vpermd zmm26, zmm30, zmm10
    vshufi32x4 zmm18, zmm18, zmm26, 0x44
    vpermd zmm26, zmm31, zmm2
    vpermd zmm10, zmm31, zmm10
    vshufi32x4 zmm26, zmm26, zmm10, 0x44
    vpermd zmm19, zmm30, zmm3
    vpermd zmm27, zmm30, zmm11
    vshufi32x4 zmm19, zmm19, zmm27, 0x44
    vpermd zmm27, zmm31, zmm3
    vpermd zmm11, zmm31, zmm11
    vshufi32x4 zmm27, zmm27, zmm11, 0x44
    vpermd zmm20, zmm30, zmm4
    vpermd zmm28, zmm30, zmm12
    vshufi32x4 zmm20, zmm20, zmm28, 0x44
    vpermd zmm28, zmm31, zmm4
    vpermd zmm12, zmm31, zmm12
    vshufi32x4 zmm28, zmm28, zmm12, 0x44
    vpermd zmm21, zmm30, zmm5
    vpermd zmm29, zmm30, zmm13
    vshufi32x4 zmm21, zmm21, zmm29, 0x44
    vpermd zmm29, zmm31, zmm5
    vpermd zmm13, zmm31, zmm13
    vshufi32x4 zmm29, zmm29, zmm13, 0x44
    vmovdqa32 zmm0, zmm30
    vmovdqa32 zmm8, zmm31
    vpermd zmm22, zmm0, zmm6
    vpermd zmm30, zmm0, zmm14
    vshufi32x4 zmm22, zmm22, zmm30, 0x44
    vpermd zmm30, zmm8, zmm6
    vpermd zmm14, zmm8, zmm14
    vshufi32x4 zmm30, zmm30, zmm14, 0x44
    vpermd zmm23, zmm0, zmm7
    vpermd zmm31, zmm0, zmm15
    vshufi32x4 zmm23, zmm23, zmm31, 0x44
    vpermd zmm31, zmm8, zmm7
    vpermd zmm15, zmm8, zmm15
    vshufi32x4 zmm31, zmm31, zmm15, 0x44
    vmovdqa32 ZMMWORD PTR [r11 + 0], zmm16
    vmovdqa32 ZMMWORD PTR [r11 + 64], zmm17
    vmovdqa32 ZMMWORD PTR [r11 + 128], zmm18
    vmovdqa32 ZMMWORD PTR [r11 + 192], zmm19
    vmovdqa32 ZMMWORD PTR [r11 + 256], zmm20
    vmovdqa32 ZMMWORD PTR [r11 + 320], zmm21
    vmovdqa32 ZMMWORD PTR [r11 + 384], zmm22
    vmovdqa32 ZMMWORD PTR [r11 + 448], zmm23
    vmovdqa32 ZMMWORD PTR [r11 + 512], zmm24
    vmovdqa32 ZMMWORD PTR [r11 + 576], zmm25
    vmovdqa32 ZMMWORD PTR [r11 + 640], zmm26
    vmovdqa32 ZMMWORD PTR [r11 + 704], zmm27
    vmovdqa32 ZMMWORD PTR [r11 + 768], zmm28
    vmovdqa32 ZMMWORD PTR [r11 + 832], zmm29
    vmovdqa32 ZMMWORD PTR [r11 + 896], zmm30
    vmovdqa32 ZMMWORD PTR [r11 + 960], zmm31
    vzeroupper
    pop r15
.cfi_def_cfa_offset 8
.cfi_restore r15
    ret
.cfi_endproc
.size parent_bridge_direct, .-parent_bridge_direct
.p2align 6
.global parent_bridge_bad
.hidden parent_bridge_bad
.type parent_bridge_bad, @function
parent_bridge_bad:
.cfi_startproc
    endbr64
    push r15
.cfi_def_cfa_offset 16
.cfi_offset r15, -16
    mov r11, rsi
    mov r15, rdx
    vmovdqa32 zmm0, ZMMWORD PTR [rdi + 0]
    vmovdqa32 zmm1, ZMMWORD PTR [rdi + 64]
    vmovdqa32 zmm2, ZMMWORD PTR [rdi + 128]
    vmovdqa32 zmm3, ZMMWORD PTR [rdi + 192]
    vmovdqa32 zmm4, ZMMWORD PTR [rdi + 256]
    vmovdqa32 zmm5, ZMMWORD PTR [rdi + 320]
    vmovdqa32 zmm6, ZMMWORD PTR [rdi + 384]
    vmovdqa32 zmm7, ZMMWORD PTR [rdi + 448]
    vmovdqa32 zmm8, ZMMWORD PTR [rdi + 512]
    vmovdqa32 zmm9, ZMMWORD PTR [rdi + 576]
    vmovdqa32 zmm10, ZMMWORD PTR [rdi + 640]
    vmovdqa32 zmm11, ZMMWORD PTR [rdi + 704]
    vmovdqa32 zmm12, ZMMWORD PTR [rdi + 768]
    vmovdqa32 zmm13, ZMMWORD PTR [rdi + 832]
    vmovdqa32 zmm14, ZMMWORD PTR [rdi + 896]
    vmovdqa32 zmm15, ZMMWORD PTR [rdi + 960]
    vmovdqa32 zmm30, ZMMWORD PTR [rip + .Leven]
    vmovdqa32 zmm31, ZMMWORD PTR [rip + .Leven]
    vpermd zmm16, zmm30, zmm0
    vpermd zmm24, zmm30, zmm8
    vshufi32x4 zmm16, zmm16, zmm24, 0x44
    vpermd zmm24, zmm31, zmm0
    vpermd zmm8, zmm31, zmm8
    vshufi32x4 zmm24, zmm24, zmm8, 0x44
    vpermd zmm17, zmm30, zmm1
    vpermd zmm25, zmm30, zmm9
    vshufi32x4 zmm17, zmm17, zmm25, 0x44
    vpermd zmm25, zmm31, zmm1
    vpermd zmm9, zmm31, zmm9
    vshufi32x4 zmm25, zmm25, zmm9, 0x44
    vpermd zmm18, zmm30, zmm2
    vpermd zmm26, zmm30, zmm10
    vshufi32x4 zmm18, zmm18, zmm26, 0x44
    vpermd zmm26, zmm31, zmm2
    vpermd zmm10, zmm31, zmm10
    vshufi32x4 zmm26, zmm26, zmm10, 0x44
    vpermd zmm19, zmm30, zmm3
    vpermd zmm27, zmm30, zmm11
    vshufi32x4 zmm19, zmm19, zmm27, 0x44
    vpermd zmm27, zmm31, zmm3
    vpermd zmm11, zmm31, zmm11
    vshufi32x4 zmm27, zmm27, zmm11, 0x44
    vpermd zmm20, zmm30, zmm4
    vpermd zmm28, zmm30, zmm12
    vshufi32x4 zmm20, zmm20, zmm28, 0x44
    vpermd zmm28, zmm31, zmm4
    vpermd zmm12, zmm31, zmm12
    vshufi32x4 zmm28, zmm28, zmm12, 0x44
    vpermd zmm21, zmm30, zmm5
    vpermd zmm29, zmm30, zmm13
    vshufi32x4 zmm21, zmm21, zmm29, 0x44
    vpermd zmm29, zmm31, zmm5
    vpermd zmm13, zmm31, zmm13
    vshufi32x4 zmm29, zmm29, zmm13, 0x44
    vmovdqa32 zmm0, zmm30
    vmovdqa32 zmm8, zmm31
    vpermd zmm22, zmm0, zmm6
    vpermd zmm30, zmm0, zmm14
    vshufi32x4 zmm22, zmm22, zmm30, 0x44
    vpermd zmm30, zmm8, zmm6
    vpermd zmm14, zmm8, zmm14
    vshufi32x4 zmm30, zmm30, zmm14, 0x44
    vpermd zmm23, zmm0, zmm7
    vpermd zmm31, zmm0, zmm15
    vshufi32x4 zmm23, zmm23, zmm31, 0x44
    vpermd zmm31, zmm8, zmm7
    vpermd zmm15, zmm8, zmm15
    vshufi32x4 zmm31, zmm31, zmm15, 0x44
    vmovdqa32 ZMMWORD PTR [r11 + 0], zmm16
    vmovdqa32 ZMMWORD PTR [r11 + 64], zmm17
    vmovdqa32 ZMMWORD PTR [r11 + 128], zmm18
    vmovdqa32 ZMMWORD PTR [r11 + 192], zmm19
    vmovdqa32 ZMMWORD PTR [r11 + 256], zmm20
    vmovdqa32 ZMMWORD PTR [r11 + 320], zmm21
    vmovdqa32 ZMMWORD PTR [r11 + 384], zmm22
    vmovdqa32 ZMMWORD PTR [r11 + 448], zmm23
    vmovdqa32 ZMMWORD PTR [r11 + 512], zmm24
    vmovdqa32 ZMMWORD PTR [r11 + 576], zmm25
    vmovdqa32 ZMMWORD PTR [r11 + 640], zmm26
    vmovdqa32 ZMMWORD PTR [r11 + 704], zmm27
    vmovdqa32 ZMMWORD PTR [r11 + 768], zmm28
    vmovdqa32 ZMMWORD PTR [r11 + 832], zmm29
    vmovdqa32 ZMMWORD PTR [r11 + 896], zmm30
    vmovdqa32 ZMMWORD PTR [r11 + 960], zmm31
    vzeroupper
    pop r15
.cfi_def_cfa_offset 8
.cfi_restore r15
    ret
.cfi_endproc
.size parent_bridge_bad, .-parent_bridge_bad
.section .rodata
.p2align 6
.Leven:
.long 0, 2, 4, 6, 8, 10, 12, 14, 0, 2, 4, 6, 8, 10, 12, 14
.p2align 6
.Lodd:
.long 1, 3, 5, 7, 9, 11, 13, 15, 1, 3, 5, 7, 9, 11, 13, 15
.section .note.GNU-stack,"",@progbits
