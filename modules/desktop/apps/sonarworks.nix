# Configures the various programs required to use the Sonarworks VST plugin.
# To set up:
#
# Set up NSM/Carla

# Start non-session-manager.
# Click New to start a new session, call it e.g. Sonarworks.
# Click Add Client to Session. Type in the command: carla
# Do the same thing, but for the command jackpatch.
# Click save to save the session.
# Carla should have opened up when you added it to the session. Configure it now:1 ms

# Click the Rack tab
# Click Add Plugin, click Refresh. It should find the Sonarworks VST - select it, then click Add Plugin. If it didn't find it, make sure you put it in ~/.vst.
# You'll see Sonarworks Reference 4 in the rack. Click the gear icon, and you can set-up Sonarworks as normal, including entering your license key.
# Click on the Patchbay tab. You should see PulseAudio JACK Sink, a system box with playback channels, and a Carla.nORVX box which represents the rack including sonarworks. The latter box may be hidden on the corner of the canvas - zoom out (ctrl -) and you should find it.
# You want to drag these close to each other, and then connect it from JACK Sink to Carla.nORVX to system playback. You can right click on the box to disconnect the existing connections. Then drag between the blue inner boxes to connect everything. The "1" and "2" correspond to left and right channels. See the diagram below.
# Click save in Carla.
#
# To use:
# jack-start <usb device>
# Run non-session-manager, and select the Sonarworks session.
# 
{ config, lib, pkgs, ... }:
with lib;
{
  options.modules.desktop.apps.sonarworks = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf config.modules.desktop.apps.sonarworks.enable {
    my.packages = with pkgs; [
      carla
      jack2
      non
      (writeScriptBin "jack-start" ''
        #!${stdenv.shell}

        # Pre-reqs:
        # pacman -S jack2 pulseaudio-jack qjackctl non-session-manager
        #
        # Then invoke with ./jackstart.sh <card>
        # Then start up non-session-manager
        #
        # Find card with cat /proc/asound/cards

        set -eu

        # stop jack if running
        jack_control stop
        # start up jack
        jack_control ds alsa
        jack_control dps device hw:$1
        # gives 10ms latency - (147/44100)*3
        jack_control dps rate 48000
        jack_control dps nperiods 3
        jack_control dps period 256
        jack_control start
      '')
    ];

    # Don't auto connect when starting jack - let non-session-manager do that.
    hardware.pulseaudio.extraConfig = ''
      .ifexists module-jackdbus-detect.so
      .nofail
      load-module module-jackdbus-detect connect=no channels=2
      .fail
      .endif
    '';
  };
}
