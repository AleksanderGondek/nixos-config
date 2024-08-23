{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.agondek-cfg;
in {
  imports = [];

  options.agondek-cfg.virtualisation.libvirtd = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = lib.mkIf cfg.virtualisation.libvirtd.enable {
    virtualisation.libvirtd = {
      enable = true;
      onBoot = "ignore";
      onShutdown = "shutdown";
    };

    environment.systemPackages = with pkgs; [
      libvirt
      virt-manager
    ];

    users.extraGroups.libvirtd.members =
      if cfg.users.agondek.enable
      then ["agondek"]
      else [];
    # NixOps requriement - allow dhcp packages
    networking.firewall.checkReversePath = false;
  };
}
