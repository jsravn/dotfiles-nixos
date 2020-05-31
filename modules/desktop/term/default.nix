{ lib, config, ... }:
with lib;
{
  imports = [
    ./kitty.nix
  ];

  options.modules.desktop.term = {
    default = mkOption {
      type = types.str;
      default = "xterm";
    };
  };

  config = {
    services.xserver.desktopManager.xterm.enable =
      config.modules.desktop.term.default == "xterm";
  };
}
