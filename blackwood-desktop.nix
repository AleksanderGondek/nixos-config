{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware/blackwood-desktop.nix
    ./base/zfs.nix
    # Carbon dns breaks VPN
    #./network/dns-carbon.nix
    ./desktops/nvidia-desktop.nix
    ./virtualisation/docker.nix
    ./cluster/k8s-dev-single-node.nix
    ./users/agondek/user-profile.nix
  ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ZFS requirement
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
    channel = "https://nixos.org/channels/nixos-19.09";
    dates = "weekly";
    # Without explicit nixos config location, you are in for a bad times
    flags = [
      "-I nixos-config=/home/agondek/projects/nixos-config/blackwood-desktop.nix"
    ];
  };
}
