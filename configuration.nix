{ config, pkgs, ... }:

let
  configurationSecrets = import ./configuration.secret.nix;
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./boot-configuration.nix
    ./networking-configuration.nix
  ];

  system.nixos.stateVersion = "18.09";
}
