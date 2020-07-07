{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    # Default applications and xdg-open.
    # See https://wiki.archlinux.org/index.php/XDG_MIME_Applications for details.
    my = {
      packages = with pkgs; [ xdg_utils desktop-file-utils ];
      home.xdg.mime.enable = true;
      home.xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = [ "writer.desktop" ];
          "application/pdf" = [ "org.gnome.Evince.desktop" ];
          "x-scheme-handler/http" = [ "chromium-browser.desktop" ];
          "x-scheme-handler/https" = [ "chromium-browser.desktop" ];
          "x-scheme-handler/slack" = [ "slack.desktop" ];
          "text/plain" = [ "org.gnome.gedit.desktop" ];
          "image/jpeg" = [ "eog.desktop" ];
        };
      };
    };
  };
}
