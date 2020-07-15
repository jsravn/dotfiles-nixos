# Thor is my desktop machine.

{ ... }: {
  imports = [ ./hardware-configuration.nix ];

  # General configuration
  time.timeZone = "Europe/London";

  # Modules
  modules = {
    desktop = {
      enable = true;
      sway.hwmonTemp = "/sys/class/hwmon/hwmon1/temp1_input";
      sway.extraConfig = [
        "output DP-1 mode 2560x1440@165Hz"
        "output DP-1 subpixel rgb"
        "output DP-1 max_render_time 6"
      ];
      browsers.default = "chromium";
    };

    dev = {
      # cc.enable = true;
      go.enable = true;
      node.enable = true;
    };

    editors = {
      default = "vim";
      emacs.enable = true;
      intellij.enable = true;
      vim.enable = true;
    };

    # make-linux-fast-again.com
    security.mitigations.disable = true;
    security.mitigations.acceptRisk = true;

    services = {
      docker.enable = true;
      libvirtd.enable = true;
      mullvad.enable = true;
      printers.enable = true;
    };

    shell.enable = true;

    work.sky.enable = true;
  };
}
