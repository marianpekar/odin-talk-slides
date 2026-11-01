package main

import "core:fmt"
import "core:simd"

main :: proc() {
    // A SIMD vector type: 4 x f32 is processed in one instruction
    a := #simd[4]f32{1, 2, 3, 4}
    b := #simd[4]f32{10, 20, 30, 40}

    // Normal operators work lane bylane
    c := a + b
    d := a * b
    fmt.println("c = %v", c) // <11, 22, 33, 44>
    fmt.println("d = %v", d) // <10, 40, 90, 160>

    // Read one lane
    fmt.println(simd.extract(c, 0), simd.extract(c, 3)) // 11 44

    // Convert to/from regular arrays
    arr := simd.to_array(c) // [4]f32
    vector := simd.from_array([4]f32{5, 6, 7, 8})
    fmt.println("arr = %v", arr)
    fmt.println("vector = %v", vector)

    // Reduce a vector to a scalar by adding up all the lanes in an ordered fashion.
    fmt.println("sum: %v", simd.reduce_add_ordered(a)) // 1 + 2 + 3 + 4 = 10

    dot := simd.reduce_add_ordered(a * b) // Dot product => multiply lanes, then sum them
    fmt.println("dot product: %v", dot) // 300
}

// See https://pkg.odin-lang.org/core/simd/