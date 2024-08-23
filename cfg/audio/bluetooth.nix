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

  options.agondek-cfg.audio.bluetooth = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.audio.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      package = latest-nixpkgs.bluez;
    };

    services.blueman.enable = true;
  };
}
