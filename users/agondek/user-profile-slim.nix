{ config, pkgs, ... }:

let
  secrets = import ../../secrets.nix {};
in
{
  environment.systemPackages = with pkgs; [
    exa
    fd
    fzf
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
      "sound"
      "pulse"
      "audio"
      "lp"
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
      git-lfs
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
      FZF_DEFAULT_COMMAND="fd --type f --hidden";
      TERM="xterm-256color";
    };
    programs.git = {
      enable = true;
      userEmail = secrets.users.agondek.git.email;
      userName = "Aleksander Gondek";
      extraConfig = {
        core = {
          editor = "vim";
        };
        "filter \"lfs\"" = {
          process = "git-lfs filter-process";
          required = true;
          clean = "git-lfs clean -- %f";
          smudge = "git-lfs smudge -- %f";
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
