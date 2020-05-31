{ config, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.apps.steam = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.steam.enable {
    my.packages = with pkgs; [ steam ];
  };
}
