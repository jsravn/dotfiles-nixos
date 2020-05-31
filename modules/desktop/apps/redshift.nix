{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop.apps.redshift;
in {
  options.modules.desktop.apps.redshift = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    wayland = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    my = {
      packages = with pkgs; if cfg.wayland then [ redshift-wlr ] else [ redshift ];
      home.xdg.configFile."redshift.conf".text = ''
        [redshift]
        location-provider=manual
        temp-day=6500

        [manual]
        lat=${config.my.latitude}
        lon=${config.my.longitude}
      '';
    };
  };
}
