{ config, pkgs, ... }:

{
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
  users.extraGroups.libvirtd.members = [ "agondek" ];
  # NixOps requriement - allow dhcp packages
  networking.firewall.checkReversePath = false;
}
