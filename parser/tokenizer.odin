package parser

import "base:runtime"
import "core:fmt"
import "core:strconv"
import "core:strings"
import "core:unicode"
import "core:unicode/utf8"
import "tokens"

Tokenizer :: struct {
	source: [dynamic]rune, // somehow
	cursor: int, // index of the cursor, each index is one rune
}

new_tokenizer :: proc(allocator: runtime.Allocator) -> ^Tokenizer { 	// i dont know the size of the source code ahead of time
	rune_array := make([dynamic]rune, allocator)
	return new_clone(Tokenizer{source = rune_array}, allocator)
}

// put new source code into the tokenizer
// it has to be rune either way
inject_src :: proc(tokenizer: ^Tokenizer, src: string) {
	for char in src {
		append(&tokenizer.source, char)
	}
}

// return rune at cursor
peek :: proc(tokenizer: ^Tokenizer) -> rune {
	return tokenizer.source[tokenizer.cursor]
}

is_at_end :: proc(tokenizer: ^Tokenizer) -> bool {
	// i shouldnt worry about performance
	return len(tokenizer.source) <= tokenizer.cursor
}

// next rune
advance :: proc(tokenizer: ^Tokenizer, n := 1) {
	tokenizer.cursor += n
}

peek_next :: proc(tokenizer: ^Tokenizer) -> (result: rune, ok: bool) #optional_ok {
	// sometimes throw and catch aint that bad honestly
	// just thinking about bobbing the error makes me nauseous

	// bad
	if len(tokenizer.source) <= tokenizer.cursor + 1 {
		return // ok is false by default
	}

	result = tokenizer.source[tokenizer.cursor + 1]
	ok = true
	return
}


next_token :: proc(tokenizer: ^Tokenizer, allocator: runtime.Allocator) -> tokens.Token {
	skip_whitespace_and_comments(tokenizer)

	if is_at_end(tokenizer) {
		return tokens.Eof{}
	}

	char := peek(tokenizer)

	switch char {
	case ':':
		advance(tokenizer)
		return tokens.Colon{}
	case '-':
		if n, ok := peek_next(tokenizer); ok && n == '>' {
			advance(tokenizer, 2)
			return tokens.Arrow{}
		}
	case '^':
		advance(tokenizer)
		return tokens.Caret{}
	case '&':
		advance(tokenizer)
		return tokens.Ampersand{}
	case '=':
		advance(tokenizer)
		return tokens.Assign{}

	case '(':
		advance(tokenizer)
		return tokens.Open_Paren{}
	case ')':
		advance(tokenizer)
		return tokens.Close_Paren{}
	case '{':
		advance(tokenizer)
		return tokens.Open_Bracket{}
	case '}':
		advance(tokenizer)
		return tokens.Close_Bracket{}
	}

	if unicode.is_alpha(char) {
		start := tokenizer.cursor
		for !is_at_end(tokenizer) &&
		    (unicode.is_alpha(peek(tokenizer)) || unicode.is_digit(peek(tokenizer))) {
			advance(tokenizer)
		}

		text_slice := tokenizer.source[start:tokenizer.cursor]

		// Use the temp_allocator for the intermediate conversion!
		// This way you don't have to manually 'delete' it at all.
		text := utf8.runes_to_string(text_slice, context.temp_allocator)

		switch text {
		case "val":
			return tokens.Val{}
		case "mut":
			return tokens.Mut{}
		case "fn":
			return tokens.Fn{}
		case "return":
			return tokens.Return{} // Don't forget this one!
		case:
			return tokens.Identifier(strings.clone(text, allocator))
		}
	}

	// TODO: float

	if unicode.is_digit(char) {
		start := tokenizer.cursor
		for !is_at_end(tokenizer) && unicode.is_digit(peek(tokenizer)) {
			advance(tokenizer)
		}
		int_slice := tokenizer.source[start:tokenizer.cursor]

		integer_str := utf8.runes_to_string(int_slice, context.temp_allocator)
		val, ok := strconv.parse_int(integer_str)
		delete(integer_str, context.temp_allocator)
		if !ok {
			panic("fail to parse int") // TODO: proper error handling
		}
		return tokens.Int_Literal(val)
	}

	fmt.println("unexpected character:", char)
	panic("unexpected character")
}


// if true means success
// if false it means the user forgot to close their comments (probably)
skip_whitespace_and_comments :: proc(tokenizer: ^Tokenizer) -> bool {
	for !is_at_end(tokenizer) {
		c := peek(tokenizer)

		// whitespace deal
		if unicode.is_white_space(c) {
			advance(tokenizer)
			continue
		}

		// comment handling
		if c == '/' {
			next, ok := peek_next(tokenizer)
			if !ok do break

			if next == '/' {
				// single line comment: skip until newline or end of file
				for !is_at_end(tokenizer) && peek(tokenizer) != '\n' {
					advance(tokenizer)
				}
				continue
			} else if next == '*' {
				// multi line comment skip until */
				advance(tokenizer, 2)
				for !is_at_end(tokenizer) {
					curr := peek(tokenizer)
					nxt, nxt_ok := peek_next(tokenizer)
					if curr == '*' && nxt_ok && nxt == '/' {
						advance(tokenizer, 2)
						break
					}
					advance(tokenizer)
				}
				continue
			}
		}

		// if its not a whitespace or comment then we are done
		break
	}
	return true
}
