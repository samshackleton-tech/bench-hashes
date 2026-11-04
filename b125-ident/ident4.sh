#!/bin/bash
# bench-hashes #125, controls (run b125-ident4): as b125-ident3, at one path P1 alone, A, B, and three
# patched copies of A committed in P1 (each commit masked): C, a real change on x86-64's path
# (MIN_SPLIT_LEN 512 KiB -> 256 KiB); D, an AArch64-only change (PREFETCH_BELOW 64 -> 32 KiB, compiled
# out on x86-64); E, three comment lines added at lanes.rs's head (lines move, code doesn't). Each pair
# compared without and with --mask-locations (panic Locations' lines). (b125-ident3's head:)
# bench-hashes #125: does a build of the bench against two commits of BLAKE3-Servil that change
# nothing it runs come out identical, when both build from the same path? (run b125-ident)
# The bench (main) is built once; then `bench-hashes build-against` with CARGO_TARGET_DIR=$R/t
# (wiped before each build) against: A (#228's base 759a1f44) at path P1, B (#228 merged, 53cf44cc)
# at P1, A again at P1, A at P2, B at P2; each checkout made by `git checkout` in a worktree at its
# path. (b125-ident2: the executable from build-against's output; b125-ident copied a path it
# doesn't build to.) compare_builds.py (inline): every allocated section but the notes, with both commits masked.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
. /root/.cargo/env
A=$(git -C fork rev-parse HEAD); B=$(git -C forkb rev-parse HEAD)
{ grep -m1 'model name' /proc/cpuinfo; rustc --version; echo "bench $(git -C bench rev-parse HEAD)"; echo "A $A"; echo "B $B"; } > "$O/machine.txt"
cat > compare_builds.py <<'PY_CMP_END'
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
PY_CMP_END
(cd bench && cargo build --release) > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
BH="$R/bench/target/release/bench-hashes"
git -C forkb fetch -q "$R/fork" "$A" 2>/dev/null || true
build() { # name path commit
  local name=$1 path=$2 commit=$3
  rm -rf "$R/t"
  [ -d "$path" ] || git -C "$R/forkb" worktree add -q --detach "$path" "$commit"
  git -C "$path" checkout -q --detach "$commit" && git -C "$path" status --porcelain --untracked-files=no > "$O/tree-$name.txt"
  (cd "$R/bench" && CARGO_TARGET_DIR="$R/t" "$BH" build-against "$path") > "$O/build-$name.out" 2> "$O/build-$name.err"
  echo "build $name exit $?" >> "$O/status.txt"
  # build-against prints its executable (with CARGO_TARGET_DIR: under t/bench-hashes-build/<the path's hash>/).
  cp "$(tail -n 1 "$O/build-$name.out")" "$O/exe-$name"
  "$O/exe-$name" provenance >> "$O/provenance.txt" 2>&1
}
git -C forkb cat-file -e "$A^{commit}" || git -C forkb fetch -q https://github.com/johnservil/BLAKE3 "$A"
patched() { # name subst-file old new
  local name=$1 file=$2 old=$3 new=$4 P="$R/p1/BLAKE3"
  git -C "$P" checkout -q --detach "$A"
  python3 - "$P/$file" "$old" "$new" <<'PY_SUB_END' || { echo "patch $name failed" >> "$O/status.txt"; exit 2; }
import sys
p, old, new = sys.argv[1:4]
s = open(p).read()
assert s.count(old) == 1, (p, old)
open(p, "w").write(s.replace(old, new.replace("\\n", "\n")))
PY_SUB_END
  git -C "$P" -c user.name=job -c user.email=job@localhost -c core.hooksPath=/dev/null commit -qam "job: $name"
  local C=$(git -C "$P" rev-parse HEAD); echo "$name $C" >> "$O/machine.txt"; MASKS+=" --mask $C --mask ${C:0:12}"
  build $name "$P" "$C"
}
MASKS="--mask $A --mask $B --mask ${A:0:12} --mask ${B:0:12}"
build A "$R/p1/BLAKE3" "$A"
build B "$R/p1/BLAKE3" "$B"
patched C src/lanes.rs "pub(crate) const MIN_SPLIT_LEN: usize = 512 * 1024;" "pub(crate) const MIN_SPLIT_LEN: usize = 256 * 1024;"
patched D src/lib.rs "const PREFETCH_BELOW: usize = 64 * 1024;" "const PREFETCH_BELOW: usize = 32 * 1024;"
E_OLD=$(head -n 1 "$R/fork/src/lanes.rs")
patched E src/lanes.rs "$E_OLD" "$E_OLD\\n// job E: a comment line\\n// and another\\n// and a third"
cmp() { for m in "" "--mask-locations"; do echo "== $1 vs $2 $m" >> "$O/compare.txt"; python3 compare_builds.py "$O/exe-$1" "$O/exe-$2" $MASKS $m >> "$O/compare.txt" 2>&1; echo "compare $1 $2 $m exit $?" >> "$O/status.txt"; done; }
cmp A B   # #228 against its base
cmp A C   # a real change on this machine's path
cmp A D   # a change compiled out here
cmp A E   # lines moved, no code changed
git -C "$R/p1/BLAKE3" diff "$A" HEAD > "$O/patch-E.diff"
echo "ident4 done" >> "$O/status.txt"
