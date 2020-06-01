{ pkgs, config, lib, ... }:
with lib;
{
  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [
        kubectl
        kubectx
      ];

      alias.k = "kubectl";
      alias.kgpo = "k get pod";
      zsh.rc = ''source <(kubectl completion zsh)
               '' + readFile <config/kubernetes/aliases.zsh>;
    };
  };
}
