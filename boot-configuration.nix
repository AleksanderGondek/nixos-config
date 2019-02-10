{ config, pkgs, ... }:

{
  # Enable zfs
  boot.supportedFilesystems = [ "zfs" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Clean /tmp on boot
  boot.cleanTmpDir = true;
}
