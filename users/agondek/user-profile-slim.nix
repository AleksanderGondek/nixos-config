{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    eza
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
      "sound"
      "pulse"
      "audio"
      "lp"
    ];
    home = "/home/agondek";
    shell = pkgs.bash;
    createHome = true;
    useDefaultShell = false;
    hashedPasswordFile = config.sops.secrets.agondek_password.path;
  };

  home-manager.users.agondek = {
    home.stateVersion = "24.05";
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
      userEmail = "gondekaleksander@protonmail.com";
      userName = "Aleksander Gondek";
      extraConfig = {
        init = {
          defaultBranch = "master";
        };
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
        key = "65CCE6BBC241FF3F30CC531D816D9CCE02C7F649";
        signByDefault = true;
      };
    };
  };

  nix.settings.trusted-users = [ "root" "agondek" ];
}
