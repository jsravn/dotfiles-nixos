{ pkgs, config, lib, ... }:
with lib; {
  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [ direnv ];

      # Enable direnv.
      zsh.rc = ''eval "$(direnv hook zsh)"'';
    };
  };
}
