{ pkgs, config, lib, ... }:
with lib; {
  options.modules.users.james = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.users.james.enable {
    my = {
      user = {
        isNormalUser = true;
        uid = 1000;
        extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
        description = "James Ravn";
        shell = pkgs.zsh;
      };
    };
  };
}
