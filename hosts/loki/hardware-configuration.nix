{ config, pkgs, lib, ... }:
with lib; {
  imports = [
    # Enables non-free firmware.
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  # Enable linux firmware package.
  hardware.firmware = with pkgs; [ firmwareLinuxNonfree ];

  # use latest kernel.
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "ahci" "usbhid" "uas" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.extraModulePackages = [ ];
  boot.kernelModules = [ "kvm-amd" "nct6775" "hid-apple" "wireguard" ];
  # 1. Use F keys as default on MacOS keyboards (aka Keychron).
  # 2. Fix ax210 wifi crashes.
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
    options iwlmvm power_scheme=1
  '';
  boot.kernelParams = [ "iommu=pt" ];

  ## CPU
  nix.maxJobs = lib.mkDefault 16;
  hardware.cpu.amd.updateMicrocode = true;
  # AMD + power-profiles-daemon don't work due to https://bugzilla.kernel.org/show_bug.cgi?id=215177,
  # so use auto-cpufreq instead.
  services.auto-cpufreq.enable = true;
  services.power-profiles-daemon.enable = false;

  ## GPU
  services.xserver = {
    videoDrivers = [ "amdgpu" ];
  };
  hardware.opengl = {
    enable = true;
    driSupport = true;
    # 32-bit support - not working on nvidia.
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };
  hardware.video.hidpi.enable = true;

  # wayland fixes for gdm to prevent crashing at startup
  #systemd.services."getty@tty1".enable = false;
  #systemd.services."autovt@tty1".enable = false;

  ## SSDs
  services.fstrim.enable = true;

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
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  };
  swapDevices = [
    {
      device = "/swapfile";
      size = 1024 * 8;
    }
  ];

  ## Networking
  networking.hostName = "loki";

  ## Bluetooth
  hardware.bluetooth.enable = true;
}
