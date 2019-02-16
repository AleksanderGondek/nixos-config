{ config, pkgs, ... }:

let
  configParams = import ./configuration-params.nix;
  nixosConfig = (import ./. + "/machine-profiles/${configParams.machineProfileName}.secret.nix"){};
in
{
  imports = [
    # Hardware configuration, pre-generated
    /etc/nixos/hardware-configuration.nix
    # NixosConfig
    ./nixos-config/nixosConfig.nix
  ];

  nixosConfig = nixosConfig;

  system.stateVersion = "18.09";
}
