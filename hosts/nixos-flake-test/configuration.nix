# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  secrets,
  latest-nixpkgs,
  ...
}: {
  imports = [];

  config = {
    # User related secrets
    # TOOD: There has to be a better way!
    sops.secrets.drone_password = {
      sopsFile = ./secrets/drone.yaml;
      neededForUsers = true;
    };

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # ZFS
    networking.hostId = "c53a68f2";
    networking.hostName = "nixos-flake-test"; # Define your hostname.

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;
    networking.interfaces.enp3s0.useDHCP = true;
    networking.interfaces.wlp4s0.useDHCP = true;

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = [
      latest-nixpkgs.vim
    ];

    users.users.root = {
      hashedPasswordFile = config.sops.secrets.drone_password.path;
    };
  };
}
