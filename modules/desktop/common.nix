{ config, lib, pkgs, ... }:
{
  # Redshift config
  my.home.xdg.configFile."redshift.conf".text = ''
    [redshift]
    location-provider=manual
    temp-day=6500

    [manual]
    lat=${config.my.latitude}
    lon=${config.my.longitude}
  '';

  # GTK-3 theme.
  my.home.xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-application-prefer-dark-theme=1
    gtk-icon-theme-name=Adwaita
    gtk-theme-name=Adwaita-dark
    gtk-font-name=DejaVu Sans 11
    gtk-cursor-theme-name=Adwaita
    gtk-cursor-theme-size=0
    gtk-toolbar-style=GTK_TOOLBAR_BOTH
    gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
    gtk-button-images=1
    gtk-menu-images=1
    gtk-enable-event-sounds=1
    gtk-enable-input-feedback-sounds=1
    gtk-xft-antialias=1
    gtk-xft-hinting=1
    gtk-xft-hintstyle=hintfull
    gtk-xft-rgba=rgb
  '';
}
