"""Independent scalar calculation of the three-block uniform startup fixture."""
import importlib.util
import pathlib
import struct
path=pathlib.Path(__file__).with_name('reference-base.py')
spec=importlib.util.spec_from_file_location('reference_compress',path)
ref=importlib.util.module_from_spec(spec);spec.loader.exec_module(ref)
lens=[0,1,31,63,64,7,32,55,3,15,48,60,2,33,62,64]
output=b''
for i in range(16):
    shape=[3,2,4][i%3]
    if shape==4:lens[i]=64
    flags=(shape|[0,16,32,64][i%4])&~11
    cv=[((0x1234abcd+i*0x9e37+w*0x1020304)*0x85ebca6b)&0xffffffff for w in range(8)]
    block=bytes((((i*37+j*17)^0x5a)&255) if j<lens[i] else 0 for j in range(64))
    for b in range(3):
        out=ref.compress(cv,block,lens[i] if b==2 else 64,flags|(1 if b==0 else 0)|(10 if b==2 else 0))
        cv=list(struct.unpack('<8I',out))
    output+=out
h=0xcbf29ce484222325
for byte in output:h=((h^byte)*0x100000001b3)&((1<<64)-1)
print(f'uniform three-block startup fold 0x{h:016x}')
