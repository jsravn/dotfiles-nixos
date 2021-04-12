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
      packages = with pkgs.jetbrains; [ idea-ultimate ];
      home.xdg.configFile."JetBrains/IntelliJIdea2020.1".source = <config/intellij>;
    };
  };
}
