{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware/blackwood-desktop.nix
    ./base/zfs.nix
    ./audio/pulseaudio.nix
    ./desktops/nvidia-desktop.nix
    ./programs/steam.nix
    ./virtualisation/containerd.nix
    ./cluster/k8s-dev-single-node.nix
    ./users/agondek/user-profile.nix
  ];
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

  # Auto upgrade stable channel
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-21.05";
    dates = "weekly";
    # Without explicit nixos config location, you are in for a bad times
    flags = [
      "-I nixos-config=/home/agondek/projects/nixos-config/blackwood-desktop.nix"
    ];
  };
}
