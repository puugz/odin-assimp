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

when ODIN_OS == .Windows {
  when ODIN_DEBUG {
    foreign import lib { "assimp-vc143-mtd.lib" }
  } else {
    foreign import lib { "assimp-vc143-mt.lib" }
  }
} else when ODIN_OS == .Linux {
  foreign import lib { "system:assimp" }
} else {
  #panic("Bindings for this OS not implemented")
}

// Name for default materials (2nd is used if meshes have UV coords)
DEFAULT_MATERIAL_NAME :: "DefaultMaterial"

@(default_calling_convention="c", link_prefix="ai")
foreign lib {
  // ---------------------------------------------------------------------------
  /** @brief Retrieve a material property with a specific key from the material
  *
  * @param pMat Pointer to the input material. May not be NULL
  * @param pKey Key to search for. One of the AI_MATKEY_XXX constants.
  * @param type Specifies the type of the texture to be retrieved (
  *    e.g. diffuse, specular, height map ...)
  * @param index Index of the texture to be retrieved.
  * @param pPropOut Pointer to receive a pointer to a valid aiMaterialProperty
  *        structure or NULL if the key has not been found. */
  // ---------------------------------------------------------------------------
  GetMaterialProperty :: proc(pMat: ^Material, pKey: cstring, type: c.uint, index: c.uint, pPropOut: [^]^MaterialProperty) -> Return ---

  // ---------------------------------------------------------------------------
  /** @brief Retrieve an array of float values with a specific key
  *  from the material
  *
  * Pass one of the AI_MATKEY_XXX constants for the last three parameters (the
  * example reads the #AI_MATKEY_UVTRANSFORM property of the first diffuse texture)
  * @code
  * aiUVTransform trafo;
  * max: c.uint = sizeof(aiUVTransform);
  * if (AI_SUCCESS != aiGetMaterialFloatArray(mat, AI_MATKEY_UVTRANSFORM(aiTextureType_DIFFUSE,0),
  *    (float*)&trafo, &max) || sizeof(aiUVTransform) != max)
  * {
  *   // error handling
  * }
  * @endcode
  *
  * @param pMat Pointer to the input material. May not be NULL
  * @param pKey Key to search for. One of the AI_MATKEY_XXX constants.
  * @param pOut Pointer to a buffer to receive the result.
  * @param pMax Specifies the size of the given buffer, in float's.
  *        Receives the number of values (not bytes!) read.
  * @param type (see the code sample above)
  * @param index (see the code sample above)
  * @return Specifies whether the key has been found. If not, the output
  *   arrays remains unmodified and pMax is set to 0.*/
  // ---------------------------------------------------------------------------
  GetMaterialFloatArray :: proc(pMat: ^Material, pKey: cstring, type: c.uint, index: c.uint, pOut: ^_real, pMax: ^c.uint) -> Return ---

  // ---------------------------------------------------------------------------
  /** @brief Retrieve an array of integer values with a specific key
  *  from a material
  *
  * See the sample for aiGetMaterialFloatArray for more information.*/
  GetMaterialIntegerArray :: proc(pMat: ^Material, pKey: cstring, type: c.uint, index: c.uint, pOut: ^c.int, pMax: ^c.uint) -> Return ---

  // ---------------------------------------------------------------------------
  /** @brief Retrieve a color value from the material property table
  *
  * See the sample for aiGetMaterialFloat for more information*/
  // ---------------------------------------------------------------------------
  GetMaterialColor :: proc(pMat: ^Material, pKey: cstring, type: c.uint, index: c.uint, pOut: ^Color4D) -> Return ---

  // ---------------------------------------------------------------------------
  /** @brief Retrieve a aiUVTransform value from the material property table
  *
  * See the sample for aiGetMaterialFloat for more information*/
  // ---------------------------------------------------------------------------
  GetMaterialUVTransform :: proc(pMat: ^Material, pKey: cstring, type: c.uint, index: c.uint, pOut: ^UVTransform) -> Return ---

  // ---------------------------------------------------------------------------
  /** @brief Retrieve a string from the material property table
  *
  * See the sample for aiGetMaterialFloat for more information.*/
  // ---------------------------------------------------------------------------
  GetMaterialString :: proc(pMat: ^Material, pKey: cstring, type: c.uint, index: c.uint, pOut: ^String) -> Return ---

  // ---------------------------------------------------------------------------
  /** Get the number of textures for a particular texture type.
  *  @param[in] pMat Pointer to the input material. May not be NULL
  *  @param type Texture type to check for
  *  @return Number of textures for this type.
  *  @note A texture can be easily queried using #aiGetMaterialTexture() */
  // ---------------------------------------------------------------------------
  GetMaterialTextureCount :: proc(pMat: ^Material, type: TextureType) -> c.uint ---

  // ---------------------------------------------------------------------------
  /** @brief Helper function to get all values pertaining to a particular
  *  texture slot from a material structure.
  *
  *  This function is provided just for convenience. You could also read the
  *  texture by parsing all of its properties manually. This function bundles
  *  all of them in a huge function monster.
  *
  *  @param[in] mat Pointer to the input material. May not be NULL
  *  @param[in] type Specifies the texture stack to read from (e.g. diffuse,
  *     specular, height map ...).
  *  @param[in] index Index of the texture. The function fails if the
  *     requested index is not available for this texture type.
  *     #aiGetMaterialTextureCount() can be used to determine the number of
  *     textures in a particular texture stack.
  *  @param[out] path Receives the output path
  *     If the texture is embedded, receives a '*' followed by the id of
  *     the texture (for the textures stored in the corresponding scene) which
  *     can be converted to an int using a function like atoi.
  *     This parameter must be non-null.
  *  @param mapping The texture mapping mode to be used.
  *      Pass NULL if you're not interested in this information.
  *  @param[out] uvindex For UV-mapped textures: receives the index of the UV
  *      source channel. Unmodified otherwise.
  *      Pass NULL if you're not interested in this information.
  *  @param[out] blend Receives the blend factor for the texture
  *      Pass NULL if you're not interested in this information.
  *  @param[out] op Receives the texture blend operation to be perform between
  *      this texture and the previous texture.
  *      Pass NULL if you're not interested in this information.
  *  @param[out] mapmode Receives the mapping modes to be used for the texture.
  *      Pass NULL if you're not interested in this information. Otherwise,
  *      pass a pointer to an array of two aiTextureMapMode's (one for each
  *      axis, UV order).
  *  @param[out] flags Receives the the texture flags.
  *  @return AI_SUCCESS on success, otherwise something else. Have fun.*/
  // ---------------------------------------------------------------------------
  GetMaterialTexture :: proc(
    mat:     ^Material,
    type:    TextureType,
    index:   c.uint,
    path:    ^String,
    mapping: ^TextureMapping = nil,
    uvindex: ^c.uint         = nil,
    blend:   ^_real          = nil,
    op:      ^TextureOp      = nil,
    mapmode: ^TextureMapMode = nil,
    flags:   ^c.uint         = nil,
  ) -> Return ---
}

