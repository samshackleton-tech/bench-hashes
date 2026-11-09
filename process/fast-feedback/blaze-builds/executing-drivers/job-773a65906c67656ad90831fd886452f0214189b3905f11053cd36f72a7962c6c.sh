#!/bin/bash
# Reuse the exact executed memlock/functional driver on a disposable Btrfs filesystem.
set -euo pipefail
exec timeout -k 15s 540s unshare --mount --propagation private bash -s -- "$1" <<'BUILD_SPEED_JOB'
set -euo pipefail
R="$1";O="$R/out";mkdir -p "$O";S="/var/tmp/$(basename "$R")"
IMAGE="$R/canary-btrfs.img";mkdir -p "$S";truncate -s 16G "$IMAGE"
mkfs.btrfs -f "$IMAGE" > "$O/filesystem-create.txt" 2>&1
mount -o loop,nosuid,nodev "$IMAGE" "$S"
# The mount belongs only to this namespace. Detach it after the driver has
# stopped/waited its daemon; the backing image stays available for review.
cleanup() { result=$?; umount -l "$S" >> "$O/filesystem-cleanup.txt" 2>&1; exit "$result"; }
trap cleanup EXIT
findmnt -J --target "$S" > "$O/filesystem-mounted.json"
# Some sandbox helpers deliberately clear HOME/XDG and use the account database.
# Give the trial uid a valid home only in this private mount namespace.
python3 - "$R" "$S" <<'PASSWD_OVERLAY'
from pathlib import Path
import sys,hashlib,json,subprocess
r,s=map(Path,sys.argv[1:]);original=Path('/etc/passwd').read_bytes();rows=original.decode().splitlines();matches=[line for line in rows if line.split(':')[2]=='65534'];assert len(matches)==1
old=matches[0];fields=old.split(':');prior_home=fields[5];fields[5]=str(s/'home');new=':'.join(fields)
p=r/'passwd.namespace';p.write_bytes(original);(r/'passwd.old').write_text(old);(r/'passwd.new').write_text(new)
subprocess.run(['/usr/local/bin/replace','-f',str(p),str(r/'passwd.old'),str(r/'passwd.new')],check=True,stdout=subprocess.DEVNULL)
subprocess.run(['mount','--bind',str(p),'/etc/passwd'],check=True)
subprocess.run(['mount','-o','remount,bind,ro','/etc/passwd'],check=True)
seen=subprocess.check_output(['getent','passwd',fields[0]],text=True).strip();assert seen==new
(r/'out/passwd-overlay.json').write_text(json.dumps(dict(uid=65534,prior_home=prior_home,namespace_home=fields[5],host_passwd_sha256=hashlib.sha256(original).hexdigest(),namespace_only=True),indent=2)+'\n')
PASSWD_OVERLAY
printf 'reflink-control-payload\n' > "$S/reflink-source"
cp --reflink=always "$S/reflink-source" "$S/reflink-clone"
cmp "$S/reflink-source" "$S/reflink-clone"
printf 'modified-clone\n' > "$S/reflink-clone"
grep -Fx 'reflink-control-payload' "$S/reflink-source" > "$O/reflink-control.txt"

. /root/.cargo/env
{ echo "source $(git -C "$R/library" rev-parse HEAD)"; echo "clocks $(git -C "$R/bench" rev-parse HEAD)"; echo "canary 0.20261105.4 e93029602544df9882fffb18bf272d048a1a7136"; echo "build-speed trial; process-tree hardware counters NA; speed unjudged"; } > "$O/identity.txt"
cat > "$R/bridge.rs" <<'BUILD_CLOCKS_RUST'
use std::{ffi::{CStr, c_char}, fs};

