{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.shell.gpg;
  homedir = "$XDG_CONFIG_HOME/gnupg";
in {
  options.modules.shell.gpg = {
    cacheTTL = mkOption {
      type = types.int;
      default = 1800;
    };

    extraInit = mkOption {
      type = with types; listOf str;
      default = [];
    };
  };

  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [ gnupg ];
      
      env.GNUPGHOME = homedir;

      home.xdg.configFile."gnupg/gpg-agent.conf" = {
        text = ''
          default-cache-ttl ${toString cfg.cacheTTL}
          # These allow Emacs to prompt for the gpg passphrase in the minibuffer.
          # This allows using Emacs in a TTY.
          allow-emacs-pinentry
          allow-loopback-pinentry
          ${concatStringsSep "\n" config.modules.shell.gpg.extraInit}
        '';
      };

      home.xdg.configFile."gnupg/gpg.conf".text = ''
        default-key 52C372C72159D6EE
      '';
    };

    programs.gnupg = {
      agent.enable = true;
      agent.enableSSHSupport = true;
    };
  };
}
