{ config, pkgs, ... }:

{
  imports = [
    ./hardware/vm-utility-drone.nix
    ./base/main.nix
    ./network/work-ntp.nix
    ./virtualisation/docker.nix
    ./users/drone/user-profile.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostId = "c90a5ed9";
  networking.hostName = "agondek-utility-drone";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.ens32.useDHCP = true;

  # Set your time zone.
  time.timeZone = pkgs.lib.mkForce "UTC";

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Disable sound.
  sound.enable = pkgs.lib.mkForce false;
  hardware.pulseaudio.enable = pkgs.lib.mkForce false;

  services.thermald.enable = pkgs.lib.mkForce false;

  users.users.root = {
    hashedPassword = pkgs.lib.mkForce secrets.users.drone.hashedPassword;
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };

  # Auto upgrade stable channel
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-19.09";
    dates = "weekly";
    # Without explicit nixos config location, you are in for a bad times
    flags = [
      "-I nixos-config=/home/agondek/projects/nixos-config/vm-utility-drone.nix"
    ];
  };
}
