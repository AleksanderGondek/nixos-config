{ config, pkgs, ... }:

{
  networking = {
    hostId = config.nixosConfig.hostId;
    hostName = config.nixosConfig.hostName;
     
    firewall.enable = true;
    firewall.trustedInterfaces = [ "lo" ];

    # To replace wiress.enable
    # networkmanager.enable = true;
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };
}
