{ config, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.xdg-mime = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.xdg-mime.enable {
    # Default applications and xdg-open.
    # See https://wiki.archlinux.org/index.php/XDG_MIME_Applications for details.
    xdg.mime.enable = true;
    my.packages = with pkgs; [ xdg_utils ];
  };
}
