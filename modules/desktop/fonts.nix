{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    fonts = {
      # fontDir.enable = true;
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
        dejavu_fonts
        noto-fonts-cjk
        noto-fonts-emoji
        font-awesome-ttf
      ];
      fontconfig = {
        defaultFonts = {
          sansSerif = [
            "DejaVu Sans"
            "Noto Sans CJK JP"
          ];
          serif = [
            "DejaVu Serif"
            "Noto Sans CJK JP"
          ];
          monospace = [
            "DejaVu Sans Mono"
            "Noto Sans Mono CJK JP"
          ];
          emoji = [
            "Noto Color Emoji"
          ];
        };
        subpixel = {
          lcdfilter = "default";
          rgba = "rgb";
        };
      };
    };

    # Enable CJK IME.
    i18n.inputMethod = {
      enabled = "fcitx";
      fcitx.engines = with pkgs.fcitx-engines; [ mozc ];
    };
  };
}
