{ pkgs, config, lib, ... }:
with lib;
{
  options.modules.system.network-manager = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.system.network-manager.enable {
    networking.networkmanager.enable = true;
  };
}
