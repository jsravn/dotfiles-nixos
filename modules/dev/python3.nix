{ pkgs, config, lib, ... }:
with lib; {
  options.modules.dev.python3 = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.dev.python3.enable {
    my = {
      packages = with pkgs; [ python3Minimal ];
    };
  };
}
