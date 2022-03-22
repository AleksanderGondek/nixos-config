{ config, lib, pkgs, ... }:

{
  # User related secrets
  # TOOD: There has to be a better way!
  sops.secrets.agondek_password = {
    sopsFile = ./secrets/agondek.yaml;
    neededForUsers = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x5002538e9053af22";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.copyKernels = true;

  # TP-Link Archer T9UH v1: rtl8814au
  # "v4l2loopback" -> virtualcam for OBS
  boot.kernelModules = [ "rtl8814au" "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl8814au v4l2loopback
  ];
  # Emulate aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # ZFS requirements
  networking.hostId = "4746a27b";
  # Network (Wireless and cord)
  networking.hostName = "blackwood";
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

   # Never ever go to sleep, hibernate of something like that
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  nix.buildMachines = [
    # tweag remote builder
    {
      hostName = "build01.tweag.io";
      maxJobs = 24;
      sshUser = "nix";
      sshKey = "/root/.ssh/agondek-id-tweag-builder";
      system = "x86_64-linux";
      supportedFeatures = [ "benchmark" "big-parallel" "kvm" ];
    }
  ];
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  # Sigh
  services.tailscale.enable = true;

  # Root config
  users.users.root = {
    passwordFile = lib.mkDefault config.sops.secrets.agondek_password.path;
  };

  # Auto upgrade stable channel
  system.autoUpgrade = {
    enable = false;
  };
}
