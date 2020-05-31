{ pkgs, config, lib, ... }:
with lib; {
  options.modules.users.james-darwin = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.users.james-darwin.enable {
    my = {
      user = {
        description = "James Ravn";
        shell = pkgs.zsh;
      };
    };
  };
}
