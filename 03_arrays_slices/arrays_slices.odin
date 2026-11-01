// Partially taken from https://gingerbill.gitbooks.io/odin-by-example/content/primitives/arrays-slices-and-vectors.html and updated

package main

import "core:fmt"

// An array is a collection of things of the same type T, stored in contiguous memory. An array type is composed [size]T.
main :: proc() {
    // Fixed-size array literal
    x := [5]i32{1, 2, 3, 4, 5}
    y: [64]i32 // All elements are initialized to the "zero value"

    n := x[4] // n = 5
    y[32] = 999 // y = [0, 0, 0, ... 999 at index 32 ...0, 0, 0] 

    // Since the stack frame of each procedure has a limited amount of memory available, 
    // making a giant fixed array is a common way to run out of stack memory.
    // lots_of_ints: [999_999_999]i128 // Warning: May blow up the stack!
    
    arr_on_heap := make([]i128,999_999_999)
    defer delete(arr_on_heap)

    // Array literal where the size is determined by the number of elements
    z := []i32{1, 2, 3, 4, 5}

    // Slices, "a window into part of an array"
    s: []i32
    s = x[:]      // Slice entire array `x` => {1, 2, 3, 4, 5}
    s1 := x[1:3]  // Slice of `x` starting from index 1, up to (not including) index 3 => {2, 3}
    s2 := x[:4]   // Slice of `x`, starting from index 0 (start), up to (not including) index 4 => {1, 2, 3}
    s3 := x[2:]   // Slice of `x`, starting from index 1, up to end => {1, 2, 3}

    fmt.printfln("s = %v", s)
    fmt.printfln("s1 = %v", s1)
    fmt.printfln("s2 = %v", s2)
    fmt.printfln("s3 = %v", s3)
    fmt.println()

    // Dynamic Array
    // intiial capacity = 8 (doubles when exceeded)
    dyn: [dynamic]int
    append(&dyn, 1)
    
    print_dynarr(dyn)

    for i in 2..<9 { // for i between 2 and 9 (not included)
        append(&dyn, i)
    }
    print_dynarr(dyn) // capacity = lenght = 8

    append(&dyn, 9)
    print_dynarr(dyn) // capacity = 16, lenght = 9

    for i in 10..<18 {
        append(&dyn, i)
    }
    print_dynarr(dyn) // capacity = 32, lenght = 17

    // (We'll get more into procedures in 04_flow)
    print_dynarr :: proc(dyn: [dynamic]$T) {
        fmt.printfln("dyn = %v (capacity: %v, lenght %v)", dyn, cap(dyn), len(dyn)) 
    }

    // __Fixed__ Dynamic Array
    f_dyn: [dynamic; 64]int
    append(&f_dyn, 1)
    fmt.printfln("f_dyn = %v (capacity: %v, lenght %v)", f_dyn, cap(f_dyn), len(f_dyn)) // capacity = 64, lenght = 1

    for i in 2..<999 {
        append(&f_dyn, i)
    }
    fmt.printfln("f_dyn = %v (capacity: %v, lenght %v)", f_dyn, cap(f_dyn), len(f_dyn))  // capacity = 64, lenght = 64 (no error, 65-998 are just ignored)
    fmt.println()

    // Swizzling, .xyzw .rgba, Array Programming
    q: [4]f32
    q.x = 1 // same as q[0] = 1
    q.y = 2 // same as q[1] = 2 and so on...
    q.z = 3  
    q.w = 4 // .w or .a (see color below) is last, no such love for 5th and other elements

    q = q + 1 // [1, 2, 3, 4] + 1 = [1+1, 2+1, 3+1, 4+1] = [2, 3, 4, 5]

    q = q * 2 // [2, 3, 4, 5] * 2 = [2*2, 3*2, 4*2, 5*2] = [4, 6, 8, 10]

    t: [2]f32 = q.xz // [4, 8]
    u: [3]f32 = q.www // [10, 10, 10]

    t.xy = t.yx // Swap values, t = [8, 4]

    fmt.printfln("q = %v", q)
    fmt.printfln("t = %v", t)
    fmt.printfln("u = %v", u)

    color: [4]u8
    color.rgb = 255
    color.a = 128
    fmt.printfln("color = %v", color)

}


