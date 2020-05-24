{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.apps.lutris = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.lutris.enable {
    my.packages = with pkgs; [
      lutris
    ];
  };
}
