package main

import rl "vendor:raylib" // rl for short, otherwise we'd have to write raylib. instead of rl. everywhere

main :: proc() {
    rl.InitWindow(800, 600, "Hello raylib")
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        defer rl.EndDrawing()

        rl.ClearBackground(rl.BLACK)
        rl.DrawText("We have a game loop...\nalmost (:", 200, 200, 50, rl.GREEN)
    }
}

// See https://www.raylib.com/cheatsheet/cheatsheet.html