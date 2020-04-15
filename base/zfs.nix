{ config, pkgs, ... }:

{
  imports = [
    ./main.nix
  ];

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
}
