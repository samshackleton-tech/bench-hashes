#!/bin/bash
# One-time: a KVM guest base image for BLAKE3 #196's one-L3 VM tests (16 vCPUs, no SMT, like the
# M4 Max's Linux VM): Ubuntu cloud image + rustup stable + cargo-nextest, ssh by /root/vm/id_vm.
set -eu
exec 9>/root/bench-native-afk.lock; flock 9
export DEBIAN_FRONTEND=noninteractive
apt-get install -y -q qemu-system-x86 qemu-utils cloud-image-utils >/dev/null
mkdir -p /root/vm && cd /root/vm
[ -f id_vm ] || ssh-keygen -q -t ed25519 -N '' -f id_vm
[ -f noble.img ] || curl -sSfL -o noble.img https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
cp noble.img base.qcow2 && qemu-img resize -q base.qcow2 40G
cat > user-data <<EOF
#cloud-config
users:
  - name: root
    ssh_authorized_keys: ["$(cat id_vm.pub)"]
disable_root: false
ssh_pwauth: false
package_update: false
runcmd:
  - [ sh, -c, "curl -sSf https://sh.rustup.rs | sh -s -- -y --profile minimal > /root/rustup.log 2>&1 && /root/.cargo/bin/cargo install cargo-nextest --locked >> /root/rustup.log 2>&1; touch /root/ready" ]
EOF
printf 'instance-id: b196vm\nlocal-hostname: b196vm\n' > meta-data
cloud-localds seed.img user-data meta-data
timeout 2400 qemu-system-x86_64 -enable-kvm -cpu host -smp 16,sockets=1,cores=16,threads=1 -m 32G -nographic \
  -drive file=base.qcow2,if=virtio -drive file=seed.img,if=virtio,format=raw \
  -netdev user,id=n0,hostfwd=tcp:127.0.0.1:2222-:22 -device virtio-net-pci,netdev=n0 > /root/vm/setup-console.log 2>&1 &
Q=$!
S="ssh -i /root/vm/id_vm -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR -o ConnectTimeout=5 -p 2222 root@127.0.0.1"
for i in $(seq 1 240); do $S test -f /root/ready 2>/dev/null && break; sleep 10; done
$S 'tail -2 /root/rustup.log; /root/.cargo/bin/cargo --version; /root/.cargo/bin/cargo nextest --version | head -1; nproc; lscpu | grep -E "^CPU\(s\)|Thread|L3"; cat /sys/devices/system/cpu/cpu0/cache/index3/shared_cpu_list' || true
$S 'cloud-init clean --logs >/dev/null 2>&1; sync; poweroff' || true
wait $Q || true
echo "vmsetup done"
