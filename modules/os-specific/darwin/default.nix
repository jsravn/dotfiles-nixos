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

    # My user.
    my.user = {
      home = "/Users/${config.my.username}";
      name = "${config.my.username}";
      shell = pkgs.zsh;
    };

    # Dotfiles location.
    my.dotfiles = "/Users/${config.my.username}/.dotfiles";

    # Enable fonts.
    fonts.enableFontDir = true;

    # Link home-manager packages to ~/Applications.
    system.build.applications = pkgs.lib.mkForce (pkgs.buildEnv {
      name = "system-applications";
      paths = config.my.packages
        ++ config.home-manager.users.${config.my.username}.home.packages
        ++ config.environment.systemPackages;
      pathsToLink = "/Applications";
    });

    system.activationScripts.applications.text = pkgs.lib.mkForce (''
      echo "setting up ~/Applications/Nix..."
      rm -rf ~/Applications/Nix
      mkdir -p ~/Applications/Nix
      chown ${config.my.username} ~/Applications/Nix
      find ${config.system.build.applications}/Applications -maxdepth 1 -type l | while read f; do
        echo "Linking $f"
        src="$(/usr/bin/stat -f%Y $f)"
        osascript -e "tell app \"Finder\" to make alias file at POSIX file \"/Users/${config.my.username}/Applications/Nix/\" to POSIX file \"$src\" with properties {name: \"$appname\"}";
      done
    '');

    # OSX Settings.
    system.defaults = {
      # Dock settings.
      dock = {
        # Autohide and remove the delay.
        autohide = true;
        autohide-delay = "0.0";
        autohide-time-modifier = "0.0";

        # Put on left of screen.
        orientation = "left";

        # Enable highlight hover effect.
        mouse-over-hilite-stack = true;

        # Default is 64.
        tilesize = 36;

        # Minimize effect.
        mineffect = "scale";

        # Minimize things to the application they are associated with.
        minimize-to-application = true;

        # Show indicator lights for open applications in the dock.
        show-process-indicators = true;

        # Reduce expose animation.
        expose-animation-duration = "0.1";

        # Don't animate opening applications from the dock.
        launchanim = false;

        # Don't group by application in Mission Control.
        expose-group-by-app = false;

        # Don't show dashboard as a space.
        dashboard-in-overlay = true;

        # Don't rearrange spaces automatically.
        mru-spaces = false;

        # Don't show recent applications in dock.
        show-recents = false;

        # Make hidden application icons translucent.
        showhidden = true;
      };

      # Enable tap to click.
      trackpad.Clicking = true;

      finder = {
        # Show all extensions.
        AppleShowAllExtensions = true;
        _FXShowPosixPathInTitle = true;
        FXEnableExtensionChangeWarning = false;

        # Allow quitting finder.
        QuitMenuItem = true;
      };

      NSGlobalDomain = {
        # Key rate.
        InitialKeyRepeat = 12;
        KeyRepeat = 1;

        # Improve font smooth on non-retina displays (https://sayzlim.net/font-smoothing-non-retina-display/).
        AppleFontSmoothing = 2;

        # Always show the scrollbars.
        AppleShowScrollBars = "Always";

        # Sidebar icon size to medium.
        NSTableViewDefaultSizeMode = 2;

        # Disable over the top focus animation.
        NSUseAnimatedFocusRing = false;

        # Speed up resize animation.
        NSWindowResizeTime = "0.001";

        # Expand save menus by default.
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;

        # Expand print menus by default.
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;

        # Save to disk by default, not iCloud :facepalm:.
        NSDocumentSaveNewDocumentsToCloud = false;

        # Display ASCII control characters using caret notation in standard text views.
        NSTextShowsControlCharacters = true;

        # Disable automatic termination of inactive apps - this isn't iOS goddammit.
        NSDisableAutomaticTermination = true;

        # Disable automatic capitalization.
        NSAutomaticCapitalizationEnabled = false;

        # Disable automatic dash substitution.
        NSAutomaticDashSubstitutionEnabled = false;

        # Disable "smart" period.
        NSAutomaticPeriodSubstitutionEnabled = false;

        # Disable "smart" quotation.
        NSAutomaticQuoteSubstitutionEnabled = false;

        # Disable automatic spelling correction.
        NSAutomaticSpellingCorrectionEnabled = false;

        # Disable inverse mouse scrolling.
        "com.apple.swipescrolldirection" = false;

        # Enable full keyboard access in all modes.
        AppleKeyboardUIMode = 3;

        # Disable press and hold - let us repeat by holding down keys.
        ApplePressAndHoldEnabled = false;

        # Enable expose for directories.
        "com.apple.springing.enabled" = true;
        "com.apple.springing.delay" = "0.0";
 
        # Set locale information. Not everything is available here - see the activation script below.
        AppleMeasurementUnits = "Centimeters";
        AppleMetricUnits = 1;
      };

      # Disable "Are you sure?" dialogue when running downloaded applications.
      LaunchServices.LSQuarantine = false;
    };

    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
      nonUS.remapTilde = true;
    };

    # Set things not in the nix-darwin module.
    # See https://github.com/mathiasbynens/dotfiles/blob/main/.macos for a reference of everything possible.
    # These should all be moved into the nix-darwin module at some point.
    system.activationScripts.extraUserActivation.text = ''
