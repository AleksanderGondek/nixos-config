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
      zeroconf.discovery.enable = true;
    };
  };
}
