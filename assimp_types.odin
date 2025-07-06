/*
---------------------------------------------------------------------------
Open Asset Import Library (assimp)
---------------------------------------------------------------------------

Copyright (c) 2006-2025, assimp team

All rights reserved.

Redistribution and use of this software in source and binary forms,
with or without modification, are permitted provided that the following
conditions are met:

* Redistributions of source code must retain the above
  copyright notice, this list of conditions and the
  following disclaimer.

* Redistributions in binary form must reproduce the above
  copyright notice, this list of conditions and the
  following disclaimer in the documentation and/or other
  materials provided with the distribution.

* Neither the name of the assimp team, nor the names of its
  contributors may be used to endorse or promote products
  derived from this software without specific prior
  written permission of the assimp team.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
SERVICES:          LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR, LOSS OF USE,
PROFITS:           DATA, OR, OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------
*/
package assimp

import "core:c"

MAXLEN :: 1024

// ----------------------------------------------------------------------------------
/** Represents a plane in a three-dimensional, euclidean space
*/
Plane :: struct {
  //! Plane equation
  a, b, c, d: _real,
}

// ----------------------------------------------------------------------------------
/** Represents a ray
*/
Ray :: struct {
  //! Position and direction of the ray
  pos, dir: Vector3D,
}

// ----------------------------------------------------------------------------------
/** Represents a color in Red-Green-Blue space.
*/
Color3D :: [3]f32

// ----------------------------------------------------------------------------------
/**
 * @brief Represents an UTF-8 string, zero byte terminated.
 *
 *  The character set of an aiString is explicitly defined to be UTF-8. This Unicode
 *  transformation was chosen in the belief that most strings in 3d files are limited
 *  to ASCII, thus the character set needed to be strictly ASCII compatible.
 *
 *  Most text file loaders provide proper Unicode input file handling, special unicode
 *  characters are correctly transcoded to UTF8 and are kept throughout the libraries'
 *  import pipeline.
 *
 *  For most applications, it will be absolutely sufficient to interpret the
 *  aiString as ASCII data and work with it as one would work with a plain char*.
 *  Windows users in need of proper support for i.e asian characters can use the
 *  MultiByteToWideChar(), WideCharToMultiByte() WinAPI functionality to convert the
 *  UTF-8 strings to their working character set (i.e. MBCS, WideChar).
 *
 *  We use this representation instead of std::string to be C-compatible. The
 *  (binary) length of such a string is limited to AI_MAXLEN characters (including the
 *  the terminating zero).
 */
String :: struct {
  /** Binary length of the string excluding the terminal 0. This is NOT the
    *  logical length of strings containing UTF-8 multi-byte sequences! It's
    *  the number of bytes from the beginning of the string to its end.*/
  length: u32 `fmt:"-"`,

  /** String buffer. Size limit is AI_MAXLEN */
  data: [MAXLEN]c.char `fmt:"q,length"`,
}

// ----------------------------------------------------------------------------------
/** Standard return type for some library functions.
 * Rarely used, and if, mostly in the C API.
 */
Return :: enum i32 {
  /** Indicates that a function was successful */
  SUCCESS = 0x0,

  /** Indicates that a function failed */
  FAILURE = -0x1,

  /** Indicates that not enough memory was available
    * to perform the requested operation
    */
  OUTOFMEMORY = -0x3,
}

// just for backwards compatibility, don't use these constants anymore
//AI_SUCCESS     :: aiReturn_SUCCESS
//AI_FAILURE     :: aiReturn_FAILURE
//AI_OUTOFMEMORY :: aiReturn_OUTOFMEMORY

// ----------------------------------------------------------------------------------
/** Seek origins (for the virtual file system API).
 *  Much cooler than using SEEK_SET, SEEK_CUR or SEEK_END.
 */
Origin :: enum {
  /** Beginning of the file */
  SET = 0x0,

  /** Current position of the file pointer */
  CUR = 0x1,

  /** End of the file, offsets must be negative */
  END = 0x2,
}

// ----------------------------------------------------------------------------------
/** @brief Enumerates predefined log streaming destinations.
 *  Logging to these streams can be enabled with a single call to
 *   #LogStream::createDefaultStream.
 */
DefaultLogStream :: enum i32 {
  /** Stream the log to a file */
  FILE = 0x1,

  /** Stream the log to std::cout */
  STDOUT = 0x2,

  /** Stream the log to std::cerr */
  STDERR = 0x4,

  /** MSVC only: Stream the log the the debugger
    * (this relies on OutputDebugString from the Win32 SDK)
    */
  DEBUGGER = 0x8,
}

// just for backwards compatibility, don't use these constants anymore
// DLS_FILE     :: aiDefaultLogStream_FILE
// DLS_STDOUT   :: aiDefaultLogStream_STDOUT
// DLS_STDERR   :: aiDefaultLogStream_STDERR
// DLS_DEBUGGER :: aiDefaultLogStream_DEBUGGER

// ----------------------------------------------------------------------------------
/** Stores the memory requirements for different components (e.g. meshes, materials,
 *  animations) of an import. All sizes are in bytes.
 *  @see Importer::GetMemoryRequirements()
*/
MemoryInfo :: struct {
  /** Storage allocated for texture data */
  textures: c.uint,

  /** Storage allocated for material data  */
  materials: c.uint,

  /** Storage allocated for mesh data */
  meshes: c.uint,

  /** Storage allocated for node data */
  nodes: c.uint,

  /** Storage allocated for animation data */
  animations: c.uint,

  /** Storage allocated for camera data */
  cameras: c.uint,

  /** Storage allocated for light data */
  lights: c.uint,

  /** Total storage allocated for the full import. */
  total: c.uint,
}

/**
 *  @brief  Type to store a in-memory data buffer.
 */
Buffer :: struct {
  data: ^c.char, ///< Begin poiner
  end:  ^c.char, ///< End pointer
}
