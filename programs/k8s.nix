{ config, pkgs, ... }:

{
  services.kubernetes = {
    roles = ["master" "node"];
    addons.dashboard.enable = true;
    kubelet.extraOpts = "--fail-swap-on=false";
    masterAddress = "localhost";
  };
}
