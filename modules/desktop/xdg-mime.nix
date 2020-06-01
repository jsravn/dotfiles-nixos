{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    # Default applications and xdg-open.
    # See https://wiki.archlinux.org/index.php/XDG_MIME_Applications for details.
    xdg.mime.enable = true;
    my.packages = with pkgs; [ xdg_utils ];
  };
}
