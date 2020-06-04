{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    my.packages = with pkgs; [ keybase keybase-gui kbfs ];

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
