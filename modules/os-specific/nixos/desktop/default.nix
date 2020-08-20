{ lib, ... }:
with lib; {
  imports = [
    ./apps
    ./browsers.nix
    ./fonts.nix
    ./xorg.nix
    # ./sddm.nix
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