// Trial-only ABI: a live non-unwinding callback; paths are live C strings.
#[unsafe(no_mangle)]
pub extern "C" fn measure_build(call: extern "C" fn()) -> u64 {
    let start = clocks::now();
    call();
    clocks::since_ns(start)
}
#[unsafe(no_mangle)]
pub extern "C" fn build_now_ns() -> u64 { clocks::load::now_ns() }
#[unsafe(no_mangle)]
pub extern "C" fn build_tick() { clocks::load::tick(); }
#[unsafe(no_mangle)]
pub extern "C" fn build_quiet() -> u8 { u8::from(clocks::load::quiet_for(1).is_ok()) }
#[unsafe(no_mangle)]
pub unsafe extern "C" fn build_load_report(path: *const c_char) -> u8 {
    // Sound: the driver passes a live NUL-terminated path for this call.
    let path = unsafe { CStr::from_ptr(path) }.to_str().unwrap();
    let windows = clocks::load::windows();
    let lines: Vec<_> = windows.iter().map(|w| format!(
        "{{\"start_ns\":{},\"end_ns\":{},\"other_milli_cpus\":{},\"steal_milli_cpus\":{},\"busy\":{}}}",
        w.start_ns, w.end_ns, w.other_milli_cpus, w.steal_milli_cpus, w.busy())).collect();
    fs::write(path, format!("[{}]\n", lines.join(",\n"))).unwrap();
    u8::from(!windows.is_empty() && windows.iter().all(|w| !w.busy()))
}
BUILD_CLOCKS_RUST
cat > "$R/build-speed.py" <<'BUILD_SPEED_DRIVER_PY'
#!/usr/bin/env python3
"""Private, pinned build-system trial. clocks owns wall timing and load rules."""
from pathlib import Path
import ctypes
import hashlib
import json
import os
import resource
import shutil
import signal
import subprocess
import sys
import tarfile

R, S = map(Path, sys.argv[1:3])
PAIRS = int(sys.argv[3])
PROFILE = sys.argv[4] if len(sys.argv) == 5 else 'release'
assert PAIRS in (1, 4) and PROFILE in ('release', 'dev')
PROFILE_ARGS = ['--release'] if PROFILE == 'release' else []
BIN_PROFILE = 'release' if PROFILE == 'release' else 'debug'
O = R / 'out'
SOURCE = '1cbdf5d72d70d8ed511870b18c7f017cce83da15'
ARCHIVE = 'a8b8f3b36b7397671d3a5bcf739e5e1407e5941ee2345aaf5dc2b0868d44d8e6'
ABC = '6437b3ac38465133ffb63b75273a8db548c558465d79db03fd359c6cd5bd9d85'
EMPTY = 'af1349b9f5f9a1a6a0404dea36dcc9499bcb25c9adc112b7cc9a93cae41f3262'
HOME = S / 'home'
MEMLOCK = 268435456
COMMANDS = []
SAMPLES = []
GROUPS = []
# Keep double-forked/setsid daemons in this process's descendant tree for clocks load.
libc = ctypes.CDLL(None, use_errno=True)
assert libc.prctl(36, 1, 0, 0, 0) == 0, ('PR_SET_CHILD_SUBREAPER', ctypes.get_errno())

def record(path, value):
    path.write_text(json.dumps(value, indent=2) + '\n')

def cancelled(sig, frame):
    raise RuntimeError('trial cancellation or outer deadline')
signal.signal(signal.SIGTERM, cancelled)
signal.signal(signal.SIGALRM, cancelled)

def cpu(group):
    values = dict(line.split() for line in (group / 'cpu.stat').read_text().splitlines())
    return {key: int(values[key]) * 1000 for key in ('usage_usec', 'user_usec', 'system_usec')}

def memory(group):
    return {name: int((group / name).read_text()) for name in ('memory.current', 'memory.peak')}

def members(group):
    return [int(p) for p in (group / 'cgroup.procs').read_text().split()]

def resident(group):
    result = []
    for pid in members(group):
        base = Path('/proc') / str(pid)
        try:
            status = dict(line.split(':', 1) for line in (base / 'status').read_text().splitlines() if ':' in line)
            args = (base / 'cmdline').read_bytes().replace(b'\0', b' ').decode(errors='replace').strip()
            result.append(dict(pid=pid, ppid=int(status['PPid']), command=args,
                               rss_bytes=int(status.get('VmRSS', '0 kB').split()[0]) * 1024,
                               high_water_rss_bytes=int(status.get('VmHWM', '0 kB').split()[0]) * 1024))
        except FileNotFoundError:
            pass
    return result

def owned_group(name):
    group = Path('/sys/fs/cgroup') / ('blaze-trial-' + R.name + '-' + name)
    group.mkdir()  # Fresh leaf only; no controller, limit or existing policy changes.
    GROUPS.append(group)
    assert (group / 'cpu.stat').is_file() and (group / 'memory.peak').is_file()
    return group

def env(state):
    return dict(HOME=str(HOME), USER='nobody', LOGNAME='nobody',
                PATH=str(S / 'cargo-toolchain/bin') + ':/usr/local/bin:/usr/bin:/bin',
                CARGO_HOME=str(HOME / '.cargo'), RUSTUP_HOME=str(HOME / '.rustup'),
                BLAZE_HOME=str(state), XDG_CACHE_HOME=str(HOME / '.cache'),
                BLAZE_CORES='all', TMPDIR=str(HOME), TERM='dumb')

