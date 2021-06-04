# The core system configuration.
#
# This is applied to all systems and contains the core configuration for my user.
{ config, lib, options, pkgs, ... }:
with lib;
let
  mkOptionStr = value:
    mkOption {
      type = types.str;
      default = value;
    };
  userType = options.users.users.type.functor.wrapped;
  mkOptionFloat = value:
    mkOption {
      type = types.float;
      default = value;
    };
in {
  imports = [
    <home-manager/nixos>
    ./nixos.nix
  ];

  options = {
    # Contains my user configuration.
    my = {
      # Personal details.
      username = mkOptionStr "james";
      homeDirectory = mkOptionStr "";
      email = mkOptionStr "james@r-vn.org";
      latitude = mkOptionFloat 51.508166;
      longitude = mkOptionFloat (-0.075971);

      # Convenience aliases.
      home =
        mkOption { type = options.home-manager.users.type.functor.wrapped; };
      user = mkOption { type = userType; };
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
        default = { };
      };

      # Dotfiles location.
      dotfiles = mkOptionStr "/etc/dotfiles";
    };
  };

  config = {
    # Convenience aliases
    home-manager.users.${config.my.username} =
      mkAliasDefinitions options.my.home;
    users.users.${config.my.username} = mkAliasDefinitions options.my.user;

    # Use the nixos user packages when installing packages via home-manager.
    home-manager.useUserPackages = true;
    # Use the global nixpkgs definition.
    home-manager.useGlobalPkgs = true;

    my = {
      homeDirectory = "/home/${config.my.username}";

      home = {
        # Obey XDG.
        xdg.enable = true;
        home.username = config.my.username;
        home.homeDirectory = config.my.homeDirectory;
      };

      # Define user packages.
      user.packages = config.my.packages;

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
      NIXPKGS_ALLOW_UNFREE = "1";
    };

    # Configure environment.
    environment.extraInit = let
      exportLines = mapAttrsToList (n: v: ''export ${n}="${v}"'') config.my.env;
    in ''
      ${concatStringsSep "\n" exportLines}
    '';

    # Add search paths so they can be referenced directly in modules.
    nix.nixPath = options.nix.nixPath.default ++ [
      "bin=${config.my.dotfiles}/bin"
      "config=${config.my.dotfiles}/config"
    ];

    # Add custom overlays to override packages.
    # See https://nixos.org/nixpkgs/manual/#chap-overlays for details.
    nixpkgs.overlays = import ../../packages;

    # Allow unfree packages.
    nixpkgs.config.allowUnfree = true;

    # Allow some insecure packages.
    nixpkgs.config.permittedInsecurePackages = [
      "ffmpeg-3.4.8"
    ];

    # Aliases for nixos.
    environment.shellAliases = {
      nix-shell = ''
        NIX_PATH="nixpkgs-overlays=${config.my.dotfiles}/packages/default.nix:$NIX_PATH" nix-shell'';
    };
  };
}
