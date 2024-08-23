{
  config,
  pkgs,
  lib,
  latest-nixpkgs,
  ...
}: let
  cfg = config.agondek-cfg;
in {
  imports = [];

  options.agondek-cfg.audio.pulseaudio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.audio.pulseaudio.enable {
    hardware.pulseaudio = {
      enable = true;
      package = latest-nixpkgs.pulseaudioFull;
      zeroconf.discovery.enable = true;
    };
    sound.enable = true;
  };
}
