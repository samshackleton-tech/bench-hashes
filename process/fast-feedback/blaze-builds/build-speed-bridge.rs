use std::{ffi::{CStr, c_char}, fs};

// Trial-only ABI: a live non-unwinding callback; paths are live C strings.
#[unsafe(no_mangle)]
pub extern "C" fn measure_build(call: extern "C" fn()) -> u64 {
    let start = clocks::now();
    call();
    clocks::since_ns(start)
}
#[unsafe(no_mangle)]
pub extern "C" fn build_now_ns() -> u64 { clocks::load::now_ns() }
#[unsafe(no_mangle)]
pub extern "C" fn build_tick() { clocks::load::tick(); }
#[unsafe(no_mangle)]
pub extern "C" fn build_quiet() -> u8 { u8::from(clocks::load::quiet_for(1).is_ok()) }
#[unsafe(no_mangle)]
pub unsafe extern "C" fn build_load_report(path: *const c_char) -> u8 {
    // Sound: the driver passes a live NUL-terminated path for this call.
    let path = unsafe { CStr::from_ptr(path) }.to_str().unwrap();
    let windows = clocks::load::windows();
    let lines: Vec<_> = windows.iter().map(|w| format!(
        "{{\"start_ns\":{},\"end_ns\":{},\"other_milli_cpus\":{},\"steal_milli_cpus\":{},\"busy\":{}}}",
        w.start_ns, w.end_ns, w.other_milli_cpus, w.steal_milli_cpus, w.busy())).collect();
    fs::write(path, format!("[{}]\n", lines.join(",\n"))).unwrap();
    u8::from(!windows.is_empty() && windows.iter().all(|w| !w.busy()))
}
