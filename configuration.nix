{ config, pkgs, machineName ? "ravenrock-nixos", ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./nixos/boot-configuration.nix
    ./nixos/networking-configuration.nix
    ./nixos/x-server-configuration.nix
    ./nixos/system-configuration.nix
  ];

  options.nixosConfig = with pkgs.lib; {
    userName = mkOption {
      type = types.string;
    };
    hostName = mkOption {
      type = types.string;
    };
    hostId = mkOption {
      type = types.string;
    };
  };

  config = let
    nixosConfig = (import "./machine-profiles/${machineName}.secret.nix"){};
    cfg = config.nixosConfig;
  in {
    nixosConfig = nixosConfig;

    system.stateVersion = "18.09";
  };
}
