package parser

import "core:bufio"
import "core:os"
import "core:strings"

read_file_by_lines_with_buffering :: proc(filepath: string) {
	// open the file
	f, ferr := os.open(filepath)
	if ferr != nil {
		panic("unable to open file")
	}
	defer os.close(f)

	// make the reader
	r: bufio.Reader
	// i swear if they put more than 512 characters on singular line
	// i will crash out
	buffer: [512]byte
	bufio.reader_init_with_buf(&r, os.stream_from_handle(f), buffer[:])
	defer bufio.reader_destroy(&r)

	// read every single line
	for {
		line, err := bufio.reader_read_string(&r, '\n', context.allocator)
		if err != nil {
      // end of it so we can break
			break
		}
		// cleanup
		defer delete(line, context.allocator)
		line = strings.trim_right(line, "\r")

		// process
	}
}
