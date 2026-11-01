package main

import "core:fmt"
import "core:unicode/utf8"
import "core:time"
import "core:os"

REVERSE :: #config(REVERSE, false) // Compile with -define:REVERSE=true flag to set to true, false is default

// Built-in constants: ODIN_ARCH, ODIN_DEBUG, ODIN_DISABLE_ASSERT and many more (see https://odin-lang.org/docs/overview/#command-line-defines)

main :: proc() {
    str := "😁こんちは世界"

    if !REVERSE { 
        fmt.println(str)
    } else {
        fmt.println(reverse_string(str))
    }

    when REVERSE { // Compile-time "if", condition must be a compile-time constant
        fmt.println(reverse_string(str))
    }

    // The if block with compile-time constant condition when compiling with optimization flag -o:speed 
    // will be optimized, in other words, the effect would be as if when was used.
    // (see for yourself at https://godbolt.org)

    assert_example()

    // Switch
    now := time.now()
    day := time.weekday(now)
    day_jp: string
    weekend := false
    switch day { 
        case .Sunday: day_jp = "日曜日"; weekend = true // ; to split staements, or use brackets => { multiple lines }
        case .Monday: day_jp = "月曜日"
        case .Tuesday: day_jp = "火曜日"
        case .Wednesday: day_jp = "水曜日"
            fallthrough // No "break" like in C, "fallthrough" is the opposite = omitting "break" in C
        case .Thursday: day_jp = "木曜日"
        case .Friday: day_jp = "金曜日";
        case .Saturday: day_jp = "土曜日"; weekend = true
    }
    fmt.printfln(day_jp)
    if !weekend do fmt.printfln("仕事"); else do fmt.printfln("休んでいる") // The "do" can replace brackets (nice touch for one-liners)

    // Odin has no "while" keyword
    is_running := true
    for is_running { // Loops while is_running = true
        fmt.println("Write 'q' to quit: ")
        buf: [256]byte
        n, err := os.read(os.stdin, buf[:])
        if err != nil {
            fmt.eprintln("Error: ", err)
        }
        if n > 0 && buf[0] == 'q' do is_running = false
    }
}

// Procedures
reverse_string :: proc (str: string) -> string {
    reversed: [dynamic]rune
    // The "defer" keyword moves the delete(reversed) to the end of the scope, can move an entire scope too: defer { multiple lines }
    defer delete(reversed) 
    #reverse for c in str { // Loops from high to low (or from top to bottom, or right to left, whatever you prefer)
        append(&reversed, c)
    }
    return utf8.runes_to_string(reversed[:])
}

assert_example :: proc() {
    bar :: 3
    #assert(bar == 3) // compile-time

    foo := []int{0,1,2,3} 
    assert(len(foo) == 4) // run-time
}

// Common pattern: returning tuple (value, ok), but #optional_ok lets callers ignore ok
find_index :: proc(haystack: []int, needle: int) -> (index: int, ok: bool) #optional_ok {
    for v, i in haystack {
        if v == needle {
            return i, true
        }
    }
    return 0, false
}

// Context is always with you... unless you say you don't want to, see contextless_procedure() bellow
procedure :: proc() {
    // Default allocator, used by make, new, delete, append, etc. when none is given explicitly
    allocator := context.allocator

    // Allocator for short-lived memory, typically freed in bulk with free_all(context.temp_allocator)
    temp_allocator := context.temp_allocator
    
    // More about allocations in 07_allocations, especially in 07_allocations/02_arenas


    // Called when assert/panic/ensure fails, lets you customize how the program reports it and exits
    assertion_failure_proc := context.assertion_failure_proc 

    // Logger used by the log.* procedures (log.info, log.error, ...); swap it to redirect or filter logs
    logger := context.logger

    // Source of randomness used by core:math/rand when no generator is passed explicitly
    random_generator := context.random_generator

    // Free-form pointer for your own data, handy for passing state through callbacks and library code
    user_ptr := context.user_ptr

    // Free-form integer for your own use, e.g. an ID or index, alongside user_ptr
    user_index := context.user_index
}

contextless_procedure :: proc "contextless" () {
    // The context is not available here,

    // "The Odin compiler can optimize that out in most cases when optimizations are applied.
    // Only use "contextless" when you know you need to use it." -Bill Hall, Odin's creator, forum.odin-lang.org
}