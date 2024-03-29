# For doom-emacs.
# From https://github.com/hlissner/dotfiles/blob/1eeb7af2bb7f49fa46bb9a880eb787da9454cafa/modules/editors/emacs.nix.
{ config, options, lib, pkgs, ... }:
with lib; {
  options.modules.editors.emacs = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    managePackage = mkOption {
      type = types.bool;
      default = true;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.emacsNativeComp;
      description = "The Emacs package to use.";
    };
  };

  config = mkIf config.modules.editors.emacs.enable {
    my = {
      home.programs.emacs = {
        enable = config.modules.editors.emacs.managePackage;
        package = config.modules.editors.emacs.package;
        extraPackages = epkgs: [ epkgs.vterm ];
      };

      packages = with pkgs; [
        ## Doom dependencies
        (ripgrep.override { withPCRE2 = true; })
        gnutls # for TLS connectivity

        ## Optional dependencies
        fd # faster projectile indexing
        imagemagick # for image-dired
        (lib.mkIf (pkgs.stdenv.isLinux)
          pinentry_emacs) # in-emacs gnupg prompts
        zstd # for undo-tree compression

        ## Module dependencies
        # :checkers spell
        (aspellWithDicts(ps: [ps.en ps.en-computers]))
        # :checkers grammar
        languagetool
        # :tools lookup
        # :tools editorconfig
        editorconfig-core-c # per-project style config
        # :tools lookup & :lang org +roam
        sqlite
        clang
        # :lang cc
        ccls
        # :lang javascript
        # nodePackages.javascript-typescript-langserver
        # # :lang latex & :lang org (latex previews)
        # texlive.combined.scheme-medium
        # :lang markdown
        pandoc
        # :lang nix
        nixfmt
        # :lang rust
        # rustfmt
        # rls
        # :lang sh
        shfmt
        shellcheck
        # :lang yaml
        #yaml-language-server
        # :term vterm
        # use shell.nix with libvterm-neovim:
        # { pkgs ? import <nixpkgs> {} }:
        # pkgs.mkShell {
        #   buildInputs = with pkgs; [ cmake libtool gcc libvterm-neovim ];
        # }
      ];

      env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];

      # Prefer GB spellings.
      home.home.file.".aspell.conf".text = ''
        master en_GB
        extra-dicts en_US
      '';

      alias.ec = "emacsclient -n";
      alias.e = "emacs -nw";
    };

    fonts.fonts = with pkgs; [ emacs-all-the-icons-fonts dejavu_fonts noto-fonts-emoji ];
  };
}
