# Thor is my desktop machine.

{ pkgs, ... }: {
  imports = [
    <modules/os-specific/nixos>
    ./hardware-configuration.nix
  ];

  # General configuration
  time.timeZone = "Europe/London";

  # Modules
  modules = {
    desktop = {
      enable = true;
      # bspwm.enable = true;
      sway = {
        enable = true;
        temperatureHwmonPath = "/sys/devices/platform/nct6775.656/hwmon";
        temperatureHwmonName = "temp1_input";
        extraConfig = [
          # Dedicated GPU.
          "output DP-1 mode 2560x1440@165Hz"
          "output DP-1 subpixel rgb"
          "output DP-1 max_render_time 6"
          # Onboard Intel.
          "output DP-5 mode 2560x1440@165Hz"
          "output DP-5 subpixel rgb"
        ];
      };
      browsers.default = "chromium";
      # To accelerate for Intel graphics.
      browsers.chromium.useVaapi = true;
      bluetooth.enable = true;
    };

    term.kitty.enable = true;
    term.tmux.enable = true;

    dev = {
      cc.enable = true;
      go.enable = true;
      # node.enable = true;
      python3.enable = true;
    };

    editors = {
      default = "nvim";
      intellij.enable = true;
      vim.enable = true;
      emacs.enable = true;
    };

    # make-linux-fast-again.com
    security.mitigations.disable = true;
    security.mitigations.acceptRisk = true;

    services = {
      docker.enable = true;
      libvirtd.enable = true;
      lorri.enable = true;
      mullvad.enable = true;
      printers.enable = true;
      ssh.enable = true;
      #virtualbox.enable = true;
    };

    shell.enable = true;

    work.sky.enable = true;
  };
}
