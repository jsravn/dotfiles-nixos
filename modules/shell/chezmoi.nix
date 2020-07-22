{ pkgs, config, lib, ... }:
with lib; {
  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [ unstable.chezmoi lastpass-cli ];
      home.xdg.configFile."chezmoi/chezmoi.toml".text = ''
        sourceDir = "/home/${config.my.username}/.dotfiles/chezmoi"
        [sourceVCS]
        autoCommit = true
      '';

      # Don't use pinentry in lastpass-cli - always use console.
      env.LPASS_DISABLE_PINENTRY = "1";
    };
  };
}
