{
  description = "A very basic flake";

  inputs.nixpkgs.url =
    "github:nixos/nixpkgs/1ac507ba981970c8e864624542e31eb1f4049751";

  inputs.customNixpkgs.url = "github:nixos/nixpkgs/4753aa83712b2870f091d57fbe06f823465228b5";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils, customNixpkgs }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };

        customPkgs = import customNixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };
      in {
        packages = pkgs.callPackage ./pkgs/top-level.nix { };

        devShell = pkgs.mkShell {
          NIX_PATH = "nixpkgs=${nixpkgs}";

          EMULATIONSTATION_CONFIG_DIR = "./config";
          EMULATIONSTATION_HOME_DIR = "./config";

          buildInputs = [
            pkgs.arion
            self.packages.x86_64-linux.emulationstation
            self.packages.x86_64-linux.skyscraper
          ];
        };

        utils = {
          buildSystem =
            { name, fullName, path, extension, command, platform, theme }: ''
              <system>
              <name>${name}</name>
              <fullname>${fullName}</fullname>
              <path>${path}</path>
              <extension>${extension}</extension>
              <command>${command}</command>
              <platform>${platform}</platform>
              <theme>${theme}</theme>
              </system>
            '';

          allSystemsConfig = systems:
            pkgs.writeText "es.config" ''
              <systemList>
                ${builtins.toString systems}
              </systemList>
            '';

          configDir = { theme }:
            pkgs.runCommand "config-dir" { preferLocalBuild = true; } ''
              mkdir -p $out/themes
              cp -rf ${theme.out} $out/themes/${theme.themeName}
            '';
        };

        defaultApp = let
          baseRomsFolder = "/run/media/juliosueiras/Backup/Roms";
          systemConfig = self.utils.${builtins.currentSystem}.allSystemsConfig [
            (self.utils.${builtins.currentSystem}.buildSystem {
              name = "ps2";
              fullName = "PlayStation 2";
              path = "${baseRomsFolder}/PS2";
              extension = ".iso";
              command =
                "${customPkgs.pcsx2}/bin/PCSX2 --fullboot --nogui --fullscreen %ROM%";
              platform = "ps2";
              theme = "ps2";
            })
            (self.utils.${builtins.currentSystem}.buildSystem {
              name = "gb";
              fullName = "Nintendo Game Boy";
              path = "${baseRomsFolder}/GB";
              extension = ".gb .zip";
              command = "${pkgs.libretro.gambatte}/bin/retroarch-gambatte -f %ROM%";
              platform = "gb";
              theme = "gb";
            })
            (self.utils.${builtins.currentSystem}.buildSystem {
              name = "gba";
              fullName = "Nintendo Game Boy Advance";
              path = "${baseRomsFolder}/GBA";
              extension = ".gba .zip";
              command = "${pkgs.libretro.mgba}/bin/retroarch-mgba -f %ROM%";
              platform = "gba";
              theme = "gba";
            })
            (self.utils.${builtins.currentSystem}.buildSystem {
              name = "gbc";
              fullName = "Nintendo Game Boy Color";
              path = "${baseRomsFolder}/GBC";
              extension = ".gbc .zip";
              command = "${pkgs.libretro.gambatte}/bin/retroarch-gambatte -f %ROM%";
              platform = "gbc";
              theme = "gbc";
            })
          ];
        in {
          type = "app";
          program = "${pkgs.writeShellScript "copy-system-config" ''
            mkdir -p ./config/themes/ckau-book
            cp -rf ${
              self.packages.${builtins.currentSystem}.emulationstation-themes.ckau-book
            }/* ./config/themes/ckau-book/
            cp ${systemConfig} ./config/es_systems.cfg
          ''}";
        };
      }) // ({ nixosModules = import ./modules/top-level.nix self; });
}
