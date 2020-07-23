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
      env.GNUPGHOME = homedir;

      # HACK Without this config file you get "No pinentry program" on 20.03.
      #      program.gnupg.agent.pinentryFlavor doesn't appear to work, and this
      #      is cleaner than overriding the systemd unit.
      home.xdg.configFile."gnupg/gpg-agent.conf" = {
        text = ''
          enable-ssh-support
          default-cache-ttl ${toString cfg.cacheTTL}
          ${concatStringsSep "\n" config.modules.shell.gpg.extraInit}
        '';
      };

      home.xdg.configFile."gnupg/gpg.conf".text = ''
        default-key 52C372C72159D6EE
      '';
    };

    programs.gnupg.agent.enable = true;
    programs.gnupg.agent.enableSSHSupport = true;
  };
}
