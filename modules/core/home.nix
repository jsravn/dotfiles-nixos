# modulues/core/home.nix -- configures my user's home
{ config, lib, options, pkgs, ... }:
with lib;
let mkOptionStr = value: mkOption
  { type = types.str;
    default = value; };
in {
  imports = [
    <home-manager/nixos>
  ];

  options = {
    # Contains my user configuration.
    my = {
      # Personal details.
      username = mkOptionStr "james";
      email = mkOptionStr "james@r-vn.org";
      latitude = mkOptionStr "51.508166";
      longitude = mkOptionStr "-0.075971";

      # Convenience aliases.
      home = mkOption { type = options.home-manager.users.type.functor.wrapped; };
      user = mkOption { type = types.submodule; };
      packages = mkOption { type = with types; listOf package; };

      # Global environment.
      env = mkOption {
        type = with types; attrsOf (either (either str path) (listOf (either str path)));
        apply = mapAttrs
          (n: v: if isList v
                then concatMapStringsSep ":" (x: toString x) v
                else (toString v));
      };

      # Global aliases.
      alias = mkOption {
        type = with types; nullOr (attrsOf (nullOr (either str path)));
      };
    };
  };

  config = {
    # Convenience aliases
    home-manager.users.${config.my.username} = mkAliasDefinitions options.my.home;
    users.users.${config.my.username} = mkAliasDefinitions options.my.user;
    my.user.packages = config.my.packages;

    my.user = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
      description = "James Ravn";
      shell = pkgs.zsh;
    };

    # Obey XDG.
    my.home.xdg.enable = true;
    environment.variables = {
      # These are the defaults, but some applications are buggy when these lack
      # explicit values.
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_DATA_HOME   = "$HOME/.local/share";
      XDG_BIN_HOME    = "$HOME/.local/bin";
    };

    # Conform more programs to XDG conventions. The rest are handled by their
    # respective modules.
    my.env = {
      __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      HISTFILE = "$XDG_DATA_HOME/bash/history";
      INPUTRC = "$XDG_CACHE_HOME/readline/inputrc";
      LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
    };

    # Add the bin folder to the user PATH.
    my.env.PATH = [ <bin> "$PATH" ];

    # Configure environment.
    environment.extraInit =
      let exportLines = mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.my.env;
      in ''
        ${concatStringsSep "\n" exportLines}
      '';

    # SSH configuration.
    my.home.programs.ssh = {
      enable = true;
      matchBlocks."*" = {
        compression = true;
        user = "${config.my.username}";
      };
      matchBlocks."hamster.lan" = {
        user = "root";
      };
    };

    # Clean up leftovers, as much as we can
    system.userActivationScripts.cleanupHome = ''
      pushd /home/${config.my.username}
      rm -rf .compose-cache .nv .pki .dbus .fehbg
      [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';
  };
}