def call(label, args, cwd, environment, group=None, timed=False, expected=0, limit=90):
    def child():
        if group is not None:
            (group / 'cgroup.procs').write_text(str(os.getpid()))
        resource.setrlimit(resource.RLIMIT_MEMLOCK, (MEMLOCK, MEMLOCK))
        os.setgroups([])
        os.setgid(65534)
        os.setuid(65534)
    errors = []
    result = {}
    with (O / (label + '.stdout')).open('wb') as out, (O / (label + '.stderr')).open('wb') as err:
        def work():
            try:
                p = subprocess.Popen(list(map(str, args)), cwd=cwd, env=environment, stdin=subprocess.DEVNULL,
                                     stdout=out, stderr=err, preexec_fn=child, start_new_session=True)
                try:
                    # Blocking wait avoids Python's timeout polling/backoff entering
                    # the wall sample. An alarm bounds this one owned child instead.
                    signal.alarm(limit)
                    result['exit'] = p.wait()
                except BaseException:
                    os.killpg(p.pid, signal.SIGTERM)
                    try:
                        p.wait(timeout=5)
                    except subprocess.TimeoutExpired:
                        os.killpg(p.pid, signal.SIGKILL)
                        p.wait()
                    raise
                finally:
                    signal.alarm(0)
            except BaseException as error:
                errors.append(error)
        before = cpu(group) if timed else None
        before_memory = memory(group) if timed else None
        before_processes = resident(group) if timed else None
        if timed:
            CLOCK.build_tick()
            started = CLOCK.build_now_ns()
            callback = CALLBACK(work)
            wall = CLOCK.measure_build(callback)
        else:
            work()
        after = cpu(group) if timed else None
        if timed:
            SAMPLES.append(dict(label=label, started_ns=started, wall_ns=wall, exit=result.get('exit'),
                                cpu_before=before, cpu_after=after,
                                cpu_ns=after['usage_usec'] - before['usage_usec'],
                                memory_before=before_memory, memory_after=memory(group),
                                processes_before=before_processes, processes_after=resident(group),
                                core_cycles=None, instructions=None, energy_nj=None))
            record(O / 'samples.json', SAMPLES)
        COMMANDS.append(dict(label=label, args=list(map(str, args)), cwd=str(cwd), exit=result.get('exit'),
                             timed=timed, cgroup=str(group) if group else None, errors=[repr(e) for e in errors]))
        record(O / 'commands.json', COMMANDS)
        if errors:
            raise errors[0]
        assert result['exit'] == expected, (label, result['exit'], expected)
        return result['exit']

def stop(label, state, group):
    call(label, [BLAZE, 'stop'], S, env(state), group, limit=15)
    stopped = subprocess.run(['/usr/local/bin/procs', '--exe', str(BLAZE), '--signal', 'TERM', '--wait', '10'],
                             capture_output=True, text=True)
    (O / (label + '-wait.txt')).write_text(stopped.stdout + stopped.stderr + '\nexit=' + str(stopped.returncode) + '\n')
    assert stopped.returncode in (0, 1)
    # Reap our adopted daemon children; no selector can affect an unrelated process.
    while True:
        try:
            pid, status = os.waitpid(-1, os.WNOHANG)
            if pid == 0:
                break
        except ChildProcessError:
            break
    assert not members(group), (label, members(group))

def clone(source, destination):
    subprocess.run(['cp', '-a', '--reflink=always', str(source), str(destination)], check=True)

def replace(path, old, new, label):
    oldfile, newfile = R / 'replace.old', R / 'replace.new'
    oldfile.write_bytes(old)
    newfile.write_bytes(new)
    with (O / (label + '-source.diff')).open('wb') as output:
        subprocess.run(['/usr/local/bin/replace', '-f', str(path), str(oldfile), str(newfile)], check=True, stdout=output)

def vendor_config(project):
    # Directory sources must lie inside the workspace's mounted view.
    clone(S / 'vendor', project / 'vendor')
    configdir = project / '.cargo'
    configdir.mkdir()
    config = configdir / 'config.toml'
    config.write_text('[source.crates-io]\nreplace-with="trial-vendor"\n[source.trial-vendor]\ndirectory="' + str(project / 'vendor') + '"\n')
    os.chown(configdir, 65534, 65534)
    os.chown(config, 65534, 65534)


