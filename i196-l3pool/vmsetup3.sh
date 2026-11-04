#!/bin/bash
# One-time, after vmsetup2.sh: lld and rustup's llvm-tools in the guest base image (bench-hashes check).
set -eu
exec 9>/root/bench-native-afk.lock; flock 9
cd /root/vm
qemu-system-x86_64 -enable-kvm -cpu host -smp 16,sockets=1,cores=16,threads=1 -m 32G -nographic \
  -drive file=base.qcow2,if=virtio -drive file=seed.img,if=virtio,format=raw \
  -netdev user,id=n0,hostfwd=tcp:127.0.0.1:2222-:22 -device virtio-net-pci,netdev=n0 > /root/vm/setup3-console.log 2>&1 &
Q=$!
S="ssh -i /root/vm/id_vm -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o ConnectTimeout=5 -p 2222 root@127.0.0.1"
for i in $(seq 1 120); do $S true 2>/dev/null && break; sleep 5; done
$S 'cloud-init status --wait >/dev/null 2>&1; export DEBIAN_FRONTEND=noninteractive; apt-get update -q >/dev/null && apt-get install -y -q lld >/dev/null; /root/.cargo/bin/rustup component add llvm-tools >/dev/null 2>&1; ls /usr/bin/ld.lld*; /root/.cargo/bin/rustup component list --installed'
$S 'sync; poweroff' || true
wait $Q || true
echo "vmsetup3 done"
