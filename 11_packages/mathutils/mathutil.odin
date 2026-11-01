package mathutil

// Procedures are public by default = visible to any package that imports this package
square :: proc(x: int) -> int {
    return x * x
}

sum_of_squares :: proc(a, b: int) -> int {
    return add(square(a), square(b))
}

// @(private) makes this private to the package = usable from any file in mathutil/,
// but not from importers.
@(private)
add :: proc(a, b: int) -> int {
    return a + b
}

// This is private to this file only
@(private = "file")
secret :: proc() -> int {
    return 42
}