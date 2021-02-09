{ config, lib, pkgs, ... }:
with lib; {
  config = mkIf config.modules.desktop.enable {
    sound.enable = true;
    hardware.pulseaudio = {
      enable = true;
      support32Bit = true;
      package = pkgs.pulseaudioFull; # Includes the JACK and bluetooth modules.
      daemon.config = {
        # 5 is good - see https://gitlab.freedesktop.org/pulseaudio/pulseaudio/issues/310
        resample-method = "speex-float-5";
        flat-volumes = "no";
        realtime-scheduling = "yes";
        default-sample-format = "float32le";
        default-sample-rate = "48000";
        alternate-sample-rate = "44100";
      };
    };
    security.rtkit.enable = true;
    my.packages = with pkgs; [ pavucontrol ];
  };
}