// ---------------------------------------------------------------------------
/** @brief Retrieve a single float property with a specific key from the material.
*
* Pass one of the AI_MATKEY_XXX constants for the last three parameters (the
* example reads the #AI_MATKEY_SHININESS_STRENGTH property of the first diffuse texture)
* @code
* float specStrength = 1.f; // default value, remains unmodified if we fail.
* aiGetMaterialFloat(mat, AI_MATKEY_SHININESS_STRENGTH,
*    (float*)&specStrength);
* @endcode
*
* @param pMat Pointer to the input material. May not be NULL
* @param pKey Key to search for. One of the AI_MATKEY_XXX constants.
* @param pOut Receives the output float.
* @param type (see the code sample above)
* @param index (see the code sample above)
* @return Specifies whether the key has been found. If not, the output
*   float remains unmodified.*/
// ---------------------------------------------------------------------------
GetMaterialFloat :: #force_inline proc(pMat: ^Material, pKey: cstring, type: c.uint, index: c.uint, pOut: ^_real) -> Return {
  return GetMaterialFloatArray(pMat, pKey, type, index, pOut, nil)
}

// ---------------------------------------------------------------------------
/** @brief Retrieve an integer property with a specific key from a material
*
* See the sample for aiGetMaterialFloat for more information.*/
// ---------------------------------------------------------------------------
aiGetMaterialInteger :: #force_inline proc(pMat: ^Material, pKey: cstring, type: c.uint, index: c.uint, pOut: ^c.int) -> Return {
  return GetMaterialIntegerArray(pMat, pKey, type, index, pOut, nil)
}


