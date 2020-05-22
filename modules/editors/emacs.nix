# For doom-emacs.
# From https://github.com/hlissner/dotfiles/blob/1eeb7af2bb7f49fa46bb9a880eb787da9454cafa/modules/editors/emacs.nix.
{ config, options, lib, pkgs, ... }:
with lib;
{
  options.modules.editors.emacs = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.editors.emacs.enable {
    my = {
      packages = with pkgs; [
        ## Doom dependencies
        emacsUnstable
        git
        (ripgrep.override {withPCRE2 = true;})
        gnutls              # for TLS connectivity

        ## Optional dependencies
        fd                  # faster projectile indexing
        imagemagick         # for image-dired
        (lib.mkIf (config.programs.gnupg.agent.enable)
          pinentry_emacs)   # in-emacs gnupg prompts
        zstd                # for undo-tree compression

        ## Module dependencies
        # :checkers spell
        aspell
        aspellDicts.en
        aspellDicts.en-computers
        aspellDicts.en-science
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
        nodePackages.javascript-typescript-langserver
        # :lang latex & :lang org (latex previews)
        texlive.combined.scheme-medium
        # :lang nix
        nixfmt
        # :lang rust
        rustfmt
        rls
        # :term vterm
        cmake
      ];

      env.PATH = [ "$XDG_CONFIG_HOME/emacs/bin" ];
      zsh.rc = lib.readFile <config/emacs/aliases.zsh>;

      # Prefer GB spellings.
      home.home.file.".aspell.conf".text = ''
        master en_GB
        extra-dicts en_US
      '';
    };

    fonts.fonts = [
      pkgs.emacs-all-the-icons-fonts
    ];
  };
}
