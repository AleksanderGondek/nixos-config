{ config, pkgs, latest-nixpkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = latest-nixpkgs.bluez;
  };
  services.blueman.enable = true;
}

