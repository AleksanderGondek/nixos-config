{ config, pkgs, ... }:

let
  userSecrets = import ./user-secrets.nix {};
in
{ 
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

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "pl";
    defaultLocale = "en_US.UTF-8";
  };
  
  # Network (Wireless and cord)
  networking.networkmanager.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Allow unfree nixpkgs
  nixpkgs.config.allowUnfree = true;

  # Base packages
  environment.systemPackages = with pkgs; [
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
  # Root config
  users.users.root = {
    hashedPassword = userSecrets.hashedPassword;
  };
}
