{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.apps.keybase = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.keybase.enable {
    my.packages = with pkgs; [
      keybase
      keybase-gui
      kbfs
    ];

    services.kbfs = {
      enable = true;
      mountPoint = "%t/kbfs";
      extraFlags = [ "-label %u" ];
    };

    systemd.user.services.kbfs = {
      environment = { KEYBASE_RUN_MODE = "prod"; };
      serviceConfig.Slice = "keybase.slice";
    };
  };
}
