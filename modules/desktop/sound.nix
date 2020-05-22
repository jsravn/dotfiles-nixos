{ config, lib, pkgs, ... }:
with lib; {
  options.modules.desktop.sound = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.sound.enable {
    sound.enable = true;
    hardware.pulseaudio.enable = true;
    hardware.pulseaudio.daemon.config = {
      # 5 is good - see https://gitlab.freedesktop.org/pulseaudio/pulseaudio/issues/310
      resample-method = "speex-float-5";
      flat-volumes = "no";
      # fix pa bug with realtime scheduling
      rlimit-rttime = "-1";
      default-sample-format = "float32le";
      default-sample-rate = "48000";
      alternate-sample-rate = "44100";
    };
    my.packages = with pkgs; [ pavucontrol ];
  };
}
