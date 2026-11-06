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

    h2 := new(int)
    free(h2)
    // Freeing a pointer that has already been freed is undefined behavior.
    // With the default heap allocator it typically aborts.
    // free(h2) // free(): invalid pointer ... terminated by signal SIGABRT (Abort)

    // When dereferencing an already freed pointer you will usually get garbage.
    fmt.printfln("h2 = %v", h2^) // e.g. h2 = -1710449640207703144

    // Setting pointer to nil after freeing might help to catch this type of bugs earlier
    h2 = nil
    fmt.printfln("h2 = %v", h2^) // h2 = <nil>

    fmt.printfln("h = %v", h^)
} // h is freed here

