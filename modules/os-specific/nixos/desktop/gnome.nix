# Gnome
# Start with: systemctl start display-manager.service
{ config, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.gnome = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf config.modules.desktop.gnome.enable {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome3.enable = true;
      desktopManager.gnome3.extraGSettingsOverrides = ''
        [org.gnome.desktop.peripherals.keyboard]
        repeat-interval = 35
        delay = 270
      '';
      autorun = true;
    };
    environment.systemPackages = with pkgs; [
      gnome3.gnome-tweak-tool
      gnomeExtensions.appindicator
      gnomeExtensions.caffeine
      gnomeExtensions.system-monitor
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.dash-to-dock
      my.gnome-extension-paperwm
      my.gnome-extension-switcher
    ];

    my.home.xdg.configFile."paperwm" = {
      source = <config/paperwm>;
      recursive = true;
    };
  };
}
