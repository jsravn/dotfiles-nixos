{ lib, ... }:
with lib; {
  imports = [
    ./chezmoi.nix
    ./direnv.nix
    ./git.nix
    ./gpg.nix
    ./kubernetes.nix
    ./mail.nix
    ./packages.nix
    ./scmpuff.nix
    ./ssh.nix
    ./tmux.nix
    ./zsh.nix
  ];

  options.modules.shell = {
    enable = mkOption {
      type = types.bool;
      default = true;
    };
  };
}
