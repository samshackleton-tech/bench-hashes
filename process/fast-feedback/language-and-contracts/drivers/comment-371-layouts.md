John, the three questions, then the last paragraph.

**1. `repr(C)` in the order the compiler chose: yes, take it first.** A statement needs the layout *stated*, so that the next compiler cannot move it; it does not care which layout. Byte for byte the same, checked by the bench's same-code check, is the right way to get there.

**2. `CvStack`: an array that may be unmade, and `len` as the only state.** `len` first, then the 55 values, `repr(C)`: the count at byte 0, value *i* at 8 + 32·*i*. The statement then reads "the first `len` values are the stack, the newest last; the bytes after them are not read", which is what `merge` and `push` do anyway. An explicit made-or-not field would be one more thing every statement must mention and every proof must carry; with `len` alone there is nothing to say about an empty stack but `len = 0`. (My proof of the crate's `merge` as compiled took the places of `len` and of the values from reading the build; that is the part that would go.)

**3. Padding: "not read" is enough; no zeroes needed.** My statements speak of a type's fields as pieces of memory, each kept or changed, and of everything else as unchanged. For padding one line covers it: the function may write those bytes and promises nothing of their contents. That also covers a copy of the whole struct, which reads and writes padding and means nothing by it. I would not make them named fields.

One point for the secrets property, to keep in mind and not to act on: padding that a copy carries along can hold old bytes of a key or an input. That is a matter of what leaves the library (it must never serialize a struct's raw bytes), not of layout.

**Which types need a fixed layout at all.** Those a separately proved unit reaches through a pointer, where the unit's statement says what the memory holds:

| type | needed? | why |
|---|---|---|
| `CvStack` | yes | `merge` and `push` are stated over it |
| `ChunkState` | yes | the chunk's update is stated over it, and the kernels read `buf` at its 64-byte boundary |
| `Output` | yes, and it is `repr(C)` already | `parent_output`, the chaining value and the root are stated over it |
| `HasherCore` | only if a unit takes it whole | if the tree walk's loop takes `&mut HasherCore`, its statement names `chunk_state`, `key` and `cv_stack` inside it. If the loop takes the three parts as their own pointers, never |
| `Hasher` | no | the staging is the adapter's; no unit I would prove takes a `Hasher` |

So: the free step (question 1) for all five costs nothing and I would take it for all five, since it also ends "the compiler's choice" for anyone reading a core dump. The one real change is `CvStack`. For `HasherCore`, shape the walk's unit whichever way is faster and tell me; I state it either way.

Where my statements name an offset today: only in one definition per type (for the stack: where the count is, where value *i* is, how many bytes in all). Every contract and proof goes through that definition, so when you fix a layout I change that one place.

**Next move:** yours, after 0.9. Nothing here is asked before it.

— Sam Shackleton
