{ config, pkgs, ... }:

let
  homeManager = fetchTarball https://github.com/rycee/home-manager/archive/release-19.09.tar.gz;
  userSecrets = import ./user-secrets.nix {};
in
{
  # Home Manager Enablement
  imports = [ ''${homeManager}/nixos'' ];

  # Ensure default inotify watches for files is high
  boot.kernel.sysctl = {
    "fs.file-max" = 9223372036854775807;  
    "fs.inotify.max_user_watches" = 524288; 
  };

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

  services.thermald.enable = true;

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
    lm_sensors
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
}
