{ pkgs, config, lib, ... }:
with lib;
{
  options.modules.shell.kubernetes = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.shell.kubernetes.enable {
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
