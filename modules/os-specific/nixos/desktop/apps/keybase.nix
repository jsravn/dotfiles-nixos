{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    my.packages = with pkgs; [ keybase-gui ];

    services.kbfs.enable = true;
    services.keybase.enable = true;
  };
}
