{ pkgs, config, lib, ... }:
with lib; {
  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [ kubectl kubectx ];

      zsh.rc = ''
        source <(kubectl completion zsh)
      '' + readFile <config/kubernetes/aliases.zsh>;
    };
  };
}
