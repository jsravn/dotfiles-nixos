{ pkgs, lib, config, ... }:
with lib; {
  options.modules.dev.java = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.dev.java.enable {
    programs.java.enable = true;
    programs.java.package = pkgs.jdk8;
  };
}
