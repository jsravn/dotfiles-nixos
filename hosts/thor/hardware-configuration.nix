{ config, pkgs, lib, ... }:
with lib; {
  imports = [
    # Enables non-free firmware.
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  # Use custom linux firmware that has the more recent firmware.
  hardware.firmware = with pkgs; [ firmwareLinuxNonfree ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "ahci" "usbhid" "uas" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.kernelModules = [ "kvm-amd" "nct6775" "hid-apple" "wireguard" ];
  # Use F keys as default on MacOS keyboards (aka Keychron).
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
    options usbhid jspoll=1
  '';
  boot.kernelParams = [ "nomodeset" "acpi_enforce_resources=lax" "mitigations=off" ];

  ## CPU
  nix.maxJobs = lib.mkDefault 32;
  powerManagement.cpuFreqGovernor = "performance";
  hardware.cpu.amd.updateMicrocode = true;

  ## GPU
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    # Disable temporal dithering, just like in Windows. Let the display handle it.
    # Also disable gsync which messes up timings for mpv display-resample.
    deviceSection = ''
      Option "FlatPanelProperties" "Dithering=Disabled"
      Option "ModeValidation" "NoEdidHDMI2Check"
      Option "ModeValidation" "AllowNonEdidModes"
      Option "ModeDebug" "true"
    '';
    # 10-bit display.
    # defaultDepth = 30;
    # screenSection = ''
    # SubSection "Display"
    # Depth 30
    # EndSubSection
    # '';
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    # 32-bit support - not working on nvidia.
    driSupport32Bit = true;
  };
  hardware.nvidia.modesetting.enable = true;

  # Configure nvidia-settings.
  my.home.systemd.user.services.nvidia-settings = {
    Unit = {
      Description = "Set nvidia settings";
      After = "graphical-session.target";
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "/run/current-system/sw/bin/nvidia-settings -a AllowVRR=0";
      Type = "oneshot";
    };
  };

  ## Sound
  # Listen to SPDIF in.
  my.home.systemd.user.services.spdiflisten = {
    Unit = {
      Description = "link spdif in to sound output";
      BindsTo = "pipewire.service";
      After = "pipewire.service";
    };
    Install.WantedBy = [ "pipewire-media-session.service" ];
    Service = {
      # Kludge to deal w/ pipewire sound cards not being immediately available.
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      ExecStart = "${pkgs.pipewire}/bin/pw-link alsa_input.pci-0000_05_00.0.iec958-stereo:capture_FR alsa_output.usb-Topping_D10-00.analog-stereo:playback_FR";
      ExecStartPost = "${pkgs.pipewire}/bin/pw-link alsa_input.pci-0000_05_00.0.iec958-stereo:capture_FL alsa_output.usb-Topping_D10-00.analog-stereo:playback_FL";
      Type = "oneshot";
    };
  };

  ## SSDs
  services.fstrim.enable = true;

  ## Support NTFS volumes.
  boot.supportedFilesystems = [ "ntfs" ];

  ## Boot with UEFI.
  boot.loader = {
    timeout = 3;
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      # Disable when working - as this allows root access.
      editor = false;
      configurationLimit = 10;
      memtest86.enable = true;
    };
  };

  ## Storage
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
    "/windows" = {
      device = "/dev/nvme0n1p4";
      fsType = "ntfs";
      options = [ "rw" ];
    };
  };
  swapDevices = [ ];

  ## Networking
  networking.hostName = "thor";

  ## Bluetooth
  hardware.bluetooth.enable = true;
}
