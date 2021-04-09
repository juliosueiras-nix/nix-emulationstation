{ stdenv, libvlc, libcec, libcec_platform, fetchgit, pkgconfig, cmake, curl, boost, eigen
, freeimage, freetype, libGLU, libGL, SDL2, SDL2_mixer, alsaLib, libarchive
, rapidjson }:

stdenv.mkDerivation {
  pname = "emulationstation";
  version = "2021-04-08";

  src = fetchgit {
    url = "https://github.com/batocera-linux/batocera-emulationstation";
    rev = "61cd03136cd282a305c1aee0ac7fff34aa46819e";
    sha256 = "hq61JHwhM3d9zjTjoTmmrAoR4UofcY08zIpfbeYfuKE=";
    deepClone = true;
  };

  patches = [
    ./patch_dirs.patch
  ];

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ alsaLib boost curl eigen freeimage freetype libarchive libGLU libGL SDL2.dev SDL2_mixer libvlc libcec_platform libcec rapidjson ];

  cmakeFlags = [
    "-DSDLMIXER_INCLUDE_DIR=${SDL2_mixer}/include/SDL2"
  ];

  installPhase = ''
    install -D ../emulationstation $out/bin/emulationstation
  '';

  enableParallelBuilding = true;
}
