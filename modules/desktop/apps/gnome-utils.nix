{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.desktop.apps.enable {
    my.packages = with pkgs; [
      gnome3.eog # Image viewer
      gnome3.evince # PDF/Document Viewer
      gnome3.gedit # A generic text editor
      gnome3.gnome-calculator # A nice calculator
      gnome3.nautilus # File browser
      gnome3.seahorse # Secret browser
    ];

    services.gvfs.enable = true;
    # unlock gnome-keyring on login. requires a keyring called "login".
    services.gnome3.gnome-keyring.enable = true;
  };
}
