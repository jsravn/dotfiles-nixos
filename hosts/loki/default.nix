# Loki is a macbook that relies on nix-darwin.

{ pkgs, ... }: {
  imports = [ <modules/os-specific/darwin> ];

  time.timeZone = "Europe/London";

  modules = {
    editors = {
      default = "nvim";
      vim.enable = true;
      emacs = {
        enable = true;
        managePackage = false;
      };
    };

    shell.enable = true;
    term.kitty.enable = true;
    term.tmux.enable = true;
    work.sky.enable = true;
  };
}
