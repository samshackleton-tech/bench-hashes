#!/bin/bash
set -euo pipefail
ulimit -c 0
R="$1"; O="$R/out"; mkdir -p "$O"; cd "$R/fork"
echo "library $(git rev-parse HEAD)" > "$O/identity.txt"
cat > "$R/cmov.c" <<'C_EOF'
#include <assert.h>
#include <stdint.h>
#include <signal.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <unistd.h>
int main(void) {
 uint64_t a=0xdead000000001234ULL;
 __asm__ volatile("cmpl $2, %%ecx; cmova %%edx, %%eax" : "+a"(a) : "d"(987ULL), "c"(1U) : "cc");
 assert(a==0x1234);
 a=0xdead000000001234ULL;
 __asm__ volatile("cmpl $2, %%ecx; cmova %%rdx, %%rax" : "+a"(a) : "d"(987ULL), "c"(1U) : "cc");
 assert(a==0xdead000000001234ULL);
 void *bad=mmap(0,4096,PROT_NONE,MAP_PRIVATE|MAP_ANONYMOUS,-1,0); assert(bad!=MAP_FAILED);
 pid_t child=fork();assert(child>=0);
 if(!child){a=123;__asm__ volatile("cmpl $2, %%ecx; cmova (%%rbx), %%rax" : "+a"(a) : "b"(bad), "c"(1U) : "cc","memory");_exit(0);}
 int status;assert(waitpid(child,&status,0)==child);assert(WIFSIGNALED(status)&&WTERMSIG(status)==SIGSEGV);
 puts("CMOV false clears upper 32 bits; false memory source still faults");return 0;
}
C_EOF
cc -O2 "$R/cmov.c" -o "$R/cmov"
"$R/cmov" > "$O/cmov.log" 2>&1
python3 -m unittest discover -s tools/verify -p 'test_*.py' > "$O/unit.log" 2>&1
timeout 240 python3 tools/verify/prove_last.py --workers 6 8:0:-1 16:0:-1 8:1:-1 16:1:-1 8:3:-1 16:3:-1 > "$O/proof.log" 2>&1
echo 'symbolic trial done' > "$O/status.txt"
