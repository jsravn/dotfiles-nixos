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
        fasd
        fd
        fzf
        tldr
        trash-cli
        htop
        libnotify
        my.notify-send-sh
      ];

      # Bind ls to exa, and add additional useful aliases.
      alias.exa = "exa --group-directories-first";
      alias.l = "exa -1";
      alias.ll = "exa -lg";
      alias.la = "LC_COLLATE=C exa -la";
      alias.ls = "exa";

      # Store zsh config and cache in XDG directories.
      env.ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
      env.ZSH_CACHE = "$XDG_CACHE_HOME/zsh";

      home = {
        # I avoid programs.zsh.*Init variables because they initialize too soon. My
        # zsh config is particular about load order.
        xdg.configFile = {
          # zsh config directory.
          "zsh" = {
            source = <config/zsh>;
            # Allow other modules to write files to it.
            recursive = true;
          };

          # Contains aliases and extra zshrc from other modules.
          "zsh/extra.zshrc".text =
            let aliasLines = mapAttrsToList (n: v: "alias ${n}=\"${v}\"") config.my.alias;
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

    # Enable the nix zsh interactive module.
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      # I init completion myself, because enableGlobalCompInit initializes it too
      # soon, which means commands initialized later in my config won't get
      # completion, and running compinit twice is slow.
      enableGlobalCompInit = false;
      promptInit = "";
    };

    # Remove zsh cache files.
    # Remove zgen files when NixOS configuration changes so it reconfigures.
    system.userActivationScripts.cleanupZsh = ''
      pushd /home/${config.my.username}/.cache
      rm -rf zsh/*
      rm -f zgen/init.zsh
      popd
    '';
  };
}
