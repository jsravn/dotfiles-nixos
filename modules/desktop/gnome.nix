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
      displayManager.gdm = {
        enable = true;
        autoSuspend = false;
      };
      desktopManager.gnome.enable = true;
      desktopManager.gnome.extraGSettingsOverrides = ''
        [org.gnome.desktop.peripherals.keyboard]
        repeat-interval = 35
        delay = 270

        [org.gnome.settings-daemon.plugins.media-keys]
        rotate-video-lock-static = []

        [org.gnome.desktop.wm.keybindings]
        switch-to-workspace-left = []
        switch-to-workspace-right = []
      '';
      autorun = true;
    };
    environment.systemPackages = with pkgs; [
      gnome.gnome-tweak-tool
      gnome.pomodoro
      gnomeExtensions.appindicator
      gnomeExtensions.caffeine
      # gnomeExtensions.system-monitor
      gnomeExtensions.clipboard-indicator
      # gnomeExtensions.dash-to-dock
      gnomeExtensions.cleaner-overview
      gnomeExtensions.vertical-overview
      gnomeExtensions.disable-workspace-switch-animation-for-gnome-40
      gnomeExtensions.paperwm
      gnomeExtensions.switcher
      unstable.gnomeExtensions.pop-shell
      #my.pop-launcher
    ];

    my.home.xdg.configFile."paperwm" = {
      source = <config/paperwm>;
      recursive = true;
    };

    # hide mouse cursor
    services.unclutter-xfixes.enable = true;
  };
}
