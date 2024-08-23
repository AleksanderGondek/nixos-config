{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./bluetooth.nix
    ./pipewire.nix
    ./pulseaudio.nix
  ];
}
