{ pkgs, config, lib, ... }:
with lib;
{
  options.modules.system.tmp-tmpfs = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.system.tmp-tmpfs.enable {
    boot.tmpOnTmpfs = true;
  };
}
