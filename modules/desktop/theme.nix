{ pkgs, config, lib, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    my = {
      home.gtk = {
        enable = true;
        iconTheme = {
          name = "Adwaita";
          package = pkgs.gnome3.adwaita-icon-theme;
        };
        theme = {
          name = "Adwaita";
          package = pkgs.gnome3.gnome_themes_standard;
        };
        font.name = "DejaVu Sans 11";
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = 1;
          gtk-cursor-theme-size = 0;
          gtk-cursor-theme-name = "Aidwata";
          gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
          gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
          gtk-button-images = 1;
          gtk-menu-images = 1;
          gtk-enable-event-sounds = 1;
          gtk-enable-input-feedback-sounds = 1;
          gtk-xft-antialias = 1;
          gtk-xft-hinting = 1;
          gtk-xft-hintstyle = "hintfull";
          gtk-xft-rgba = "rgb";
        };
      };

      home.home.file.".icons/default/index.theme".text = ''
        [Icon Theme]
        Inherits=Aidwata
      '';
    };
  };
}
