{
  config,
  lib,
  pkgs,
  latest-nixpkgs,
  ...
}: {
  imports = [];
  options.agondek-nixos-config.users.agondek = {
    enable = lib.mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, default agondek user will be defined on the host.
      '';
    };
  };
  config = mkIf config.services.agondek-nixos-config.users.agondek.enable {
    users.users.agondek = {
      description = "Aleksander Gondek";
      uid = 6666;
      isNormalUser = true;
      group = "nogroup";
      extraGroups = [
        "wheel"
      ];
      home = "/home/agondek";
      shell = pkgs.bash;
      createHome = true;
      useDefaultShell = false;
      hashedPasswordFile = config.sops.secrets.agondek_password.path;
    };

    nix.settings.trusted-users = ["agondek"];

    home-manager.users.agondek = {
      home.stateVersion = "24.05";

      home.packages = with pkgs; [
        coreutils-full
        curlFull
        eza
        fd
        fx
        fzf
        gitFull
        gnupg
        gnutar
        helix
        htop
        jq
        kubectl
        less
        ncurses
        neofetch
        nix
        niv
        ranger
        ripgrep
        unzip
        wget
        vim
        zellij
      ];

      home.sessionVariables = {
        EDITOR = "hx";
        FZF_DEFAULT_COMMAND = "fd --type f --hidden";
        TERM = "xterm-256color";
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
            editor = "hx";
          };
        };
        signing = {
          key = "65CCE6BBC241FF3F30CC531D816D9CCE02C7F649";
          signByDefault = true;
        };
      };
    };
  };
}
