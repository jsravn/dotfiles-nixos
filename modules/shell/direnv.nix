{ pkgs, config, lib, ... }:
with lib; {
  config = mkIf config.modules.shell.enable {
    # See https://github.com/nix-community/nix-direnv
    environment.systemPackages = with pkgs; [ direnv nix-direnv ];
    # nix options for derivations to persist garbage collection
    nix.extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';
    environment.pathsToLink = [ "/share/nix-direnv" ];

    my = {
      # Enable direnv.
      zsh.rc = ''eval "$(direnv hook zsh)"'';

      # Enable nix-direnv.
      home.xdg.configFile."direnv/direnvrc".source = "${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
    };
  };
}
