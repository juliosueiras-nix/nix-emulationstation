{
  description = "A very basic flake";

  inputs.nixpkgs.url =
    "github:nixos/nixpkgs/1ac507ba981970c8e864624542e31eb1f4049751";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };
      in {
        packages = pkgs.callPackage ./pkgs/top-level.nix { };

        devShell = pkgs.mkShell {
          NIX_PATH = "nixpkgs=${nixpkgs}";

          EMULATIONSTATION_CONFIG_DIR = "./config";
          EMULATIONSTATION_HOME_DIR = "./config";

          buildInputs = [ pkgs.arion self.packages.x86_64-linux.emulationstation self.packages.x86_64-linux.skyscraper];
        };
      }) // ({
        nixosModules = import ./modules/top-level.nix self;
      });

}
