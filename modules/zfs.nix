{ config, pkgs, ... }:

{
  # Remember to define
  # networking.hostId
  # networking.hostName
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/";

  services.zfs.trim.enable = true;
  services.zfs.autoScrub = {
    enable = true;
    pools = [ "rpool" ];
  };

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
