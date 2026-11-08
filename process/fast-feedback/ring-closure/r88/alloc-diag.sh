#!/bin/bash
set -euo pipefail
exec timeout -k 5s 900s bash -s -- "$1" <<'JOB'
set -euo pipefail
R="$1"
mkdir -p "$R/out"
export HOME=/root
. /root/.cargo/env
export CARGO_TARGET_DIR="$R/target"
cd "$R/fork"
NEW="$(git rev-parse HEAD)"
{ echo "library $NEW";rustc -Vv;uname -m;nproc;} > "$R/out/identity.txt"
# Diagnostic only, an untracked test file removed afterwards. It runs the
# unchanged admission body under the same global counter, and also counts
# the bytes asked for by threads other than the measuring one.
cat > tests/zz_alloc_diag.rs <<'RS'
#![cfg(feature = "std")]
use std::alloc::{GlobalAlloc, Layout, System};
use std::cell::Cell;
use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering::Relaxed};
struct Counting;
static BYTES: AtomicUsize = AtomicUsize::new(0);
static OTHER: AtomicUsize = AtomicUsize::new(0);
static WINDOW: AtomicBool = AtomicBool::new(false);
thread_local! { static MINE: Cell<bool> = const { Cell::new(false) }; }
unsafe impl GlobalAlloc for Counting {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        BYTES.fetch_add(layout.size(), Relaxed);
        if WINDOW.load(Relaxed) && !MINE.try_with(|m| m.get()).unwrap_or(false) {
            OTHER.fetch_add(layout.size(), Relaxed);
        }
        unsafe { System.alloc(layout) }
    }
    unsafe fn dealloc(&self, ptr: *mut u8, layout: Layout) {
        unsafe { System.dealloc(ptr, layout) }
    }
}
#[global_allocator]
static COUNTING: Counting = Counting;
mod finish_sync {
    pub use std::sync::Mutex;
}
#[path = "../src/admission.rs"]
#[allow(dead_code)]
mod admission;
#[test]
fn diag_admission_bytes_by_thread() {
    use core::{future::Future, task::{Context, Poll}};
    let pool = std::sync::Arc::new(admission::Pool::new(vec![17]));
    let mut cx = Context::from_waker(std::task::Waker::noop());
    MINE.with(|m| m.set(true));
    let before = BYTES.load(Relaxed);
    WINDOW.store(true, Relaxed);
    for _ in 0..1000 {
        let mut immediate = std::pin::pin!(pool.acquire());
        let held: admission::Lease<'_, usize> = match immediate.as_mut().poll(&mut cx) { Poll::Ready(v) => v, Poll::Pending => panic!() };
        let mut waiting = std::pin::pin!(pool.clone().acquire_owned());
        assert!(waiting.as_mut().poll(&mut cx).is_pending());
        held.release();
        let returned: admission::OwnedLease<usize> = match waiting.as_mut().poll(&mut cx) { Poll::Ready(v) => v, Poll::Pending => panic!() };
        let mut withdrawn = std::pin::pin!(pool.acquire());
        assert!(withdrawn.as_mut().poll(&mut cx).is_pending());
        drop(withdrawn);
        returned.release();
    }
    WINDOW.store(false, Relaxed);
    let total = BYTES.load(Relaxed) - before;
    println!("DIAG total={total} other_threads={}", OTHER.load(Relaxed));
}
RS
cargo nextest run --release --features serde,zeroize --test zz_alloc_diag --test allocations --no-run > "$R/out/build.log" 2>&1
diag=$(ls -t "$R"/target/release/deps/zz_alloc_diag-* | grep -v '\.d$' | head -1)
orig=$(ls -t "$R"/target/release/deps/allocations-* | grep -v '\.d$' | head -1)
rm tests/zz_alloc_diag.rs
test -z "$(git status --porcelain)"
# 400 processes of each, 16 at a time, as nextest runs a test alone in its
# process; the original reports its assertion, the diagnostic its counts.
python3 - "$R/out" "$diag" "$orig" <<'PY'
import subprocess,sys,collections,concurrent.futures as cf
out,diag,orig=sys.argv[1:]
def run(cmd):
    p=subprocess.run(cmd,capture_output=True,text=True,timeout=60)
    return p.returncode,p.stdout+p.stderr
with cf.ThreadPoolExecutor(16) as ex:
    d=list(ex.map(lambda _:run([diag,'--exact','diag_admission_bytes_by_thread','--nocapture']),range(400)))
    o=list(ex.map(lambda _:run([orig,'--exact','resource_admission_allocates_nothing_when_ready_or_waiting']),range(400)))
counts=collections.Counter()
for rc,text in d:
    line=next(l for l in text.splitlines() if l.startswith('DIAG '))
    counts[line]+=1
fails=[t for rc,t in o if rc!=0]
with open(out+'/diag.txt','w') as f:
    f.write('diagnostic outcomes (400 processes):\n')
    for k,v in counts.most_common():f.write(f'{v}\t{k}\n')
    f.write(f'original test failures: {len(fails)} of 400\n')
    for t in fails[:5]:f.write(t[-600:]+'\n---\n')
print(open(out+'/diag.txt').read())
PY
printf 'allocation diagnostic recorded\n' > "$R/out/status.txt"
JOB
