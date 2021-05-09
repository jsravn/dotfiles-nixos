{ config, lib, pkgs, ... }:
with lib; {
  imports = [
    ./apps
    ./bluetooth.nix
    ./bspwm.nix
    ./fonts.nix
    ./gnome.nix
    ./kde.nix
    ./scanner.nix
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
  };
}
