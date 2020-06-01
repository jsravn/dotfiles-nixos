{ lib, ... }:
with lib; {
  imports = [
    ./apps
    ./browsers.nix
    ./fonts.nix
    ./sound.nix
    ./sway.nix
    ./term.nix
    ./theme.nix
    ./xdg-mime.nix
  ];

  options.modules.desktop = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
}
