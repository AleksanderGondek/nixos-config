{ config, lib, pkgs, ... }:

{
  # User related secrets
  # TOOD: There has to be a better way!
  sops.secrets.agondek_password = {
    sopsFile = ./secrets/agondek.yaml;
    neededForUsers = true;
  };
  sops.secrets.drone_password = {
    sopsFile = ./secrets/drone.yaml;
    neededForUsers = true;
  };

  boot.supportedFilesystems = [ "ext4" "zfs" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.copyKernels = true;
  boot.zfs.devNodes = lib.mkForce "/dev/disk/by-path";

  networking.hostId = "c90a5ed9";
  networking.hostName = "vm-utility-drone";

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
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.root = {
    hashedPasswordFile = config.sops.secrets.drone_password.path;
  };

  # Auto upgrade stable channel
  system.autoUpgrade = {
    enable = false;
  };
}
