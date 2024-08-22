{
  config,
  pkgs,
  ...
}: {
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = false;
    addNetworkInterface = true;
    enableHardening = true;
    headless = false;
  };
  users.extraGroups.vboxusers.members = ["agondek"];
}
