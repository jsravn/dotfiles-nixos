# Screensharing configuration for Wayland/Sway.
#
# This enables chromium to do screensharing when the pipewire flag is enabled in chrome://flags.
#
# This only works with chromium on unstable - which breaks opening links from stable apps. So for now,
# this will have to wait until the next NixOS stable release.
{ config, lib, pkgs, ... }:
with lib;
let xdp = pkgs.unstable.xdg-desktop-portal;
in {
  config = mkIf false {
    systemd.packages = with pkgs; [
      unstable.pipewire
      xdp 
      unstable.xdg-desktop-portal-wlr
    ];
    systemd.user.sockets.pipewire.wantedBy = [ "sockets.target" ];
    services.dbus.packages = with pkgs; [
      xdp
      unstable.xdg-desktop-portal-wlr
    ];
    environment.variables = {
      XDG_DESKTOP_PORTAL_DIR = pkgs.symlinkJoin {
        name = "xdg-portals";
        paths = [ pkgs.unstable.xdg-desktop-portal-wlr ];
      } + "/share/xdg-desktop-portal/portals";
    };
  };
}
