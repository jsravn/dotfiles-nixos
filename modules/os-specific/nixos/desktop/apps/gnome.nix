# Install gnome applications and utilities.
# For use with non-gnome display managers.
{ config, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.apps.gnome = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf config.modules.desktop.apps.gnome.enable {
    my = {
      packages = with pkgs; [
        # Gnome utility apps
        gnome3.eog # Image viewer
        gnome3.evince # PDF/Document Viewer
        gnome3.gedit # A generic text editor
        gnome3.gnome-calculator # A nice calculator
        gnome3.gnome-disk-utility # Format disks from nautilus
        gnome3.nautilus # File browser
        gnome3.seahorse # Secret browser
      ];
    };

    # Add support for mounting network filesystems to Nautilus
    services.gvfs.enable = true;

    # Unlock gnome-keyring on login. Requires a keyring called "login".
    services.gnome3.gnome-keyring.enable = true;
  };
}
