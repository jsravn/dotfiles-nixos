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
    # systemd.mounts = [{
    #   type = "rclone";
    #   what = "mjolnir:/mnt";
    #   where = "/mnt/mjolnir";
    #   options = "rw,allow_other,use-mmap,vfs-cache-mode=full,config=/home/${config.my.username}/.config/rclone/rclone.conf";
    # }];

    # systemd.automounts = [{
    #   where = "/mnt/mjolnir";
    #   wantedBy = [ "default.target" ];
    # }];

    # environment.systemPackages = [
    #   (pkgs.rclone.overrideAttrs (oldAttrs: rec {
    #     postInstall = oldAttrs.postInstall + ''
    #       mkdir -p $out/sbin
    #       ln -s $out/bin/rclone $out/sbin/mount.rclone
    #     '';
    #   }))
    # ];

    # my = {
      # packages = [ pkgs.rclone ];
      # home.systemd.user.services.mjolnir_mount = {
      #   Unit = {
      #     Description = "mount mjolnir directories";
      #     After = "graphical-session.target";
      #   };
      #   Install.WantedBy = [ "graphical-session.target" ];
      #   Service = {
      #     ExecStartPre = "/run/current-system/sw/bin/mkdir -p ${mountDir}";
      #     ExecStart = ''
      #       ${pkgs.rclone}/bin/rclone mount mjolnir:/mnt ${mountDir} \
      #         --use-mmap \
      #         --vfs-cache-mode=full \
      #         --vfs-read-ahead=64M
      #     '';
      #     ExecStop = "${pkgs.fuse}/bin/fusermount -u ${mountDir}";
      #     Type = "notify";
      #     KillMode = "none";
      #     Restart = "always";
      #     RestartSec = "10m";
      #   };
      # };
    # };
  };
}
