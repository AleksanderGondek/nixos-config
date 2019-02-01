{ lib, config, pkgs, configurationSecrets, ... }:

{
  networking.hostName = configurationSecrets.hostName;
  networking.hostId = configurationSecrets.hostId;
  
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
}
