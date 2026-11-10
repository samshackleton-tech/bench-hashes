#!/bin/bash
set -euo pipefail
exec timeout -k 15s 540s bash -s -- "$1" <<'MUTATION_BUDGET_BASELINE'
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";. <home>/.cargo/env
export CARGO_TARGET_DIR="$R/target"
# The mutator's retained shard directory follows tempfile.gettempdir(). A
# run owns its own namespace; a different pinned checkout must never inherit
# /tmp shards belonging to a different Git mirror or contaminate 'fresh'.
export TMPDIR="$R/mutation-tmp"
mkdir -p "$TMPDIR"
# Unit controls create private commits; their author is explicit rather than
# depending on a host-global Git identity. No host configuration is changed.
export GIT_AUTHOR_NAME='Sam Shackleton' GIT_COMMITTER_NAME='Sam Shackleton'
export GIT_AUTHOR_EMAIL='samshackleton-tech@users.noreply.github.com' GIT_COMMITTER_EMAIL='samshackleton-tech@users.noreply.github.com'
# The comparison base is a separately pinned input, never guessed from a
# candidate's immediate parent (a tooling-only carrier can have that parent).
BASE=$(git -C "$R/baseline" rev-parse HEAD)
git -C "$R/library" merge-base --is-ancestor "$BASE" HEAD
{ for repo in library baseline mutator bench;do echo "$repo $(git -C "$R/$repo" rev-parse HEAD)";done;echo "mutation_baseline $BASE";rustc -Vv;cargo -V;uname -a;lscpu; } > "$O/identity.txt"
test "$BASE" = "$(git -C "$R/baseline" rev-parse HEAD)"
cd "$R/library"
CARGO_TARGET_DIR="$R/mutator-target" cargo install --locked --path "$R/mutator" --root "$R/mutator-install" > "$O/install-mutator.log" 2>&1
export PATH="$R/mutator-install/bin:$PATH"
test "$(cargo mutants --version)" = 'cargo-mutants 27.1.0'
CARGO_TARGET_DIR="$R/b3sum-target" cargo install --locked --version '=1.8.7' b3sum --root "$R/target/b3sum-official-1.8.7" > "$O/install-b3sum.log" 2>&1
export MUTANTS_B3SUM="$R/target/b3sum-official-1.8.7/bin/b3sum"
cargo fetch > "$O/fetch.log" 2>&1
python3 -m unittest discover -s tools/mutants -p 'test_*.py' > "$O/tool-tests.log" 2>&1
mkdir -p "$R/clock/src"
printf '[package]\nname="mutation-clock"\nversion="0.1.0"\nedition="2021"\n[dependencies]\nclocks={path="%s/bench/clocks"}\n' "$R" > "$R/clock/Cargo.toml"
cat > "$R/clock/src/main.rs" <<'MUTATION_CLOCK_RUST'
use std::{fs::File, process::{Command, Stdio}};
unsafe extern "C" {
    fn prctl(option: i32, a2: usize, a3: usize, a4: usize, a5: usize) -> i32;
    fn waitpid(pid: i32, status: *mut i32, options: i32) -> i32;
}
fn drain_children() -> Vec<(i32, i32)> {
    let mut reaped = Vec::new();
    loop {
        let mut status = 0;
        let pid = unsafe { waitpid(-1, &mut status, 0) };
        if pid > 0 { reaped.push((pid, status)); continue; }
        let error = std::io::Error::last_os_error();
        if error.kind() == std::io::ErrorKind::Interrupted { continue; }
        assert_eq!(error.raw_os_error(), Some(10), "waitpid must end at ECHILD");
        return reaped;
    }
}
fn main() {
    let a: Vec<_> = std::env::args().skip(1).collect();
    assert!(a.len() >= 4);
    // Nextest's immediate fail-fast can terminate a shell before its helpers.
    // Keep such descendants in this measuring tree, rather than PID 1's tree.
    assert_eq!(unsafe { prctl(36, 1, 0, 0, 0) }, 0);
    let control = Command::new("python3").args(["-c", "import subprocess; p=subprocess.Popen(['sleep','0.05'],stdout=subprocess.DEVNULL,stderr=subprocess.DEVNULL); print(p.pid)"]).output().unwrap();
    assert!(control.status.success());
    let pid: i32 = String::from_utf8(control.stdout).unwrap().trim().parse().unwrap();
    let status = std::fs::read_to_string(format!("/proc/{pid}/status")).unwrap();
    assert!(status.lines().any(|line| line == format!("PPid:\t{}", std::process::id())));
    assert_eq!(drain_children(), vec![(pid, 0)]);
    println!("measurement_control adopted_sleeping_child=true reaped_child=true");
    clocks::load::tick();
    if let Err(reason) = clocks::load::quiet_for(1) { eprintln!("mutation study abstained: {reason}"); std::process::exit(2); }
    clocks::load::tick();
    let mut c = Command::new(&a[3]);
    c.args(&a[4..]).current_dir(&a[2]).stdout(Stdio::from(File::create(&a[0]).unwrap())).stderr(Stdio::from(File::create(&a[1]).unwrap()));
    let start = clocks::now();
    let r = clocks::child::run(&mut c);
    let reaped = drain_children();
    let complete_wall_ns = clocks::since_ns(start);
    clocks::load::tick();
    let windows = clocks::load::windows();
    assert!(!windows.is_empty());
    eprintln!("load: {}", clocks::load::describe(&windows));
    for w in &windows { eprintln!("window {} {} {} {}", w.start_ns, w.end_ns, w.other_milli_cpus, w.steal_milli_cpus); }
    println!("complete_wall_ns={} primary_command_wall_ns={} primary_wait4_cpu_ns={:?} primary_wait4_max_process_rss_bytes={:?} primary_wait4_storage_read_bytes={:?} primary_wait4_major_faults={:?} success={} adopted_children={:?} all_descendant_cpu_ns=NA process_tree_cycles=NA process_tree_instructions=NA energy=NA", complete_wall_ns, r.wall_ns, r.cpu_ns, r.max_rss_bytes, r.storage_read_bytes, r.major_faults, r.success, reaped);
    if !r.success { eprintln!("mutation payload failed"); std::process::exit(1); }
    if windows.iter().any(|w| w.busy()) { std::process::exit(2); }
}
MUTATION_CLOCK_RUST
CARGO_TARGET_DIR="$R/clock-target" cargo build --release --manifest-path "$R/clock/Cargo.toml" > "$O/build-clock.log" 2>&1
# The collector is not a source edit or a timing implementation: preserve each
# execution before the tool overwrites its normal tmp/mutants-last outputs.
cat > "$R/collect.py" <<'MUTATION_COLLECT_PY'
from pathlib import Path
import hashlib,json,os,shutil,subprocess,sys
r=Path(sys.argv[1]);label=sys.argv[2];o=r/'out';lib=r/'library';dest=o/label;dest.mkdir()
source=lib/'tmp/mutants-last'
if source.exists():shutil.copytree(source,dest/'mutants-last')
worktrees=subprocess.check_output(['git','-C',str(lib),'worktree','list','--porcelain'],text=True)
(dest/'worktrees.txt').write_text(worktrees)
entries=[]
for line in worktrees.splitlines():
 if line.startswith('worktree '):
  path=Path(line[9:]);p=path/'src/lib.rs'
  if p.exists():
   s=p.stat();entries.append(dict(path=str(path),lib_inode=s.st_ino,lib_mtime_ns=s.st_mtime_ns,lib_sha256=hashlib.sha256(p.read_bytes()).hexdigest()))
