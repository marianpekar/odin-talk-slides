package main

import "core:fmt"
import "core:mem"
import "core:mem/virtual"
import "core:strings"

main :: proc() {
    {
        // Arena with a fixed buffer on stack
        buf: [1024]byte
        arena: mem.Arena
        mem.arena_init(&arena, buf[:])
        allocator := mem.arena_allocator(&arena)

        a := new(int, allocator)
        b := make([]f32, 8, allocator)
        a^ = 7
        b[0] = 1.5
        fmt.printfln("a = %v, b = %v", a^, b[0]) // 7, 1.5

        // Free everything (a and b) in one go
        free_all(allocator)
    } // but the buffer lives on the stack, so there is nothing else to free at the end of this scope

    // Swapping context.allocator
    {
        buf: [512]byte
        arena: mem.Arena
        mem.arena_init(&arena, buf[:])

        context.allocator = mem.arena_allocator(&arena)

        x := new(int) // now allocates from the arena
        x^ = 1
        fmt.printfln("x = %v", x^) // 1
    } // context.allocator is restored when the scope ends

    {
        // Growing arena (virtual memory)
        arena: virtual.Arena
        err := virtual.arena_init_growing(&arena, reserved = 4*mem.Kilobyte)

        defer virtual.arena_destroy(&arena)
        allocator := virtual.arena_allocator(&arena)

        items := make([dynamic]string, allocator)
        append(&items, strings.clone("one", allocator))
        append(&items, strings.clone("two", allocator))
        fmt.println(items) // ["one", "two"]

    } // again, no per-item delete, arena_destroy frees everything


    {
        // Tracking allocator finds leaks during development
        track: mem.Tracking_Allocator
        mem.tracking_allocator_init(&track, context.allocator)
        defer mem.tracking_allocator_destroy(&track)
        context.allocator = mem.tracking_allocator(&track)

        leaked := new(int)
        _ = leaked

        for _, entry in track.allocation_map {
            fmt.eprintfln("leak: %v bytes at %v", entry.size, entry.location)
        }
    }
} 

