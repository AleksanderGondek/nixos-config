{ config, pkgs, ... }:

let
  secrets = import ../../secrets.nix {};
in
{
  environment.systemPackages = with pkgs; [
    exa
    fd
    ripgrep
  ];

  users.users.agondek = {
    description = "Aleksander Gondek";
    uid = 6666;
    isNormalUser = true;
    group = "nogroup";
    extraGroups = [
      "wheel"
      "docker"
    ];
    home = "/home/agondek";
    shell = pkgs.bash;
    createHome = true;
    useDefaultShell = false;
    hashedPassword = secrets.users.agondek.hashedPassword;
  };

  home-manager.users.agondek = {
    home.packages = with pkgs; [
      git-crypt
      kubectl
      jq
      binutils
      gcc
      gnumake
      openssl
    ];
    home.sessionVariables = {
      NIXOS_CONFIG = /home/agondek/projects/nixos-config;
      EDITOR = "vim";
    };
    programs.git = {
      enable = true;
      userEmail = secrets.users.agondek.git.email;
      userName = "Aleksander Gondek";
      extraConfig = {
        core = {
          editor = "vim";
        };
      };
      signing = {
        key = secrets.users.agondek.git.gpgSigningKey;
        signByDefault = true;
      };
    };
  };

  nix.trustedUsers = [ "root" "agondek" ];
}