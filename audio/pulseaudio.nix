{ config, pkgs, ... }:

{
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    zeroconf.discovery.enable = true;
  };
  sound.enable = true;
}
