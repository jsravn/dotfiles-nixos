# Loki is a macbook that relies on nix-darwin.

{ pkgs, ... }: {
  imports = [ <modules/os-specific/darwin> ];

  time.timeZone = "Europe/London";
  networking.hostName = "loki";

  modules = {
    dev = {
      go.enable = true;
    };

    editors = {
      default = "nvim";
      vim.enable = true;
      emacs = {
        enable = true;
        managePackage = false;
      };
    };

    shell = {
      enable = true;
      git.managePackage = false;
    };

    term.kitty.enable = true;
    term.tmux.enable = true;
    work.sky.enable = true;
  };
}
