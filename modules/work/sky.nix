{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.work.sky;
in {
  options.modules.work.sky = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    my = {
      home.programs.ssh.extraConfig = "Include sky";
      packages = with pkgs; [ aws openconnect ] ++ optional pkgs.stdenv.isLinux networkmanager-openconnect;
    };
    # For when Sky DNS fails.
    networking.extraHosts = ''
      80.238.0.29 skyremoteaccess.bskyb.com
    '';
  };
}
