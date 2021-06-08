{ config, pkgs, ... }:

let 
  secrets = import ./secrets.nix {};
in {
  imports = [
    ./hardware/vm-utility-drone.nix
    ./base/zfs.nix
    ./network/work-ntp.nix
    ./users/drone/user-profile.nix
    ./users/agondek/user-profile-slim.nix
    #./cluster/k8s-dev-single-node.nix
  ];

  boot.supportedFilesystems = [ "ext4" "zfs" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.copyKernels = true;
  boot.zfs.devNodes = "/dev/disk/by-path";

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

  # Thermal control not needed on VM
  services.thermald.enable = pkgs.lib.mkForce false;

  # Ensure work-env will assign proper dns name
  virtualisation.vmware.guest.enable = true;
  virtualisation.vmware.guest.headless = true;

  # Expose Nginx ingress & k8s api to world
  networking.firewall.allowedTCPPorts = [ 80 443 6443 ];

  # Enable sshd
  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    permitRootLogin = "no";
  };

  users.users.root = {
    hashedPassword = pkgs.lib.mkForce secrets.users.drone.hashedPassword;
  };

  # Auto upgrade stable channel
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-20.09";
    dates = "weekly";
    # Without explicit nixos config location, you are in for a bad times
    flags = [
      "-I nixos-config=/root/nixos-config/vm-utility-drone.nix"
    ];
  };
}
