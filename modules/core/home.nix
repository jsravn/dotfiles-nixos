# modules/core/default.nix -- configures my user's home
{ config, lib, options, pkgs, ... }:
with lib;
let
  mkOptionStr = value:
    mkOption {
      type = types.str;
      default = value;
    };
in {
  options = {
    # Contains my user configuration.
    my = {
      # Personal details.
      username = mkOptionStr "james";
      email = mkOptionStr "james@r-vn.org";
      latitude = mkOptionStr "51.508166";
      longitude = mkOptionStr "-0.075971";

      # Convenience aliases.
      home =
        mkOption { type = options.home-manager.users.type.functor.wrapped; };
      user = mkOption { type = types.submodule; };
      packages = mkOption { type = with types; listOf package; };

      # Global environment.
      env = mkOption {
        type = with types;
          attrsOf (either (either str path) (listOf (either str path)));
        apply = mapAttrs (n: v:
          if isList v then
            concatMapStringsSep ":" (x: toString x) v
          else
            (toString v));
      };

      # Global aliases.
      alias = mkOption {
        type = with types; nullOr (attrsOf (nullOr (either str path)));
      };
    };
  };

  config = {
    # Convenience aliases
    home-manager.users.${config.my.username} =
      mkAliasDefinitions options.my.home;
    users.users.${config.my.username} = mkAliasDefinitions options.my.user;

    my = {
      user.packages = config.my.packages;

      # Obey XDG.
      home.xdg.enable = true;

      # Conform more programs to XDG conventions. The rest are handled by their
      # respective modules.
      env = {
        __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        HISTFILE = "$XDG_DATA_HOME/bash/history";
        INPUTRC = "$XDG_CACHE_HOME/readline/inputrc";
        LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
      };

      # Add the bin folder to the user PATH.
      env.PATH = [ <bin> "$XDG_BIN_HOME" "$PATH" ];
    };

    environment.variables = {
        # These are the defaults, but some applications are buggy when these lack
        # explicit values.
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_BIN_HOME = "$HOME/.local/bin";
    };

    # Configure environment.
    environment.extraInit = let
      exportLines = mapAttrsToList (n: v: ''export ${n}="${v}"'') config.my.env;
    in ''
      ${concatStringsSep "\n" exportLines}
    '';
  };
}
