"""Probe for #196 (splitwake), on probe/l3-pool-split 52f894f0: a stream's wakes go to parked
primaries only (a domain's first `cores` workers), so a domain whose primaries all run passes the
wake to the next domain, where -split's woke a second worker that may not take it. Job wakes are
unchanged. Usage: splitwake_patch.py TREE"""
import sys, pathlib

tree = pathlib.Path(sys.argv[1])


def sub(path, a, b, n=1):
    p = tree / path
    s = p.read_text()
    assert s.count(a) == n, f"{path}: {a[:60]!r} found {s.count(a)} times"
    p.write_text(s.replace(a, b))


# park.rs: wake one parked worker below `limit`.
sub("src/park.rs", """    /// Wake workers for `wanted` pieces of new work, given `workers`
""", """    /// Wake one parked worker of index below `limit`, if any (PROBE #196,
    /// splitwake: a stream's wake, for a primary).
    pub(crate) fn wake_one_below(&self, limit: usize) -> bool {
        for (w, (word, handles)) in self.parked.iter().zip(self.handles.chunks(64)).enumerate() {
            let below = limit.saturating_sub(w * 64);
            if below == 0 {
                break;
            }
            let mask = if below >= 64 { u64::MAX } else { (1u64 << below) - 1 };
            let mut bits = word.load(Ordering::SeqCst) & mask;
            while bits != 0 {
                let bit = 1u64 << bits.trailing_zeros();
                let before = word.fetch_and(!bit, Ordering::SeqCst);
                if before & bit != 0 {
                    handles[bit.trailing_zeros() as usize].get().expect("a parked worker has set its thread").unpark();
                    return true;
                }
                bits = before & !bit & mask;
            }
        }
        false
    }

    /// Wake workers for `wanted` pieces of new work, given `workers`
""")

# lanes.rs: the stream's wake.
sub("src/lanes.rs", """    /// Whether `domain` runs as many stream tasks as it has cores (PROBE
""", """    /// Domain `d`'s primaries: its first workers, one a core (all of them
    /// where the cores are unknown). PROBE #196, splitwake.
    fn primaries(&self, d: usize) -> usize {
        let c = self.core_cpus.get(d).map_or(0, |c| c.len());
        if c == 0 { usize::MAX } else { c }
    }

    /// Wake one parked primary for a stream's task: of `domain`, or, where
    /// it is busy, of another domain first (EVERY: of any). PROBE #196,
    /// splitwake.
    pub(crate) fn wake_stream(&self, domain: u32) -> bool {
        if self.one {
            return self.park.wake_one_below(self.primaries(0));
        }
        if domain == EVERY {
            return self.parks().enumerate().any(|(d, p)| p.wake_one_below(self.primaries(d)));
        }
        if self.busy(domain) {
            return self.parks().enumerate().any(|(d, p)| d != domain as usize && p.wake_one_below(self.primaries(d)))
                || self.park_of(domain as usize).wake_one_below(self.primaries(domain as usize));
        }
        self.park_of(domain as usize).wake_one_below(self.primaries(domain as usize))
    }

    /// Whether `domain` runs as many stream tasks as it has cores (PROBE
""")
sub("src/lanes.rs", """            if p + 1 - self.claimed.load(Ordering::Relaxed) >= 2 {
                pool.wake_one(domain);
            }""", """            if p + 1 - self.claimed.load(Ordering::Relaxed) >= 2 {
                pool.wake_stream(domain);
            }""")
sub("src/lanes.rs", """            if self.waiting() > 0 {
                pool.wake_one(self.domain.load(Ordering::Relaxed));
            }""", """            if self.waiting() > 0 {
                pool.wake_stream(self.domain.load(Ordering::Relaxed));
            }""")
sub("src/lanes.rs", """            if source.waiting() >= 2 {
                pool().wake_one(source.domain.load(Ordering::Relaxed));
            }""", """            if source.waiting() >= 2 {
                if source.ring.is_empty() {
                    pool().wake_one(source.domain.load(Ordering::Relaxed));
                } else {
                    pool().wake_stream(source.domain.load(Ordering::Relaxed));
                }
            }""")
print("splitwake patched")
