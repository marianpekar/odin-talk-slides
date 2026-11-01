package main

import "core:fmt"
import "core:strings"

main :: proc() {
    // Heap allocation with new/free
    h := new(int)
    defer free(h)
    h^ = 42

    {
        // Think of context.temp_allocator as of a short-lived scratch memory.
        // Nothing is freed individually and one free_all releases everything.
        defer free_all(context.temp_allocator)

        s := fmt.tprintf("hello %d", 123) // tprintf allocates on temp
        t := strings.clone("copy me", context.temp_allocator)
        tmp := make([]int, 100, context.temp_allocator)

        fmt.printfln("s = %v, t = %v, length of tmp is %v", s, t, len(tmp))
        // no delete needed for s, t or tmp
    }   // temp memory released here

    fmt.printfln("h = %v", h^)
} // h is freed here

