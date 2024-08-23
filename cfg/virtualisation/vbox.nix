{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.agondek-cfg;
in {
  imports = [];

  options.agondek-cfg.virtualisation.virtualbox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.virtualisation.virtualbox.enable {
    virtualisation.virtualbox.host = {
      enable = true;
      enableExtensionPack = false;
      addNetworkInterface = true;
      enableHardening = true;
      headless = false;
    };
    users.extraGroups.vboxusers.members =
      if cfg.users.agondek.enable
      then ["agondek"]
      else [];
  };
}
