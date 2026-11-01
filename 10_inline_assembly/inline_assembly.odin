package main

import "core:fmt"

when ODIN_ARCH == .amd64 {
    add :: asm(x, y: u64) -> (r: u64) {
        mov r, x
        add r, y
    }
}

main :: proc() {
    when ODIN_ARCH == .amd64 {
        x := add(1, 2)
        fmt.println(x) // 3
    } else {
        fmt.printfln("Not supported on %v", ODIN_ARCH)
    }
}

// For more see https://odin-lang.org/docs/inline-asm/