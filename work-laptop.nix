{ config, pkgs, ... }:

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
  boot.kernelModules = [ "kvm-intel" "iwlwifi" "dell-smm-hwmon"];
  boot.kernelParams = [
    "acpi_osi=Linux"
    "acpi_rev_override=1"
    "i915.disable_power_well=0"
    "dell-smm-hwmon.ignore_dmi=1"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  ##### disable nvidia, very nice battery life.
  hardware.nvidiaOptimus.disable = true;
  boot.blacklistedKernelModules = [ "nouveau" "nvidia" ];
  services.xserver.videoDrivers = [ "intel" ];

  # Counteract high-temperatures
  powerManagement.powertop.enable = false;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    extraConfig = ''
      TLP_DEFAULT_MODE=AC
      CPU_SCALING_GOVERNOR_ON_AC=powersave
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
      ENERGY_PERF_POLICY_ON_AC=default
      ENERGY_PERF_POLICY_ON_BAT=power
      CPU_HWP_ON_AC=power
      CPU_HWP_ON_BAT=balance_power
      RUNTIME_PM_BLACKLIST="01:00.0"
      WIFI_PWR_ON_AC=off
      WIFI_PWR_ON_BAT=off
      USB_AUTOSUSPEND=0
    '';
  };

  networking.hostId = "d3b1c241";
  networking.hostName = "TAG009443491811";
  networking.useDHCP = false;
  networking.interfaces.ens1u2u4.useDHCP = true;
  networking.interfaces.wlp59s0.useDHCP = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
}
