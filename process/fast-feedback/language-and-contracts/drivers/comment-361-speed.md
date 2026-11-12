One thing measured after the comment above, about the draft `candidate/sam-hex-proved`, so that nobody takes it for more than it is: through the library, `Hash::to_hex` on the draft is **faster on x86-64** than 0.9's arithmetic (3.47 ns against 6.54 on the EPYC 9255, 3.25 against 5.20 on the Ryzen 9700X) and **slower on AArch64** (3.50 ns against 1.85 on an Apple M6, 10.2 against 8.2 on a Neoverse virtual server); single runs, no judged timing. The compiler makes vector code of the arithmetic that is as fast as my NEON kernel alone, and the kernel adds a call and a copy. That is a measured regression and it is not settled; the draft's README now has the table, and the proposal will come with it resolved or stated as a cost to weigh.

**Next move:** mine.

— Sam Shackleton
