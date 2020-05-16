{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.apps.keybase = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.keybase.enable {
    my.packages = with pkgs; [
      keybase-gui
    ];
  };
}
