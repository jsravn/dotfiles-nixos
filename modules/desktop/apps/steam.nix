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
    hardware.opengl.driSupport32Bit = true;
    hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
    hardware.pulseaudio.support32Bit = true;
  };
}
