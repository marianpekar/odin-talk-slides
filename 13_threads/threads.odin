package main

import "core:fmt"
import "core:sync"
import "core:thread"

Work :: struct {
    id: int,
    counter: ^int,
    mtx: ^sync.Mutex,
}

DISABLE_MUTEX :: #config(DISABLE_MUTEX, false)

worker :: proc(w: Work) {
    fmt.printfln("thread %d started", w.id)

    for _ in 0..<10_000_000 {
        when !DISABLE_MUTEX do sync.mutex_lock(w.mtx)
        w.counter^ += 1
        when !DISABLE_MUTEX do sync.mutex_unlock(w.mtx)    
    }

    fmt.printfln("thread %d finished", w.id)
}

main :: proc() {
    NUM_THREADS :: 4
    counter: int
    mtx: sync.Mutex

    threads: [NUM_THREADS]^thread.Thread

    // Start 4 threads, each gets its own copy of a Work struct
    for i in 0..<len(threads) {
        threads[i] = thread.create_and_start_with_poly_data(
            Work{id = i, counter = &counter, mtx = &mtx},
            worker,
        )
    }

    // Wait for all of them, then free the thread handles
    thread.join_multiple(..threads[:])
    for t in threads {
        thread.destroy(t)
    }

    fmt.println("counter =", counter) // 40 000 000, unless compiled with -define:DISABLE_MUTEX=false, then most likely much less (e.g. 11 634 110)
}

// See https://pkg.odin-lang.org/core/thread and https://pkg.odin-lang.org/core/sync