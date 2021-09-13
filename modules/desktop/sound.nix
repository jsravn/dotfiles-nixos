{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    # Enable alsa.
   # sound.enable = true;
    # hardware.pulseaudio = {
    #   enable = true;
    #   support32Bit = true;
    #   package = pkgs.pulseaudioFull; # Includes the JACK and bluetooth modules.
    #   daemon.config = {
    #     # 5 is good - see https://gitlab.freedesktop.org/pulseaudio/pulseaudio/issues/310
    #     resample-method = "speex-float-5";
    #     flat-volumes = "no";
    #     realtime-scheduling = "yes";
    #     default-sample-format = "float32le";
    #     default-sample-rate = "48000";
    #     alternate-sample-rate = "44100";
    #     # Just set DAC to the match the rate when possible.
    #     avoid-resampling = "yes";
    #   };
    # };

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
      pulseeffects-pw
      pavucontrol
      #pulseeffects-legacy
      # my.dsp
      # pulseeffects-pw
    ];
  };
}
