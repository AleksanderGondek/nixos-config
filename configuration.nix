{ config, pkgs, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
    ./boot-configuration.nix
    ./networking-configuration.nix
    ./x-server-configuration.nix
    ./system-configuration.nix
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
    nixosConfig = (import ./configuration.secret.nix){};
    cfg = config.nixosConfig;
  in {
    nixosConfig = nixosConfig;

    system.nixos.stateVersion = "18.09";
  };
}
