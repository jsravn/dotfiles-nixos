{ pkgs, config, lib, ... }:
with lib;
{
  options.modules.shell.chezmoi = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.chezmoi.enable {
    my = {
      packages = with pkgs; [
        unstable.chezmoi
        lastpass-cli
      ];
    };
  };
}
