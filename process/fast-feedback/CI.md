# The fast checks run first in existing CI

The runner controls and proof-cache tests now run automatically before longer CI work. This closes the handoff from the pinned pilot checks to routine pull-request validation without adding another job matrix.

## Runner controls

Bench-hashes PR [#150](https://github.com/servil-software-factory/bench-hashes/pull/150) head **`6778f98dcfaa24f2fc331a9252f65817f8eb03e7`** adds the existing self-contained command to both Linux jobs, immediately after checkout. The runner implementation remains byte-identical to tested source `50a8f2621c8511463ceafee8738f5908552c44c2`.

GitHub run [42408023095](https://github.com/servil-software-factory/bench-hashes/actions/runs/42408023095) passed the **44 tests and fifteen fault controls** on hosted Linux x86-64 and ARM. Each step took about three seconds by GitHub's step timestamps. The server tests use Linux's `/proc`, so the macOS job keeps its existing benchmark checks and skips this step.

The new artifact upload stores the test and control logs under a separate name. The downloaded artifact digests were checked against GitHub's metadata before extracting their text logs. `ci-runs/bench-hashes/42408023095/` contains both sets of logs, source metadata and the recorded step conclusions. Existing benchmark artifacts retain their layout.

The subsequent request-identity control at head **`c4e57ee2e465a5f9a8b7c272006047bbc65b1702`** also passed automatically on both hosted Linux architectures: **44 tests and sixteen fault controls**. Run [42408880986](https://github.com/servil-software-factory/bench-hashes/actions/runs/42408880986) and its downloaded logs are in `ci-runs/bench-hashes/42408880986/`.

## Proof-cache identity

BLAKE3 PR [#290](https://github.com/servil-software-factory/BLAKE3/pull/290) head **`2cbea238af01a79a5f7cb68adb5a04eeb8f516ab`** adds its three focused cache-key tests immediately after checkout in the existing formatting/tool-controls job. Its functional correction and tests remain those checked at source `349bc152064388de20fd5ff6bcaea1e668d952d6`.

GitHub run [42408024141](https://github.com/servil-software-factory/BLAKE3/actions/runs/42408024141) passed the new step. `ci-runs/BLAKE3/42408024141/steps.json` records its source and conclusion. `PROOF-CACHE.md` retains the pinned Ice Lake/ARM runs and the original-key negative control.

## Integration

John rebased and fast-forwarded the ten runner commits onto `next`, ending at **`0b9ccc2f9cfc783700a62e8943237527f0c64e47`**, and closed #150/#148/#149. The runner files match tested C4 byte for byte. John independently reproduced 44 tests and sixteen controls on ARM alongside the benchmark’s 137 tests; Devon reproduced the runner and empty-HOME checks on x86. The proof-cache correction #290 remains open for review.

## Evidence publication

Fourteen pushes to this evidence branch triggered **42 hosted Rust jobs**, occupying **8,710 aggregate job-wall seconds (145.2 job-minutes)**. [The recorded workflow/job metadata](evidence-ci-audit.json) names every run and source. The branch changed process evidence and standalone runner tooling; benchmark source and dependencies stayed unchanged, and this branch’s old Rust workflow exercised neither addition.

The workflow now excludes push events for exactly `process/sam-fast-feedback`. Pull-request and manual events retain the full matrix; source branches’ workflows are unchanged. This uses GitHub’s existing branch filter, independent of file-count limits. Publication still checks remote paths, modes, blob hashes, sizes and selected exact bytes. The superseded runner copy was removed from the evidence branch; immutable historical source commits remain linked from the reports.

The YAML parse and unchanged job definitions are checked locally. The next publication will also check that its new head starts no automatic workflow. No new Rust build is needed for this branch-only trigger change: the job code and benchmark inputs are unchanged.

— Sam Shackleton
