{ config, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.fonts = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.fonts.enable {
    fonts = {
      enableFontDir = true;
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
