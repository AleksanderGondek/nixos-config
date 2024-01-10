# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  # User related secrets
  # TOOD: There has to be a better way!
  sops.secrets.agondek_password = {
    sopsFile = ./secrets/agondek.yaml;
    neededForUsers = true;
  };
  sops.secrets.viewer_password = {
    sopsFile = ./secrets/viewer.yaml;
    neededForUsers = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.copyKernels = true;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

  networking.hostName = "pasithea"; # Define your hostname.
  networking.hostId = builtins.substring 0 8 (builtins.hashString "md5" config.networking.hostName);

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.autoSuspend = false;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.sushi.enable = true;
  services.gnome.gnome-settings-daemon.enable = true;
  environment.systemPackages = [
    pkgs.gnome.gnome-tweaks
  ];

  # Ensure thermald runs
  services.thermald.enable = true;

  # Never ever go to sleep, hibernate of something like that
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Root config
  users.users.root = {
    hashedPasswordFile = lib.mkDefault config.sops.secrets.agondek_password.path;
  };

  # Auto upgrade stable channel
  system.autoUpgrade = {
    enable = false;
  };
}

