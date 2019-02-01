{ config, pkgs, ... }:

let
  configurationSecrets = import ./configuration.secret.nix;
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  system.nixos.stateVersion = "18.09";
}
