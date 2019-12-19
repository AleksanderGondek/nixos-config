{ config, pkgs, ... }:

let
  userSecrets = import ./user-secrets.nix {};
  preConfiguredVscode = pkgs.vscode-with-extensions.override {
    vscodeExtensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "python";
        publisher = "ms-python";
        version = "2019.11.50794";
        sha256 = "1imc4gc3aq5x6prb8fxz70v4l838h22hfq2f8an4mldyragdz7ka";
      }
      {
        name = "metals";
        publisher = "scalameta";
        version = "1.6.3";
        sha256 = "1mc3awybzd2ql1b86inirhsw3j2c7cs0b0nvbjp38jjpq674bmj7";
      }
    ];
  };
in {
  environment.systemPackages = with pkgs; [
    evince # pdf reader
    firefox
    git-crypt
    kubectl
    preConfiguredVscode
    # Developing Scala
    jdk
    sbt
  ];

  users.users.agondek = {
    description = "Aleksander Gondek";
    uid = 6666;
    isNormalUser = true;
    group = "nogroup";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
    home = "/home/agondek";
    shell = pkgs.zsh;
    createHome = true;
    useDefaultShell = false;
    hashedPassword = userSecrets.hashedPassword;
  };

  home-manager.users.agondek = {
    home.file = {
      ".Xresources".source = ./config-files/.Xresources;
      ".config/alacritty/alacritty.yml".source = ./config-files/.config/alacritty/alacritty.yml;
      ".config/htop/htoprc".source = ./config-files/.config/htop/htoprc;
      ".config/i3/config".source = ./config-files/.config/i3/config;
      ".config/i3/status.toml".source = ./config-files/.config/i3/status.toml;
      ".config/rofi/config".source = ./config-files/.config/rofi/config;
      ".config/rofi/Monokai.rasi".source = ./config-files/.config/rofi/Monokai.rasi;
    };
    home.sessionVariables = {
      NIXOS_CONFIG = /home/agondek/Projects/nixos-config;
    };
    programs.git = {
      enable = true;
      userEmail = "gondekaleksander@protonmail.com";
      userName = "Aleksander Gondek";
      extraConfig = {
        core = {
          editor = "vim";
        };
      };
      signing = {
        key = userSecrets.gitGpgSigningKey;
        signByDefault = true;
      };
    };
    programs.zsh = {
      enable = true;
      enableAutosuggestions = true;

      oh-my-zsh = {
        enable = true;
        plugins = [];
        theme = "agnoster";
      };
    };
  };

  nix.trustedUsers = [ "root" "agondek" ];
}
