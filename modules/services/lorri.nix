# Lorri service - relies on direnv to work seamlessly.
{ config, options, pkgs, lib, ... }:
with lib; {
  options.modules.services.lorri = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.services.lorri.enable {
    services.lorri.enable = true;
  };
}
