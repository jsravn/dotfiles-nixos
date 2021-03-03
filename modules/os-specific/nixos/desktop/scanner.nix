{ pkgs, config, lib, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    hardware.sane.enable = true;
    my.user.extraGroups = [ "scanner" "lp" ];
    my.packages = with pkgs; [ waifu2x-converter-cpp ];
  };
}
