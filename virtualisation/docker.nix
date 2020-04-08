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
  };

  networking.firewall.trustedInterfaces = [" docker0" ];
}