###############################################################################
# Home directory                                                              #
###############################################################################
# Remove zsh cache files and zgen files when configuration changes so it reconfigures.
pushd /Users/${config.my.username}/.cache
rm -rf zsh/*
rm -f zgen/init.zsh
popd

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true

# Increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en-GB" "en"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=GBP"

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "/Users/${config.my.username}/Desktop"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################
# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Show item info to the right of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Show the ~/Library folder
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library || true

# Remove Dropbox’s green checkmark icons in Finder
file=/Applications/Dropbox.app/Contents/Resources/emblem-dropbox-uptodate.icns
[ -e "''${file}" ] && mv -f "''${file}" "''${file}.bak"

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################
# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# Top left screen corner → Mission Control
defaults write com.apple.dock wvous-tl-corner -int 2
defaults write com.apple.dock wvous-tl-modifier -int 0
# Top right screen corner → Desktop
defaults write com.apple.dock wvous-tr-corner -int 4
defaults write com.apple.dock wvous-tr-modifier -int 0
# Bottom left screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

###############################################################################
# Google Chrome & Google Chrome Canary                                        #
###############################################################################

# Disable the all too sensitive backswipe on trackpads
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# Disable the all too sensitive backswipe on Magic Mouse
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

# Use the system-native print preview dialog
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome.canary DisablePrintPreview -bool true

# Expand the print dialog by default
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true
    '';

    # Things to run as the root user.
    system.activationScripts.extraActivation.text = ''
###############################################################################
# General UI/UX                                                               #
###############################################################################

# Disable the sound effects on boot
nvram SystemAudioVolume=" "

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Show language menu in the top right corner of the boot screen
defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

# Disable transparency in the menu bar and elsewhere on Yosemite
defaults write com.apple.universalaccess reduceTransparency -bool true

# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

###############################################################################
# Energy saving                                                               #
###############################################################################

## These power settings supposedly fix a lot of the problems w/ the macbook not sleeping properly.
# Enable lid wakeup
pmset -a lidwake 1

# Restart automatically on power loss
pmset -a autorestart 1

# Restart automatically if the computer freezes
systemsetup -setrestartfreeze on

# Sleep the display after 15 minutes
pmset -a displaysleep 15

# Disable machine sleep while charging
pmset -c sleep 0

# Set machine sleep to 5 minutes on battery
pmset -b sleep 5

# Set standby delay to 24 hours (default is 1 hour)
pmset -a standbydelay 86400

# Never go into computer sleep mode
systemsetup -setcomputersleep Off > /dev/null

# Hibernation mode
# 0: Disable hibernation (speeds up entering sleep mode)
# 3: Copy RAM to disk so the system state can still be restored in case of a
#    power failure.
pmset -a hibernatemode 0

# Remove the sleep image file to save disk space
# sudo rm /private/var/vm/sleepimage
# Create a zero-byte file instead…
# sudo touch /private/var/vm/sleepimage
# …and make sure it can’t be rewritten
# sudo chflags uchg /private/var/vm/sleepimage

###############################################################################
# Screen                                                                      #
###############################################################################

# Enable HiDPI display modes (requires restart)
defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Show the /Volumes folder
chflags nohidden /Volumes
'';

    # Use pinentry for gpg-agent.
    # HACK Without this config file you get "No pinentry program" on 20.03.
    #      program.gnupg.agent.pinentryFlavor doesn't appear to work, and this
    #      is cleaner than overriding the systemd unit.
    modules.shell.gpg.extraInit = [
      "pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac"
    ];

    # Darwin specific home-manager settings.
    my.home = {
      # Use keychain for ssh.
      programs.ssh.extraConfig = ''
        UseKeychain yes
        AddKeysToAgent yes
      '';
    };

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

    # Kludge to force git to use Apple ssh.
    my.env.SSH_GIT_COMMAND = "/usr/bin/ssh";
  };
}
