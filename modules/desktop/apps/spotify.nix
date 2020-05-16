{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.apps.spotify = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.spotify.enable {
    my.packages = with pkgs; [
      spotify
    ];
  };
}
