{ config, lib, ... }:
with lib; {
  imports = [
    ./apps
    ./browsers.nix
    ./bluetooth.nix
    ./bspwm.nix
    ./fonts.nix
    ./gnome.nix
    ./kde.nix
    ./sound.nix
    ./sway.nix
    ./theme.nix
    ./xdg-mime.nix
    ./wayland-screensharing.nix
  ];

  options.modules.desktop = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    wallpaper.path = mkOption {
      type = types.path;
      default = <config/images/publicenemy1HDfree.jpg>;
    };
  };

  config = mkIf (builtins.pathExists config.modules.desktop.wallpaper.path) {
    my.home.home.file.".background-image".source = config.modules.desktop.wallpaper.path;
  };
}
