# Skeleton setup for Hydra
{ config, pkgs, ... }:

{
  services.hydra = {
    enable = true;
    # To be improved.
    hydraURL = "https://${config.networking.hostName}";
    notificationSender = "hydra@localhost";
    # Please use nix cache, otherwise build takes hours
    useSubstitutes = true;
    # A standalone hydra will require you to unset 
    # the buildMachinesFiles list to avoid using 
    # a nonexistant /etc/nix/machines
    buildMachinesFiles = [
    ];
  };
}
