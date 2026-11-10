| `admission.rs` | `replace && with \|\| in <impl Drop for Acquire<P, T>>::drop` | survives | survives |
| `admission.rs` | `replace += with -= in <impl Future for Acquire<P, T>>::poll` | survives | survives |
| `stream/frontend.rs` | `delete ! in Message<'_, 'a, T, F>::input` | survives | survives |
| `stream/frontend.rs` | `delete ! in Stream<'a, T, F>::admit` | survives | survives |
| `stream/frontend.rs` | `delete ! in Stream<'a, T, F>::ready` | survives | survives |
| `stream/frontend.rs` | `replace && with \|\| in Stream<'a, T, F>::admit` | survives | survives |
| `stream/frontend.rs` | `replace += with *= in Stream<'a, T, F>::collect` | survives | survives |
| `stream/frontend.rs` | `replace += with -= in Stream<'a, T, F>::collect` | survives (2 places) | survives (2 places) |
| `stream/frontend.rs` | `replace <impl std::task::Wake for NotifyWake>::wake with ()` | times out | times out |
| `stream/frontend.rs` | `replace <impl std::task::Wake for NotifyWake>::wake_by_ref with ()` | times out | times out |
| `stream/frontend.rs` | `replace == with != in Stream<'a, T, F>::admit` | survives | survives |
| `stream/frontend.rs` | `replace Stream<'a, T, F>::collect -> usize with 1` | times out | caught |
| `stream/frontend.rs` | `replace Stream<'a, T, F>::ready with ()` | survives | survives |
| `stream/receiver.rs` | `delete ! in Core::forget` | times out | times out |
| `stream/receiver.rs` | `replace != with == in Core::consume` | times out | caught |
| `stream/receiver.rs` | `replace != with == in Core::finalize_if_idle` | times out | times out |
| `stream/receiver.rs` | `replace && with \|\| in Core::forget` | survives | survives |
| `stream/receiver.rs` | `replace && with \|\| in Message::end` | survives | survives |
| `stream/receiver.rs` | `replace + with * in Receiver::core` | survives | survives |
| `stream/receiver.rs` | `replace > with >= in Message::end` | survives | survives |
| `stream/receiver.rs` | `replace Core::consume with ()` | times out | times out |
| `stream/receiver.rs` | `replace Core::finalize_if_idle with ()` | times out | times out |
| `stream/receiver.rs` | `replace Receiver::help -> bool with false` | survives | survives |
| `stream/receiver.rs` | `replace Receiver::help -> bool with true` | times out | survives |
