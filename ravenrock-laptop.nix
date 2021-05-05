{ config, pkgs, ... }:

{
  imports = [
    ./hardware/ravenrock-laptop.nix
    ./base/zfs.nix
    ./audio/pulseaudio.nix
    ./audio/bluetooth.nix
    ./desktops/default-desktop.nix
    ./virtualisation/docker.nix
    ./virtualisation/vbox.nix
    ./cluster/k8s-dev-single-node.nix
    ./users/agondek/user-profile.nix
  ];

  # nixos-hardware for X1 Carbon
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "acpi_call" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ravenrock";
  networking.hostId = "8611bc40";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s20f0u3.useDHCP = true;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  # Ensure thermald runs
  services.thermald.enable = true;

  # Auto upgrade stable channel
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-20.09";
    dates = "weekly";
    # Without explicit nixos config location, you are in for a bad times
    flags = [
      "-I nixos-config=/home/agondek/projects/nixos-config/ravenrock-laptop.nix"
    ];
  };
}