// ---------------------------------------------------------------------------
/** @brief Defines how the Nth texture of a specific type is combined with
 *  the result of all previous layers.
 *
 *  Example (left: key, right: value): <br>
 *  @code
 *  DiffColor0     - gray
 *  DiffTextureOp0 - aiTextureOpMultiply
 *  DiffTexture0   - tex1.png
 *  DiffTextureOp0 - aiTextureOpAdd
 *  DiffTexture1   - tex2.png
 *  @endcode
 *  Written as equation, the final diffuse term for a specific pixel would be:
 *  @code
 *  diffFinal = DiffColor0 * sampleTex(DiffTexture0,UV0) +
 *     sampleTex(DiffTexture1,UV0) * diffContrib;
 *  @endcode
 *  where 'diffContrib' is the intensity of the incoming light for that pixel.
 */
TextureOp :: enum i32 {
  /** T = T1 * T2 */
  Multiply = 0x0,

  /** T = T1 + T2 */
  Add = 0x1,

  /** T = T1 - T2 */
  Subtract = 0x2,

  /** T = T1 / T2 */
  Divide = 0x3,

  /** T = (T1 + T2) - (T1 * T2) */
  SmoothAdd = 0x4,

  /** T = T1 + (T2-0.5) */
  SignedAdd = 0x5,
}

// ---------------------------------------------------------------------------
/** @brief Defines how UV coordinates outside the [0...1] range are handled.
 *
 *  Commonly referred to as 'wrapping mode'.
 */
TextureMapMode :: enum i32 {
  /** A texture coordinate u|v is translated to u%1|v%1
    */
  Wrap = 0x0,

  /** Texture coordinates outside [0...1]
    *  are clamped to the nearest valid value.
    */
  Clamp = 0x1,

  /** If the texture coordinates for a pixel are outside [0...1]
    *  the texture is not applied to that pixel
    */
  Decal = 0x3,

  /** A texture coordinate u|v becomes u%1|v%1 if (u-(u%1))%2 is zero and
    *  1-(u%1)|1-(v%1) otherwise
    */
  Mirror = 0x2,
}

// ---------------------------------------------------------------------------
/** @brief Defines how the mapping coords for a texture are generated.
 *
 *  Real-time applications typically require full UV coordinates, so the use of
 *  the aiProcess_GenUVCoords step is highly recommended. It generates proper
 *  UV channels for non-UV mapped objects, as long as an accurate description
 *  how the mapping should look like (e.g spherical) is given.
 *  See the #AI_MATKEY_MAPPING property for more details.
 */
TextureMapping :: enum i32 {
  /** The mapping coordinates are taken from an UV channel.
    *
    *  #AI_MATKEY_UVWSRC property specifies from which UV channel
    *  the texture coordinates are to be taken from (remember,
    *  meshes can have more than one UV channel).
  */
  UV = 0x0,

  /** Spherical mapping */
  SPHERE = 0x1,

  /** Cylindrical mapping */
  CYLINDER = 0x2,

  /** Cubic mapping */
  BOX = 0x3,

  /** Planar mapping */
  PLANE = 0x4,

  /** Undefined mapping. Have fun. */
  OTHER = 0x5,
}

