{
  config,
  pkgs,
  ...
}: {
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  environment.systemPackages = with pkgs; [
    libvirt
    virt-manager
  ];

  users.extraGroups.libvirtd.members = ["agondek"];
  # NixOps requriement - allow dhcp packages
  networking.firewall.checkReversePath = false;
}
