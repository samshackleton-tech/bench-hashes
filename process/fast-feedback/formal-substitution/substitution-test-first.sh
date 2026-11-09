#!/bin/bash
set -euo pipefail
exec timeout -k 5s 120s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1";mkdir -p "$R/out"
cd "$R/library/tools/verify"
{ echo "library $(git rev-parse HEAD)";python3 --version;python3 -c 'import z3; print("Z3",z3.get_full_version())'; } > "$R/out/identity.txt"
python3 -m unittest test_helpers.SpecificationTests.test_all_outputs_preserve_simultaneous_bindings -v > "$R/out/positive-bindings.log" 2>&1
set +e
python3 -m unittest test_helpers.SpecificationTests.test_one_substitution_traverses_all_output_roots -v > "$R/out/desired-red.log" 2>&1
status=$?
set -e
test "$status" = 1
grep -q '16 != 1 : one traversal of the shared compression graph' "$R/out/desired-red.log"
test -z "$(git status --porcelain)"
printf 'all sixteen output bindings pass; current sixteen-traversal implementation rejected\n' > "$R/out/status.txt"
JOB
