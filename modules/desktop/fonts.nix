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
        # Ensure missing emojis/unicode characters fallback to Noto.
        localConf = ''
          <?xml version='1.0'?>
          <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
          <fontconfig>
            <match target="pattern">
                <edit name="family" mode="append">
                    <string>Noto Color Emoji</string>
                </edit>
            </match>
          </fontconfig>
        '';
      };
    };
  };
}
