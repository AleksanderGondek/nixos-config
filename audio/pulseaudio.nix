{ config, pkgs, ... }:

{
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull.override;
  };
  sound.enable = true;
}
