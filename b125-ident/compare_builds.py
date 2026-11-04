#!/usr/bin/env python3
"""Compare two ELF builds of the bench (bench-hashes #125): every allocated
section but the notes (the build ID), byte for byte, with the given strings
masked (the two sides' commit names, which the bench writes on purpose); and
the functions (nm -S -C, the legacy hash suffix dropped) whose size or bytes
differ.

    compare_builds.py A B [--mask STRING]... [--mask-locations]
Prints one verdict line, IDENTICAL or DIFFERS, then the differing sections
and functions.
"""
import re, struct, subprocess, sys

SHF_ALLOC, SHT_NOBITS, SHT_NOTE = 2, 8, 7
relocs = {}


def sections(path):
    data = open(path, "rb").read()
    assert data[:4] == b"\x7fELF" and data[4] == 2, f"{path}: a 64-bit ELF"
    shoff, = struct.unpack_from("<Q", data, 0x28)
    shentsize, shnum, shstrndx = struct.unpack_from("<HHH", data, 0x3A)
    hdrs = [struct.unpack_from("<IIQQQQIIQQ", data, shoff + i * shentsize) for i in range(shnum)]
    names_off = hdrs[shstrndx][4]
    out = {}
    for name_off, kind, flags, addr, offset, size, *_ in hdrs:
        name = data[names_off + name_off:data.index(b"\0", names_off + name_off)].decode()
        if not flags & SHF_ALLOC or kind == SHT_NOTE:
            continue
        body = b"" if kind == SHT_NOBITS else data[offset:offset + size]
        out[name] = (addr, size, body)
    return out


def relative_relocs(path):
    """R_X86_64_RELATIVE / R_AARCH64_RELATIVE relocations: {offset: addend}
    (a PIE's pointers in read-only data are zero on disk, their targets here)."""
    data = open(path, "rb").read()
    shoff, = struct.unpack_from("<Q", data, 0x28)
    shentsize, shnum, _ = struct.unpack_from("<HHH", data, 0x3A)
    out = {}
    for i in range(shnum):
        _, kind, _, _, offset, size, _, _, _, entsize = struct.unpack_from("<IIQQQQIIQQ", data, shoff + i * shentsize)
        if kind != 4:  # SHT_RELA
            continue
        for j in range(size // 24):
            r_offset, r_info, r_addend = struct.unpack_from("<QQq", data, offset + j * 24)
            if r_info & 0xffffffff in (8, 1027):  # R_X86_64_RELATIVE, R_AARCH64_RELATIVE
                out[r_offset] = r_addend
    return out


def location_lines(path, secs):
    """The addresses of every panic Location's line and column (core::panic::Location:
    a &str of a file name ending in .rs, then line and column, u32 each): where a change
    moves source lines, these alone differ, and the code that runs is the same."""
    rodata = secs.get(".rodata")
    out = []
    if rodata is None:
        return out
    for name, (addr, size, body) in secs.items():
        if not body or name in (".text", ".rodata"):
            continue
        for at in range(addr, addr + size - 23, 8):
            o = at - addr
            ptr = relocs.get(at) or struct.unpack_from("<Q", body, o)[0]
            length, = struct.unpack_from("<Q", body, o + 8)
            if not (rodata[0] <= ptr < rodata[0] + rodata[1]) or not 3 < length < 4096:
                continue
            text = rodata[2][ptr - rodata[0]:ptr - rodata[0] + length]
            if text.endswith(b".rs") and b"\0" not in text:
                out.append((name, o + 16))
    return out


def functions(path, secs):
    nm = subprocess.run(["nm", "-S", "-C", "--defined-only", path], capture_output=True, text=True, check=True).stdout
    text = secs.get(".text")
    out = {}
    for line in nm.splitlines():
        f = line.split(None, 3)
        if len(f) != 4 or f[2] not in ("t", "T"):
            continue
        addr, size, name = int(f[0], 16), int(f[1], 16), re.sub(r"::h[0-9a-f]{16}$", "", f[3])
        body = b""
        if text and text[0] <= addr < text[0] + text[1]:
            body = text[2][addr - text[0]:addr - text[0] + size]
        out.setdefault(name, []).append((size, body))
    return out


def masked(body, masks):
    for m in masks:
        body = body.replace(m, b"0" * len(m))
    return body


def main():
    a, b = sys.argv[1:3]
    masks = [sys.argv[i + 1].encode() for i, x in enumerate(sys.argv) if x == "--mask"]
    sa, sb = sections(a), sections(b)
    # --lines-moved: each side's panic Locations' line and column masked (see location_lines).
    if "--mask-locations" in sys.argv:
        global relocs
        for path, secs in ((a, sa), (b, sb)):
            relocs = relative_relocs(path)
            spots = location_lines(path, secs)
            for name in {n for n, _ in spots}:
                addr, size, body = secs[name]
                body = bytearray(body)
                for n, o in spots:
                    if n == name:
                        body[o:o + 8] = bytes(8)
                secs[name] = (addr, size, bytes(body))
            print(f"{path}: {len(spots)} panic locations' lines masked")
    diff = []
    for name in sorted(set(sa) | set(sb)):
        if name not in sa or name not in sb:
            diff.append(f"section {name}: only in {'A' if name in sa else 'B'}")
            continue
        (aa, za, ba), (ab, zb, bb) = sa[name], sb[name]
        if za != zb:
            diff.append(f"section {name}: {za} bytes against {zb}")
        elif masked(ba, masks) != masked(bb, masks):
            n = sum(1 for x, y in zip(masked(ba, masks), masked(bb, masks)) if x != y)
            diff.append(f"section {name}: {n} of {za} bytes differ")
    fa, fb = functions(a, sa), functions(b, sb)
    sized = sorted(n for n in set(fa) | set(fb) if sorted(s for s, _ in fa.get(n, [])) != sorted(s for s, _ in fb.get(n, [])))
    bytes_ = sorted(n for n in set(fa) & set(fb) if n not in sized and sorted(x for _, x in fa[n]) != sorted(x for _, x in fb[n]))
    print("IDENTICAL" if not diff else "DIFFERS", f"({len(diff)} sections differ; functions: {len(sized)} of other size or only one side, {len(bytes_)} of other bytes, of {len(set(fa) | set(fb))})")
    for d in diff:
        print("  " + d)
    for n in sized[:40]:
        print(f"  size: {n[:160]}: {[s for s, _ in fa.get(n, [])]} against {[s for s, _ in fb.get(n, [])]}")
    for n in bytes_[:40]:
        print(f"  bytes: {n[:160]}")


main()
