package main

import "core:fmt"

Vector2 :: struct {
    x, y: f32
}

main :: proc() {
    x := 10
    ptr := &x // The ptr is of type ^int, &x reads as "address of x"
    fmt.println(ptr^) // Dereferencing ptr with ^ on the right 
    ptr^ = 20
    fmt.println(x) // 20 (x was changed through ptr)

    // See comment above increment()
    increment(&x) // Passing by reference with & on the left
    fmt.println(x) // 21

    // See comment above move()
    v := Vector2{1, 2}
    move(&v, 5, 5)
    fmt.println(v)   // Vector2{x = 6, y = 7}

    // nil
    q: ^int // zero value is nil
    if q == nil {
        fmt.println("q is nil")
    }

    // Pointer to an array element
    arr := [3]int{1, 2, 3}
    e := &arr[1]
    e^ = 99
    fmt.println(arr) // [1, 99, 3]

    // Multi-pointer [^]T is a pointer to many elements and is indexable
    mp: [^]int = raw_data(arr[1:])
    fmt.println(mp[1]) // 3
}


// Takes an explicit pointer, so the caller's value is modified.
// Plain (non-pointer) parameters are immutable and have value semantics.
// The compiler may pass them by copy or by immutable reference, whichever is
// more efficient (e.g. large structs), but you can't tell the difference
// because you can't modify them.
// So use ^T when you need to mutate the caller's data, not for performance.
increment :: proc(n: ^int) {
    n^ += 1
}

// Pointers to structs auto-dereference with "."
move :: proc(v: ^Vector2, dx, dy: f32) {
    v.x += dx
    v.y += dy
}