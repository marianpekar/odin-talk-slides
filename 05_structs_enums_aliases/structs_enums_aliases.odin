package main

import "core:fmt"

// Declaration (use :: as with constants)
Square :: struct {
    // x: f32 = 1.0 // Error: default parameters are only allowed for procedures
    x: f32,
    y: f32,
    size: f32
}

// Aliases (again, use :: as with constants. Syntax make sense, once struct or alias is declared like this, the name is reserved, like a constant)
Vector2 :: [2]f32
Vector3 :: [3]f32
Matrix4x4 :: [4][4]f32

// Player struct shows usage of enum and using keyword
Player :: struct {
    name: string,
    class: Class,
    position: Vector2,
    using stats: PlayerStats // The "using" keyword makes fields of PlayerStats directly accessible on Player
}

PlayerStats :: struct {
    str: int,
    dex: int,
    int: int // This is fine! *dog sitting on a chair in a burning room*...
}

Class :: enum {
	Fighter, // 0
	Mage,    // 1
	Ranger   // 2
}

main :: proc() {
    s: Square // Fields will be zero initialized.

    s2: Square = { size = 20 } // x = y = 0

    // No need to provide field names.
    // I'm not sure if I'm a big fan of this, maybe when name is self-explanatory like Vector3 or struct would have just one member, 
    // but in both cases I'd use alias.
    s3 := Square { 10, 10, 5 }

    fmt.printf("s = %v\n", s)
    fmt.printf("s2 = %v\n", s2)
    fmt.printf("s3 = %v\n", s3)

    p1 := Player {
        name = "Bob",
        class = .Mage,
        str = 2,
        dex = 5,
        int = 12 // ... it's valid, but syntax highlighter is confused (and I don't blame it)
    }

    fmt.printf("p1 = %v\n", p1)
}

