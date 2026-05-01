package shiver

import "core:fmt"
import "core:mem"
import "core:mem/virtual"
import "core:os"
import "parser"
import "parser/tokens"

main :: proc() {
	context.allocator = mem.panic_allocator()

	file := os.args[1]

	arena: virtual.Arena
	_ = virtual.arena_init_growing(&arena)
	allocator := virtual.arena_allocator(&arena)
	defer virtual.arena_destroy(&arena)

	fmt.println("reading", file)
	tokenizer := parser.read_all(file, allocator)
	fmt.println("done reading")
	fmt.println(tokenizer)

	for {
		token := parser.next_token(tokenizer, allocator)
		if i, ok := token.(tokens.Eof); ok {
			break
		}
		fmt.println(token)
	}

	fmt.println("done")
}
