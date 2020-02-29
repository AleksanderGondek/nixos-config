{ config, pkgs, ... }:

let
  userSecrets = import ./user-secrets.nix {};
  preConfiguredVscode = import ./programs/vscode.nix { 
    inherit config pkgs userSecrets;
  };
  ffAddons = import ./programs/firefox-addons.nix {
    inherit config pkgs;
  };
in {
  environment.systemPackages = with pkgs; [
    exa
    fd
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
      ".fehbg".source = ./config-files/.fehbg;
      ".gtkrc-2.0".source = ./config-files/.gtkrc-2.0;
      ".config/gtk-3.0/settings.ini".source = ./config-files/.config/gtk-3.0/settings.ini;
      ".config/alacritty/alacritty.yml".source = ./config-files/.config/alacritty/alacritty.yml;
      ".config/htop/htoprc".source = ./config-files/.config/htop/htoprc;
      ".config/i3/config".source = ./config-files/.config/i3/config;
      ".config/i3/status.toml".source = ./config-files/.config/i3/status.toml;
      ".config/polybar/config".source = ./config-files/.config/polybar/config;
      ".config/polybar/run-polybar.sh".source = ./config-files/.config/polybar/run-polybar.sh;
      ".config/rofi/config".source = ./config-files/.config/rofi/config;
      ".config/rofi/Monokai.rasi".source = ./config-files/.config/rofi/Monokai.rasi;
      ".config/Code/User/settings.json".source = ./config-files/.config/Code/User/settings.json;
      ".config/wallpapers/01.jpg".source = ./config-files/.config/wallpapers/01.jpg;
    };
    home.packages = with pkgs; [
      evince # pdf reader
      git-crypt
      kubectl
      # Passwords
      keepassxc
      # Emails
      thunderbird
      # IDEs
      preConfiguredVscode
      # Taking notes
      zim
      cherrytree
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
    services.dunst = {
      enable = true;
      settings = {
        global = {
          startup_notification = true;
          follow = "mouse";
          geometry = "300x6-10+30";
          transparency = 0;
          font = "Hack Regular 8";
          markup = "full";
          format = "<b>%s</b>\n%b";
          padding = 8;
          horizontal_padding = 8;
          frame_width = 2;
          frame_color = "#788388";
          sort = "yes";
          browser = "firefox";
          icon_position = "left";
          max_icon_size=32;
        };
      };
    };
    programs.firefox = {
      enable = true;
      extensions = with ffAddons; [
        dark-night-mode
        facebook-container
        ghostery
        multi-account-containers
        octotree
        ublock-origin        
      ];
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
