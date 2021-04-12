{ stdenv, lib, fetchurl }:

let
  buildTheme = { name, url, sha256 }: stdenv.mkDerivation {
    name = "emulationstation-theme-${name}";

    src = fetchurl {
      inherit url sha256;
    };

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };
in {
  ckau-book = buildTheme {
    name = "ckau-book";
    url = "https://github.com/CkauNui/ckau-book/archive/ce23599828dc11c5711246aaab13c51d9f571fda.tar.gz";
    sha256 = "c94t7xgGG96F0feIh2f/yhfdxRC4JBQVxA6ii1/iHBw=";
  };
}

