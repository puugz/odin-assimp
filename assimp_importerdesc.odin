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

/** Mixed set of flags for #aiImporterDesc, indicating some features
  *  common to many importers*/
ImporterFlags :: enum i32 {
  /** Indicates that there is a textual encoding of the
    *  file format; and that it is supported.*/
  SupportTextFlavour = 0x1,

  /** Indicates that there is a binary encoding of the
    *  file format; and that it is supported.*/
  SupportBinaryFlavour = 0x2,

  /** Indicates that there is a compressed encoding of the
    *  file format; and that it is supported.*/
  SupportCompressedFlavour = 0x4,

  /** Indicates that the importer reads only a very particular
    * subset of the file format. This happens commonly for
    * declarative or procedural formats which cannot easily
    * be mapped to #aiScene */
  LimitedSupport = 0x8,

  /** Indicates that the importer is highly experimental and
    * should be used with care. This only happens for trunk
    * (i.e. SVN) versions, experimental code is not included
    * in releases. */
  Experimental = 0x10,
}

/** Meta information about a particular importer. Importers need to fill
 *  this structure, but they can freely decide how talkative they are.
 *  A common use case for loader meta info is a user interface
 *  in which the user can choose between various import/export file
 *  formats. Building such an UI by hand means a lot of maintenance
 *  as importers/exporters are added to Assimp, so it might be useful
 *  to have a common mechanism to query some rough importer
 *  characteristics. */
ImporterDesc :: struct {
  /** Full name of the importer (i.e. Blender3D importer)*/
  mName: cstring,

  /** Original author (left blank if unknown or whole assimp team) */
  mAuthor: cstring,

  /** Current maintainer, left blank if the author maintains */
  mMaintainer: cstring,

  /** Implementation comments, i.e. unimplemented features*/
  mComments: cstring,

  /** These flags indicate some characteristics common to many
      importers. */
  mFlags: c.uint,

  /** Minimum format version that can be loaded im major.minor format,
      both are set to 0 if there is either no version scheme
      or if the loader doesn't care. */
  mMinMajor: c.uint,
  mMinMinor: c.uint,

  /** Maximum format version that can be loaded im major.minor format,
      both are set to 0 if there is either no version scheme
      or if the loader doesn't care. Loaders that expect to be
      forward-compatible to potential future format versions should
      indicate  zero, otherwise they should specify the current
      maximum version.*/
  mMaxMajor: c.uint,
  mMaxMinor: c.uint,

  /** List of file extensions this importer can handle.
      List entries are separated by space characters.
      All entries are lower case without a leading dot (i.e.
      "xml dae" would be a valid value. Note that multiple
      importers may respond to the same file extension -
      assimp calls all importers in the order in which they
      are registered and each importer gets the opportunity
      to load the file until one importer "claims" the file. Apart
      from file extension checks, importers typically use
      other methods to quickly reject files (i.e. magic
      words) so this does not mean that common or generic
      file extensions such as XML would be tediously slow. */
  mFileExtensions: cstring,
}
