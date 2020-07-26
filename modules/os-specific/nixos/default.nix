# NixOS specific configuration and modules.

{ config, lib, options, pkgs, stdenv, ... }:
with lib; {
  imports = [
    <home-manager/nixos>
    ./desktop # X11/Wayland desktop apps
    ./security # Security settings
    ./services # Background services
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03";

  # Optimise hard disk space of store.
  nix.autoOptimiseStore = true;

  # Use tmpfs for /tmp.
  boot.tmpOnTmpfs = true;

  # Many modern apps require a large number of watches.
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

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
    libsysfs
    lm_sensors
  ];

  # NixOS specific packages for my user.
  my.packages = with pkgs; [ my.cached-nix-shell ];

  # Dotfiles location.
  my.dotfiles = "/etc/dotfiles";

  # Login user.
  my.user = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "audio" "video" "networkmanager" ];
    description = "James Ravn";
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
    # I init completion myself, because enableGlobalCompInit initializes it too
    # soon, which means commands initialized later in my config won't get
    # completion, and running compinit twice is slow.
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
}
