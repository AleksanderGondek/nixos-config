{ config, pkgs, ... }:

let
  secrets = import ../../secrets.nix {};
in
{
  users.users.drone = {
    description = "Drone Utility Account";
    uid = 2137;
    isNormalUser = true;
    group = "nogroup";
    extraGroups = [
      "wheel"
      "docker"
    ];
    home = "/home/drone";
    shell = pkgs.bash;
    createHome = true;
    hashedPassword = secrets.users.drone.hashedPassword;
  };

  home-manager.users.drone = {
    home.packages = with pkgs; [
      kubectl
      jq
      binutils
      gcc
      gnumake
      openssl
    ];
    home.sessionVariables = {
      NIXOS_CONFIG = /home/drone/projects/nixos-config;
      EDITOR = "vim";
    };
  };

  nix.trustedUsers = [ "drone" ];
}
