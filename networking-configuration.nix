{ lib, config, pkgs, ... }:

{
  networking.hostName = config.nixosConfig.hostName;
  networking.hostId = config.nixosConfig.hostId;
  
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
}
