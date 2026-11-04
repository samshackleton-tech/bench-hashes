#!/bin/bash
# BLAKE3 #196, the one-L3 cost in a VM (run i196-vm): a KVM guest on the EPYC shaped like the M4 Max's
# Linux VM (16 vCPUs, one socket, no SMT; the qemu process on host CPUs 0-15, one thread a core), a
# fresh overlay of /root/vm/base.qcow2 (vmsetup.sh) a boot. One factor: the host's kvm halt_poll_ns,
# the default 200000 and 0 (every idle vCPU halts; a wake is a full exit and IPI), set before each boot
# and restored on exit. In each guest: bench-hashes built against servil 354d71d1 and the candidate
# de0451dc, then alternating runs of servil mt at the continuous points John's VM read slower
# (--contenders blake3-servil-mt --points "continuous 64 B,... 64 MiB"), 4 rounds each.
set -u
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R"
HP0=$(cat /sys/module/kvm/parameters/halt_poll_ns)
trap 'echo $HP0 > /sys/module/kvm/parameters/halt_poll_ns' EXIT
{ grep -m1 'model name' /proc/cpuinfo; nproc; uname -r; qemu-system-x86_64 --version | head -1; echo "halt_poll_ns at start $HP0"
  for v in base cand; do echo "$v $(git -C $v log -1 --format=%H)"; done; echo "bench $(git -C bench log -1 --format=%H)"; } > "$O/machine.txt"
K=/root/vm/id_vm
S="ssh -i $K -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o ConnectTimeout=5 -p 2222 root@127.0.0.1"
POINTS="continuous 64 B,continuous 256 KiB,continuous 1 MiB,continuous 4 MiB,continuous 16 MiB,continuous 64 MiB"
tar -C "$R" -cf "$R/src.tar" bench base cand
for hp in 200000 0; do
  echo $hp > /sys/module/kvm/parameters/halt_poll_ns
  echo "halt_poll_ns $(cat /sys/module/kvm/parameters/halt_poll_ns) for the guest of condition $hp" >> "$O/machine.txt"
  qemu-img create -q -f qcow2 -b /root/vm/base.qcow2 -F qcow2 "$R/vm-$hp.qcow2"
  printf 'instance-id: %s\nlocal-hostname: b196vm\n' "run-$hp-$(basename $R)" > "$R/meta-data"
  printf '#cloud-config\nusers:\n  - name: root\n    ssh_authorized_keys: ["%s"]\ndisable_root: false\nssh_pwauth: false\npackage_update: false\n' "$(cat $K.pub)" > "$R/user-data"
  cloud-localds "$R/seed-$hp.img" "$R/user-data" "$R/meta-data"
  taskset -c 0-15 qemu-system-x86_64 -enable-kvm -cpu host -smp 16,sockets=1,cores=16,threads=1 -m 32G -nographic \
    -drive file="$R/vm-$hp.qcow2",if=virtio -drive file="$R/seed-$hp.img",if=virtio,format=raw \
    -netdev user,id=n0,hostfwd=tcp:127.0.0.1:2222-:22 -device virtio-net-pci,netdev=n0 > "$O/console-$hp.log" 2>&1 &
  QPID=$!
  for i in $(seq 1 120); do $S true 2>/dev/null && break; sleep 5; done
  $S true || { echo "guest $hp unreachable" >> "$O/status.txt"; kill $QPID; exit 2; }
  $S '{ nproc; lscpu | grep -E "^CPU\(s\)|Thread|Socket|L3"; cat /sys/devices/system/cpu/cpu0/cache/index3/shared_cpu_list; uname -r; }' > "$O/guest-$hp.txt" 2>&1
  $S 'mkdir -p /root/r && tar -C /root/r -xf -' < "$R/src.tar"
  $S 'cd /root/r/bench && . /root/.cargo/env && cargo build --release -q 2>&1 | tail -3; for v in base cand; do ./target/release/bench-hashes build-against /root/r/$v 2>/dev/null | tail -1 > /root/r/exe-$v; [ -x "$(cat /root/r/exe-$v)" ] || echo "build-against $v failed"; done' > "$O/guest-build-$hp.txt" 2>&1
  echo "guest $hp built" >> "$O/status.txt"
  for round in 1 2 3 4; do
    for v in base cand; do
      C=$(git -C "$R/$v" rev-parse HEAD)
      $S "mkdir -p /root/s-$v-$round && cd /root/s-$v-$round && \$(cat /root/r/exe-$v) --contenders blake3-servil-mt --expect-servil $C --points '$POINTS' > run.out 2> run.err; echo \$?" > "$O/exit-$hp-$v-$round.txt"
      echo "hp $hp $v round $round exit $(cat "$O/exit-$hp-$v-$round.txt")" >> "$O/status.txt"
      $S "cat /root/s-$v-$round/benchmark-results/*/bench-hashes.samples.tsv" > "$O/run-$hp-$v-$round.samples.tsv" 2>/dev/null || echo "hp $hp $v round $round: NO SAMPLES" >> "$O/status.txt"
      [ -s "$O/run-$hp-$v-$round.samples.tsv" ] || echo "hp $hp $v round $round: NO SAMPLES" >> "$O/status.txt"
    done
  done
  $S poweroff >/dev/null 2>&1 || true
  for i in $(seq 1 60); do kill -0 $QPID 2>/dev/null || break; sleep 2; done
  kill $QPID 2>/dev/null; wait $QPID 2>/dev/null
  rm -f "$R/vm-$hp.qcow2"
done
echo "vm done" >> "$O/status.txt"
