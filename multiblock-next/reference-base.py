"""Independent scalar compression for the mixed CV/root startup fixture."""
import struct
IV = [0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19]
PERM = [2,6,3,10,7,0,4,13,1,11,12,5,9,14,15,8]
COLS = [(0,4,8,12),(1,5,9,13),(2,6,10,14),(3,7,11,15)]
DIAGS = [(0,5,10,15),(1,6,11,12),(2,7,8,13),(3,4,9,14)]
MASK = 0xffffffff

def compress(cv, block, length, flags):
    s = list(cv) + IV[:4] + [0, 0, length, flags]
    m = list(struct.unpack('<16I', block))
    def r(x,n):return ((x>>n)|(x<<(32-n)))&MASK
    def g(a,b,c,d,x,y):
        s[a]=(s[a]+s[b]+x)&MASK;s[d]=r(s[d]^s[a],16)
        s[c]=(s[c]+s[d])&MASK;s[b]=r(s[b]^s[c],12)
        s[a]=(s[a]+s[b]+y)&MASK;s[d]=r(s[d]^s[a],8)
        s[c]=(s[c]+s[d])&MASK;s[b]=r(s[b]^s[c],7)
    for _ in range(7):
        for half,positions in enumerate([COLS,DIAGS]):
            for i,p in enumerate(positions):g(*p,m[8*half+2*i],m[8*half+2*i+1])
        m=[m[i] for i in PERM]
    return struct.pack('<8I',*(s[i]^s[i+8] for i in range(8)))

assert compress(IV,bytes(64),0,3|8).hex()=='af1349b9f5f9a1a6a0404dea36dcc9499bcb25c9adc112b7cc9a93cae41f3262'
assert compress(IV,b'abc'+bytes(61),3,3|8).hex()=='6437b3ac38465133ffb63b75273a8db548c558465d79db03fd359c6cd5bd9d85'
lens=[0,1,31,63,64,7,32,55,3,15,48,60,2,33,62,64]
out=b''
for i in range(16):
    shape=[3,2,4][i%3]
    if shape==4:lens[i]=64
    flags=shape|[0,16,32,64][i%4]|(8 if (i//4)%2==0 else 0)
    cv=[((0x1234abcd+i*0x9e37+w*0x1020304)*0x85ebca6b)&MASK for w in range(8)]
    block=bytes((((i*37+j*17)^0x5a)&255) if j<lens[i] else 0 for j in range(64))
    out+=compress(cv,block,lens[i],flags)
h=0xcbf29ce484222325
for b in out:h=((h^b)*0x100000001b3)&((1<<64)-1)
print(f'mixed CV/root startup fold 0x{h:016x}; empty/abc standard vectors passed')
