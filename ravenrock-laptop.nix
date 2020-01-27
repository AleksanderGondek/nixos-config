{ config, pkgs, ... }:

{
  imports = [
    ./hardware/ravenrock-laptop.nix
    ./base.nix
    ./desktops/default-desktop.nix
    ./virtualisation/docker.nix
    ./user-profile.nix
  ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ZFS requirement
  networking.hostId = "f0f00fca";
  # Network (Wireless and cord)
  networking.hostName = "ravenrock";
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
}