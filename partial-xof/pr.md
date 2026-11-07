## Reuse the current partial XOF block across sequential short reads

Retain one64-byte block and a validity bit in `OutputReader`. Repeated short
`fill`/`Read::read` calls reuse the remaining bytes instead of recompressing the
same block. Whole blocks keep the existing vectorized path; seeking invalidates
the cache; clones copy position/cache; explicit zeroization wipes inactive bytes
as well. Returning when a partial head consumes the request avoids a zero-length
`xof_many` call.

Frozen head **`762b0227939e60a0f2d4f3da5cfc8742d8c01697`**;
direct measured baseline **`f47d9e5d284aafcbabf7b6b2105bdedde4832261`** (#278).
Independent of #281/#283. No source gains composed.

[Full report, controls, costs and raw data](https://github.com/samshackleton-tech/bench-hashes/blob/034790cde31f08d3189ac898b687d6be708d171e/PARTIAL-XOF-CACHE.md)
—30retainedruns,28VERIFIED/2FAILEDprobecompileattempts; all18,519publicationpaths/
sizes and report/index/inventorybytes remotelyverified.

### Complete convenience call, not just a finishing kernel

64-byte input,4KiBoutput extracted one byte at a time. **Input hashing, reader
construction and every read are inside** `convenience::hash_xof` operation timing;
allocations/reference outside:

| Host | Wall ns old → new | Package nJ old → new |
|---|---:|---:|
|9700X|192147.3500 →15504.7638|9793196.5743 →853557.0476|
|EPYC9255|241598.1381 →18147.4145|16755540.0292 →1334311.0518|
|Ice Lake6330|374602.7250 →45574.7318|33304002.5481 →4083062.9680|
|Zen3 EPYC7443|218445.1082 →27988.7129|14055824.2788 →1897092.4627|

**7.8–13.3× faster in these short-read calls**,CPU/instructions/energy down too.
Not a generic canonical-hash or long-vectorized-XOF bandwidth claim. RAPL is the
whole package including idle/background; CPU/wall/cycles/instructions separate.
The old repeated-compression behavior was documented already; this is a measured
change to that trade-off, not claiming discovery of it.

Primary96shapes/op/host:1/64readers,input64B/16KiB,output4096B,
read1/7/16/32/63/64/65/1024B,3modes. Ready read, prepared-Hasher construct/read and
complete convenience call measured separately. Everyhost/operationwall72F24L0S;
64/1024Bwhole-block controlsLevel. Constructor/copy/seekcontrols24shapes×8ops:
constructor/first32/conveniencefirst32wallLevelorFaster; clone/read32everycellFaster.
Current-headA/A**4800metricsallLevel** acrossprimary/constructor instruments.

Existingclocksafter1msidle/busyworkconveniencecontrols:first32/full64alljudgments
Level;4096one-bytereadall24wallcells/hostFasteronEPYC/Zen3. CPU/energyNAingap
cohort, no attribution from elapsed intervals. LargeLevelmeans retained too:
EPYCbusy/full64mean453→577ns,Zen3busy/first32mean728→783ns,not proof of zero cost.

Alltiminghash-pinned/preparation-locked,fourfreshsource/targetbuilds/layouts,
adjacentalternatingorder,clocks3%practicalmargin/5%FDR. Nativeownership/stride
logged; no concurrentfalse-sharing/cache/aliascauseinferredfromtimings.

### Smallest mechanism and explicit costs

**No new API/type/kernel/assembly/ABI/worker/clock or production unsafe code.**
Two private fields retain one output block. NativeReader **192→256B,align64**
(actualmeasurement,notassumedsourceorder); Hasherstorageunchanged. This state
and copy footprint must earn its place. No speculative future block computation.

**[Sam-owned follow-up #284](https://github.com/servil-software-factory/BLAKE3/issues/284)**
has exactsource/reproduction/rawcosts,head-returnmitigation and boundednextwork:

- Ice:fourpartial-clonebatchwallcells+4.6–8.0%,~0.43–0.75ns/copy,14Slower
  wall/CPU/cycle/package metrics.
- Zen3:four empty-clonebatchwallcells+3.2–7.9%,~0.19–0.45ns,onepartial+5.3%,
  ~0.30ns;17Slowerclonemetrics.
- Zen3:oneconstructor-onlypackage1546.5593→1604.7252nJ,+3.8%,wallLevel.
- Ice:onepreparedconstruct/readwhole64Bchunkcontrolpackage505393.5607→522949.3637nJ,
  +3.5%,wall/CPULevel.

These are retained costs, not called false positives or automatically vetoed.
Matching clone/read32 is Faster everywhere; ordinaryfirst32/whole-block wall
controlsremainLevel. My recommendation is to weigh each phase with the complete
workload and memory footprint. **Acceptance remains pending**, not inferred from
earlier praise or overnight authorization.

The initialcache-onlysource911c4026hadZen3seek/read32~3.4–3.6%costs. The selected
partial-headreturn removes the zero-length output call; currentseekwallcontrols
LevelorFaster. Earliercosts/sourcepreserved,separatefromcurrentcomparison.

### Correctness and actual work protection

Exacthead191/191tests each4x86,164/164ARMVM; serde/zeroize/no-default/19docs/
warnings-deniedrustdocall5. ExistingRootBlockactualcounterguardnowrequiresa
cachedheadcomputenone,newtailone. Newtestscover33one-bytereads/emptyfills,clone
independence,seeksacrosscounters,3modes,everyplatform,independentofficialbytes.
Zeroizewipesinactivecachebytes; Debugstillonlyposition.

Pinnednegativecontrolforcescachemisses. Independentgoldenbytetestsstillpass,
thenworkguardfails **“the rest of that block is cached”**. Expectedfailurecontrol
VERIFIED,nottimingassertion. TwoFAILEDgap-probecompileattempts(E0596)retained,
notlibraryfailuresortimingevidence;correctedprobeownsoutputseparately.

NoASM/generator/proofmodel/harness/buildbyteschange. Existingfull-roundstandard
BLAKE3compression/ABI/memorycontractsremain; new safeRustcacheStateMachineis
nativelytested,notclaimedasanewformalRustproof. Modes/counters/flags/XOFbytes
andRead/Seek/Clonesemanticsunchanged.

### Integration / API migration boundary

Targets`servil` with measured#278ancestry,butthisprivateOutputReaderoptimization
has no dependency on the newSIMDadditions and may integrate independently. Earlier
reviewheadsremainfrozen. The#267/#279publiccontract/name/hintmigrationisJohn's;
no new publicsurfaceorstreamenginedesignhere. BothconvenienceandHasher-produced
readersusethe sameexistingtype. Migrationcallers/tests/sourcesmustmove together.

John Servil: independentdesign/cost/migration-fitreviewandintegration. Sam
Shackleton: implementation/evidenceand#284follow-up. Devon Jonte: peer/Intelreview.
No merge,tag,releaseorcrateupload authorizedorperformed.

— Sam Shackleton
