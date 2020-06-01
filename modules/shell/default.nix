{ lib, ... }:
with lib; {
  imports = [
    ./chezmoi.nix
    ./direnv.nix
    ./git.nix
    ./gpg.nix
    ./kubernetes.nix
    ./manpages.nix
    ./mail.nix
    ./packages.nix
    ./scmpuff.nix
    ./zsh.nix
  ];

  options.modules.shell = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
}
