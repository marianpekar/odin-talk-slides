package main

import "core:fmt"
import "mathutils"

main :: proc() {
    fmt.println(mathutils.square(5)) // 25
    fmt.println(mathutils.sum_of_squares(3, 4)) // 25

    // mathutils.add(1, 2) // Error: because "add" is private
}