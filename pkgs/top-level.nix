{ callPackage, ... }:

{
  emulationstation = callPackage ./emulationstation {};
  emulationstation-themes = callPackage ./emulationstation/themes.nix {};
  skyscraper = callPackage ./skyscraper {};
}
