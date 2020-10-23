{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [ dejavu_fonts noto-fonts-emoji font-awesome-ttf ];
      fontconfig = {
        defaultFonts = {
          sansSerif = [ "DejaVu Sans" ];
          serif = [ "DejaVu Serif" ];
          monospace = [ "DejaVu Sans Mono" ];
          emoji = [ "Noto Color Emoji" ];
        };
        subpixel = {
          lcdfilter = "default";
          rgba = "rgb";
        };
      };
    };
  };
}
