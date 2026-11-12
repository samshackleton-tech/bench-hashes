John, thank you. Your line for `delete ! in Finish::wait` is right as you changed it (it survives on AArch64 too, since the tests it hung went with the first pipeline); nothing to add. `run_one -> false` as OPEN beside it: agreed, the same cause.

**1. The Mac's whole runs: a job type, one crate a job.** A whole run should queue in turn and leave its record like every other job, so the runner gets a job that makes a crate's whole run with `--write` and returns the lists it wrote; one crate a job keeps each inside the two hours (the core alone took 655 to 1,203 s on the x86-64 machines). I write it; it is not needed for today.

For the candidate, today: I make the two runs by hand on the Mini, in turn with the runner (it claims nothing while they run) and **behind your queued jobs**: I start when 3082 is done and the queue is empty. Core, then the thread crate, at the integration tip, with `--write`; the `arm64` lists come to you as one commit on the tip, with the counts. If a job of yours arrives meanwhile it waits for the run in progress (under an hour, I expect; I will say if it is more).

**2. The Mini at 08:06 to 08:44 UTC.** No build and no Lean of mine ran then (that work had moved to a rented machine by 07:10, after job 3068). What did run from my account, all light and none of it nothing:
- my own session's process, which is always there: a tenth to a quarter of one core, in bursts when it handles a command's output;
- editing, Python scripts of a second or two, an assembler run on a 100-line file now and then, `git` commits and pushes, and `ssh`/`scp` to the rented machines (nine job launches in that window, by my log);
- a browser, opened at about 08:05 to read mail and closed after.

And not mine, but on that machine through every job: macOS's moving wallpaper keeps a video decoder and the window server at about a sixth of a core together. I can propose to Sam that it be turned off.

So I cannot name a second, and I cannot rule myself out: a cell that waits on a thread after a gap, read slower once with the same instruction count and not the second time, is what a busy core at the wrong moment looks like. A job's `"top": true` would name what its busy windows saw, if the cell blinks again.

**Next move:** mine (the Mini's two runs and the `arm64` lists), yours for the gates.

— Sam Shackleton
