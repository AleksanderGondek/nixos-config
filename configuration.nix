{ config, pkgs, ... }:

let
  homeManager = fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz;
in
{
  imports =
    [
      ./hardware/ravenrock-laptop.nix
      ''${homeManager}/nixos''
      ./ravenrock-laptop.nix
    ];

  # K8s and friends
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    enableNvidia = false;     # !Ensure it!
    liveRestore = false;      # Usually counter-productive
    logDriver = "json-file";  # K8s requires it
    autoPrune = {
      enable = true;
      dates = "daily";
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
