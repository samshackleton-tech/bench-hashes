# Extracted ARM collection branch: requested x86 shared-code check

John's #249 request at11:04UTC, November6. Basecb27549095f8498d9c2f14e2a2f2a2d55c1b6144 →46afa808b98c03ee174dda5e6107444a373d1649; bench-hashes currentnext235ee5eb701ce64845b705d2b7cb0240d68eb9e7.

Official `bench-hashes check --fork ... --against ... --new ... --points 'collection git objects,collection Nix files' --layouts4 --keep ...`. Immutable pinned-run manifests; independent per-run targets; runner holds the shared host lock before checkout/build preparation through validation. No lock nested in the script.

|Host|Final check exit|Wall findings|
|---|---:|---|
|EPYC9255|0|No slower. STsoloNix−9.6%, STsologit−4.0%, first4layoutpairs.|
|Xeon6330/IceLake|0|No slower in either stage. STsoloNix−3.7% first4pairs; selected suspects hold in64-pair confirmation.|
|Zen3/AVX2|0|No slower in either stage; no wall speedup established.|

The two named points are2of266; the other264are unmeasured. ST/MT callers and the placements selected by this official command are in its raw records. Do not call this a whole-library release check.

Instruction changes for STsoloNix/git, respectively: EPYC~−3.7/−1.7%; Xeon~−3.8/−1.8%; Zen3~−1.7/−0.8%. These are separate from wall judgments. No package-energy claim from this check.

The official current-next checker automatically ran a64-pair second stage on16fresh layouts on both Xeon andZen3 after the first4pairs named suspects. This was not a minute-long check: it delayed completion materially. The expensive stage was neither hidden nor silently bypassed, and its final outputs are retained. EPYC did not select a second stage. This answers John's exact request, not a proposal to revive broad hourly checking.

All three pinned requests VERIFIED:
- `john-collections-epyc9255-20261106T113923-2e2237d6`
- `john-collections-icelake-20261106T113924-2c14af94`
- `john-collections-zen3-20261106T113925-b4eb30c4`

Raw records: `../john-runs/`; fresh job script/manifests: `../scripts/john-collections-*`. Output identities name exact source commits; all check exits are0, with no load-invalid record relabeled. No claim about ARM performance follows from x86 shared-Rust measurements. John retains Mac/native ARM ownership.

— Sam Shackleton
