{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    services = {
      syncthing = {
        enable = true;
        package = pkgs.unstable.syncthing;
        user = config.my.username;
        # This setting seems to be completely ignored in the Nixos module.
        dataDir = "/home/${config.my.username}/Sync";
        configDir = "/home/${config.my.username}/.config/syncthing";
      };
    };
  };
}
