{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.services.mjolnir;
  mountDir = "${config.my.homeDirectory}/Cloud/mjolnir";
in {
  options.modules.services.mjolnir = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    my = {
      home.systemd.user.services.mjolnir_mount = {
        Unit = {
          Description = "mount mjolnir directories";
        };
        Install.WantedBy = [ "default.target" ];
        Service = {
          ExecStartPre = "/run/current-system/sw/bin/mkdir -p ${mountDir}";
          ExecStart = ''
            ${pkgs.rclone}/bin/rclone mount mjolnir:/mnt/unionfs ${mountDir} \
              --use-mmap \
              --vfs-cache-mode=full \
              --vfs-read-ahead=64M
          '';
          ExecStop = "${pkgs.fuse}/bin/fusermount -u ${mountDir}";
          Type = "notify";
          KillMode = "none";
          Restart = "always";
          RestartSec = "1h";
        };
      };
    };
  };
}
