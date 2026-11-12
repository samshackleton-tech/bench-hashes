#!/bin/bash
# The contracts experiment (BLAKE3 #361) as a third party would check it, from nothing, on Linux:
# install Lean, then in tools/verify/machine/lang run the two pipelines from the source (the kernel
# hex; merge with its contract), the join to the specification, and the audit of merge's proof.
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";export HOME=/root;. <home>/.cargo/env
export ELAN_HOME="$R/elan"; export PATH="$ELAN_HOME/bin:$PATH"
cd "$R/library"; { echo "library $(git rev-parse HEAD)"; nproc; uname -m; grep -m1 'model name' /proc/cpuinfo || true; cc --version | head -n 1; llvm-objdump --version | head -n 2; } > "$O/identity.txt"
: > "$O/steps.txt"
step() { local n="$1"; shift; local s=$(date +%s.%N); local rc=0; "$@" > "$O/$n.log" 2>&1 < /dev/null || rc=$?; echo "$n rc=$rc $(python3 -c "import sys,time; print(round(time.time()-float(sys.argv[1]),1))" "$s") s" >> "$O/steps.txt"; }
step elan sh -c 'curl -sSf https://elan.lean-lang.org/elan-init.sh | sh -s -- -y --default-toolchain none --no-modify-path'
cd tools/verify/machine/lang
step toolchain sh -c 'lake --version'
step one sh -c 'cd ../one && lake build'
step hex sh -c 'MUTANTS=0 ./prove.sh'
step merge sh -c './prove_fn.sh'
step merge-again sh -c './prove_fn.sh'
step push sh -c './prove_fn.sh push 0x70000'
step swap sh -c './swap.sh'
step steps-fn sh -c './prove_fn.sh merge_steps 0xA0000'
cp merge.build.log "$O/merge.build.log" 2>/dev/null || true
step reading sh -c 'printf "import ReadingList\nimport Checked_merge\nimport Meets_hex\n#reading_list Checked_merge.merge_checked_meets\n#reading_list hex_meets\n#print axioms hex_meets\n" > rl.lean && lake build ReadingList && lake env lean rl.lean'
cp Proof_merge.lean "$O/Proof_merge.lean"; git diff --stat > "$O/diff-after.txt" || true
step audit sh -c "python3 mutants_fn.py ${JOBS:-6}"
step any sh -c 'lake build Meets_push_bytes Meets_hex_bytes Meets_merge_bytes UsableBytes 2>&1 | grep -E "error|sorry|_bytes. depends on axioms|Build completed"'
step hexaudit sh -c "python3 mutants_hex.py --jobs ${JOBS:-6}"
step codeaudit sh -c "python3 mutants_code.py push ${JOBS:-6} && python3 mutants_code.py add ${JOBS:-6} && python3 mutants_code.py merge_steps ${JOBS:-6}"
cat "$O/steps.txt"; grep "rejected" "$O/audit.log" "$O/hexaudit.log" | tail -n 4
head -n 3 "$O/reading.log" | cut -c1-160 > "$O/theorems.txt" || true
if grep -v -q 'rc=0' "$O/steps.txt"; then echo "FAILED steps: $(grep -v 'rc=0' "$O/steps.txt" | cut -d' ' -f1 | tr '\n' ' ')" > "$O/status.txt"; exit 1; fi
grep -q "the compiler's proof of merge: checked" "$O/merge.log" && grep -q "push_meets_bytes. depends on axioms" "$O/any.log" && grep -q "hex_meets_bytes. depends on axioms" "$O/any.log" && grep -q "merge_meets_bytes. depends on axioms" "$O/any.log" && grep -q "add_meets_bytes. depends on axioms" "$O/any.log" && grep -q "usable_bytes. depends on axioms" "$O/any.log" && ! grep -q -E "error|sorry" "$O/any.log" && grep -q "the compiler's proof of push: checked" "$O/push.log" && grep -q "add with merge_sse behind Merge.contract in place of merge: checked" "$O/swap.log" && grep -q "the compiler's proof of hex: checked" "$O/hex.log" && grep -q "changed clauses: 35 rejected$" "$O/audit.log" && grep -q "false statements: 11 rejected$" "$O/hexaudit.log" && grep -q "changed instructions: 10 rejected$" "$O/hexaudit.log" && grep -q "^push: 26 instructions, each in turn made a no-op: 26 rejected" "$O/codeaudit.log" && grep -q "^add: 32 instructions, each in turn made a no-op: 2 ACCEPTED, 30 rejected" "$O/codeaudit.log" && grep -q "^merge_steps: 38 instructions, each in turn made a no-op: 38 rejected" "$O/codeaudit.log" && grep -q "the compiler's proof of merge_steps: checked" "$O/steps-fn.log" && head -n 1 "$O/audit.log" | grep -q "control: ACCEPTED" && echo "contract-skeptic done" > "$O/status.txt"
