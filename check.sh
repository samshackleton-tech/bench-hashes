#!/bin/bash
# The integer-register chunk root on AMD from Zen 5 (candidate/sam-gpr-root-amd): bench-hashes check of
# the branch's head against servil a2651d64, the cells the change touches (check's coverage), bench-hashes 0.20.4 nested.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
export PATH="$(rustc --print sysroot)/lib/rustlib/x86_64-unknown-linux-gnu/bin:$PATH"
export GIT_AUTHOR_NAME='Sam Shackleton' GIT_COMMITTER_NAME='Sam Shackleton' GIT_AUTHOR_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_COMMITTER_EMAIL='samshackleton-tech@users.noreply.github.com'
{ date -u; uptime; grep -m1 'model name' /proc/cpuinfo; nproc; echo "library $(git -C fork rev-parse HEAD)"; git -C fork status --short; echo "against a2651d64d4886807205c07e7c14aecf289d41df2"; echo "bench $(git -C fork/bench rev-parse HEAD)"; } > "$O/provenance.txt"
cd "$R/fork/bench"
cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
./target/release/bench-hashes check --fork "$R/fork" --against a2651d64d4886807205c07e7c14aecf289d41df2 --keep "$O/samples" > "$O/check.out" 2> "$O/check.err"
rc=$?; echo "check exit $rc" >> "$O/status.txt"
case $rc in 0|1) echo "check verdict" >> "$O/status.txt";; esac
echo "check done" >> "$O/status.txt"
