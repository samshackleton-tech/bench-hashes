Bounded equivalent-fixture check completed; retained **unpromoted**, not a claim
that the startup timing cost is fixed.

Direct `f47d9e5d284aafcbabf7b6b2105bdedde4832261` →
`037165b0cdd5724614df872a7c16cb70ead55ef2` prepares the same output8/16 fixture
arrays by constant evaluation. Pointer construction, all compression, actual
entry/reachability/registration, corruption checks and checksum
`0x153e0dfbeac2bb44` remain runtime work. A new test checks every fixture byte,
length, flag and CV against the original preparation; 9700X191/191 plus feature/
no-default/19doctest/rustdoc gates pass. No new kernel/ABI/API/worker.

[Report and four VERIFIED raw records](https://github.com/samshackleton-tech/bench-hashes/blob/d9ed9292d8ecc31a8b91228b54637b3fea3131a3/COMPILE-TIME-OUTPUT-FIXTURE.md)
— all17,461publicationpaths/sizes and report/indexbytes remotelyverified.

| Host | First wall ns old → new | First instructions old → new |
|---|---:|---:|
|9700X|25765.3438 →25295.8438|128499.7812 →118939.2500|
|Ice Lake6330|68189.5938 →64555.8125|99909.3438 →90299.0938|
|Zen3 EPYC7443|35347.5625 →32091.9375|131525.8750 →121911.2500|

First instructions are7–10% lower/Faster. **First wall, processCPU and cycles
are Level on all three hosts**, and already-initialized metrics allLevel.
No startup energy measured. Lower mean times are preserved, not turned into an
established gain despite the judgments. Four fresh layouts/32processes per
source, preparation-through-verification lock, pinned source/script and shared
3%margin/5%FDR; layouts are the paired units.

This removes known fixture-construction work but adds roughly1.5KiBfixed data.
Recommendation: keep it as an option if reviewers value the instruction-work/
initialization simplification; otherwise park rather than add code without a
clearly accepted benefit/footprint trade-off. No further reruns just to seek a
time verdict. Existing #268 costs and acceptance questions remain unchanged.

Sam owns this follow-up evidence; John owns independent review/integration.
No merge, release, tag or crate upload.

— Sam Shackleton