(dest/'worktree-files.json').write_text(json.dumps(entries,indent=2)+'\n')
(dest/'source-status.txt').write_text(subprocess.check_output(['git','-C',str(lib),'status','--porcelain','--untracked-files=no'],text=True))
if (lib/'Cargo.lock').exists():shutil.copy2(lib/'Cargo.lock',dest/'Cargo.lock')
for p in (r/'target/mutants').glob('model-only-targets.*'):shutil.copy2(p,dest/p.name)
MUTATION_COLLECT_PY
cat > "$R/old-rule.py" <<'MUTATION_OLD_RULE_PY'
# Side "old": this same checkout with the shard limit the tool had before the
# change (SHARDS on every machine). Nothing else differs from check.py.
import sys
sys.argv=['tools/mutants/check.py',*sys.argv[1:]]
sys.path.insert(0,'tools/mutants')
import check
check.wide_shards=lambda cpus,memory:check.SHARDS
check.main()
MUTATION_OLD_RULE_PY
ID="${R##*-}"
LABELS=''
side() {
 # One measured or preparing execution in its own cgroup-v2 leaf: cpu.stat
 # counts every descendant, the tests nextest ended and orphaned included.
 local label="$1"; shift
 local cg="/sys/fs/cgroup/mb-$ID-$label"
 mkdir "$cg"
 git status --porcelain --untracked-files=no > "$O/$label-before-status.txt"
 set +e
 bash -c 'echo $$ > "$1/cgroup.procs" || exit 97; shift; exec "$@"' sh "$cg" "$R/clock-target/release/mutation-clock" "$O/$label.log" "$O/$label.stderr" "$R/library" bash -c '"$@"; result=$?; printf "%s\n" "$result" > "$0"; exit "$result"' "$O/$label-exit.txt" "$@" > "$O/$label-process.txt" 2> "$O/$label-load.txt"
 local s=$?
 set -e
 echo "$s" > "$O/$label-clock-exit.txt"
 cat "$cg/cpu.stat" > "$O/$label-cgroup-cpu.txt"
 cat "$cg/cgroup.procs" > "$O/$label-cgroup-left.txt"
 if [ -f "$cg/memory.peak" ];then cat "$cg/memory.peak" > "$O/$label-cgroup-memory-peak.txt";fi
 test ! -s "$O/$label-cgroup-left.txt"
 rmdir "$cg"
 python3 "$R/collect.py" "$R" "$label"
 # A failed or busy execution is retained and stops this job; never repeated
 # inside it until an outcome appears.
 test "$s" = 0
 git diff --exit-code -- src c build.rs Cargo.toml > "$O/$label-runtime-diff.txt"
 LABELS="$LABELS $label"
}
PAIRS='1 2'
for p in $PAIRS;do
 # A fresh private layout for each pair: its own worktrees and builds.
 export TMPDIR="$R/layout-$p/tmp" CARGO_TARGET_DIR="$R/layout-$p/target"
 mkdir -p "$TMPDIR" "$CARGO_TARGET_DIR"
 cp -a "$R/target/b3sum-official-1.8.7" "$CARGO_TARGET_DIR/"
 side "p$p-prepare" python3 tools/mutants/check.py --since "$BASE"
 if [ $((p % 2)) = 1 ];then order='old new';else order='new old';fi
 printf '%s %s\n' "$p" "$order" >> "$O/order.txt"
 for which in $order;do
  if [ "$which" = old ];then side "p$p-old" python3 "$R/old-rule.py" --since "$BASE"
  else side "p$p-new" python3 tools/mutants/check.py --since "$BASE";fi
 done
