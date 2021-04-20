{ stdenv, lib, fetchurl, runCommand, curl, cacert, unzip}:

let

  gdriveDownload = fileid: runCommand "gdrive-download" { preferLocalBuild = true; buildInputs = [ curl cacert ]; } ''
    curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=${fileid}" > /dev/null
    curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=`awk '/download/ {print $NF}' ./cookie`&id=${fileid}" -o $out
  '';

  buildTheme = { name, url, sha256, postBuild ? "" }: stdenv.mkDerivation {
    name = "emulationstation-theme-${name}";

    src = fetchurl {
      inherit url sha256;
    };

    passthru = {
      themeName = name;
    };

    inherit postBuild;

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

    postBuild = ''
      ${unzip}/bin/unzip ${gdriveDownload "1mjMWW4szkzqYBc4MyqgA1UlFIqA3jMW-"}
      cp -rf ckau-book/* .
      rm -rf ckau-book
    '';
  };
}

