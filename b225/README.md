# The EPYC check of #225-#227 (Devon, BLAKE3 #219)

bench-hashes 0.20.4 check of c6ab3318 against servil 1a06dfd6 (the stack's merge-base), the cells the change touches. check.out: no cell slower in either stage. (Samples kept on the machine.)

## AArch64 twins

`twins.sh` (run b225-twins2-ampereone): the 67 known-aarch64.txt rows whose x86-64 twins #225-#227 catch, every place applied on the AmpereOne (Linux, FEAT_SHA3, no SME2) at c6ab3318, the library's tests in the mutants profile: all 98 places caught. `aarch64-twins-caught.txt` lists them.
- `twins228.sh` (run b228-twins-ampereone): #228's 15 AArch64 twins at 9c58fe97, all caught (`aarch64-twins-228.txt`).
