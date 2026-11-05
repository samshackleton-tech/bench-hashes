// Probe (not for merging): long messages through submit_with, digests against convenience::hash.
#![cfg(feature = "std")]
use blake3_servil::{Hash, Mode};
#[test]
fn long_messages_through_submit_with() {
    let threads = std::env::var("PROBE_THREADS").ok().and_then(|v| v.parse().ok()).and_then(std::num::NonZeroUsize::new);
    blake3_servil::initialize_multithreaded(threads);
    for &len in &[9usize << 20, 17 << 20, 40 << 20] {
        let msg: Vec<u8> = (0..len).map(|i| (i * 13 + i / 4093) as u8).collect();
        let mut place = Hash::from([0; 32]);
        let mut places = vec![Hash::from([0; 32]); 3];
        blake3_servil::performance::stream(Mode::Plain, |_| {}, |s| {
            s.submit_with(len, |at, room| { room.copy_from_slice(&msg[at..][..room.len()]); room.len() }, &mut place);
            for p in places.iter_mut() { s.submit_with(len, |at, room| { room.copy_from_slice(&msg[at..][..room.len()]); room.len() }, p); }
            s.finish();
        });
        let want = blake3_servil::convenience::hash(&msg);
        assert_eq!(place, want, "{len} bytes");
        for p in &places { assert_eq!(*p, want, "{len} bytes, back to back"); }
    }
}
