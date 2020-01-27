{ config, pkgs, ... }:

let
  userSecrets = import ./user-secrets.nix {};
  preConfiguredVscode = import ./programs/vscode.nix { 
    inherit config pkgs userSecrets;
  };
in {
  environment.systemPackages = with pkgs; [
    evince # pdf reader
    exa
    fd
    firefox
    ripgrep # Grep written in rust
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
      ".gtkrc-2.0".source = ./config-files/.gtkrc-2.0;
      ".config/gtk-3.0/settings.ini".source = ./config-files/.config/gtk-3.0/settings.ini;
      ".config/alacritty/alacritty.yml".source = ./config-files/.config/alacritty/alacritty.yml;
      ".config/htop/htoprc".source = ./config-files/.config/htop/htoprc;
      ".config/i3/config".source = ./config-files/.config/i3/config;
      ".config/i3/status.toml".source = ./config-files/.config/i3/status.toml;
      ".config/rofi/config".source = ./config-files/.config/rofi/config;
      ".config/rofi/Monokai.rasi".source = ./config-files/.config/rofi/Monokai.rasi;
      ".config/Code/User/settings.json".source = ./config-files/.config/Code/User/settings.json;
    };
    home.packages = with pkgs; [
      git-crypt
      kubectl
      preConfiguredVscode
      # Developing in Scala
      jdk
      sbt
      # Developing in Python
      pypi2nix
      (python37.withPackages(ps : with ps; [ 
          ipython
          flake8
          pycodestyle
          pylint
          setuptools
          virtualenv
        ]
      ))
      # Developiong in Rust
      binutils
      gcc
      gnumake
      openssl
      pkgconfig
      rustc
      cargo
    ];
    home.sessionVariables = {
      NIXOS_CONFIG = /home/agondek/Projects/nixos-config;
      EDITOR = "vim";
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