// ---------------------------------------------------------------------------
/** @brief Defines the purpose of a texture
 *
 *  This is a very difficult topic. Different 3D packages support different
 *  kinds of textures. For very common texture types, such as bumpmaps, the
 *  rendering results depend on implementation details in the rendering
 *  pipelines of these applications. Assimp loads all texture references from
 *  the model file and tries to determine which of the predefined texture
 *  types below is the best choice to match the original use of the texture
 *  as closely as possible.<br>
 *
 *  In content pipelines you'll usually define how textures have to be handled,
 *  and the artists working on models have to conform to this specification,
 *  regardless which 3D tool they're using.
 */
TextureType :: enum i32 {
  /** Dummy value.
    *
    *  No texture, but the value to be used as 'texture semantic'
    *  (#aiMaterialProperty::mSemantic) for all material properties
    *  *not* related to textures.
    */
  NONE = 0,

  /** LEGACY API MATERIALS
    * Legacy refers to materials which
    * Were originally implemented in the specifications around 2000.
    * These must never be removed, as most engines support them.
    */

  /** The texture is combined with the result of the diffuse
    *  lighting equation.
    *  OR
    *  PBR Specular/Glossiness
    */
  DIFFUSE = 1,

  /** The texture is combined with the result of the specular
    *  lighting equation.
    *  OR
    *  PBR Specular/Glossiness
    */
  SPECULAR = 2,

  /** The texture is combined with the result of the ambient
    *  lighting equation.
    */
  AMBIENT = 3,

  /** The texture is added to the result of the lighting
    *  calculation. It isn't influenced by incoming light.
    */
  EMISSIVE = 4,

  /** The texture is a height map.
    *
    *  By convention, higher gray-scale values stand for
    *  higher elevations from the base height.
    */
  HEIGHT = 5,

  /** The texture is a (tangent space) normal-map.
    *
    *  Again, there are several conventions for tangent-space
    *  normal maps. Assimp does (intentionally) not
    *  distinguish here.
    */
  NORMALS = 6,

  /** The texture defines the glossiness of the material.
    *
    *  The glossiness is in fact the exponent of the specular
    *  (phong) lighting equation. Usually there is a conversion
    *  function defined to map the linear color values in the
    *  texture to a suitable exponent. Have fun.
  */
  SHININESS = 7,

  /** The texture defines per-pixel opacity.
    *
    *  Usually 'white' means opaque and 'black' means
    *  'transparency'. Or quite the opposite. Have fun.
  */
  OPACITY = 8,

  /** Displacement texture
    *
    *  The exact purpose and format is application-dependent.
    *  Higher color values stand for higher vertex displacements.
  */
  DISPLACEMENT = 9,

  /** Lightmap texture (aka Ambient Occlusion)
    *
    *  Both 'Lightmaps' and dedicated 'ambient occlusion maps' are
    *  covered by this material property. The texture contains a
    *  scaling value for the final color value of a pixel. Its
    *  intensity is not affected by incoming light.
  */
  LIGHTMAP = 10,

  /** Reflection texture
    *
    * Contains the color of a perfect mirror reflection.
    * Rarely used, almost never for real-time applications.
  */
  REFLECTION = 11,

  /** PBR Materials
    * PBR definitions from maya and other modelling packages now use this standard.
    * This was originally introduced around 2012.
    * Support for this is in game engines like Godot, Unreal or Unity3D.
    * Modelling packages which use this are very common now.
    */

  BASE_COLOR = 12,
  NORMAL_CAMERA = 13,
  EMISSION_COLOR = 14,
  METALNESS = 15,
  DIFFUSE_ROUGHNESS = 16,
  AMBIENT_OCCLUSION = 17,

  /** Unknown texture
    *
    *  A texture reference that does not match any of the definitions
    *  above is considered to be 'unknown'. It is still imported,
    *  but is excluded from any further post-processing.
  */
  UNKNOWN = 18,

  /** PBR Material Modifiers
  * Some modern renderers have further PBR modifiers that may be overlaid
  * on top of the 'base' PBR materials for additional realism.
  * These use multiple texture maps, so only the base type is directly defined
  */

  /** Sheen
  * Generally used to simulate textiles that are covered in a layer of microfibers
  * eg velvet
  * https://github.com/KhronosGroup/glTF/tree/master/extensions/2.0/Khronos/KHR_materials_sheen
  */
  SHEEN = 19,

  /** Clearcoat
  * Simulates a layer of 'polish' or 'lacquer' layered on top of a PBR substrate
  * https://autodesk.github.io/standard-surface/#closures/coating
  * https://github.com/KhronosGroup/glTF/tree/master/extensions/2.0/Khronos/KHR_materials_clearcoat
  */
  CLEARCOAT = 20,

  /** Transmission
  * Simulates transmission through the surface
  * May include further information such as wall thickness
  */
  TRANSMISSION = 21,

  /**
    * Maya material declarations
    */
  MAYA_BASE = 22,
  MAYA_SPECULAR = 23,
  MAYA_SPECULAR_COLOR = 24,
  MAYA_SPECULAR_ROUGHNESS = 25,

  /** Anisotropy
  * Simulates a surface with directional properties
    */
  ANISOTROPY = 26,

  /**
    * gltf material declarations
    * Refs: https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html#metallic-roughness-material
    *           "textures for metalness and roughness properties are packed together in a single
    *           texture called metallicRoughnessTexture. Its green channel contains roughness
    *           values and its blue channel contains metalness values..."
    *       https://registry.khronos.org/glTF/specs/2.0/glTF-2.0.html#_material_pbrmetallicroughness_metallicroughnesstexture
    *           "The metalness values are sampled from the B channel. The roughness values are
    *           sampled from the G channel..."
    */
  GLTF_METALLIC_ROUGHNESS = 27,
}

