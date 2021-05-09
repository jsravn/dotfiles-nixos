{ config, lib, pkgs, ... }:

with lib;

let
  name = "roon-bridge";
  cfg = config.modules.services.roon-bridge;
  pkg = pkgs.my.roon-bridge;
in {
  options.modules.services.roon-bridge = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    my = {
      packages = [ pkg ];
    };

    systemd.services.roon-bridge = {
      after = [ "network.target" ];
      description = "Roon Bridge";
      wantedBy = [ "multi-user.target" ];

      environment.ROON_DATAROOT = "/var/lib/${name}";

      serviceConfig = {
        ExecStart = "${pkg}/start.sh";
        LimitNOFILE = 8192;
        User = "${name}";
        Group = "${name}";
        StateDirectory = name;
      };
    };

    # XXX hack to get roon-bridge to connect to roon-core
    # it seems to listen on a random port, not sure how to fix that
    networking.firewall.enable = false;
    networking.firewall = {
      allowedTCPPortRanges = [
        { from = 9100; to = 9200; }
      ];
      allowedUDPPorts = [ 9003 ];
    };

    users.groups.${name} = {};
    users.users.${name} = {
      isSystemUser = true;
      description = "Roon Bridge user";
      group = name;
      extraGroups = [ "audio" ];
    };
  };
}
