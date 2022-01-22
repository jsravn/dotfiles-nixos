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
    # systemd.mounts = [{
    #   type = "rclone";
    #   what = "google:";
    #   where = "/mnt/google";
    #   options = "vv,rw,allow_other,use-mmap,vfs-cache-mode=full,config=/home/${config.my.username}/.config/rclone/rclone.conf";
    # }];

    # systemd.automounts = [{
    #   where = "/mnt/google";
    #   wantedBy = [ "default.target" ];
    # }];

    # environment.systemPackages = [
    #   pkgs.my.rclone
    # ];
  };
}
