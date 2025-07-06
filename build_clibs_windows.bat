@echo off
pushd source

mkdir build
pushd build
mkdir debug
pushd debug
:: Build Debug
cmake ..\.. ^
  -DBUILD_SHARED_LIBS=ON ^
  -DASSIMP_BUILD_ASSIMP_TOOLS=OFF ^
  -DASSIMP_BUILD_TESTS=OFF ^
  -DASSIMP_BUILD_SAMPLES=OFF ^
  -DASSIMP_NO_EXPORT=ON ^
  -DASSIMP_BUILD_ZLIB=ON ^
  -DASSIMP_INSTALL=OFF ^
  -DUSE_STATIC_CRT=OFF ^
  -DCMAKE_BUILD_TYPE=Debug
cmake --build . --config Debug --parallel

popd
mkdir release
pushd release

:: Build Release
cmake ..\.. ^
  -DBUILD_SHARED_LIBS=ON ^
  -DASSIMP_BUILD_ASSIMP_TOOLS=OFF ^
  -DASSIMP_BUILD_TESTS=OFF ^
  -DASSIMP_BUILD_SAMPLES=OFF ^
  -DASSIMP_NO_EXPORT=ON ^
  -DASSIMP_BUILD_ZLIB=ON ^
  -DASSIMP_INSTALL=OFF ^
  -DUSE_STATIC_CRT=ON ^
  -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release --parallel
:: "Command line warning D9025 : overriding '/MD' with '/MT'"

popd
popd
popd
