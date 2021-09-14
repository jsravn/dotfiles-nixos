{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # required for pipewire PA emulation
    hardware.pulseaudio.enable = false;
    # required for realtime audio
    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      alsaUtils
      pavucontrol
      unstable.easyeffects
    ];
  };
}
