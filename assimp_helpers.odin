package assimp

import "core:strings"

to_odin_string :: proc(assimp_string: ^String, allocator := context.allocator) -> string {
	return strings.clone_from_bytes(assimp_string.data[:assimp_string.length], allocator)
}

to_assimp_string :: proc(text: string, assimp_string: ^String) {
	assert(assimp_string != nil)
	copy(assimp_string.data[:], text)
	assimp_string.length = u32(len(text))
}
