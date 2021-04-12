let
  emulationstation = (import ./. {}).defaultNix.packages.x86_64-linux.emulationstation;
in {
  services.webserver = { pkgs, ... }: {
    nixos.useSystemd = true;
    nixos.configuration = {
      boot.tmpOnTmpfs = true;

      users.users = {
        vagrant = {
          isNormalUser = true;
          shell = "${pkgs.bashInteractive}/bin/bash";
          uid = 1000;
          extraGroups = [ "vagrant" ];
        };
      };

      users.groups = {
        vagrant = {
          gid = 499;
        };
      };

      environment.systemPackages = [
        emulationstation
      ];
    };
    service.useHostStore = true;
    service.environment = {
      DISPLAY = ":1";
      EMULATIONSTATION_HOME_DIR = "/home/vagrant/config";
      EMULATIONSTATION_CONFIG_DIR = "/home/vagrant/config";
    };
  };
}
