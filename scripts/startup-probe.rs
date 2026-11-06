fn main(){
    // Initialize the measurement machinery before the first B3 call.
    clocks::load::tick();let _=clocks::Counts::read();let _=clocks::process_cpu_ns();let _=clocks::now();
    for phase in ["first","already_initialized"]{
        let c=clocks::Counts::read();let cpu=clocks::process_cpu_ns();let t=clocks::now();
        blake3_servil::initialize();
        let wall=clocks::since_ns(t);let cpu=clocks::process_cpu_ns()-cpu;let c=c.zip(clocks::Counts::read()).map(|(a,b)|b.since(a));
        clocks::load::tick();
        println!("{phase}\t{wall}\t{cpu}\t{}\t{}",c.map_or(0,|c|c.p.cycles+c.e.cycles),c.map_or(0,|c|c.p.instructions+c.e.instructions));
    }
}
