# Darwin specific configuration, using nix-darwin.

{ config, pkgs, ... }: {
  imports = [ <home-manager/nix-darwin> ];

  config = {
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    system.stateVersion = 4;

    # Enable the zsh interactive module.
    programs.zsh = {
      enable = true;
      promptInit = "";
      # Our zsh config sets up completion.
      enableCompletion = false;
    };

    # Dotfiles location.
    my.dotfiles = "/Users/${config.my.username}/.dotfiles";

    # Enable fonts.
    fonts.enableFontDir = true;

    # Remove zsh cache files.
    # Remove zgen files when configuration changes so it reconfigures.
    system.activationScripts.extraUserActivation.text = ''
      pushd /Users/${config.my.username}/.cache
      rm -rf zsh/*
      rm -f zgen/init.zsh
      popd
    '';

    # Link home-manager packages to ~/Applications.
    system.build.applications = pkgs.lib.mkForce (pkgs.buildEnv {
      name = "system-applications";
      paths = config.my.packages
        ++ config.home-manager.users.${config.my.username}.home.packages
        ++ config.environment.systemPackages;
      pathsToLink = "/Applications";
    });

    system.activationScripts.applications.text = pkgs.lib.mkForce (''
      echo "setting up ~/Applications/NixApps..."
      mkdir -p ~/Applications
      rm -rf ~/Applications/NixApps
      mkdir -p ~/Applications/NixApps
      chown ${config.my.username} ~/Applications/NixApps
      find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read f; do
        echo "Linking $f"
        src=$(/usr/bin/stat -f%Y $f)
        osascript -e "tell app \"Finder\" to make alias file at POSIX file \"/Users/${config.my.username}/Applications/NixApps/\" to POSIX file \"$src\"";
      done
    '');

    # OS Settings.
    system.defaults = {
      dock = { autohide = true; };

      finder = {
        AppleShowAllExtensions = true;
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;
      };

      NSGlobalDomain = {
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };
    };

    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
      nonUS.remapTilde = true;
    };

    # Use pinentry for gpg-agent.
    # HACK Without this config file you get "No pinentry program" on 20.03.
    #      program.gnupg.agent.pinentryFlavor doesn't appear to work, and this
    #      is cleaner than overriding the systemd unit.
    modules.shell.gpg.extraInit = [
      "pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac"
    ];

    # Use keychain for ssh.
    my.home.programs.ssh.extraConfig = ''
      UseKeychain yes
      AddKeysToAgent yes
    '';

    # Enable lorri.
    environment.systemPackages = [ pkgs.lorri ];
    # XXX: Copied verbatim from https://github.com/iknow/nix-channel/blob/7bf3584e0bef531836050b60a9bbd29024a1af81/darwin-modules/lorri.nix
    launchd.user.agents = {
      "lorri" = {
        serviceConfig = {
          WorkingDirectory = (builtins.getEnv "HOME");
          EnvironmentVariables = { };
          KeepAlive = true;
          RunAtLoad = true;
          StandardOutPath = "/var/tmp/lorri.log";
          StandardErrorPath = "/var/tmp/lorri.log";
        };
        script = ''
          source ${config.system.build.setEnvironment}
          exec ${pkgs.lorri}/bin/lorri daemon
        '';
      };
    };
  };
}