def project(path, library, pair):
    (path / 'src').mkdir(parents=True)
    (path / 'Cargo.toml').write_text('[package]\nname="blaze_b3_probe"\nversion="0.1.0"\nedition="2024"\n'
        '[dependencies]\nblake3-servil={path="' + str(library) + '"}\n'
        '[profile.release]\nopt-level=3\ndebug=false\nincremental=false\nlto=false\npanic="unwind"\ncodegen-units=16\n'
        '[profile.dev]\nopt-level=0\ndebug=2\nincremental=true\nlto=false\npanic="unwind"\ncodegen-units=256\ndebug-assertions=true\noverflow-checks=true\n')
    (path / 'src/main.rs').write_text('#[used]\nstatic LAYOUT: [u8; ' + str(193 * pair) + '] = [7; ' + str(193 * pair) + '];\n'
        'fn main(){std::hint::black_box(&LAYOUT);blake3_servil::initialize();'
        'let h=blake3_servil::convenience::hash(b"abc").to_hex().to_string();'
        'println!("source ' + SOURCE + ' digest {}",h);if h!="' + ABC + '"{std::process::exit(42);}}\n')
    for file in [path, path / 'src', path / 'Cargo.toml', path / 'src/main.rs']:
        os.chown(file, 65534, 65534)

