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
      packages = with pkgs; [ go ];

      env.GOPATH = "$HOME/go:$HOME/godev";
      env.PATH = [ "$HOME/go/bin" ];
    };
  };
}
