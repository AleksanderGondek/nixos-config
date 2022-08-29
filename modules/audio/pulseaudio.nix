{ config, pkgs, latest-nixpkgs, ... }:

{
  hardware.pulseaudio = {
    enable = true;
    package = latest-nixpkgs.pulseaudioFull;
    zeroconf.discovery.enable = true;
  };
  sound.enable = true;
}
