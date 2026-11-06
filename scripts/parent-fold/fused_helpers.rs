// Provisional benchmark-only contract: 32 complete chunks -> 16 parent CVs.
unsafe extern "C" {
    fn bench_k32_parent16(inputs: *const *const u8, blocks: u64, key: *const u32, counter: u64, packed_flags: u64, out: *mut u8);
}
fn fused_groups(ptrs: &[*const u8], output: &mut [Block]) {
    assert!(matches!(ptrs.len(),32|64));
    assert!(Block::bytes(output).len()>=ptrs.len()/2*32);
    for (group, inputs) in ptrs.chunks_exact(32).enumerate() {
        unsafe {bench_k32_parent16(inputs.as_ptr(),16,IV.as_ptr(),(group*32) as u64,packed(0,1,2),Block::bytes_mut(output).as_mut_ptr().add(group*16*32))};
    }
}
fn pipeline_fused(ptrs: &[*const u8], a: &mut [Block], b: &mut [Block], output: &mut [u8;64]) {
    if ptrs.len()==16 {return pipeline(ptrs,a,b,output,false);}
    fused_groups(ptrs,a);
    let mut n=ptrs.len()/2;
    while n>2 {
        parent_level(a,n,b);n/=2;
        cv_view_mut(a)[..n].copy_from_slice(&cv_view(b)[..n]);
    }
    root(a,output);
}
fn verify_fused_modes(ptrs: &[*const u8], blocks: &[Block]) {
    if ptrs.len()<32 {return;}
    const CONTEXT: &str="BLAKE3-Servil parent-fold benchmark context";
    let key: [u8;32]=core::array::from_fn(|i|(i*37+11) as u8);
    let cx=blake3::hazmat::hash_derive_key_context(CONTEXT);
    let words=|bytes: &[u8;32]|core::array::from_fn(|i|u32::from_le_bytes(bytes[4*i..4*i+4].try_into().unwrap()));
    let keys=[IV,words(&key),words(&cx)];
    for mode in 0..3 {
        let flags=[0u8,16,64][mode];
        let reference_mode=match mode {0=>RefMode::Hash,1=>RefMode::KeyedHash(&key),_=>RefMode::DeriveKeyMaterial(&cx)};
        for counter in [0u64,32,1u64<<32,(1u64<<54)-64] {
            let expected_leaves: Vec<Cv>=(0..32).map(|i| {
                let mut h=match mode {0=>blake3::Hasher::new(),1=>blake3::Hasher::new_keyed(&key),_=>blake3::Hasher::new_derive_key(CONTEXT)};
                h.set_input_offset((counter+i as u64)*1024);
                h.update(&Block::bytes(blocks)[i*1024..(i+1)*1024]);h.finalize_non_root()
            }).collect();
            let expected: Vec<Cv>=expected_leaves.chunks_exact(2).map(|c|blake3::hazmat::merge_subtrees_non_root(&c[0],&c[1],reference_mode)).collect();
            let mut out=cv_storage(32);Block::bytes_mut(&mut out).fill(0xa5);
            unsafe {bench_k32_parent16(ptrs.as_ptr(),16,keys[mode].as_ptr(),counter,packed(flags,1,2),Block::bytes_mut(&mut out).as_mut_ptr())};
            assert_eq!(&cv_view(&out)[..16],&expected,"fused mode={mode} counter={counter}");
            assert!(Block::bytes(&out)[512..].iter().all(|&b|b==0xa5),"fused output exceeded 16 CVs");
        }
    }
    eprintln!("fused parent CVs verified: plain/keyed/derived, four counters, 512-byte output canary");
}
