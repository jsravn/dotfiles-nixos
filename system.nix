# NixOS specific configuration and modules.
{ config, lib, options, pkgs, stdenv, ... }:
with lib; {
  options = {
    username = mkOption {
      type = types.str;
      default = "james";
    };
  };

  config = {
    # This value determines the NixOS release with which your system is to be
    # compatible, in order to avoid breaking some software such as database
    # servers. You should change this only after NixOS release notes say you
    # should.
    system.stateVersion = "20.09";

    # Optimise hard disk space of store.
    nix.autoOptimiseStore = true;

    # Enable flakes.
    nix.package = pkgs.nixUnstable;
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Use tmpfs for /tmp.
    boot.tmpOnTmpfs = true;

    # Many modern apps require a large number of watches.
    boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

    # Raise nofile limits for esync.
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";
    systemd.user.extraConfig = "DefaultLimitNOFILE=1048576";

    # Networking settings.
    networking.networkmanager.enable = true;
    networking.firewall.logRefusedConnections = false;

    # Core system packages for NixOS.
    environment.systemPackages = with pkgs; [
      coreutils
      killall
      unzip
      vim
      wget
      curl
      gnumake
      file
      pciutils
      usbutils
      libsysfs
      lm_sensors
    ];

    # Login user.
    users.users.${username} = {
      home = "/home/${username}";
      name = config.username;
      isNormalUser = true;
      uid = 1000;
      extraGroups = [ "wheel" "audio" "video" "networkmanager" "input" ];
      shell = pkgs.zsh;
    };

    # Clean up leftovers, as much as we can
    system.userActivationScripts.cleanupHome = ''
      pushd /home/${config.my.username}
      rm -rf .compose-cache .nv .pki .dbus .fehbg
      [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';

    # Clean up mesa cache - can change when versions update.
    system.userActivationScripts.cleanupMesaCache = ''
      pushd /home/${config.my.username}/.cache
      rm -rf mesa_shader_cache
      popd
    '';

    # Remove zsh cache files.
    # Remove zgen files when NixOS configuration changes so it reconfigures.
    system.userActivationScripts.cleanupZsh = ''
      pushd /home/${config.my.username}/.cache
      rm -rf zsh/*
      rm -f zgen/init.zsh
      popd
    '';

    # Enable all the dev documentation.
    documentation.dev.enable = true;

    # Enable the zsh interactive module.
    programs.zsh = {
      enable = true;
      promptInit = "";
      enableCompletion = true;
      enableGlobalCompInit = false;
    };

    # Use pinentry for gpg-agent.
    # HACK Without this config file you get "No pinentry program" on 20.03.
    #      program.gnupg.agent.pinentryFlavor doesn't appear to work, and this
    #      is cleaner than overriding the systemd unit.
    modules.shell.gpg.extraInit =
      [ "pinentry-program ${pkgs.pinentry.gtk2}/bin/pinentry" ];

    # Use gpg as the ssh agent.
    programs.gnupg.agent.enableSSHSupport = true;

    # Add /bin/bash. Yes, it's not pure, but it is pragmatic to do so.
    system.activationScripts.binbash = ''
      mkdir -m 0755 -p /bin
      ln -sfn ${pkgs.bash}/bin/bash /bin/.bash.tmp
      mv /bin/.bash.tmp /bin/bash # atomically replace /bin/bash
    '';

    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      users.${config.username} = args: import ./home.nix (args // { inherit pkgs; });
    };
  };
}
