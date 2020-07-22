{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.editors.intellij = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.editors.intellij.enable {
    my = {
      packages = with pkgs.unstable.jetbrains; [ idea-ultimate ];
      # Provide some JDKs that IntelliJ can use (it doesn't support direnv, unfortunately).
      home.xdg.dataFile = with pkgs; {
        "jdk8".source = unstable.jdk8;
        "jdk11".source = unstable.adoptopenjdk-bin;
      };
    };
  };
}
