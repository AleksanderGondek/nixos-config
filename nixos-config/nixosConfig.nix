{ config, pkgs, ... }:

with pkgs.lib;
let
  cfg = config.nixosConfig;
in
{
  imports = [
    # Option declarations
    ./nixosConfig-options.nix
    
    # Configuration accordingly to NixOs config
    ./boot-configuration.nix
    ./networking-configuration.nix
    ./x-server-configuration.nix
    ./system-configuration.nix
    ./users-configuration.nix
  ];
}
