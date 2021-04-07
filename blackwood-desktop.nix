{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware/blackwood-desktop.nix
    ./base/zfs.nix
    ./audio/pulseaudio.nix
    ./desktops/nvidia-desktop.nix
    ./programs/steam.nix
    ./virtualisation/docker.nix
    ./virtualisation/libvirtd.nix
    ./cluster/k8s-dev-single-node.nix
    #./ci/hydra.nix
    ./users/agondek/user-profile.nix
  ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/disk/by-id/wwn-0x5002538e9053af22";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.copyKernels = true;

  # ZFS requirements
  networking.hostId = "4746a27b";
  # Network (Wireless and cord)
  networking.hostName = "blackwood";
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;

  # Auto upgrade stable channel
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-20.09";
    dates = "weekly";
    # Without explicit nixos config location, you are in for a bad times
    flags = [
      "-I nixos-config=/home/agondek/projects/nixos-config/blackwood-desktop.nix"
    ];
  };
}
