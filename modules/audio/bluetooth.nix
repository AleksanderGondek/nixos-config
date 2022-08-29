{ config, pkgs, latest-nixpkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = latest-nixpkgs.bluezFull;
  };
  services.blueman.enable = true;
}

