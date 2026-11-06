#!/usr/bin/env python3
"""Benchmark-only full-round candidate: 32 complete chunks -> 16 parent CVs.

The leaf prefix is the pinned production k32 emitter. Keep its key pointer,
replace its final CV stores with the checked adjacent-child register bridge,
then perform the current seven-round parent compression in registers.
Common flags are mode flags (structural low four bits clear). Parent counter
is zero and ROOT stays with the caller. Production source is read-only.
"""
import pathlib
import sys

source = pathlib.Path(sys.argv[1]).read_text()


def exact(old, new, count=1):
    global source
    assert source.count(old) == count, (old, source.count(old))
    source = source.replace(old, new)


exact('blake3_servil_avx512_k32', 'bench_k32_parent16', 3)
exact('blake3_servil_avx512_p32', 'bench_unused_p32_parent16', 3)
exact("emit('xor r14d, r14d')  # Byte offset into every input.",
      "emit('mov r10, r14')  # Preserve the common key for the parent phase.\nemit('xor r14d, r14d')  # Byte offset into every input.")
exact('for k in range(2):\n    output_group(8*k, 512*k)', 'emit_fused_parent()')
exact("parent16()\nprint('.section .rodata", "print('.section .rodata")
namespace = {}


def fused_parent():
    emit = namespace['emit']
    g = namespace['g']
    perm = namespace['PERM']
    print('.Lfused_parent:')
    emit('vmovdqa32 zmm30, ZMMWORD PTR [rip + .Lfused_even]')
    emit('vmovdqa32 zmm31, ZMMWORD PTR [rip + .Lfused_odd]')
    for w in range(8):
        if w == 6:
            emit('vmovdqa32 zmm0, zmm30')
            emit('vmovdqa32 zmm8, zmm31')
        even, odd = (30, 31) if w < 6 else (0, 8)
        a, b, left, right = w, 8+w, 16+w, 24+w
        emit(f'vpermd zmm{left}, zmm{even}, zmm{a}')
        emit(f'vpermd zmm{right}, zmm{even}, zmm{b}')
        emit(f'vshufi32x4 zmm{left}, zmm{left}, zmm{right}, 0x44')
        emit(f'vpermd zmm{right}, zmm{odd}, zmm{a}')
        emit(f'vpermd zmm{b}, zmm{odd}, zmm{b}')
        emit(f'vshufi32x4 zmm{right}, zmm{right}, zmm{b}, 0x44')
    messages = list(range(16, 32))
    for w in range(8):
        emit(f'vpbroadcastd zmm{w}, DWORD PTR [r10 + {4*w}]')
    for w in range(4):
        emit(f'vpbroadcastd zmm{8+w}, DWORD PTR [rip + .Liv32 + {4*w}]')
    for w in [12, 13]:
        emit(f'vpxord zmm{w}, zmm{w}, zmm{w}')
    emit('mov eax, 64')
    emit('vpbroadcastd zmm14, eax')
    emit('movzx eax, bl')
    emit('or eax, 4')
    emit('vpbroadcastd zmm15, eax')

    def round_body(schedule):
        for half, positions in enumerate((namespace['COLS'], namespace['DIAGS'])):
            chains = [g(*[f'zmm{w}' for w in pos],
                        f'zmm{messages[schedule[8*half+2*i]]}',
                        f'zmm{messages[schedule[8*half+2*i+1]]}')
                      for i, pos in enumerate(positions)]
            for instructions in zip(*chains):
                for instruction in instructions:
                    emit(instruction)

    p2 = [perm[perm[i]] for i in range(16)]
    cycles, seen = [], set()
    for start in range(16):
        if start in seen:
            continue
        cycle, word = [], start
        while word not in seen:
            seen.add(word)
            cycle.append(word)
            word = p2[word]
        assert word == start
        cycles.append(cycle)
    assert len(cycles) == 4 and all(len(c) == 4 for c in cycles)
    emit('mov r11d, 3')
    print('.p2align 5\n.Lfused_pairs:')
    round_body(list(range(16)))
    round_body(perm)
    for i, cycle in enumerate(cycles):
        emit(f'vmovdqa32 ZMMWORD PTR [rsp + {64*i}], zmm{messages[cycle[0]]}')
        for a, b in zip(cycle, cycle[1:]):
            emit(f'vmovdqa32 zmm{messages[a]}, zmm{messages[b]}')
        emit(f'vmovdqa32 zmm{messages[cycle[-1]]}, ZMMWORD PTR [rsp + {64*i}]')
    emit('dec r11d')
    emit('jne .Lfused_pairs')
    round_body(list(range(16)))
    for w in range(8):
        emit(f'vpxord zmm{w}, zmm{w}, zmm{8+w}')
    namespace['output_group'](0, 0)


namespace['emit_fused_parent'] = fused_parent
exec(compile(source, 'pinned_k32_with_parent_phase', 'exec'), namespace)
print('.section .rodata\n.p2align 6\n.Lfused_even:\n.long ' + ', '.join(str(i) for i in list(range(0, 16, 2))*2))
print('.p2align 6\n.Lfused_odd:\n.long ' + ', '.join(str(i) for i in list(range(1, 16, 2))*2))
