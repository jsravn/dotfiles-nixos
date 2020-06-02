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
      browsers.default = "chromium";
    };

    dev = {
      # Use shell.nix to avoid polluting the dev environment.
      # cc.enable = true;
      # go.enable = true;
    };

    editors = {
      default = "vim";
      emacs.enable = true;
      vim.enable = true;
    };

    # make-linux-fast-again.com
    security.mitigations.disable = true;
    security.mitigations.acceptRisk = true;

    services = {
      docker.enable = true;
      mullvad.enable = true;
      printers.enable = true;
    };

    shell.enable = true;

    work.sky.enable = true;
  };
}
