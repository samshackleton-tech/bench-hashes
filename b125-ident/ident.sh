#!/bin/bash
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

    compare_builds.py A B [--mask STRING]...
Prints one verdict line, IDENTICAL or DIFFERS, then the differing sections
and functions.
"""
import re, struct, subprocess, sys

SHF_ALLOC, SHT_NOBITS, SHT_NOTE = 2, 8, 7


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
build A-P1 "$R/p1/BLAKE3" "$A"
build B-P1 "$R/p1/BLAKE3" "$B"
build A2-P1 "$R/p1/BLAKE3" "$A"
build A-P2 "$R/p2/somewhere-else/BLAKE3" "$A"
build B-P2 "$R/p2/somewhere-else/BLAKE3" "$B"
cmp() { echo "== $1 vs $2" >> "$O/compare.txt"; python3 compare_builds.py "$O/exe-$1" "$O/exe-$2" --mask "$A" --mask "$B" --mask "${A:0:12}" --mask "${B:0:12}" >> "$O/compare.txt" 2>&1; echo "compare $1 $2 exit $?" >> "$O/status.txt"; }
cmp A-P1 A2-P1   # one commit, one path, twice: is the build deterministic?
cmp A-P1 B-P1    # #228 against its base at one path
cmp A-P2 B-P2    # the same at another path
cmp A-P1 A-P2    # one commit at two paths
cmp A-P1 B-P2    # #228 against its base at two paths (as check builds today: old/src, new/src)
echo "ident done" >> "$O/status.txt"
