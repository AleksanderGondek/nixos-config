globalprotect{ config, pkgs, ... }:

{
  imports = [
    ./hardware/work-laptop.nix
    ./base.nix
    ./network/ntp-from-secret.nix
    ./desktops/default-desktop.nix
    ./virtualisation/docker.nix
    ./user-profile.nix
  ];

  # Use the systemd-boot EFI boot loader.
  # Whole disk is encrypted via luks
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    version = 2;
    efiSupport = true;
    enableCryptodisk = true;
    extraInitrd = "/boot/initrd.keys.gz";
  };
  boot.initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/disk/by-uuid/b76f891e-e1ce-401a-ab04-2605a7190e36";
        preLVM = true;
        keyFile = "/keyfile0.bin";
        allowDiscards = true;
      }
  ];

  # Dell Precision 5540 - Disable nvidia, 
  # ensure WiFi & thunderbolt will work
  hardware.enableRedistributableFirmware = true;
  boot.kernelModules = [ "kvm-intel" "iwlwifi"];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  ##### disable nvidia, very nice battery life.
  hardware.nvidiaOptimus.disable = true;
  boot.blacklistedKernelModules = [ "nouveau" "nvidia" ];
  services.xserver.videoDrivers = [ "intel" ];

  # Counteract high-temperatures
  services.thermald.enable = true;

  networking.hostId = "d3b1c241";
  networking.hostName = "TAG009443491811";
  networking.useDHCP = false;
  networking.interfaces.ens1u2u4.useDHCP = true;
  networking.interfaces.wlp59s0.useDHCP = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
}
