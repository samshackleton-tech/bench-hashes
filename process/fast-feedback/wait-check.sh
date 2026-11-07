#!/bin/bash
set -euo pipefail
R="$1"
bash "$R/tools/tools/pinned-run/verify-clean-home.sh" "$R"
if [[ ${PINNED_RUN_PREFLIGHT:-0} == 1 ]]; then
    printf 'pinned-run preflight complete\n' > "$R/out/preflight.txt"
fi
