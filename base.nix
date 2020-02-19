{ config, pkgs, ... }:

let
  homeManager = fetchTarball https://github.com/rycee/home-manager/archive/release-19.09.tar.gz;
  userSecrets = import ./user-secrets.nix {};
in
{
  # Home Manager Enablement
  imports = [ ''${homeManager}/nixos'' ];

  # Use ZFS filesytem
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = true;
  # ZFS requirement: networking.hostId = "f0f00fca";
  services.zfs.trim.enable = true;
  services.zfs.autoSnapshot = {
    enable = true;
    flags = "-k -p --utc";
    frequent = 4;
    hourly = 6;
    daily = 3;
    weekly = 1;
    monthly = 1;
  };

  # Clean up nix gc
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "pl";
    defaultLocale = "en_US.UTF-8";
  };
  
  # Network (Wireless and cord)
  networking.networkmanager.enable = true;

  # DNS Resolution
  networking.nameservers = [
    "1.1.1.1"
    "9.9.9.9"
  ];
  # Enforce only nameservers from configuration
  # To be removed after: https://github.com/NixOS/nixpkgs/issues/61230 is resolved
  networking.networkmanager.dns = pkgs.lib.mkForce "none"; # networkmaneger not to overwrite /etc/resolv.conf
  services.resolved.enable = pkgs.lib.mkForce false; # just to be sure
  environment.etc."resolv.conf" = {
    text = pkgs.lib.optionalString (config.networking.nameservers != []) (
            pkgs.lib.concatMapStrings (ns: "nameserver ${ns}\n") config.networking.nameservers
          );
    mode = "0444";
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Allow unfree nixpkgs
  nixpkgs.config.allowUnfree = true;

  # Base packages
  environment.systemPackages = with pkgs; [
    bind
    busybox
    curl
    gitAndTools.gitFull
    gnupg
    gparted
    htop
    less
    ranger
    unzip
    vim
    wget
    xterm
  ];

  # Bash settings
  programs.bash = {
    enableCompletion = true;
  };

  users.defaultUserShell = pkgs.bash;
  # Disallow user management sheneningans
  users.mutableUsers = false;
  # Root config
  users.users.root = {
    hashedPassword = userSecrets.hashedPassword;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
  
  # Auto upgrade stable channel
  system.autoUpgrade = {
    enable = true;
    channel = "https://nixos.org/channels/nixos-19.09";
    dates = "daily";
  };
}
