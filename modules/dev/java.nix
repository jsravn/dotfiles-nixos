{ pkgs, lib, config, ... }:
with lib; {
  options.modules.dev.java = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.dev.java.enable {
    # Enable global default java.
    programs.java.enable = true;

    # Also install different JDK versions.
    my.home.xdg.dataFile = {
      "jdk8".source = "${pkgs.jdk8}/lib/openjdk";
      "jdk11".source = "${pkgs.jdk11}/lib/openjdk";
    };
  };
}
