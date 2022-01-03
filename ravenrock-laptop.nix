{ config, pkgs, ... }:

{
  imports = [
    ./hardware/ravenrock-laptop.nix
    ./base/zfs.nix
    ./audio/pulseaudio.nix
    ./audio/bluetooth.nix
    ./desktops/default-desktop.nix
    ./virtualisation/vbox.nix
    ./virtualisation/containerd.nix
    ./cluster/k8s-dev-single-node.nix
    ./users/agondek/user-profile.nix
  ];

  # nixos-hardware for X1 Carbon
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "acpi_call" "v4l2loopback" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call v4l2loopback ];

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

  # Enable quemu aarch64 emulation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  # Ensure thermald runs
  services.thermald.enable = true;

  # Tweag remote builder
  nix.buildMachines = [{
    hostName = "build01.tweag.io";
    maxJobs = 24;
    sshUser = "nix";
    sshKey = "/root/.ssh/agondek-id-tweag-builder";
    system = "x86_64-linux";
    supportedFeatures = [ "benchmark" "big-parallel" "kvm" ];
  }];
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  # Never ever go to sleep, hibernate of something like that
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Auto upgrade stable channel
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-21.11";
    dates = "weekly";
    # Without explicit nixos config location, you are in for a bad times
    flags = [
      "-I nixos-config=/home/agondek/projects/nixos-config/ravenrock-laptop.nix"
    ];
  };
}

