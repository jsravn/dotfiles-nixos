{ pkgs, config, lib, ... }:
with lib; {
  options.modules.dev.go = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.dev.go.enable {
    my = {
      packages = with pkgs; [
        # use latest released golang
        unstable.go
        # gcc is needed for cgo
        gcc
      ];

      env.GOPATH = "$HOME/go";
      env.PATH = [ "$HOME/go/bin" ];
    };
  };
}
