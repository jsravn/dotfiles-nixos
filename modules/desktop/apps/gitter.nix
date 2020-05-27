{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.apps.gitter = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.gitter.enable {
    my.packages = with pkgs; [
      gitter
    ];
  };
}