try:
    archive = Path('/var/tmp/blaze-input-' + ARCHIVE + '.tar.gz')
    assert hashlib.sha256(archive.read_bytes()).hexdigest() == ARCHIVE
    (S / 'tool').mkdir()
    with tarfile.open(archive) as tf:
        tf.extractall(S / 'tool', filter='data')
    BLAZE = next(p for p in (S / 'tool').rglob('blaze') if p.is_file())
    HOME.mkdir()
    SEED = HOME / '.blaze'
    SEED.mkdir()
    (SEED / 'config.toml').write_text('[update]\nmode="offline"\n')
    sysroot = subprocess.check_output(['/root/.cargo/bin/rustc', '--print', 'sysroot'], text=True).strip()
    subprocess.run(['cp', '-a', sysroot, str(S / 'cargo-toolchain')], check=True)
    shutil.copytree(R / 'library', S / 'library-template', symlinks=True)
    shutil.rmtree(S / 'library-template/.git')
    project(S / 'seed-project', S / 'library-template', 1)
    for path in [S, *S.rglob('*')]:
        os.chown(path, 65534, 65534, follow_symlinks=False)
    seed_group = owned_group('seed')
    call('cargo-version', [S / 'cargo-toolchain/bin/cargo', '-V'], S, env(SEED))
    call('rustc-version', [S / 'cargo-toolchain/bin/rustc', '-Vv'], S, env(SEED))
    call('canary-version', [BLAZE, '--version'], S, env(SEED))
    call('canary-toolchain', [BLAZE, 'toolchain'], S, env(SEED), seed_group, limit=140)
    call('cargo-fetch', [S / 'cargo-toolchain/bin/cargo', 'fetch', '--manifest-path', S / 'seed-project/Cargo.toml'], S, env(SEED), seed_group)
    # A fresh Blaze store cannot fetch offline from unpacked sources alone.
    # Give both systems Cargo's checksum-verified directory source instead;
    # this prepares exact dependencies without cloning compiled artifacts.
    call('cargo-vendor', [S / 'cargo-toolchain/bin/cargo', 'vendor', '--locked', '--manifest-path',
                         S / 'seed-project/Cargo.toml', S / 'vendor'], S, env(SEED), seed_group)
    vendor_config(S / 'seed-project')
    shutil.copyfile(S / 'seed-project/.cargo/config.toml', O / 'private-cargo-config.toml')
    # This release has no `fetch` command (pilot1 retained that failure).
    # Prepare both systems once, then clone only toolchains and source,
    # never the seed's compiled outputs or Blaze's v2 compilation store.
    for label, tool in [('cargo-seed', S / 'cargo-toolchain/bin/cargo'), ('canary-seed', BLAZE)]:
        call(label, [tool, 'build', *PROFILE_ARGS, '--locked', '--manifest-path', S / 'seed-project/Cargo.toml',
                     '--target-dir', S / (label + '-target')], S / 'seed-project', env(SEED), seed_group, limit=180)
    stop('seed-stop', SEED, seed_group)
    record(O / 'seed-tree.json', [{'path': str(p.relative_to(SEED)), 'bytes': p.stat().st_size}
                                 for p in SEED.rglob('*') if p.is_file()])
    shutil.copyfile(S / 'seed-project/Cargo.lock', O / 'probe-Cargo.lock')
    shutil.copyfile(S / 'seed-project/Cargo.toml', O / 'probe-Cargo.toml')
    # Bridge compilation and every download finish before quiet sampling.
    bridge = R / 'bridge'
    (bridge / 'src').mkdir(parents=True)
    shutil.copyfile(R / 'bridge.rs', bridge / 'src/lib.rs')
    (bridge / 'Cargo.toml').write_text('[package]\nname="build-clocks"\nversion="0.1.0"\nedition="2021"\n'
        '[lib]\ncrate-type=["cdylib"]\n[dependencies]\nclocks={path="' + str(R / 'bench/clocks') + '"}\n')
    with (O / 'bridge-build.log').open('wb') as output:
        subprocess.run(['/root/.cargo/bin/cargo', 'build', '--release', '--manifest-path', str(bridge / 'Cargo.toml')],
                       check=True, stdout=output, stderr=subprocess.STDOUT)
    CLOCK = ctypes.CDLL(str(bridge / 'target/release/libbuild_clocks.so'))
    CALLBACK = ctypes.CFUNCTYPE(None)
    CLOCK.measure_build.argtypes = [CALLBACK]
    CLOCK.measure_build.restype = ctypes.c_uint64
    CLOCK.build_now_ns.restype = ctypes.c_uint64
    CLOCK.build_quiet.restype = ctypes.c_uint8
    CLOCK.build_load_report.argtypes = [ctypes.c_char_p]
    CLOCK.build_load_report.restype = ctypes.c_uint8
    # A positive attribution control: the controller is outside the child cgroup.
    control = owned_group('control')
    call('launch-control-true', ['/usr/bin/true'], S, env(SEED), control, timed=True)
    call('cpu-control-sleep', ['/usr/bin/sleep', '0.05'], S, env(SEED), control, timed=True)
    call('cpu-control-work', ['/usr/bin/python3', '-c', 'print(sum(i*i for i in range(3000000)))'], S, env(SEED), control, timed=True)
    sleep_cpu, work_cpu = [s['cpu_ns'] for s in SAMPLES[-2:]]
    assert sleep_cpu < 30000000 and work_cpu > max(50000000, 3 * sleep_cpu), (sleep_cpu, work_cpu)
    try:
        call('failure-control', ['/usr/bin/python3', '-c', 'raise SystemExit(17)'], S, env(SEED), control, timed=True)
    except AssertionError as error:
        assert error.args[0] == ('failure-control', 17, 0)
    else:
        raise AssertionError('planted command failure was accepted')
    try:
        call('deadline-control', ['/usr/bin/sleep', '3'], S, env(SEED), control, timed=True, limit=1)
    except RuntimeError as error:
        assert str(error) == 'trial cancellation or outer deadline'
        assert not members(control)
    else:
        raise AssertionError('planted deadline was accepted')
    record(O / 'measurement-controls.json', dict(sleep_cpu_ns=sleep_cpu, work_cpu_ns=work_cpu,
                                                 planted_failure_exit=17, failure_propagated=True,
                                                 deadline_propagated=True, deadline_child_exited=True))
    assert CLOCK.build_quiet() == 1, 'clocks quiet preflight abstained'
    original = (S / 'library-template/src/convenience.rs').read_bytes()
    old = b'pub fn hash(input: &[u8]) -> Hash {\n    crate::hash_serial_cold(input, IV, 0)\n}'
    new = old.replace(b'(input, IV, 0)', b'(&input[..0], IV, 0)')
    assert original.count(old) == 1
    lifetimes = []
    for pair in range(1, PAIRS + 1):
        # All copies/layout preparation finish before either side's timed build.
        prepared = {}
        for side in ['cargo', 'canary']:
            base = S / ('layout-' + str(pair) + '-' + side)
            base.mkdir()
            lib, probe, state = base / 'library', base / 'probe', base / 'state'
            clone(S / 'library-template', lib)
            state.mkdir(mode=0o700)
            os.chown(state, 65534, 65534)
            for name in ['toolchains', 'library']:
                assert (SEED / name).is_dir(), name
                clone(SEED / name, state / name)
            shutil.copyfile(SEED / 'config.toml', state / 'config.toml')
            os.chown(state / 'config.toml', 65534, 65534)
            assert not (state / 'v2').exists()
            project(probe, lib, pair)
            vendor_config(probe)
            shutil.copyfile(S / 'seed-project/Cargo.lock', probe / 'Cargo.lock')
            os.chown(probe / 'Cargo.lock', 65534, 65534)
            group = owned_group(str(pair) + '-' + side)
            tool = S / 'cargo-toolchain/bin/cargo' if side == 'cargo' else BLAZE
            args = [tool, 'build', *PROFILE_ARGS, '--offline', '--locked', '--manifest-path', probe / 'Cargo.toml', '--target-dir', probe / 'target']
            prepared[side] = (base, lib, probe, state, group, args)
        for side in (['cargo', 'canary'] if pair % 2 else ['canary', 'cargo']):
            base, lib, probe, state, group, args = prepared[side]
            tag = side + '-' + str(pair)
            environment = env(state)
            lifetime_cpu = cpu(group)
            lifetime_start = CLOCK.build_now_ns()
            target = probe / 'target' / BIN_PROFILE / 'blaze_b3_probe'
            def build(case):
                call(tag + '-' + case, args, probe, environment, group, timed=True, limit=120)
            def check(case, changed=False):
                call(tag + '-' + case + '-check', [target], probe, environment, group, expected=42 if changed else 0, limit=15)
                assert ('digest ' + (EMPTY if changed else ABC)) in (O / (tag + '-' + case + '-check.stdout')).read_text()
            try:
                build('fresh')
                check('fresh')
                assert hashlib.sha256(target.read_bytes()).hexdigest()
                (O / (tag + '-artifact.sha256')).write_text(hashlib.sha256(target.read_bytes()).hexdigest() + '\n')
                for iteration in range(1, 5):
                    build('noop-' + str(iteration))
                    check('noop-' + str(iteration))
                for iteration in range(1, 5):
                    replace(lib / 'src/convenience.rs', old, new, tag + '-edit-' + str(iteration))
                    try:
                        build('edit-' + str(iteration))
                        check('edit-' + str(iteration), changed=True)
                    finally:
                        replace(lib / 'src/convenience.rs', new, old, tag + '-restore-' + str(iteration))
                    assert (lib / 'src/convenience.rs').read_bytes() == original
                    build('restore-' + str(iteration))
                    check('restore-' + str(iteration))
            finally:
                if side == 'canary':
                    for filename in ['serve.log', 'serve.pid']:
                        path = state / 'v2' / filename
                        if path.is_file():
                            shutil.copyfile(path, O / (tag + '-' + filename))
                    stop(tag + '-stop', state, group)
                assert (lib / 'src/convenience.rs').read_bytes() == original
            lifetimes.append(dict(pair=pair, side=side, elapsed_ns=CLOCK.build_now_ns() - lifetime_start,
                                  cpu_before=lifetime_cpu, cpu_after=cpu(group), memory=memory(group),
                                  empty=not members(group), source_restored=True))
            record(O / 'lifetimes.json', lifetimes)
    quiet = CLOCK.build_load_report(os.fsencode(O / 'load.json')) == 1
    assert quiet, 'clocks found busy load; no speed verdict'
    record(O / 'outcome.json', dict(pairs=PAIRS, profile=PROFILE, complete=True, library_bytes_restored=True,
                                    clocks='9994de190259648ede82f7c5e4dbac4f1534a41d',
                                    source=SOURCE, archive_sha256=ARCHIVE,
                                    process_tree_cycles=None, process_tree_instructions=None, energy=None,
                                    pilot=PAIRS == 1, speed_verdict='unjudged'))
    (O / 'status.txt').write_text('build-system trial complete; digest and restoration controls pass; all-worker cgroup CPU collected; process-tree hardware counts NA; speed unjudged\n')
finally:
    cleanup = []
    for group in GROUPS:
        # Only this newly created leaf's PIDs; never a global name/pattern selector.
        pids = members(group)
        for pid in pids:
            try:
                os.kill(pid, signal.SIGKILL)
            except ProcessLookupError:
                pass
        while True:
            try:
                os.waitpid(-1, os.WNOHANG)
            except ChildProcessError:
                break
            # No blocking wait or retry loop; rmdir fails loudly if a process remains.
            break
        remaining = members(group)
        cleanup.append(dict(path=str(group), initially_alive=pids, remaining=remaining))
        if not remaining:
            group.rmdir()
    record(O / 'cgroup-cleanup.json', cleanup)
BUILD_SPEED_DRIVER_PY
python3 "$R/build-speed.py" "$R" "$S" 1 dev > "$O/driver.stdout" 2> "$O/driver.stderr"
git -C "$R/library" diff --exit-code > "$O/original-source-diff.txt"
BUILD_SPEED_JOB
