package main

import "core:fmt"

Circle :: struct { r: f32 }
Rectangle :: struct { w, h: f32 }

// A union holds exactly one of its variants and remembers which one.
// The default value is nil
Shape :: union { Circle, Rectangle }

main :: proc() {
    s: Shape
    fmt.println(s == nil) // true

    s = Circle{r = 1.96}
    fmt.printfln("Circle area: %v", calc_area(s)) // Circle area: 12.06874

    s = Rectangle{3, 4}
    fmt.printfln("Rectangle area: %v", calc_area(s)) // Rectangle area: 12

}

calc_area :: proc(s: Shape) -> f32 {
    switch v in s {
        case Circle: return 3.141592 * v.r * v.r
        case Rectangle: return v.w * v.h
        case nil: return 0
    }
    return 0
}

// Maybe(T) is just a union with one variant: union { T }
// Useful when the zero value of T is valid, so you can't use it to mean "absent".
find_index :: proc(haystack: []int, needle: int) -> Maybe(int) {
    for v, i in haystack {
        if v == needle {
            return i
        }
    }
    return nil
}