{ pkgs, config, lib, ... }:
with lib;
let my-python-packages = python-packages: with python-packages; [
      pip
      setuptools
    ];
    python-with-my-packages = pkgs.python3.withPackages my-python-packages;
in {
  options.modules.dev.python3 = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.dev.python3.enable {
    my = {
      packages = with pkgs; [
        python-with-my-packages
        python-language-server
      ];
    };
  };
}
