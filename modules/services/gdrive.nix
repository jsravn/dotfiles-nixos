{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.services.gdrive;
  mountDir = "${config.my.homeDirectory}/Cloud/gdrive";
in {
  options.modules.services.gdrive = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    my = {
      packages = [ pkgs.rclone ];
      home.systemd.user.services.gdrive_mount = {
        Unit = {
          Description = "mount gdrive";
          After = "graphical-session.target";
        };
        Install.WantedBy = [ "graphical-session.target" ];
        Service = {
          ExecStartPre = "/run/current-system/sw/bin/mkdir -p ${mountDir}";
          ExecStart = ''
            ${pkgs.rclone}/bin/rclone mount google:/ ${mountDir} \
              --use-mmap \
              --vfs-cache-mode=full \
              --vfs-read-ahead=64M
          '';
          ExecStop = "${pkgs.fuse}/bin/fusermount -u ${mountDir}";
          Type = "notify";
          KillMode = "none";
          Restart = "always";
          RestartSec = "10m";
        };
      };
    };
  };
}
