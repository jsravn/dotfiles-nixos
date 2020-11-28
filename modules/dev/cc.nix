{ pkgs, lib, config, ... }:
with lib; {
  options.modules.dev.cc = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.dev.cc.enable {
    my = { packages = with pkgs; [ cmake gnumake libtool clang gdb ]; };
  };
}
