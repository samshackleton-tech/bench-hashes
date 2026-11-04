#!/bin/bash
# One-time, after vmsetup.sh: build-essential, pkg-config and git in the guest base image.
set -eu
exec 9>/root/bench-native-afk.lock; flock 9
cd /root/vm
qemu-system-x86_64 -enable-kvm -cpu host -smp 16,sockets=1,cores=16,threads=1 -m 32G -nographic \
  -drive file=base.qcow2,if=virtio -drive file=seed.img,if=virtio,format=raw \
  -netdev user,id=n0,hostfwd=tcp:127.0.0.1:2222-:22 -device virtio-net-pci,netdev=n0 > /root/vm/setup2-console.log 2>&1 &
Q=$!
S="ssh -i /root/vm/id_vm -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o ConnectTimeout=5 -p 2222 root@127.0.0.1"
for i in $(seq 1 120); do $S true 2>/dev/null && break; sleep 5; done
$S 'cloud-init status --wait >/dev/null 2>&1; export DEBIAN_FRONTEND=noninteractive; apt-get update -q >/dev/null && apt-get install -y -q build-essential pkg-config git >/dev/null; cc --version | head -1; git --version; ls /root/.cargo/bin'
$S 'sync; poweroff' || true
wait $Q || true
echo "vmsetup2 done"
