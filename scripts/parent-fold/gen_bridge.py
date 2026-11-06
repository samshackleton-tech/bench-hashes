#!/usr/bin/env python3
"""Benchmark-only CV/message layout controls; no compression or hash API.

Reuse current generator's output/transpose emitters for the round-trip path.
Compare that with register-only adjacent-child compaction. Both controls load
16 SoA CV vectors and store 16 SoA parent-message vectors. The round-trip also
materializes 32 canonical CVs and reloads them as 16 parent blocks.
"""
import ast
import pathlib
import sys

source = pathlib.Path(sys.argv[1]).read_text()
module = ast.parse(source)
names = {"emit", "transpose", "output_group"}
nodes = []
for node in module.body:
    if isinstance(node, ast.FunctionDef) and node.name in names:
        nodes.append(node)
    elif isinstance(node, ast.Assign) and any(isinstance(t, ast.Name) and t.id == "WORD" for t in node.targets):
        nodes.append(node)
assert len(nodes) == 4
namespace = {}
exec(compile(ast.Module(body=nodes, type_ignores=[]), "current_transpose_helpers", "exec"), namespace)
emit = namespace["emit"]
transpose = namespace["transpose"]
output_group = namespace["output_group"]
word = namespace["WORD"]

print('.intel_syntax noprefix\n.text')


def begin(name):
    print(f'.p2align 6\n.global {name}\n.hidden {name}\n.type {name}, @function\n{name}:\n.cfi_startproc')
    emit('endbr64')
    emit('push r15')
    print('.cfi_def_cfa_offset 16\n.cfi_offset r15, -16')
    # ABI: rdi = SoA CV input, rsi = SoA message output,
    # rdx = canonical CV scratch, rcx = 16 pointers into scratch.
    emit('mov r11, rsi')
    emit('mov r15, rdx')
    for r in range(16):
        emit(f'vmovdqa32 zmm{r}, ZMMWORD PTR [rdi + {64*r}]')


def end(name):
    emit('vzeroupper')
    emit('pop r15')
    print('.cfi_def_cfa_offset 8\n.cfi_restore r15')
    emit('ret')
    print(f'.cfi_endproc\n.size {name}, .-{name}')


name = 'parent_bridge_roundtrip'
begin(name)
output_group(0, 0)
output_group(8, 512)
for i in range(16):
    emit(f'mov rax, QWORD PTR [rcx + {8*i}]')
    emit(f'vmovdqu32 zmm{16+i}, ZMMWORD PTR [rax]')
rows = transpose(list(range(16, 32)), 8)
for w in range(16):
    emit(f'vmovdqa32 ZMMWORD PTR [r11 + {64*w}], zmm{rows[word[w]]}')
end(name)


def direct(name, odd):
    begin(name)
    emit('vmovdqa32 zmm30, ZMMWORD PTR [rip + .Leven]')
    emit(f'vmovdqa32 zmm31, ZMMWORD PTR [rip + {odd}]')
    for w in range(8):
        if w == 6:
            # The first child word's two source registers are now dead.
            emit('vmovdqa32 zmm0, zmm30')
            emit('vmovdqa32 zmm8, zmm31')
        even_index, odd_index = (30, 31) if w < 6 else (0, 8)
        a, b = w, 8+w
        left, right = 16+w, 24+w
        emit(f'vpermd zmm{left}, zmm{even_index}, zmm{a}')
        emit(f'vpermd zmm{right}, zmm{even_index}, zmm{b}')
        # 0x44 joins low eight words of each input, not repeated quarters.
        emit(f'vshufi32x4 zmm{left}, zmm{left}, zmm{right}, 0x44')
        emit(f'vpermd zmm{right}, zmm{odd_index}, zmm{a}')
        emit(f'vpermd zmm{b}, zmm{odd_index}, zmm{b}')
        emit(f'vshufi32x4 zmm{right}, zmm{right}, zmm{b}, 0x44')
    for w in range(16):
        emit(f'vmovdqa32 ZMMWORD PTR [r11 + {64*w}], zmm{16+w}')
    end(name)


direct('parent_bridge_direct', '.Lodd')
direct('parent_bridge_bad', '.Leven')
print('.section .rodata\n.p2align 6\n.Leven:\n.long ' + ', '.join(str(i) for i in list(range(0, 16, 2))*2))
print('.p2align 6\n.Lodd:\n.long ' + ', '.join(str(i) for i in list(range(1, 16, 2))*2))
print('.section .note.GNU-stack,"",@progbits')
