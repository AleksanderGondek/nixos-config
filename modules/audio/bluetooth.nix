{ config, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluezFull;
  };
  services.blueman.enable = true;
}

