# NixOS specific configuration.

{ config, options, pkgs, ... }: {
  imports = [ <home-manager/nixos> ];

  config = {
    # This value determines the NixOS release with which your system is to be
    # compatible, in order to avoid breaking some software such as database
    # servers. You should change this only after NixOS release notes say you
    # should.
    system.stateVersion = "20.03";

    # Optimise hard disk space of store.
    nix.autoOptimiseStore = true;

    # Add search paths so they can be referenced directly in modules.
    nix.nixPath = options.nix.nixPath.default
      ++ [ "bin=/etc/nixfiles/bin" "config=/etc/nixfiles/config" ];

    # Add custom overlays to override packages.
    # See https://nixos.org/nixpkgs/manual/#chap-overlays for details.
    nixpkgs.overlays = import ../../packages;

    # Allow unfree packages.
    nixpkgs.config.allowUnfree = true;

    # Aliases for nixos.
    environment.shellAliases = {
      nix-env = "NIXPKGS_ALLOW_UNFREE=1 nix-env";
      nix-shell = ''
        NIX_PATH="nixpkgs-overlays=/etc/nixfiles/packages/default.nix:$NIX_PATH" nix-shell'';
    };

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
      git
      killall
      unzip
      vim
      wget
      curl
      gnumake
      file
    ];

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
  };
}
