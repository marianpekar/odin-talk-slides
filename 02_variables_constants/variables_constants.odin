package main

import "core:fmt"

// Compile-time constants (name :: value)
PI :: 3.1415692
TAU :: f32(PI*2)

main :: proc() {
    // Declaration (name: type)
    a: int
    b: f32
    c: string

    // Declaration + initialization (name := value, or name: type = value)
    r := 8 // int (: declaration, = assignment)
    s: i64 = 16
    t := i32(8) // i32 is not alias for int, int is a distinct platform-sized type (64-bit on 64-bit targets)
    
    // r = 2.5 // => Error: no implicit casting between *typed* values...
    r = 2.0    // ...but this is ok, because untyped constant 2.0 is exactly 2, so it converts


    // Assignment
    a = 1
    r = 4

    // o := r*TAU => Error: no implicit casting in Odin!
    u := f32(r)*TAU

    // Built-in types with self-explanatory type names:
    // i8, i16, i32, i64, i128, u8, u16, u32, u64, u128 (compare with short, word, dword, int, long)
    // f16, f32, f64 ... (IEEE 754 Floating-Point Arithmetic standard)
    // i8be (big-endianness), i8le (little-endianness), i16be, f64le, i128be ...
    // complex32 (f16 real and imaginary parts), complex64, complex128
    // quaternion64 (f16 real and imaginary (i, j, & k) parts)
    // See https://pkg.odin-lang.org/base/builtin/
    rot := quaternion128(0.707+0i+0j+0.707k)

    w,i,j,k := rot.w, rot.x, rot.y, rot.z

    fmt.printfln("rot = %v ", rot) // 0.707+0i+0j+0.707k 
    fmt.printfln("i=%v j=%v k=%v w=%v ", i, j, k, w) // i=0 j=0 k=0.707 w=0.707 

    mask: u8 = 0b01010101
    bits: = 64 & mask

    fmt.printfln("bits: %b ", bits) // 1000000 (0 on the left not printed) 

    hex := 0xFF
    long_number := 999_999_999 // Sweet syntactic sugar, underscore is ignored => the value is 9999999999 
                               // Did you noticed I added one extra 9? The value is actually 99999999...
                               // ...nah, I removed two 9s. Seriously now, the value is 999999999 (or isn't?)
    
    // string, string16 (cstring, cstring16 for interoperability with C)
    kana := "なに"
    kanji := '何' // rune ''
    romanji := "nani"

    fmt.printfln("%v %v %v", kana, kanji, romanji)
    // More about formatting at https://pkg.odin-lang.org/core/fmt/
}