#!/bin/bash
# hash_each by blocks (candidate/sam-each-by-blocks): bench-hashes check of the branch's head against
# its base, #246's head 09ef4072, the cells the change touches (check's coverage), bench-hashes 0.20.4 nested.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
export HOME=/root; . /root/.cargo/env
export PATH="$(rustc --print sysroot)/lib/rustlib/x86_64-unknown-linux-gnu/bin:$PATH"
export GIT_AUTHOR_NAME='Sam Shackleton' GIT_COMMITTER_NAME='Sam Shackleton' GIT_AUTHOR_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_COMMITTER_EMAIL='samshackleton-tech@users.noreply.github.com'
{ date -u; uptime; grep -m1 'model name' /proc/cpuinfo; nproc; echo "library $(git -C fork rev-parse HEAD)"; git -C fork status --short; echo "against 09ef407229ced0ee5b501b089bf66dbcfc42a5bf"; echo "bench $(git -C fork/bench rev-parse HEAD)"; } > "$O/provenance.txt"
cd "$R/fork/bench"
cargo build --release > "$O/bench-build.log" 2>&1 || { echo "bench build failed" >> "$O/status.txt"; exit 2; }
./target/release/bench-hashes check --fork "$R/fork" --against 09ef407229ced0ee5b501b089bf66dbcfc42a5bf --keep "$O/samples" > "$O/check.out" 2> "$O/check.err"
rc=$?; echo "check exit $rc" >> "$O/status.txt"
case $rc in 0|1) echo "check verdict" >> "$O/status.txt";; esac
echo "check done" >> "$O/status.txt"
