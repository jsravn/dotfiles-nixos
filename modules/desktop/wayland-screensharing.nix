# Screensharing configuration for Wayland/Sway.
# Not working at the moment - there are various issues w/ Nix packages.
{ config, lib, pkgs, ... }:
with lib;
{
  config = mkIf config.modules.desktop.enable {
    # services.pipewire.enable = true;
    systemd.packages = with pkgs; [
      (unstable.pipewire.overrideAttrs (oldAttrs: rec {
        patches = [
          (fetchpatch {
            # https://gitlab.freedesktop.org/pipewire/pipewire/-/merge_requests/263
            url =
              "https://gitlab.freedesktop.org/flokli/pipewire/-/commit/b099f58b9e0a159926f2f66c72eae1b9ef7650d7.patch";
            sha256 = "0345y5lfjl98208jcysyqvj0yw6x977msr33p02dcjzyh8chp0w5";
          })
        ];
      }))
      my.xdg-desktop-portal
      my.xdg-desktop-portal-wlr
    ];
    systemd.user.sockets.pipewire.wantedBy = [ "sockets.target" ];
    services.dbus.packages = with pkgs; [
      my.xdg-desktop-portal
      my.xdg-desktop-portal-wlr
    ];
    environment.variables = {
      XDG_DESKTOP_PORTAL_DIR = pkgs.symlinkJoin {
        name = "xdg-portals";
        paths = [ pkgs.my.xdg-desktop-portal-wlr ];
      } + "/share/xdg-desktop-portal/portals";
    };
    # xdg.portal = {
    #   enable = true;
    #   extraPortals = with pkgs; [ my.xdg-desktop-portal-wlr ];
    #   gtkUsePortal = false;
    # };
  };
}
