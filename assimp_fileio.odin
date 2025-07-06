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

// aiFile callbacks
FileWriteProc :: proc "c" (^File, cstring, c.size_t, c.size_t) -> c.size_t
FileReadProc  :: proc "c" (^File, cstring, c.size_t, c.size_t) -> c.size_t
FileTellProc  :: proc "c" (^File) -> c.size_t
FileFlushProc :: proc "c" (^File)
FileSeek      :: proc "c" (^File, c.size_t, Origin) -> Return

// aiFileIO callbacks
FileOpenProc  :: proc "c" (^FileIO, cstring, cstring) -> ^File
FileCloseProc :: proc "c" (^FileIO, ^File)

// Represents user-defined data
UserData :: ^c.char

// ----------------------------------------------------------------------------------
/** @brief C-API: File system callbacks
 *
 *  Provided are functions to open and close files. Supply a custom structure to
 *  the import function. If you don't, a default implementation is used. Use custom
 *  file systems to enable reading from other sources, such as ZIPs
 *  or memory locations. */
FileIO :: struct {
  /** Function used to open a new file
    */
  OpenProc: FileOpenProc,

  /** Function used to close an existing file
    */
  CloseProc: FileCloseProc,

  /** User-defined, opaque data */
  UserData: UserData,
}

// ----------------------------------------------------------------------------------
/** @brief C-API: File callbacks
 *
 *  Actually, it's a data structure to wrap a set of fXXXX (e.g fopen)
 *  replacement functions.
 *
 *  The default implementation of the functions utilizes the fXXX functions from
 *  the CRT. However, you can supply a custom implementation to Assimp by
 *  delivering a custom aiFileIO. Use this to enable reading from other sources,
 *  such as ZIP archives or memory locations. */
File :: struct {
  /** Callback to read from a file */
  ReadProc: FileReadProc,

  /** Callback to write to a file */
  WriteProc: FileWriteProc,

  /** Callback to retrieve the current position of
    *  the file cursor (ftell())
    */
  TellProc: FileTellProc,

  /** Callback to retrieve the size of the file,
    *  in bytes
    */
  FileSizeProc: FileTellProc,

  /** Callback to set the current position
    * of the file cursor (fseek())
    */
  SeekProc: FileSeek,

  /** Callback to flush the file contents
    */
  FlushProc: FileFlushProc,

  /** User-defined, opaque data
    */
  UserData: UserData,
}
