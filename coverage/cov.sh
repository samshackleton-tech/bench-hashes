#!/bin/bash
# BLAKE3-Servil test coverage on this machine (run cov): cargo llvm-cov over the library's and the
# integration tests (features serde,zeroize; nextest, as the mutation runs), at the manifest's servil.
# Outputs: the per-file summary, the per-function JSON export, and every uncovered line (text report).
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R/fork"
export HOME=/root; . /root/.cargo/env
{ uname -m; nproc; grep -m1 -E 'model name' /proc/cpuinfo || lscpu | grep -m1 'Model name'; grep -o -w -E 'avx512f|avx2|sha3|sme2' /proc/cpuinfo | sort -u | tr '\n' ' '; echo; rustc --version; echo "fork $(git rev-parse HEAD)"; } > "$O/machine.txt" 2>&1
rustup component add llvm-tools > "$O/llvm-tools.log" 2>&1
cargo llvm-cov --version > /dev/null 2>&1 || cargo install cargo-llvm-cov --locked > "$O/install.log" 2>&1
cargo llvm-cov --version >> "$O/machine.txt" 2>&1
export BLAKE3_EMULATED=1  # pool_fairness (#230's skip): a timing test, not coverage's to run under instrumentation
cargo llvm-cov nextest --features serde,zeroize --lib --tests --no-fail-fast --summary-only > "$O/summary.txt" 2> "$O/run.err"; echo "cov exit $?" >> "$O/status.txt"
cargo llvm-cov report --json > "$O/cov.json" 2>> "$O/run.err"; echo "json exit $?" >> "$O/status.txt"
cargo llvm-cov report --text > "$O/cov.txt" 2>> "$O/run.err"; echo "text exit $?" >> "$O/status.txt"
gzip -f "$O/cov.json" "$O/cov.txt"
echo "cov done" >> "$O/status.txt"
