# Screensharing configuration for Wayland/Sway.
# Not working at the moment - there are various issues w/ Nix packages.
{ config, lib, pkgs, ... }:
with lib;
let xdp = pkgs.enableDebugging pkgs.my.xdg-desktop-portal;
in {
  config = mkIf config.modules.desktop.enable {
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
