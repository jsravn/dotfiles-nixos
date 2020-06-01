{ pkgs, config, lib, ... }:
with lib;
{
  options.modules.shell.scmpuff = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [
        my.scmpuff
      ];

      zsh.rc = ''eval "$(scmpuff init -s)"'';
    };
  };
}
