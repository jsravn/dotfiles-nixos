# Thor is my desktop machine.

{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  # General configuration
  time.timeZone = "Europe/London";

  # Modules
  modules = {
    desktop = {
      enable = true;
      sway.hwmonTemp = "/sys/class/hwmon/hwmon0/temp1_input";
    };

    dev = {
      cc.enable = true;
      go.enable = true;
    };

    editors = {
      default = "vim";
      emacs.enable = true;
      vim.enable = true;
    };

    security = {
      # make-linux-fast-again.com
      mitigations.disable = true;
      mitigations.acceptRisk = true;
    };

    services = {
      docker.enable = true;
      mullvad.enable = true;
    };

    shell = {
      cached-nix-shell.enable = true;
      chezmoi.enable = true;
      direnv.enable = true;
      git.enable = true;
      gpg.enable = true;
      isync.enable = true;
      kubernetes.enable = true;
      manpages.enable = true;
      mu.enable = true;
      netutils.enable = true;
      scmpuff.enable = true;
      zsh.enable = true;
    };

    work = {
      sky.enable = true;
    };
  };
}
