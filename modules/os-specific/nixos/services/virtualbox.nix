{ config, options, pkgs, lib, ... }:
with lib; {
  options.modules.services.virtualbox = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.services.virtualbox.enable {
    virtualisation.virtualbox = {
      host.enable = true;
      host.enableExtensionPack = true;
    };
    users.extraGroups.vboxusers.members = [ config.my.username ];
  };
}