done
python3 - "$R" $LABELS <<'MUTATION_CHECK_PY'
from pathlib import Path
import json,sys
r=Path(sys.argv[1]);o=r/'out';rows={};test_commands={};labels=sys.argv[2:]
for label in labels:
 outcomes={};selected={}
 for p in(o/label/'mutants-last').rglob('outcomes.json'):
  for x in json.loads(p.read_text())['outcomes']:
   if isinstance(x['scenario'],dict):
    name=x['scenario']['Mutant']['name'];assert name not in outcomes;outcomes[name]=x['summary']
    selected[name]=[ph['argv']for ph in x['phase_results']if ph['phase']=='Test']
 rows[label]=outcomes;test_commands[label]=selected
first=labels[0];assert rows[first]
for label in labels[1:]:
 assert rows[label]==rows[first],label+': planned exact mutant sites and cargo-mutants outcomes differ'
 assert test_commands[label]==test_commands[first],label+': selected test command obligations differ'
(o/'obligation-check.json').write_text(json.dumps(dict(labels=labels,exact_sites=len(rows[first]),same_sites_and_raw_outcomes=True,same_selected_test_commands=True,sites=rows[first]),indent=2)+'\n')
MUTATION_CHECK_PY
printf 'paired shard-rule executions complete for pairs %s; every execution has the same exact sites/outcomes; judged offline by the frozen judge over four pairs\n' "$PAIRS" > "$O/status.txt"
MUTATION_BUDGET_BASELINE