// -------------------------------------------------------------------------------
/**
 * @brief  Get a string for a given aiTextureType
 *
 * @param  in  The texture type
 * @return The description string for the texture type.
 */
// aiTextureTypeToString :: proc(in: TextureType) -> cstring

// ---------------------------------------------------------------------------
/** @brief Defines all shading models supported by the library
 *
 *  Property: #AI_MATKEY_SHADING_MODEL
 *
 *  The list of shading modes has been taken from Blender.
 *  See Blender documentation for more information. The API does
 *  not distinguish between "specular" and "diffuse" shaders (thus the
 *  specular term for diffuse shading models like Oren-Nayar remains
 *  undefined). <br>
 *  Again, this value is just a hint. Assimp tries to select the shader whose
 *  most common implementation matches the original rendering results of the
 *  3D modeler which wrote a particular model as closely as possible.
 *
 */
ShadingMode :: enum i32 {
  /** Flat shading. Shading is done on per-face base,
    *  diffuse only. Also known as 'faceted shading'.
    */
  Flat = 0x1,

  /** Simple Gouraud shading.
    */
  Gouraud = 0x2,

  /** Phong-Shading -
    */
  Phong = 0x3,

  /** Phong-Blinn-Shading
    */
  Blinn = 0x4,

  /** Toon-Shading per pixel
    *
    *  Also known as 'comic' shader.
    */
  Toon = 0x5,

  /** OrenNayar-Shading per pixel
    *
    *  Extension to standard Lambertian shading, taking the
    *  roughness of the material into account
    */
  OrenNayar = 0x6,

  /** Minnaert-Shading per pixel
    *
    *  Extension to standard Lambertian shading, taking the
    *  "darkness" of the material into account
    */
  Minnaert = 0x7,

  /** CookTorrance-Shading per pixel
    *
    *  Special shader for metallic surfaces.
    */
  CookTorrance = 0x8,

  /** No shading at all. Constant light influence of 1.0.
  * Also known as "Unlit"
  */
  NoShading = 0x9,
  Unlit = NoShading, // Alias

  /** Fresnel shading
    */
  Fresnel = 0xa,

  /** Physically-Based Rendering (PBR) shading using
  * Bidirectional scattering/reflectance distribution function (BSDF/BRDF)
  * There are multiple methods under this banner, and model files may provide
  * data for more than one PBR-BRDF method.
  * Applications should use the set of provided properties to determine which
  * of their preferred PBR rendering methods are likely to be available
  * eg:
  * - If AI_MATKEY_METALLIC_FACTOR is set, then a Metallic/Roughness is available
  * - If AI_MATKEY_GLOSSINESS_FACTOR is set, then a Specular/Glossiness is available
  * Note that some PBR methods allow layering of techniques
  */
  PBR_BRDF = 0xb,
}

