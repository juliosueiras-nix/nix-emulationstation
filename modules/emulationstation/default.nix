self:

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.valheim-server;

  buildSystem = {name, fullname, path, extension, command, platform, theme} : ''
    <system>
		  <name>${name}</name>
		  <fullname>${fullname}</fullname>
		  <path>${path}</path>
		  <extension>${extension}</extension>
		  <command>${command}</command>
		  <platform>${platform}</platform>
		  <theme>${theme}</theme>
	  </system>
  '';
in {
  #options = {
  #  services.valheim-server = {
  #    enable = mkOption {
  #      type = types.bool;
  #      default = false;
  #    };

  #    package = mkOption {
  #      type = types.package;
  #      default = self.packages.${builtins.currentSystem}.valheim-server;
  #    };

  #    password = mkOption {
  #      type = types.str;
  #    };

  #    port = mkOption {
  #      type = types.int;
  #      default = 2456;
  #    };

  #    displayName = mkOption {
  #      type = types.str;
  #    };

  #    worldName = mkOption {
  #      type = types.str;
  #    };

  #    public = mkOption {
  #      type = types.bool;
  #      default = true;
  #    };
  #  };
  #};

  #config = mkIf cfg.enable {
  #  systemd.services.valheim-server = {
  #    wantedBy = [ "multi-user.target" ];
  #    after = [ "network.target" ];

  #    serviceConfig = {
  #      ExecStart = ''${cfg.package}/bin/valheim-server -name "${cfg.displayName}" -port ${toString cfg.port} -nographics -batchmode -world "${cfg.worldName}" -password "${cfg.password}" -public "${if cfg.public then "1" else "0"}"'';
  #    };
  #  };
  #};
}
