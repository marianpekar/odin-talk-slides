// Example copied from https://odin-lang.org/

package main

import "core:fmt"

main :: proc() {
	greetings := []string{"Hellope", "Bonjour", "こんにちは"} 
	for greeting, i in greetings {
		fmt.println(i, "=", greeting)
	}
}

// UTF-8 is the default encoding used by the string type (check out https://zylinski.se/posts/iterating-strings-and-manually-decoding-utf8/)