// ---------------------------------------------------------------------------
/**
 *  @brief Defines some mixed flags for a particular texture.
 *
 *  Usually you'll instruct your cg artists how textures have to look like ...
 *  and how they will be processed in your application. However, if you use
 *  Assimp for completely generic loading purposes you might also need to
 *  process these flags in order to display as many 'unknown' 3D models as
 *  possible correctly.
 *
 *  This corresponds to the #AI_MATKEY_TEXFLAGS property.
*/
TextureFlags :: enum i32 {
  /** The texture's color values have to be inverted (component-wise 1-n)
    */
  Invert = 0x1,

  /** Explicit request to the application to process the alpha channel
    *  of the texture.
    *
    *  Mutually exclusive with #aiTextureFlags_IgnoreAlpha. These
    *  flags are set if the library can say for sure that the alpha
    *  channel is used/is not used. If the model format does not
    *  define this, it is left to the application to decide whether
    *  the texture alpha channel - if any - is evaluated or not.
    */
  UseAlpha = 0x2,

  /** Explicit request to the application to ignore the alpha channel
    *  of the texture.
    *
    *  Mutually exclusive with #aiTextureFlags_UseAlpha.
    */
  IgnoreAlpha = 0x4,
}

// ---------------------------------------------------------------------------
/**
 *  @brief Defines alpha-blend flags.
 *
 *  If you're familiar with OpenGL or D3D, these flags aren't new to you.
 *  They define *how* the final color value of a pixel is computed, basing
 *  on the previous color at that pixel and the new color value from the
 *  material.
 *  The blend formula is:
 *  @code
 *    SourceColor * SourceBlend + DestColor * DestBlend
 *  @endcode
 *  where DestColor is the previous color in the frame-buffer at this
 *  position and SourceColor is the material color before the transparency
 *  calculation.<br>
 *  This corresponds to the #AI_MATKEY_BLEND_FUNC property.
*/
BlendMode :: enum i32 {
  /**
    *  Formula:
    *  @code
    *  SourceColor*SourceAlpha + DestColor*(1-SourceAlpha)
    *  @endcode
    */
  Default = 0x0,

  /** Additive blending
    *
    *  Formula:
    *  @code
    *  SourceColor*1 + DestColor*1
    *  @endcode
    */
  Additive = 0x1,
}

// ---------------------------------------------------------------------------
/**
 *  @brief Defines how an UV channel is transformed.
 *
 *  This is just a helper structure for the #AI_MATKEY_UVTRANSFORM key.
 *  See its documentation for more details.
 *
 *  Typically you'll want to build a matrix of this information. However,
 *  we keep separate scaling/translation/rotation values to make it
 *  easier to process and optimize UV transformations internally.
 */
UVTransform :: struct {
  /** Translation on the u and v axes.
    *
    *  The default value is (0|0).
    */
  mTranslation: Vector2D,

  /** Scaling on the u and v axes.
    *
    *  The default value is (1|1).
    */
  mScaling: Vector2D,

  /** Rotation - in counter-clockwise direction.
    *
    *  The rotation angle is specified in radians. The
    *  rotation center is 0.5f|0.5f. The default value
    *  0.f.
    */
  mRotation: _real,
}

