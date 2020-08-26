# Initially generated by 'nixos-generate-config' on qemu.
{ config, pkgs, lib, ... }:
with lib; {
  imports = [
    # Enables non-free firmware.
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  # Use custom linux firmware that has the more recent amdgpu firmware (navi14).
  hardware.firmware = with pkgs; [ firmwareLinuxNonfree ];

  # Use latest kernel to better support 5500XT.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "uas" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.kernelModules = [ "kvm-intel" "nct6775" "hid-apple" ];
  # Use F keys as default on MacOS keyboards (aka Keychron).
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=2
  '';
  # Unlocks more sensors.
  boot.kernelParams = mkBefore [ "acpi_enforce_resources=lax" ];

  ## CPU
  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = "performance";
  hardware.cpu.intel.updateMicrocode = true;

  ## GPU
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ libva ];
  };

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
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };
  };
  swapDevices = [ ];

  ## Networking
  networking.hostName = "thor";
}
