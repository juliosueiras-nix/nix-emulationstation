{ stdenv, libvlc, libcec, libcec_platform, fetchgit, pkgconfig, cmake, curl, boost, eigen
, freeimage, freetype, libGLU, libGL, SDL2, SDL2_mixer, alsaLib, libarchive
, rapidjson, makeWrapper }:

let
  src = fetchgit {
    url = "https://github.com/batocera-linux/batocera-emulationstation";
    rev = "61cd03136cd282a305c1aee0ac7fff34aa46819e";
    sha256 = "csbezub17rf2QFwn3NnOCpEICXQ7hA7wSpDYevuuH1s=";
    deepClone = true;
  };

  resources = stdenv.mkDerivation {
    name = "emulationstation-resources";
    src = "${src}/resources";

    installPhase = ''
        mkdir -p $out
        cp -rf * $out/
    '';
  };
in stdenv.mkDerivation {
  pname = "emulationstation";
  version = "2021-04-08";

  inherit src;

  patches = [
    ./patch_dirs.patch
  ];

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ alsaLib boost curl eigen freeimage freetype libarchive libGLU libGL SDL2.dev SDL2_mixer libvlc libcec_platform libcec rapidjson makeWrapper ];

  cmakeFlags = [
    "-DSDLMIXER_INCLUDE_DIR=${SDL2_mixer}/include/SDL2"
  ];

  passthru = {
    inherit resources;
  };

  installPhase = ''
    install -D ../emulationstation $out/bin/emulationstation
    makeWrapper $out/bin/emulationstation $out/bin/emulationstation-frontend --set EMULATIONSTATION_RESOURCES_DIR ${resources}
  '';

  enableParallelBuilding = true;
}