//! @cond AI_DOX_INCLUDE_INTERNAL
// ---------------------------------------------------------------------------
/**
 *  @brief A very primitive RTTI system for the contents of material properties.
 */
PropertyTypeInfo :: enum i32 {
  /** Array of single-precision (32 Bit) floats
    *
    *  It is possible to use aiGetMaterialInteger[Array]() (or the C++-API
    *  aiMaterial::Get()) to query properties stored in floating-point format.
    *  The material system performs the type conversion automatically.
  */
  Float = 0x1,

  /** Array of double-precision (64 Bit) floats
    *
    *  It is possible to use aiGetMaterialInteger[Array]() (or the C++-API
    *  aiMaterial::Get()) to query properties stored in floating-point format.
    *  The material system performs the type conversion automatically.
  */
  Double = 0x2,

  /** The material property is an aiString.
    *
    *  Arrays of strings aren't possible, aiGetMaterialString() (or the
    *  C++-API aiMaterial::Get()) *must* be used to query a string property.
  */
  String = 0x3,

  /** Array of (32 Bit) integers
    *
    *  It is possible to use aiGetMaterialFloat[Array]() (or the C++-API
    *  aiMaterial::Get()) to query properties stored in integer format.
    *  The material system performs the type conversion automatically.
  */
  Integer = 0x4,

  /** Simple binary buffer, content undefined. Not convertible to anything.
  */
  Buffer = 0x5,
}

// ---------------------------------------------------------------------------
/** @brief Data structure for a single material property
 *
 *  As an user, you'll probably never need to deal with this data structure.
 *  Just use the provided aiGetMaterialXXX() or aiMaterial::Get() family
 *  of functions to query material properties easily. Processing them
 *  manually is faster, but it is not the recommended way. It isn't worth
 *  the effort. <br>
 *  Material property names follow a simple scheme:
 *  @code
 *    $<name>
 *    ?<name>
 *       A public property, there must be corresponding AI_MATKEY_XXX define
 *       2nd: Public, but ignored by the #aiProcess_RemoveRedundantMaterials
 *       post-processing step.
 *    ~<name>
 *       A temporary property for internal use.
 *  @endcode
 *  @see aiMaterial
 */
MaterialProperty :: struct {
  /** Specifies the name of the property (key)
    *  Keys are generally case insensitive.
    */
  mKey: String,

  /** Textures: Specifies their exact usage semantic.
    * For non-texture properties, this member is always 0
    * (or, better-said, #NONE).
    */
  mSemantic: c.uint,

  /** Textures: Specifies the index of the texture.
    *  For non-texture properties, this member is always 0.
    */
  mIndex: c.uint,

  /** Size of the buffer mData is pointing to, in bytes.
    *  This value may not be 0.
    */
  mDataLength: c.uint,

  /** Type information for the property.
    *
    * Defines the data layout inside the data buffer. This is used
    * by the library internally to perform debug checks and to
    * utilize proper type conversions.
    * (It's probably a hacky solution, but it works.)
    */
  mType: PropertyTypeInfo,

  /** Binary buffer to hold the property's value.
    * The size of the buffer is always mDataLength.
    */
  mData: ^c.char,
}

// ---------------------------------------------------------------------------
/** @brief Data structure for a material
*
*  Material data is stored using a key-value structure. A single key-value
*  pair is called a 'material property'. C++ users should use the provided
*  member functions of aiMaterial to process material properties, C users
*  have to stick with the aiGetMaterialXXX family of unbound functions.
*  The library defines a set of standard keys (AI_MATKEY_XXX).
*/
Material :: struct {
  /** List of all material properties loaded. */
  mProperties: [^]^MaterialProperty `fmt:"v,mNumProperties"`,

  /** Number of properties in the data base */
  mNumProperties: c.uint,

  /** Storage allocated */
  mNumAllocated: c.uint,
}
