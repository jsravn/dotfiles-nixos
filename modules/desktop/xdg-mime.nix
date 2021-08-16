{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.desktop;
in {
  config = mkIf cfg.enable {
    # Default applications and xdg-open.
    # See https://wiki.archlinux.org/index.php/XDG_MIME_Applications for details.
    my = {
      packages = with pkgs; [ xdg_utils desktop-file-utils perl530Packages.FileMimeInfo ];
      home.xdg.mime.enable = true;
      home.xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "writer.desktop" ];
          "application/pdf" = [ "org.gnome.Evince.desktop" ];
          "x-scheme-handler/http" = [ cfg.browsers.defaultDesktop ];
          "x-scheme-handler/https" = [ cfg.browsers.defaultDesktop ];
          "scheme-handler/http" = [ cfg.browsers.defaultDesktop ];
          "scheme-handler/https" = [ cfg.browsers.defaultDesktop ];
          "application/xhtml+xml" = [ cfg.browsers.defaultDesktop ];
          "text/html" = [ cfg.browsers.defaultDesktop ];
          "text/markdown" = [ "org.gnome.gedit.desktop" ];
          "x-scheme-handler/slack" = [ "slack.desktop" ];
          "text/plain" = [ "org.gnome.gedit.desktop" ];
          "image/jpeg" = [ "org.gnome.eog.desktop" ];
          "image/png" = [ "org.gnome.eog.desktop" ];
          "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        };
      };
      # Overwrite any changes made manually to the mimeapps.list.
      home.xdg.configFile."mimeapps.list".force = true;
    };
  };
}
