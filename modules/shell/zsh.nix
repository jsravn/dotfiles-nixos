{ pkgs, config, lib, ... }:
with lib; {
  options = {
    # My additional zsh configuration, used by other modules.
    my = {
      zsh = {
        rc = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshrc and
            sourced by $XDG_CONFIG_HOME/zsh/.zshrc
          '';
        };
        env = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshenv and
            sourced by $XDG_CONFIG_HOME/zsh/.zshenv
          '';
        };
      };
    };
  };

  config = mkIf config.modules.shell.enable {
    my = {
      packages = with pkgs; [
        zsh
        nix-zsh-completions
        bat
        exa
        du-dust
        fasd
        fd
        fzf
        procs
        tldr
        trash-cli
        libnotify
        my.notify-send-sh
      ];

      # Store zsh config and cache in XDG directories.
      env.ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
      env.ZSH_CACHE = "$XDG_CACHE_HOME/zsh";

      home = {
        # zsh config.
        xdg.configFile."zsh" = {
          source = <config/zsh>;
          # recursive to allow the extra files to be managed separately.
          recursive = true;
        };

        # I avoid programs.zsh.*Init variables because they initialize too soon. My
        # zsh config is particular about load order.
        xdg.configFile = {
          # Contains aliases and extra zshrc from other modules.
          "zsh/extra.zshrc".text = let
            aliasLines =
              mapAttrsToList (n: v: ''alias ${n}="${v}"'') config.my.alias;
          in ''
            # This file is autogenerated, do not edit it!
            ${concatStringsSep "\n" aliasLines}
            ${config.my.zsh.rc}
          '';

          # Contains zsh specific environment variables (for interactive shells).
          "zsh/extra.zshenv".text = ''
            # This file is autogenerated, do not edit it!
            ${config.my.zsh.env};
          '';
        };
      };
    };
  };
}
