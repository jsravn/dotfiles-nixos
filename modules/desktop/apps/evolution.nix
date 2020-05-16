{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.apps.evolution = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.evolution.enable {
    my.packages = with pkgs; [
      gnome3.evolution
    ];
  };
}
