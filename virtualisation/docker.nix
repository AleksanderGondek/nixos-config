{ config, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    enableNvidia = false;     # !Ensure it!
    liveRestore = false;      # Usually counter-productive
    logDriver = "json-file";  # K8s requires it
    autoPrune = {
      enable = true;
      dates = "daily";
    };
    #extraOptions = ''
    #  --bip 10.200.0.1/24
    #  --default-address-pool=10.201.0.0/16,size=24
    #  --default-address-pool=10.202.0.0/16,size=24
    #'';
  };

  networking.firewall.trustedInterfaces = [" docker0" ];
}
