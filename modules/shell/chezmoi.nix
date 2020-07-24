{ pkgs, config, lib, ... }:
with lib; {
  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [ unstable.chezmoi lastpass-cli ];
      home.xdg.configFile."chezmoi/chezmoi.toml".text = ''
        sourceDir = "${config.my.dotfiles}/chezmoi"
      '';

      # Don't use pinentry in lastpass-cli - always use console.
      env.LPASS_DISABLE_PINENTRY = "1";
    };
  };
}
